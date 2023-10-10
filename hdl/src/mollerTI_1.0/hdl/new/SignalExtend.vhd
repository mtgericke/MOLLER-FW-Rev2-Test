----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 11:20:10 AM
-- Design Name: 
-- Module Name: SignalExtend - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SignalExtend is
  Port (Clock : in  STD_LOGIC;
    SigIn     : in  STD_LOGIC;
    SigOut    : out STD_LOGIC);
end SignalExtend;

architecture Behavioral of SignalExtend is

  signal SigExt   : std_logic := '0';
  signal CntTC    : std_logic;
  signal CountExt : std_logic_vector(23 downto 0) := (others => '0');
  
begin

  process(Clock, SigIn, CntTc)
  begin
    if (CntTc = '1') then
      SigExt <= '0';
    elsif (SigIn'event and SigIn = '1') then
      SigExt <= '1';
    end if;
    if (Clock'event and Clock = '1') then
      if (CntTC = '1') then
        CountExt <= (others => '0');
      elsif (SigExt = '1') then
        CountExt <= CountExt + 1;
      end if;
      CntTC <= CountExt(23) and CountExt(22) and CountExt(13) and CountExt(12) and CountExt(11) and CountExt(10);
    end if;
  end process;
  SigOut <= SigIn or SigExt;

end Behavioral;
