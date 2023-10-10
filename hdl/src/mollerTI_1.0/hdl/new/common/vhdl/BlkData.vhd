----------------------------------------------------------------------------------
-- Company: 
-- Engineer: GU
-- 
-- Create Date:    10:17:05 10/19/2010 
-- Design Name: 
-- Module Name:    BlkData - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity BlkData is
  Port ( BoardID : in  STD_LOGIC_VECTOR (4 downto 0);
    TimeStamp : in  STD_LOGIC;
    BlkSize : in  STD_LOGIC_VECTOR (7 downto 0);
    WordCount : in  STD_LOGIC_VECTOR (15 downto 0);
    L1AData : in  STD_LOGIC_VECTOR (35 downto 0);
    BlkNumb : in STD_LOGIC_VECTOR (23 downto 0);
    JlabBID: in STD_LOGIC_VECTOR (3 downto 0);
    BlkHead : in  STD_LOGIC;
    Blk2Head: in STD_LOGIC;
    BlkTail : in  STD_LOGIC;
    EvtData : in  STD_LOGIC;
    ExtraWord: in STD_LOGIC;
    BlkData : out  STD_LOGIC_VECTOR (35 downto 0));
end BlkData;

architecture Behavioral of BlkData is

  signal BlkNumP1 : std_logic_vector(23 downto 0);

begin

  BlkNumP1 <= BlkNumb; --  + 1; --use a Reset_to_1 counter

  process (BoardID, TimeStamp, BlkSize, WordCount, L1AData, BlkNumP1, JlabBID, BlkHead, Blk2Head, BlkTail, EvtData, ExtraWord)
  begin
    if (BlkHead = '1') then
      BlkData (35 downto 29) <= "0110000"; -- '10000" block header, plus "01";
      BlkData (28 downto 24) <= BoardID(4 downto 0);
--      BlkData (29 downto 24) <= CrateID (5 downto 0);
      BlkData (23 downto 20) <= JlabBID; -- TI_ID is 0000, TS_ID is 0101, 
      BlkData (19 downto 18) <= BlkNumP1 (9 downto 8);
      BlkData (17 downto 16) <= "00";
      BlkData (15 downto 8) <= BlkNumP1 (7 downto 0);
      BlkData (7 downto 0) <= BlkSize;
    elsif (Blk2Head = '1') then
      BlkData (35 downto 19) <= "00111111110001000";  -- "00", plus 0xFF1x
      BlkData (18) <= TimeStamp;
      BlkData (17 downto 8) <= "0000100000"; --"00" plus 0x20
      BlkData (7 downto 0) <= BlkSize;
    elsif (EvtData = '1') then
      BlkData (35 downto 34) <= "00";
      BlkData (33 downto 18) <= L1AData (31 downto 16);
      BlkData (17) <= '0';
      BlkData (16) <= L1AData (34);
      BlkData (15 downto 0) <= L1AData (15 downto 0);
    elsif (BlkTail = '1') then
      BlkData (35) <= not (WordCount(0));  -- set the block trailer if Even number of words in the block
      BlkData (34 downto 29) <= "010001";  -- "10001" block trailer, plus "10"
      BlkData (28 downto 24) <= BoardID(4 downto 0); --TI slot number
      BlkData (23 downto 18) <= "000000"; -- Word count, but the TI can never has these high order bits filled.
      BlkData (17 downto 16) <="00";
      BlkData (15 downto 0) <= WordCount;
     elsif (ExtraWord = '1') then
      BlkData (35 downto 29) <= "1011111"; --"10" plus "1_1111"
      BlkData (28 downto 24) <= BoardID(4 downto 0); -- slot number
      BlkData (23 downto 16) <= "00000000";
      BlkData (15 downto 0) <= BlkNumP1(15 downto 0); 
    else                                            -- dummy words
      BlkData (35 downto 34) <= "00";
      BlkData (33 downto 18) <= "1001011001011010"; -- 0x965A
      BlkData (17 downto 16) <= "00";
      BlkData (15 downto 0) <= BlkNumP1(15 downto 0);
    end if;
  end process;
  
end Behavioral;

