----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2020 12:48:35 PM
-- Design Name: 
-- Module Name: Carry8FD - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity Carry8FD is
  generic (InvertClock : std_logic_vector(2 downto 1) := "00");
  Port (
    FFout  : out std_logic_vector(7 downto 0); -- added FD out
    Clock  : in  std_logic;                    -- register clock
    CO     : out std_logic_vector(7 downto 0); -- 8-bit output: Carry-out
    O      : out std_logic_vector(7 downto 0); -- 8-bit output: Carry chain XOR data out
    CI     : in  std_logic;                    -- 1-bit input: Lower Carry-In
    CI_TOP : in  std_logic;                    -- 1-bit input: Upper Carry-In
    DI     : in  std_logic_vector(7 downto 0); -- 8-bit input: Carry-MUX data in
    S      : in  std_logic_vector(7 downto 0) );  -- 8-bit input: Carry-mux select
end Carry8FD;

architecture Behavioral of Carry8FD is
  signal COint : std_logic_vector(7 downto 0);
begin

  CARRY8_SigIn : CARRY8
    generic map (
      CARRY_TYPE => "SINGLE_CY8" ) -- 8-bit or dual 4-bit carry (DUAL_CY4, SINGLE_CY8)
    port map (
      CO     => COint,  -- 8-bit output: Carry-out
      O      => O,      -- 8-bit output: Carry chain XOR data out
      CI     => CI,     -- 1-bit input: Lower Carry-In
      CI_TOP => CI_TOP, -- 1-bit input: Upper Carry-In
      DI     => DI,     -- 8-bit input: Carry-MUX data in
      S      => S   );  -- 8-bit input: Carry-mux select
  CO <= COint;

-- rising clock for CO(3:0)
  LowerBitsRisingEdge:
  if (InvertClock(1) = '0') generate
    begin
      process (Clock)
      begin
        if (Clock'event and Clock = '1') then
          FFout(3 downto 0) <= COint(3 downto 0);
        end if;
      end process;
  end generate;
-- rising clock for CO(7:4)
  HigherBitsRisingEdge:
  if (InvertClock(2) = '0') generate
    begin
      process (Clock)
      begin
        if (Clock'event and Clock = '1') then
          FFout(7 downto 4) <= COint(7 downto 4);
        end if;
      end process;
  end generate;
-- Falling clock for CO(3:0)
  LowerBitsFallingEdge:
  if (InvertClock(1) = '1') generate
    begin
      process (Clock)
      begin
        if (Clock'event and Clock = '0') then
          FFout(3 downto 0) <= COint(3 downto 0);
        end if;
      end process;
  end generate;
-- Falling clock for CO(7:4)
  HigherBitFallingEdge:
  if (InvertClock(2) = '1') generate
    begin
      process (Clock)
      begin
        if (Clock'event and Clock = '0') then
          FFout(7 downto 4) <= COint(7 downto 4);
        end if;
      end process;
  end generate;
  
end Behavioral;
