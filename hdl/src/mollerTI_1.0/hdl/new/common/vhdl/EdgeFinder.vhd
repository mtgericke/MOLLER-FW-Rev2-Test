----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:48:22 05/27/2015 
-- Design Name: 
-- Module Name:    EdgeFinder - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EdgeFinder is
    Port ( EdgeIn : in  STD_LOGIC_VECTOR (127 downto 0);
           EdgeOut : out  STD_LOGIC_VECTOR (6 downto 0);
			  RiseEdge : out std_logic;
			  FallEdge : out std_logic;
           Clock : in std_logic );
end EdgeFinder;

architecture rtl of EdgeFinder is

   signal OneHotIn : std_logic_vector (126 downto 0);

   function OneHot (
	    One_Hot: std_logic_vector (126 downto 0);
		 Size : natural )  return std_logic_vector is
		 
		 variable Bin_Vec_Var : std_logic_vector(6 downto 0);
	 begin
   	Bin_Vec_Var := (others => '0');
	   for Iloop in 0 to 126  loop
	      if One_Hot(Iloop) = '1' then
		      Bin_Vec_Var := Bin_Vec_Var or std_logic_vector(to_unsigned(Iloop, size));
		   end if;
	   end loop;
	   return Bin_Vec_Var;
   end function;

begin

   XORLogic: for Iloop in 0 to 126 generate
	   begin
	      OneHotIn (Iloop) <= EdgeIn(Iloop) xor EdgeIn(Iloop + 1) ;
	end generate XORLogic;
	process (Clock)
	  begin
       if (Clock'event and Clock = '1') then
         EdgeOut <= OneHot(OneHotIn, 7);
         RiseEdge <= (EdgeIn(127) or EdgeIn(126)) and not (EdgeIn(0) and EdgeIn(1));
         FallEdge <= not (EdgeIn(127) and EdgeIn(126)) and (EdgeIn(0) or EdgeIn(1));
		 end if;
   end process;
end rtl;

