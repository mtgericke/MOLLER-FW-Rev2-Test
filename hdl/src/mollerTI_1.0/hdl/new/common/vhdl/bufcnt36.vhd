----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:23:56 09/22/2010 
-- Design Name: 
-- Module Name:    buffer32 - Behavioral 
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

entity bufcnt36 is
    Port ( intrg : in  STD_LOGIC_VECTOR (5 downto 0);
           intime : in  STD_LOGIC_VECTOR (15 downto 0);
			  triggered: in STD_LOGIC_VECTOR (7 downto 0);
			  trgsrcen: in STD_LOGIC_VECTOR (7 downto 0);
           outcnt : out  STD_LOGIC_VECTOR (35 downto 0));
end bufcnt36;

architecture Behavioral of bufcnt36 is
begin

 process (intrg, intime, triggered, trgsrcen)
 begin
	outcnt(5 downto 0) <= intrg(5 downto 0);
	outcnt(9 downto 6) <= triggered(3 downto 0);
	outcnt(17 downto 10) <= trgsrcen;
	outcnt(25 downto 18) <= intime(7 downto 0);
	outcnt(26) <= '1';
	outcnt(34 downto 27) <= intime(15 downto 8);
	outcnt(35) <= '1';
 end process;

end Behavioral;

