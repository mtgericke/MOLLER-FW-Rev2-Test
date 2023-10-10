----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 03:09:54 PM
-- Design Name: 
-- Module Name: TrigPulCond - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TrigPulCond is
  Port (Clock : in STD_LOGIC;  -- 250 MHz
    ClkUsr    : in STD_LOGIC;  -- 62.5 MHz
    TrigIn    : in STD_LOGIC;
    WidthSet  : in STD_LOGIC_VECTOR (7 downto 0);
    TrigQuadL : in STD_LOGIC;
    TrigQuadH : in STD_LOGIC;
    TrigOut   : out STD_LOGIC;
    TrigAck   : out STD_LOGIC;
    Reset     : in std_logic );
end TrigPulCond;

architecture Behavioral of TrigPulCond is
  component SigDelay is
    Port ( SigIn : in STD_LOGIC;
      Clock      : in STD_LOGIC;
      DelayVal   : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax  : out std_logic;
      SigOut     : out STD_LOGIC);
  end component SigDelay;

  signal TrigOutInt : std_logic;
  signal RegTrig    : std_logic;
  signal PreTrigOut : std_logic_vector(3 downto 0);
  signal AdjTrig    : std_logic;
  signal ResetTrig  : std_logic;
  signal DlyTrigOut : std_logic;
  signal Dly2TrigOut : std_logic;
  signal MaxWidth   : std_logic;
  signal WidthCnt   : std_logic_vector(8 downto 0);
  
begin

  process(ClkUsr)
  begin
    if (ClkUsr'event and ClkUsr= '1') then
      RegTrig <= TrigIn;
      TrigAck <= RegTrig;
    end if;
  end process;

  TrigQuadAdj : SRLC32E
    generic map (
INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' ) -- Optional inversion for CLK
    port map (
Q => PreTrigOut(2),  -- 1-bit output: SRL Data
      Q31  => open ,          -- 1-bit output: SRL Cascade Data
      A(0) => TrigQuadL,      -- 5-bit input: Selects SRL depth
      A(1) => TrigQuadH,      -- 5-bit input: Selects SRL depth
      A(4 downto 2) => "000", -- 5-bit input: Selects SRL depth
      CE   => '1',            -- 1-bit input: Clock enable
      CLK  => Clock,          -- 1-bit input: Clock
      D    => PreTrigOut(3) );  -- 1-bit input: SRL Data
  TrigResetDelay : SigDelay
    Port map(SigIn => TrigOutInt,
      Clock        => Clock,        -- in STD_LOGIC;
      DelayVal     => WidthSet,     -- in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax    => open, -- out std_logic;
      SigOut       => DlyTrigOut ); -- out STD_LOGIC);
  
  TrigOut <= TrigOutInt;
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      PreTrigOut(3) <= RegTrig;
      PreTrigOut(1) <= PreTrigOut(2);
      if (ResetTrig = '1') then
        TrigOutInt <= '0';
      elsif (TrigOutInt = '0') then
        TrigOutInt <= PreTrigOut(2) and (not PreTrigOut(1)) ;
      end if;
      Dly2TrigOut <= DlyTrigOut;
      ResetTrig <= Reset or (DlyTrigOut and (not Dly2TrigOut)) or MaxWidth;
      if (DlyTrigOut = '0' or MaxWidth = '1') then
        WidthCnt <= (others => '0');
      elsif (DlyTrigOut = '1') then
        WidthCnt <= WidthCnt + 1;
      end if;
      MaxWidth <= WidthCnt(8) and WidthCnt(7) and WidthCnt(6);
    end if;
  end process;

end Behavioral;
