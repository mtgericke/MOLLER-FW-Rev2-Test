----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:19:15 11/18/2015 
-- Design Name: 
-- Module Name:    TriggerDelay - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity TriggerDelay is
    Port ( TrgAIn : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
           TrgADly : in  STD_LOGIC_VECTOR (7 downto 0);
           TrgAOut : out  STD_LOGIC);
end TriggerDelay;

architecture Behavioral of TriggerDelay is

  signal TrgAInt : std_logic_vector(31 downto 0); -- Output from the SRLC32E Q
  signal TrgAMed : std_logic_vector(31 downto 0); -- Output from the SRLC32E Q31
  signal TrgADelay : std_logic_vector (4 downto 0);
  signal TrgAShort : std_logic;
  signal TrgALong : std_logic;

begin
-- The short range delay
   SRLC32E0_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(0),        -- SRL data output
      Q31 => TrgAMed(0),    -- SRL cascade output pin
      A => TrgADly(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAIn );         -- SRL data input
  
   SRLC32E1_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(1),        -- SRL data output
      Q31 => TrgAMed(1),    -- SRL cascade output pin
      A => TrgADly(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(0) );         -- SRL data input

   SRLC32E2_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(2),        -- SRL data output
      Q31 => TrgAMed(2),    -- SRL cascade output pin
      A => TrgADly(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(1) );         -- SRL data input

   SRLC32E3_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(3),        -- SRL data output
      Q31 => TrgAMed(3),    -- SRL cascade output pin
      A => TrgADly(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(2) );         -- SRL data input

-- 4 us fixed delay
   SRLC32E4_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(4),        -- SRL data output
      Q31 => TrgAMed(4),    -- SRL cascade output pin
      A => "11111",        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(3) );         -- SRL data input
   SRLC32E5_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(5),        -- SRL data output
      Q31 => TrgAMed(5),    -- SRL cascade output pin
      A => "11111",        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(4) );         -- SRL data input
   SRLC32E6_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(6),        -- SRL data output
      Q31 => TrgAMed(6),    -- SRL cascade output pin
      A => "11111",        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(5) );         -- SRL data input
   SRLC32E7_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(7),        -- SRL data output
      Q31 => TrgAMed(7),    -- SRL cascade output pin
      A => "11111",        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(6) );         -- SRL data input

-- Additional delays
   TrgADelay(4 downto 0) <= TrgADly(2 downto 0) & "11";
   SRLC32E16_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(16),        -- SRL data output
      Q31 => TrgAMed(16),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(7) );         -- SRL data input
   SRLC32E17_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(17),        -- SRL data output
      Q31 => TrgAMed(17),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(16) );         -- SRL data input
   SRLC32E18_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(18),        -- SRL data output
      Q31 => TrgAMed(18),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(17) );         -- SRL data input
   SRLC32E19_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(19),        -- SRL data output
      Q31 => TrgAMed(19),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(18) );         -- SRL data input
   SRLC32E20_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(20),        -- SRL data output
      Q31 => TrgAMed(20),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(19) );         -- SRL data input
   SRLC32E21_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(21),        -- SRL data output
      Q31 => TrgAMed(21),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(20) );         -- SRL data input
   SRLC32E22_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(22),        -- SRL data output
      Q31 => TrgAMed(22),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(21) );         -- SRL data input
   SRLC32E123_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(23),        -- SRL data output
      Q31 => TrgAMed(23),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(22) );         -- SRL data input
   SRLC32E24_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(24),        -- SRL data output
      Q31 => TrgAMed(24),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(23) );         -- SRL data input
   SRLC32E25_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(25),        -- SRL data output
      Q31 => TrgAMed(25),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(24) );         -- SRL data input
   SRLC32E26_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(26),        -- SRL data output
      Q31 => TrgAMed(26),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(25) );         -- SRL data input
   SRLC32E27_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(27),        -- SRL data output
      Q31 => TrgAMed(27),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(26) );         -- SRL data input
   SRLC32E28_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(28),        -- SRL data output
      Q31 => TrgAMed(28),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(27) );         -- SRL data input
   SRLC32E29_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(29),        -- SRL data output
      Q31 => TrgAMed(29),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(28) );         -- SRL data input
   SRLC32E30_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(30),        -- SRL data output
      Q31 => TrgAMed(30),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(29) );         -- SRL data input
   SRLC32E31_inst : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => TrgAInt(31),        -- SRL data output
      Q31 => TrgAMed(31),    -- SRL cascade output pin
      A => TrgADelay(4 downto 0),        -- 5-bit shift depth select input
      CE => '1',      -- Clock enable input
      CLK => Clock,    -- Clock input
      D => TrgAMed(30) );         -- SRL data input

   process (TrgADly, TrgAInt) 
     begin
       case TrgADly(6 downto 5) is
         when "00" => TrgAShort <= TrgAInt(0);
        when "01" => TrgAShort <= TrgAInt(1);
        when "10" => TrgAShort <= TrgAInt(2);
         when others => TrgAShort <= TrgAInt(3);
      end case;
       case TrgADly(6 downto 3) is
        when "0000" => TrgALong <= TrgAInt(16);
        when "0001" => TrgALong <= TrgAInt(17);
        when "0010" => TrgALong <= TrgAInt(18);
        when "0011" => TrgALong <= TrgAInt(19);
        when "0100" => TrgALong <= TrgAInt(20);
        when "0101" => TrgALong <= TrgAInt(21);
        when "0110" => TrgALong <= TrgAInt(22);
        when "0111" => TrgALong <= TrgAInt(23);
        when "1000" => TrgALong <= TrgAInt(24);
        when "1001" => TrgALong <= TrgAInt(25);
        when "1010" => TrgALong <= TrgAInt(26);
        when "1011" => TrgALong <= TrgAInt(27);
        when "1100" => TrgALong <= TrgAInt(28);
        when "1101" => TrgALong <= TrgAInt(29);
        when "1110" => TrgALong <= TrgAInt(30);
        when others => TrgALong <= TrgAInt(31);
       end case;
  end process;
    process (Clock)
    begin
      if (Clock'event and Clock = '1') then
        if (TrgADly(7) = '0') then
          TrgAOut <= TrgAShort;
      else
        TrgAOut <= TrgALong;
      end if;
    end if;
   end process;

end Behavioral;

