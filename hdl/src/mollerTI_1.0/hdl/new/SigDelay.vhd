----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2020 11:01:19 AM
-- Design Name: 
-- Module Name: SigDelay - Behavioral
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

entity SigDelay is
  Port ( SigIn : in STD_LOGIC;
   Clock     : in STD_LOGIC;
   DelayVal  : in STD_LOGIC_VECTOR (7 downto 0);
   SigOutMax : out std_logic;
   SigOut    : out STD_LOGIC);
end SigDelay;

architecture Behavioral of SigDelay is
  signal DelayOut : std_logic_vector(7 downto 0);
  signal Q31Out   : std_logic_vector(7 downto 0);
  signal SRLout   : std_logic;
  
  
--  attribute RLOC : string;
--  attribute RLOC of SRLC32E_First:   label is "X0Y0";
--  attribute RLOC of SRLC32E_Second:  label is "X0Y1";
--  attribute RLOC of SRLC32E_Third:   label is "X0Y2";
--  attribute RLOC of SRLC32E_Forth:   label is "X0Y3";
--  attribute RLOC of SRLC32E_Fifth:   label is "X0Y4";
--  attribute RLOC of SRLC32E_Sixth:   label is "X0Y5";
--  attribute RLOC of SRLC32E_Seventh: label is "X0Y6";
--  attribute RLOC of SRLC32E_Eighth:  label is "X0Y7";

begin

  SRLC32E_First : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(0),     -- 1-bit output: SRL Data
      Q31 => Q31Out(0),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => SigIn      );          -- 1-bit input: SRL Data
  SRLC32E_Second : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(1),     -- 1-bit output: SRL Data
      Q31 => Q31Out(1),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(0)      );      -- 1-bit input: SRL Data
  SRLC32E_Third : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(2),     -- 1-bit output: SRL Data
      Q31 => Q31Out(2),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(1)      );      -- 1-bit input: SRL Data
  SRLC32E_Forth : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(3),     -- 1-bit output: SRL Data
      Q31 => Q31Out(3),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(2)      );      -- 1-bit input: SRL Data
  SRLC32E_Fifth : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(4),     -- 1-bit output: SRL Data
      Q31 => Q31Out(4),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(3)      );      -- 1-bit input: SRL Data
  SRLC32E_Sixth : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(5),     -- 1-bit output: SRL Data
      Q31 => Q31Out(5),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(4)      );      -- 1-bit input: SRL Data
  SRLC32E_Seventh : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(6),     -- 1-bit output: SRL Data
      Q31 => Q31Out(6),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(5)      );      -- 1-bit input: SRL Data
  SRLC32E_Eighth : SRLC32E
    generic map (INIT => X"00000000",  -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )         -- Optional inversion for CLK
    port map (Q => DelayOut(7),     -- 1-bit output: SRL Data
      Q31 => Q31Out(7),             -- 1-bit output: SRL Cascade Data
      A   => DelayVal(4 downto 0),  -- 5-bit input: Selects SRL depth
      CE  => '1',                   -- 1-bit input: Clock enable
      CLK => Clock,                 -- 1-bit input: Clock
      D   => Q31Out(6)      );      -- 1-bit input: SRL Data

  SigOutMax <= Q31Out(7);

  process (Clock)
  begin
    if (Clock'event and CLock = '1') then
      case (DelayVal(7 downto 5)) is
        when "001" =>
          SigOut <= DelayOut(1);
        when "010" =>
          SigOut <= DelayOut(2);
        when "011" =>
          SigOut <= DelayOut(3);
        when "100" =>
          SigOut <= DelayOut(4);
        when "101" =>
          SigOut <= DelayOut(5);
        when "110" =>
          SigOut <= DelayOut(6);
        when "111" =>
          SigOut <= DelayOut(7);
        when others =>
          SigOut <= DelayOut(0);
      end case;
    end if;  
  end process;

end Behavioral;
