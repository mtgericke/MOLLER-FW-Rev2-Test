----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2020 10:35:20 AM
-- Design Name: 
-- Module Name: SyncSGen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity SyncSGen is
  Port ( Clock : in STD_LOGIC;
    ClkSlow    : in STD_LOGIC;
    SyncCode   : in STD_LOGIC_VECTOR (7 downto 0);
    SyncDelay  : in STD_LOGIC_VECTOR (7 downto 0);
    SyncCodeEn : in STD_LOGIC;
    ClkCode    : in STD_LOGIC;
    TIBusy     : in STD_LOGIC_VECTOR (8 downto 0);
    SRespTI    : in std_logic_vector(8 downto 0);
    SReqSet    : in std_logic;
    BusySrcEn  : in STD_LOGIC_VECTOR (15 downto 0);
    SyncMode   : in STD_LOGIC;
    Reset      : in STD_LOGIC;
    AutoSyncEn : in STD_LOGIC;
    SyncRegFP  : in STD_LOGIC;
    SyncValid  : out STD_LOGIC;
    TrgSendEn  : out STD_LOGIC;
    SyncOut    : out STD_LOGIC;
    SyncCodedA : out STD_LOGIC;
    SyncCodedB : out STD_LOGIC;
    TestPt     : out STD_LOGIC_VECTOR (7 downto 0));
end SyncSGen;

architecture Behavioral of SyncSGen is

  component SigDelay is
    Port ( SigIn : in STD_LOGIC;
      Clock      : in STD_LOGIC;
      DelayVal   : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax  : out std_logic;
      SigOut     : out STD_LOGIC);
  end component;

  signal SyncGenEn : std_logic_vector(7 downto 0) := (others =>'0');
  signal SyncDone  : std_logic;
  signal VSCode    : std_logic_vector(7 downto 0) := (others => '0');
  signal SCvalid   : std_logic_vector(7 downto 0) := (others => '0');
  signal SreqValid : std_logic_vector(8 downto 0);
  signal SreqAuto  : std_logic_vector(7 downto 0) := (others => '0');
  signal VSbitEn   : std_logic_vector(7 downto 0) := (others => '0');
  signal TSCodes   : std_logic_vector(3 downto 0) := (others => '0');
  signal TSsyncOut : std_logic;
  signal DlySyncFP : std_logic;
  signal SyncOutA  : std_logic;
  signal SyncDlyIn : std_logic;
  signal SyncOutB  : std_logic; -- inverse of SyncOutA
  signal TrgSendEnInt : std_logic;
  
begin

-- Sync generation cycle (every 24 Clock cycles)
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      SyncGenEn(1) <= SyncGenEn(0);
      SyncGenEn(2) <= SyncGenEn(1);
      SyncGenEn(3) <= SyncGenEn(2);
      SyncGenEn(7) <= SyncGenEn(2) and (not SyncGenEn(3));
    end if;
  end process;
  SyncGenEn(0) <= not SyncGenEn(3);  -- to match with the Clk41.667; so divided by 6

  -- SyncCode storage, asynchronous clear, synchronous load
  process (ClkCode, SyncDone, VSBitEn)
  begin
    if (VSBitEn(5) = '1') then  -- VS_Done
      VSCode(7 downto 4) <= (others => '0');
    else
      if (ClkCode'event and ClkCode = '1') then
        if (SyncCodeEn = '1') then
          VSCode(7 downto 4) <= SyncCode(7 downto 4);
        end if;
      end if;
    end if;
  end process;
  process (ClkCode, SyncDone, VSBitEn)
  begin
    if (VSBitEn(4) = '1') then  -- VS_Start
      VSCode(3 downto 0) <= (others => '0');
      SCvalid(0) <= '0';
    else
      if (ClkCode'event and ClkCode = '1') then
        if (SyncCodeEn = '1') then
          VSCode(3 downto 0) <= SyncCode(3 downto 0);
        end if;
   -- SyncCode Valid check, bit(7:4)=bit(3:0), and the code is not 0 or F
        SCvalid(0) <= (not (VSCode(7) and VSCode(6) and VSCode(5) and VSCode(4))) -- not F
                  and (VSCode(7) xnor VSCode(3)) and (VSCode(6) xnor VSCode(2))   -- Bit(7:6)=Bit(3:2)
                  and (VSCode(5) xnor VSCode(1)) and (VSCode(4) xnor VSCode(0))   -- Bit(5:4)=Bit(1:0)
                  and (VSCode(7) or VSCode(6) or VSCode(5) or VSCode(4));         -- not 0
      end if;
    end if;
  end process;

  -- AutoSyncEn logic
  SreqValid <= SRespTI(8 downto 0) or (not TIBusy(8 downto 0)) or (not BusySrcEn(15 downto 7));
  SreqAuto(0) <= SreqValid(8) and SreqValid(7) and SreqValid(6) and SreqValid(5) and SreqValid(4)
             and SreqValid(3) and SreqValid(2) and SreqValid(1) and SreqValid(0)
             and SReqSet and AutoSyncEn;
-- change the following (the same as SyncGen.SCH) to ClkSlow synced design
--  process (Reset, SreqAuto )
--  begin
--    if (Reset = '1') then
--      SreqAuto(1) <= '0';
--    elsif (SreqAuto(0)'event and SreqAuto(0) = '1') then
--      SreqAuto(1) <= '1';
--    end if;
--    if (SreqAuto(6) = '1') then
--      SreqAuto(2) <= '0';
--    elsif (SreqAuto(1)'event and SreqAuto(1) = '1') then
--      SreqAuto(2) <= '1';
--    end if;
--  end process;
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      if (Reset = '1') then
        SreqAuto(1) <= '0';
        SreqAuto(2) <= '0';
      else
        if (SreqAuto(0) = '1') then
          SreqAuto(1) <= '1';
        end if;
        SreqAuto(2) <= SreqAuto(1);
        SreqAuto(3) <= SreqAuto(1) and (not SreqAuto(2));  -- one clock cycle
      end if;
      if (SreqAuto(6) = '1') then
        SreqAuto(5) <= '0';
      elsif (SreqAuto(3) = '1' ) then
        SreqAuto(5) <= '1';
      end if;
      if (SyncGenEn(7) = '1') then
        SreqAuto(6) <= SreqAuto(5);
      end if;
      SreqAuto(7) <= SreqAuto(6);
    end if;
  end process;

  process (ClkSlow, VSBitEn)
  begin
    if (VSBitEn(4) = '1') then
      VSBitEn(7) <= '0';
    elsif (ClkSlow'event and ClkSlow = '1') then
      if (SyncGenEn(7) = '1') then
        VSBitEn(7) <= SreqAuto(6) or SCValid(0);
      end if;
    end if;
  end process;
  
  process (Clock)
  begin
    if (Clock'event and Clock  = '1') then
      if (VSBitEN(6) = '1') then
        VSBitEN(6) <= '0';
      else
        VSBitEn(6) <= VSBitEn(7);
      end if;
      VSBitEN(4) <= VSBitEn(6);
      VSBitEn(3) <= VSBitEn(4);
      VSBitEn(2) <= VSBitEn(3);
      VSBitEn(1) <= VSBitEn(2);
      VSBitEn(0) <= VSBitEn(1);
      VSBitEn(5) <= VSBitEn(0);  -- end of bits, VSBitDone
    end if;
  end process;
  
  SyncValid <= VSBitEn(6);
-- VSBitEn(4) = VSbit_start
-- Code serialization
  process (Clock, VSBitEN)
  begin
    if (VSBitEn(5) = '1') then
      TSCodes(3 downto 0) <= (others => '0');
    else
      if (Clock'event and Clock = '1') then
        if (VSBitEN(6) = '1') then
          case SreqAuto(7) is
            when '1' => TSCodes(3 downto 0) <= "1110";
            when '0' => TSCodes(3 downto 0) <= VSCode(3 downto 0);
          end case;
        end if;
      end if;
    end if;
  end process;
  
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      case SyncMode is
        when '1' => SyncOutA <= DlySyncFP;
        when '0' => SyncOutA <= TSsyncOut;
      end case;
    -- TrgSendEN logic, '1' on code 0x5, to '0' on code 0x7
      if (VSBitEn(4) = '1' and TSCodes(3 downto 0) = "0111") then
        TrgSendEnInt <= '0';
      elsif (VSBitEn(4) = '1' and TSCodes(3 downto 0) = "0101") then
        TrgSendEnInt <= '1';
      end if;
    end if;
  end process;
-- Sync the TrgSendEn to ClkSlow/Clk625
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      TrgSendEn <= TrgSendEnInt;
    end if;
  end process;
  
  SyncDlyin <= (not (VSBitEn(0) and (not TsCodes(0)))) and
               (not (VSBitEn(1) and (not TsCodes(1)))) and
               (not (VSBitEn(2) and (not TsCodes(2)))) and
               (not (VSBitEn(3) and (not TsCodes(3)))) and
               (not VSBitEn(4));
-- delay the serialized code 
  DelaySerialCode : SigDelay
    Port map (SigIn  => SyncDlyIn, --  in STD_LOGIC;
      Clock          => Clock,     -- in STD_LOGIC;
      DelayVal       => SyncDelay, -- in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax      => open, -- out std_logic;
      SigOut         => TSsyncOut );   -- out STD_LOGIC);
-- Delay the SyncRegF1 by 3*32 clock cycles
  DelayF1Sync : SigDelay
    Port map (SigIn  => SyncRegFP, --  in STD_LOGIC;
      Clock          => Clock,     -- in STD_LOGIC;
      DelayVal       => "01011111", -- in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax      => open, -- out std_logic;
      SigOut         => DlySyncFP );   -- out STD_LOGIC);
  SyncOut <= SyncOutA;
  SyncOutB <= not SyncOutA;
-- ODDR for the SYNC coded
  SyncCodedODDRETI1 : ODDRE1  -- D1/D2 polarity changed to match with the QSFP connection (polarity change)
    generic map (IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D1_INVERTED => '0',           -- Unsupported, do not use
      IS_D2_INVERTED => '0',           -- Unsupported, do not use
      SIM_DEVICE => "ULTRASCALE_PLUS", -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS,
                                       -- ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
      SRVAL => '0'  )                  -- Initializes the ODDRE1 Flip-Flops to the specified value ('0', '1')
    port map (Q => SyncCodedA,   -- 1-bit output: Data output to IOB  -- reverse the polarity of SyncCodedA to match with the polarity inverse in QSFP#A
      C  => Clock,    -- 1-bit input: High-speed clock input
      D1 => SyncOutB, -- 1-bit input: Parallel data input 1 
      D2 => SyncOutA, -- 1-bit input: Parallel data input 2
      SR => Reset  ); -- 1-bit input: Active High Async Reset
  SyncCodedODDRETI5 : ODDRE1
    generic map (IS_C_INVERTED => '0', -- Optional inversion for C
      IS_D1_INVERTED => '0',           -- Unsupported, do not use
      IS_D2_INVERTED => '0',           -- Unsupported, do not use
      SIM_DEVICE => "ULTRASCALE_PLUS", -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS,
                                       -- ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
      SRVAL => '0'  )                  -- Initializes the ODDRE1 Flip-Flops to the specified value ('0', '1')
    port map (Q => SyncCodedB,   -- 1-bit output: Data output to IOB
      C  => Clock,    -- 1-bit input: High-speed clock input
      D1 => SyncOutA, -- 1-bit input: Parallel data input 1
      D2 => SyncOutB, -- 1-bit input: Parallel data input 2
      SR => Reset  ); -- 1-bit input: Active High Async Reset

  TestPt(7 downto 0) <= SyncGenEn(2) & SyncOutA & TSSyncOut & SyncDlyIn & VSBitEn(4) & VSBitEn(5) & SyncMode & SyncCodeEn;
end Behavioral;
