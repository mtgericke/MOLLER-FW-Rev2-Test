----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:27:51 04/11/2017 
-- Design Name: 
-- Module Name:    IRQbusy - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IRQbusy is
  Port ( Busy  : out  STD_LOGIC;
    BlockTh    : in  STD_LOGIC_VECTOR (7 downto 0);
    BufSize    : in  STD_LOGIC_VECTOR (7 downto 0);
    VmeSetting : in  STD_LOGIC_VECTOR (31 downto 0);
    IRQcount   : in  STD_LOGIC_VECTOR (7 downto 0)   );
end IRQbusy;

architecture Behavioral of IRQbusy is

  signal BufferLevel : std_logic_vector(7 downto 0);

begin
  process (VmeSetting, IRQcount, BlockTh, BufSize, BufferLevel)
    begin
      if (VmeSetting(22) = '1') then
        BufferLevel <= BlockTh;
      else
        BufferLevel <= BufSize;
      end if;
      if (IRQcount < BufferLevel) then
        Busy <= '0';
      else
        Busy <= VmeSetting(23);
      end if;
  end process;
end Behavioral;

