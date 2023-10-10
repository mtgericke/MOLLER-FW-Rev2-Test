----------------------------------------------------------------------------------
-- Company: Thomas Jefferson National Accelerator Facility
-- Engineer: GU
-- 
-- Create Date:    10:20:25 01/12/2012 
-- Design Name: 
-- Module Name:    TrigBitControl - Behavioral 
-- Project Name:   TSFPGA
-- Target Devices:   GU
-- Tool versions: 
-- Description: 
--         Trigger input signal treatment:   Enable control, signal width extension,
--     32-bit scalar, preScale (factors of 1, 2, 3, 5, 9, ..., 1+2**14), etc.
--         There are effectively two clock cycles delay, one by prescale, the other
--     by signal width extension.
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TrigBitControl is
    Port ( TrigIn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
        Reset  : in std_logic;
           PreScale : in  STD_LOGIC_VECTOR (3 downto 0);
           TrigEn : in  STD_LOGIC;
           Window : in  STD_LOGIC_VECTOR (7 downto 0);
           Count : inout  STD_LOGIC_VECTOR (31 downto 0);
        ScalarLatch : in std_logic;
        ScalarReset : in std_logic;
        ScalarEnable : in std_logic;
        STrigOut : inout std_logic;
           TrigOut : inout  STD_LOGIC);
end TrigBitControl;

architecture Behavioral of TrigBitControl is

  COMPONENT Count48DSP
    PORT (CLK : IN STD_LOGIC;
      CE : IN STD_LOGIC;
      SCLR : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)  );
  END COMPONENT;

  signal Counter  : std_logic_vector (37 downto 0);
  signal DSPcntReset : std_logic;
  signal DSPcntEn    : std_logic;
  signal PSCounter : std_logic_vector (15 downto 0);
  signal PSTrig  : std_logic;
  signal DPSTrig  : std_logic;
  signal D2PSTrig: std_logic;
  signal WinTrig  : std_logic;
  signal DWinTrig  : std_logic;
  signal TrigL1  : std_logic;
  signal TrigL2  : std_logic;
  signal TrigL3  : std_logic;
  signal TrigL4  : std_logic;
  signal TrigC1  : std_logic;
  signal TrigC2  : std_logic;
  signal TrigC3  : std_logic;
  signal DlyTrigIn : std_logic;

begin

-- trig counter,  scalers, 32-bit counter, before enable and prescale
  process (Clk)
    begin
      if (Clk'event and Clk= '1') then
        DlyTrigIn <= TrigIn;
        if (ScalarLatch ='1') then
          Count(30 downto 7) <= Counter(30 downto 7);
          if (Counter(37 downto 31) > 0) then
            Count(31) <= '1';
            Count(6 downto 0) <= Counter(37 downto 31);
          else
            Count(31) <= '0';
            Count(6 downto 0) <= Counter(6 downto 0);
          end if;
        end if;
-- use DSP counter
--        if ( (Reset = '1') or (ScalarReset = '1') ) then
--          Counter <= (others => '0');
--        elsif (DlyTrigIn = '1' and ScalarEnable = '1') then
--          Counter <= Counter + 1;
--        end if;

        if (STrigOut = '1') then
          PSCounter <= (others => '0');
        elsif (DlyTrigIn = '1') then
          PSCounter <= PSCounter + 1;
        end if;
        
      end if;
  end process;
-- use DSP for counter 
  DSPcntReset <= Reset or ScalarReset;
  DSPcntEn <= DlyTrigIn and ScalarEnable;
  BusyCounterDSP : Count48DSP
    PORT MAP (CLK => Clk,         -- IN STD_LOGIC;
      CE          => DSPcntEn,    -- IN STD_LOGIC;
      SCLR        => DSPcntReset, -- IN STD_LOGIC;
      Q(37 downto 0)  => Counter, -- OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      Q(47 downto 38) => open   );
  
--Prescale
  process (Clk, PSCounter, TrigIn, PreScale, TrigEn)
    begin
       if (Clk'event and Clk = '1') then
        STrigOut <= PSTrig;
      end if;
      case PreScale(3 downto 0) is
         when "0001" => PSTrig <= PSCounter(0) and TrigIn and TrigEn;
         when "0010" => PSTrig <= PSCounter(1) and TrigIn and TrigEn;
         when "0011" => PSTrig <= PSCounter(2) and TrigIn and TrigEn;
         when "0100" => PSTrig <= PSCounter(3) and TrigIn and TrigEn;
         when "0101" => PSTrig <= PSCounter(4) and TrigIn and TrigEn;
         when "0110" => PSTrig <= PSCounter(5) and TrigIn and TrigEn;
         when "0111" => PSTrig <= PSCounter(6) and TrigIn and TrigEn;
         when "1000" => PSTrig <= PSCounter(7) and TrigIn and TrigEn;
         when "1001" => PSTrig <= PSCounter(8) and TrigIn and TrigEn;
         when "1010" => PSTrig <= PSCounter(9) and TrigIn and TrigEn;
         when "1011" => PSTrig <= PSCounter(10) and TrigIn and TrigEn;
         when "1100" => PSTrig <= PSCounter(11) and TrigIn and TrigEn;
         when "1101" => PSTrig <= PSCounter(12) and TrigIn and TrigEn;
         when "1110" => PSTrig <= PSCounter(13) and TrigIn and TrigEn;
         when "1111" => PSTrig <= PSCounter(14) and TrigIn and TrigEn;
         when others =>  PSTrig <= TrigIn and TrigEn;  -- When no-prescale, the PSTrig is also one clock delayed
      end case;
  end process;

  
-- The signal extension part,  implemented at the end of this module
-- SRL32E
  SRLDelay0 : SRLC32E
    generic map (
      INIT => X"00000000")
    port map (
      Q => TrigL1,        -- SRL data output
      Q31 => TrigC1,    -- SRL cascade output pin
      A => Window(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clk,    -- Clock input
      D => PSTrig );       -- SRL data input

  SRLDelay1 : SRLC32E
    generic map (
      INIT => X"00000000")
    port map (
      Q => TrigL2,        -- SRL data output
      Q31 => TrigC2,    -- SRL cascade output pin
      A => Window(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clk,    -- Clock input
      D => TrigC1 );        -- SRL data input

  SRLDelay2 : SRLC32E
    generic map (
      INIT => X"00000000")
    port map (
      Q => TrigL3,        -- SRL data output
      Q31 => TrigC3,    -- SRL cascade output pin
      A => Window(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clk,    -- Clock input
      D => TrigC2 );      -- SRL data input

  SRLDelay3 : SRLC32E
    generic map (
      INIT => X"00000000")
    port map (
      Q => TrigL4,        -- SRL data output
      Q31 => OPEN,    -- SRL cascade output pin
      A => Window(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clk,    -- Clock input
      D => TrigC3      -- SRL data input
    );

-- selection
  process (Clk, Window, TrigL1, TrigL2, TrigL3, TrigL4, PSTrig)
    begin
      if (Clk'event and Clk = '1') then
          DWinTrig <= WinTrig;
        end if;
      case Window (6 downto 5) is
        when "01" => WinTrig <= TrigL2;
        when "10" => WinTrig <= TrigL3;
        when "11" => WinTrig <= TrigL4;
        when others => WinTrig <= TrigL1;
      end case;
  end process;
   
  
-- TrigOut is the latch output of PSTrig, the latch is enabled by NOT(TrigOut), and reset by WinTrg&not(DWinTrig)
-- That is, the TrigOut is one clocked delayed, and width extended (to the window width) PSTrig.
  process (Clk)
    begin
      if (Clk'event and Clk = '1')  then
        if ((WinTrig = '1') or (Reset = '1')) then
          TrigOut <= '0';
        elsif (TrigOut = '0') then
          TrigOut <= PSTrig;
        end if;
      end if;
  end process;
  
end Behavioral;

