----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2020 02:33:30 PM
-- Design Name: 
-- Module Name: TimerRstGen - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity TimerRstGen is
  Port (Clock : in STD_LOGIC;
    ClkSlow   : in STD_LOGIC;
    RstIn     : in STD_LOGIC;
    RstOut    : out STD_LOGIC  );
end TimerRstGen;

architecture Behavioral of TimerRstGen is
  signal RstRcvd     : std_logic; -- registered on the RstIn rising edge
  signal RstRcvdSlow : std_logic; -- Synced to the ClkSlow
  signal RstOutInt   : std_logic; -- Synced to the Clock
begin

  process (RstIn, RstOutInt)
  begin
    if (RstOutInt = '1') then
      RstRcvd <= '0';
    elsif (RstIn'event and RstIn = '1') then
      RstRcvd <= '1';
    end if;
  end process;
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      RstRcvdSlow <= RstRcvd;
    end if;
  end process;
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      RstOutInt <= RstRcvdSlow;
    end if;
  end process;
  RstOut <= RstOutInt;
  
end Behavioral;
