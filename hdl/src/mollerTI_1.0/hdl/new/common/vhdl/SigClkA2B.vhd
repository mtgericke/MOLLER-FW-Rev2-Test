----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2021 08:25:56 AM
-- Design Name: 
-- Module Name: SigClkA2B - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
--  Thomas Jefferson National Accelerator Facility, GU
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments:
--   Sync the one-period SigIn (on ClkIn) to one-period SigOut on ClkOut
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

entity SigClkA2B is
  Port ( SigIn  : in STD_LOGIC;
         ClkIn  : in STD_LOGIC;
         ClkOut : in STD_LOGIC;
         SigOut : out STD_LOGIC);
end SigClkA2B;

architecture Behavioral of SigClkA2B is
  signal SigInt : std_logic_vector(3 downto 0) := (others => '0');
begin
  process (ClkIn, SigInt(1) )
  begin
    if (SigInt(1) = '1') then
      SigInt(0) <= '0';
    elsif (ClkIn'event and ClkIn = '1') then
      if (SigIn = '1') then
        SigInt(0) <= '1';
      end if;
    end if;
  end process;
  process (ClkOut)
  begin
    if (ClkOut'event and ClkOut = '1') then
      SigInt(1) <= SigInt(0);
    end if;
  end process;
  SigOut <= SigInt(1);

end Behavioral;
