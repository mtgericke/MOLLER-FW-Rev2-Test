----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/16/2020 09:37:57 AM
-- Design Name: 
-- Module Name: Signal2Clk - Behavioral
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

entity Signal2Clk is
    Port ( FakeClkIn : in STD_LOGIC;
           Clk : in STD_LOGIC;
           SigOut : inout STD_LOGIC);
end Signal2Clk;

architecture Behavioral of Signal2Clk is
  signal PreOut1 : std_logic;
  signal PreOut2 : std_logic;
begin

  FakeClkInRcv : FDCE
    generic map (INIT => '0',  -- Initial value of register, '0', '1'
   -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      IS_CLR_INVERTED => '0',  -- Optional inversion for CLR
      IS_C_INVERTED => '0',    -- Optional inversion for C
      IS_D_INVERTED => '0' )   -- Optional inversion for D
    port map (Q => PreOut1, -- 1-bit output: Data
      C   => FakeClkIn,     -- 1-bit input: Clock
      CE  => '1',           -- 1-bit input: Clock enable
      CLR => SigOut,        -- 1-bit input: Asynchronous clear
      D   => '1' );         -- 1-bit input: Data

  process (Clk)
    begin
      if (Clk'event and Clk = '1') then
        if (SigOut = '1') then
          SigOut  <= '0';
          PreOut2 <= '0';
        else
          PreOut2 <= PreOut1;
          SigOut  <= PreOut2;
        end if;
      end if;
  end process;
end Behavioral;
