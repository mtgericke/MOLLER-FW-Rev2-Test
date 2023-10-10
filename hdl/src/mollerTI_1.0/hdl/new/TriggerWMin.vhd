----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 01:42:34 PM
-- Design Name: 
-- Module Name: TriggerWMin - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity TriggerWMin is
  Port ( Clock : in STD_LOGIC;
    ClockW : in STD_LOGIC;
    TrigIn : in STD_LOGIC;
    MinWidth : in STD_LOGIC_VECTOR (7 downto 0);
    TrigInhibit : out STD_LOGIC);
end TriggerWMin;

architecture Behavioral of TriggerWMin is
  signal PreWMin  : std_logic;
  signal WCount   : std_logic_vector(7 downto 0) := (others => '0');
  signal WMinRst  : std_logic;
begin

-- use the TrigIn as clock
  process (TrigIn, WMinRst)
  begin
    if (WMinRst = '1') then
      PreWMin <= '0';
    elsif (TrigIn'event and TrigIn = '1') then
      PreWMin <= '1';
    end if;
  end process;
--  process (Clock)
--  begin
--    if (Clock'event and Clock = '1') then
--      if (WMinRst = '1') then
--        PreWMin <= '0';
--      elsif (TrigIn = '1') then
--        PreWMin <= '1';
--      end if;
--    end if;
--  end process;
  process (ClockW)
  begin
    if (ClockW'event and ClockW = '1') then
      if (WMinRst = '1') then
        WCount <= (others => '0');
      elsif (PreWMin = '1') then
        WCount <= WCount + 1;
      end if;
      if (WCount(6 downto 0) = MinWidth(6 downto 0)) then
        WMinRst <= '1';
      else
        WMinRst <= '0';
      end if;
    end if;
  end process;
  TrigInhibit <= MinWidth(7) and PreWMin;

end Behavioral;
