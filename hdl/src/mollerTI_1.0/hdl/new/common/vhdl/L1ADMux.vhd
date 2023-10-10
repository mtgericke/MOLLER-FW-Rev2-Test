----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:15:02 10/19/2010 
-- Design Name: 
-- Module Name:    L1AData - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--use UNISIM.VComponents.all;

entity L1ADMux is
  Port ( TTime : in  STD_LOGIC_VECTOR (47 downto 0);
    Numb : in  STD_LOGIC_VECTOR (47 downto 0);
    TrgType: in STD_LOGIC_VECTOR (7 downto 0);
    WordCnt: in STD_LOGIC_VECTOR (2 downto 0);
    AddTrgType : in std_logic_vector(15 downto 0);
    RawTrgIn : in std_logic_vector(32 downto 1);
    SelA : in  STD_LOGIC;
    SelB : in  STD_LOGIC;
    SelC : in  STD_LOGIC;
    SelD : in  STD_LOGIC;
    SelE : in std_logic;
    DOut : out  STD_LOGIC_VECTOR (31 downto 0));
end L1ADMux;

architecture Behavioral of L1ADMux is

  signal RealWordCnt: std_logic_vector (2 downto 0);

begin

--  RealWordCnt(1) <= (WordCnt(1) or WordCnt(0));
--  RealWordCnt(0) <= (WordCnt(1) xnor WordCnt(0));
  process (WordCnt)
  begin
    case (WordCnt) is
      when "000" =>  RealWordCnt <= "001";
      when "001" =>  RealWordCnt <= "010";
      when "010" =>  RealWordCnt <= "010";
      when "011" =>  RealWordCnt <= "011";
      when "100" =>  RealWordCnt <= "010";
      when "101" =>  RealWordCnt <= "011";
      when "110" =>  RealWordCnt <= "011";
      when "111" =>  RealWordCnt <= "100";
      when others => NULL;
    end case;
  end process;
  
  process (TTime, Numb, TrgType, WordCnt, SelA, SelB, SelC, SelD, SelE, RawTrgIn, RealWordCnt, AddTrgType)
  begin
    if (SelA = '1') Then
      DOut (31 downto 24) <= TrgType(7 downto 0);
--      DOut (24) <= ( not TrgType(0));  -- Trigger type(0) is inverted
      DOut (23 downto 16) <= "00000001"; -- hex 0x01
      DOut(15 downto 3) <= "0000000000000";
      DOut (2 downto 0) <= RealWordCnt;
    elsif (SelB = '1') then
      DOut <= Numb(31 downto 0);
    elsif (SelC = '1') then
--      DOut(31 downto 24) <= "10011000"; -- time word
--      DOut(23 downto 0) <= TTime(23 downto 0);
      DOut <= TTime(31 downto 0);
    elsif (SelD = '1') then
--      DOut (31 downto 24) <= "00000000";
      DOut(31 downto 20) <= AddTrgType(11 downto 0);
      DOut(19 downto 16) <= Numb(35 downto 32);
      DOut(15 downto 0) <= TTime(47 downto 32);
    else
      DOut(15 downto 0) <= RawTrgIn(16 downto 1);
      DOut(31 downto 16) <= "1101101001010110"; -- DA56
    end if;
  end process;

end Behavioral;

