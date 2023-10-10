----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:22:58 10/19/2011 
-- Design Name: 
-- Module Name:    GtpReceiver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FPReceiver is
  Port ( Clk : in  STD_LOGIC;
	ClkTable : in STD_LOGIC;
    TsIn     : in  STD_LOGIC_VECTOR (6 downto 1);
    Reset    : in std_logic;
    LevelReadEn : in std_logic;
    TrigEn      : in std_logic_vector (6 downto 1);
    MatchWindow	: in std_logic_vector (7 downto 0);
    TrigInhibit	: in std_logic_vector (7 downto 0);
    TrigPreScale : in std_logic_vector (24 downto 1);
    FPCount	 : inout std_logic_vector (191 downto 0);
    TblReg	 : inout std_logic_vector (6 downto 1);
    PreTable : out std_logic_vector(6 downto 1);
    ScalarLatch : in std_logic;
    ScalarReset : in std_logic;
    ScalarEnableSet : in std_logic_vector(2 downto 1);
    TableValid	 : inout std_logic_vector (31 downto 0); 
    FPPreMatch	 : inout std_logic;
    ChannelDelay : in std_logic_vector(63 downto 0);
    TestPt       : out std_logic_vector (8 downto 1) );
end FPReceiver;

architecture Behavioral of FPReceiver is

	signal FPDataIn : std_logic_vector (6 downto 1);
	signal FPDataReg : std_logic_vector (6 downto 1);
	signal DFPReg	: std_logic_vector (6 downto 1);
	signal FPInData	: std_logic_vector (6 downto 1);
	signal DlyFPInData : std_logic_vector(6 downto 1);
	signal PreFPTable : std_logic_vector (6 downto 1);
	signal SPreFPTable : std_logic_vector (6 downto 1);
	signal TableOutEn : std_logic;
	signal PrePreTable   : std_logic_vector(6 downto 1);
	signal ScalarEnable  : std_logic_vector(6 downto 1);
    signal SigOutCascade : std_logic_vector(6 downto 1);
    signal SigOutDlyA    : std_logic_vector(6 downto 1);
    signal SigOutDlyB    : std_logic_vector(6 downto 1);

  component TrigBitControl
    Port ( TrigIn : in  STD_LOGIC;  
      Clk : in  STD_LOGIC;
      Reset	: in std_logic;
      PreScale : in  STD_LOGIC_VECTOR (3 downto 0);
      TrigEn : in  STD_LOGIC;
      Window : in  STD_LOGIC_VECTOR (7 downto 0);
      Count : inout  STD_LOGIC_VECTOR (31 downto 0);
      ScalarLatch : in std_logic;
      ScalarReset : in std_logic;
      ScalarEnable : in std_logic;
      STrigOut	: inout std_logic;
      TrigOut : inout  STD_LOGIC);
  end component;

  component SigDelay is
    Port (SigIn : in STD_LOGIC;
      Clock     : in STD_LOGIC;
      DelayVal  : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax : out std_logic;
      SigOut    : out STD_LOGIC);
  end component SigDelay;

  COMPONENT FastMatchVeto
    PORT( Din :	IN	STD_LOGIC_VECTOR (6 DOWNTO 1);
      DinB    : in std_logic_vector (10 downto 1);
      DinC    : in std_logic_vector (16 downto 1);			 
      SDin    : in std_logic_vector (6 downto 1);
      SDinB   : in std_logic_vector (10 downto 1);
      SDinC   : in std_logic_vector (16 downto 1);
      Dout    : OUT	STD_LOGIC_VECTOR (6 DOWNTO 1); 
      DoutB   : out std_logic_vector (10 downto 1);
      DoutC   : out std_logic_vector (16 downto 1);
      Clk250  :	IN STD_LOGIC; 
      LookUpEn : OUT STD_LOGIC; 
      Reset   : in std_logic;
      TestPt  : out std_logic_vector (4 downto 1);
      Window  :	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
      Inhibit :	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
      MatchEn : out std_logic);
  END COMPONENT;

  COMPONENT PreTableED
    PORT( Sin	:	IN	STD_LOGIC; 
      Delay	:	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
      Width	:	IN	STD_LOGIC_VECTOR (4 DOWNTO 0); 
      Clock	:	IN	STD_LOGIC; 
      SOut	:	OUT	STD_LOGIC);
  END COMPONENT;

begin

-- LVDS receivers, One clock regions only, move it out
--LoopExtIn: for iloop in 1 to 6 generate
--  IBUFDS_inst : IBUFDS
--    generic map ( DIFF_TERM => FALSE, -- Differential Termination
--      IOSTANDARD => "DEFAULT")
--    port map ( O  => FPDataIn(iloop),  -- Clock buffer output  
--      I  => In_P(iloop),  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => In_N(iloop) ); -- Diff_n clock buffer input (connect directly to top-level port)
--end generate LoopExtIn;
  FPDataIn(6 downto 1) <= TsIn(6 downto 1);

-- This is different from the ExtTrig and GtpTrig, here the rising clock is used to latch the 
-- front panel async trigger input.  This will ease the timing on the signal processing later.
  process (Clk)
  begin
    If (Clk'event and Clk = '1') then
      FPDataReg <= FPDataIn;
      DFPReg <= FPDataReg;
  -- Input rising edge sensitive
      FPInData <= FPDataReg and (not (DFPReg));			
    else
      null;
    end if;
  end process;

  LoopTrgInDelay :  for iloop in 1 to 6 generate
  begin
    TriggerInDelayA : SigDelay
      port map(SigIn => FPInData(iloop), -- in STD_LOGIC;
        Clock     => Clk, -- in STD_LOGIC;
        DelayVal  => ChannelDelay( (((iloop-1)/3)*32+10*((iloop-1) mod 3)+7) downto (((iloop-1)/3)*32+10*((iloop-1) mod 3))), -- in STD_LOGIC_VECTOR (7 downto 0);
        SigOutMax => SigOutCascade (iloop), -- out std_logic;
        SigOut    => SigOutDlyA(iloop) );   --  out STD_LOGIC);
        
    TriggerInDelayB : SigDelay
      port map(SigIn => SigOutCascade(iloop), -- in STD_LOGIC;
        Clock     => Clk, -- in STD_LOGIC;
        DelayVal  => ChannelDelay( (((iloop-1)/3)*32+10*((iloop-1) mod 3)+7) downto (((iloop-1)/3)*32+10*((iloop-1) mod 3))), -- in STD_LOGIC_VECTOR (7 downto 0);
        SigOutMax => open, -- out std_logic;
        SigOut    => SigOutDlyB(iloop) ); --  out STD_LOGIC);
        
    DlyFPInData(iloop) <= SigOutDlyB(iloop) when ChannelDelay(((iloop-1)/3)*32+10*((iloop-1) mod 3)+8) = '1' else SigOutDlyA(iloop);

  end generate;  -- LoopTrgInDelay;

--     TriggerInDelay: TrgInDelay
--   	  PORT MAP(
--	   	Clock => Clk, 
--		   Sin => FPInData(iloop), 
--		   Sout => DlyFPInData(iloop), 
--		   Delay => ChannelDelay( (((iloop-1)/3)*32+10*((iloop-1) mod 3)+8) downto (((iloop-1)/3)*32+10*((iloop-1) mod 3)) )
--       );

-- Output the 'raw' trigger input pattern
	LoopOverCh: for iloop in 1 to 6 generate
     ChanProc: PreTableED PORT MAP(
		  Sin => DlyFPInData(iloop), 
		  Delay => MatchWindow(7 downto 0), 
		  Width => "00110", 
		  Clock => Clk, 
		  SOut => PrePreTable(iloop) ); -- PreTable(iloop)   );
	  PreTable(iloop) <= PrePreTable(iloop) or (LevelReadEn and DFPReg(iloop));  -- enable level readout
	end generate LoopOverCh;

-- Trigger input scaler, prescale, and signal width extension
-- use generate statement
  LoopFPTrig : for iloop in 1 to 6 generate
    ScalarEnable(iloop) <= ((not ScalarEnableSet(2)) or TrigEn(iloop)) and ScalarEnableSet(1);
    FPtrig :  TrigBitControl
      Port map ( TrigIn => DlyFPInData(iloop),
       Clk => Clk,
       Reset	=> Reset,
       PreScale => TrigPreScale(iloop*4 downto (iloop*4-3)),
       TrigEn => TrigEn(iloop),
       Window => MatchWindow,
       Count => FPCount((iloop*32-1) downto (iloop-1)*32),
       ScalarLatch => ScalarLatch,
       ScalarReset => ScalarReset,
       ScalarEnable => ScalarEnable(iloop),
       STrigOut => SPreFPTable(iloop),
       TrigOut => PreFPTable(iloop) );
  end generate LoopFPTrig ;

-- generate lookup table input signals, which is synced with 62.5MHz clock.
   Mod3MatchVeto: FastMatchVeto PORT MAP(
		Din => PreFPTable,
		DinB => "0000000000",
		DinC => "0000000000000000",
		SDin => SPreFPTable,
		SDinB => "0000000000",
		SDinC => "0000000000000000",
		Dout => TblReg, 
		DoutB => open, 
		DoutC => open, 
		Clk250 => Clk, 
		Reset	=> Reset,
		TestPt	=> open,
		LookUpEn => TableOutEn, 
		Window => MatchWindow, 
		Inhibit => TrigInhibit, 
		MatchEn => FPPreMatch
   );

-- count how many TableOutEn (qualified for table lookup)
	process (ClkTable, Reset)
		begin
			if (Reset = '1') then
				TableValid <= (others => '0');
			elsif (ClkTable'event and ClkTable = '1') then
				if (TableOutEn = '1') then
					TableValid <= TableValid + 1;
				end if;
			end if;
	end process;


-- test Point assignment
	TestPt(1) <= FPDataIn(1);  -- after the differential receiver
	TestPt(2) <= FPinData(1); -- Rising edge detected
	TestPt(3) <= DlyFPinData(1); -- after enable, and prescale
	TestPt(4) <= PrePreTable(1); --Trigger bit enabled?
    TestPt(5) <= PreFPTable(1);
    TestPt(6) <= SPreFPTable(1);
    TestPt(7) <= TblReg(1);
    TestPt(8) <= TableOutEn;
end Behavioral;