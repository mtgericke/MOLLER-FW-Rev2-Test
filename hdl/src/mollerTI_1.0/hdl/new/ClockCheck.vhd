----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2020 08:31:11 AM
-- Design Name: 
-- Module Name: ROCAckBuf - Behavioral
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

entity ClockCheck is
  Port (ClkPrg : in STD_LOGIC;
    CLk250     : in STD_LOGIC;
    Clk625     : in STD_LOGIC;
    ClkChkd  : out STD_LOGIC_VECTOR (2 downto 0));
end ClockCheck;

architecture Behavioral of ClockCheck is

  signal ClkOKint  : std_logic_vector(11 downto 0):= (others => '0');

begin

-- if the two processes for each clock domain are combined into one processes, the placer will not work, complaining of multiple drivers on ClkOKint(11:8) ?!?!?!, May 2, 2022

  process (ClkPrg)
  begin
    if (ClkPrg'event and ClkPrg = '1') then
      ClkOKint(0) <= '1';
      ClkOKint(3) <= not ClkOKint(0);
      ClkChkd(2) <= ClkOKint(0) and ClkOKint(1) and ClkOKint(2) and (not ClkOKint(3));
    end if;
  end process;
  process (ClkPrg)
  begin
   if (CLkPrg'event and ClkPrg = '0') then
      ClkOKint(2) <= '1';
      ClkOKint(1) <= ClkOKint(0);
    end if;
  end process;
  
  process (Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      ClkOKint(4) <= '1';
      ClkOKint(7) <= not ClkOKint(4);
      ClkChkd(1) <= ClkOKint(4) and ClkOKint(5) and  ClkOKint(6) and (not ClkOKint(7));
    end if;
  end process;
  process (Clk625)
  begin
    if (CLk625'event and Clk625 = '0') then
      ClkOKint(6) <= '1';
      ClkOKint(5) <= ClkOKint(4);
    end if;
  end process;
  
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      ClkOKint(8) <= '1';
      ClkOKint(11) <= not ClkOKint(8);
      ClkChkd(0) <= ClkOKint(8) and ClkOKint(9) and ClkOKint(10) and (not ClkOKint(11));
    end if;
  end process;
  process (Clk250)
  begin
    if (CLk250'event and Clk250 = '0') then
      ClkOKint(10) <= '1';
      ClkOKint(9) <= ClkOKint(8);
    end if;
  end process;
  
end Behavioral;
