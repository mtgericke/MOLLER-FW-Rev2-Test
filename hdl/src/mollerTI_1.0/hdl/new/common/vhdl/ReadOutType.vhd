----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:57:01 02/07/2013 
-- Design Name: 
-- Module Name:    ReadOutType - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ReadOutType is
    Port ( SDTrg : in  STD_LOGIC;
           TS2Trg : in  STD_LOGIC;
        Clock : in std_logic;
           SDType : in  STD_LOGIC_VECTOR (7 downto 0);
           TS2Type : in  STD_LOGIC_VECTOR (7 downto 0);
           OutType : out  STD_LOGIC_VECTOR (7 downto 0));
end ReadOutType;

architecture Behavioral of ReadOutType is

begin
  process (Clock) -- SDTrg, TS2Trg, SDType, TS2Type)
  begin
    if (Clock'event and Clock = '1') then
     if (SDTrg = '1') then
      OutType <= SDType;
     elsif (TS2Trg = '1') then
      OutType <= TS2Type;
       end if;
    end if;
  end process;

end Behavioral;

