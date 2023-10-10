----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/16/2020 09:15:26 AM
-- Design Name: 
-- Module Name: SignalF2S - Behavioral
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

entity SignalF2S is
    Port ( Clk250 : in STD_LOGIC;
           Clk625 : in STD_LOGIC;
           SigIn250 : in STD_LOGIC;
           SigOut625 : inout STD_LOGIC);
end SignalF2S;

architecture Behavioral of SignalF2S is
  signal PreNewSyncBlk : std_logic;
begin
  process (Clk250, SigOut625)
    begin
      if (SigOut625 = '1') then
        PreNewSyncBlk <= '0';
      elsif (Clk250'event and Clk250 = '1') then
        if (SigIn250 = '1') then
          PreNewSyncBlk <= '1';
        end if;
      end if;
  end process;
  process (Clk625) 
    begin
      if (Clk625'event and Clk625 = '1') then
        if (SigOut625 = '1') then
          SigOut625 <= '0';
        else 
          SigOut625 <= PreNewSyncBlk;
        end if;
      end if;
  end process;
end Behavioral;
