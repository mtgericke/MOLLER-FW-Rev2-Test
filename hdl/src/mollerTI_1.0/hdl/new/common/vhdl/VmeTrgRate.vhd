----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:37:45 11/12/2010 
-- Design Name: 
-- Module Name:    VmeTrgRate - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VmeTrgRate is
    Port ( Count : in  STD_LOGIC_VECTOR (31 downto 0);
           Rate : in  STD_LOGIC_VECTOR (15 downto 0);
           Clk : in  STD_LOGIC;
           Timed : out  STD_LOGIC);
end VmeTrgRate;

architecture Behavioral of VmeTrgRate is
signal rateeq: STD_LOGIC;
begin
process (Count, Rate, Clk)
  begin
    if (Clk'event and Clk = '1') then
     if ((Rate(15) = '1') and (Count(1) = '1') and (Count(0) = '1') and (Count (25 downto 11) = Rate (14 downto 0)))  then
      Timed <= '1';
     elsif ((Rate(15) = '0') and (Count(1)='1') and (Count(0) = '1') and (Count (14 downto 2) = Rate (14 downto 2))) then
      Timed <= '1';
     else 
      Timed <= '0';
     end if;
    end if;
  end process;


end Behavioral;

