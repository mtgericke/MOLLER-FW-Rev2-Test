----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2020 02:43:31 PM
-- Design Name: 
-- Module Name: TrigPrescale - Behavioral
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

entity TrigPrescale is
  Port (Clock : in STD_LOGIC;
    TrigIn    : in STD_LOGIC;
    PreScale  : in STD_LOGIC_VECTOR (15 downto 0);
    Reset     : in STD_LOGIC;
    TrigOut   : out STD_LOGIC  );  -- out rate = In_rate/(Prescale(15:0)+1)
end TrigPrescale;

architecture Behavioral of TrigPrescale is

  signal TrigOutInt : std_logic := '0';
  signal Counter    : std_logic_vector(15 downto 0) := (others => '0');

begin

  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (Reset = '1' or TrigOutInt = '1') then
        Counter <= (others => '0');
      elsif (TrigIn = '1') then
        Counter <= Counter + 1;
      end if;
      if (Reset = '1') then
        TrigOutInt <= '0';
      elsif ((Counter(15 downto 0) xnor PreScale(15 downto 0)) = "1111111111111111") then
        TrigOutInt <= TrigIn;
      end if;
    end if;
  end process;
  TrigOut <= TrigOutInt;
  
end Behavioral;
