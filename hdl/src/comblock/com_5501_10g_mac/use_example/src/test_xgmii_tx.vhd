-------------------------------------------------------------
-- MSS copyright 2017-2018
--	Filename:  TEST_XGMII_TX.VHD
-- Author: Alain Zarembowitch / MSS
--	Version: 0
--	Date last modified: 12/6/17
-- Inheritance: 	N/A
-- 
-- description:  send a single Ethernet frame (including preamble, sfd, etc) 
-- to the XGMII transmit interface, upon trigger.
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity TEST_XGMII_TX is
    Port ( 
		--// CLK, RESET
		CLK156g: in std_logic;
			-- PHY-side GLOBAL clock at 156.25 MHz
		SYNC_RESET156: in std_logic;
			
		--// CONTROLS
		TX_TRIGGER: in std_logic;
			-- 1 CLK156g pulse to trigger sending the test frame. 
		
		--// XGMII PHY Interface 
		XGMII_TXD: out std_logic_vector(63 downto 0);
		XGMII_TXC: out std_logic_vector(7 downto 0);
			-- Single data rate transmit interface 
			-- LSB is sent first
			
		--// TEST POINTS, COMSCOPE TRACES
		TP: out std_logic_vector(10 downto 1)
		
 );
end entity;

architecture Behavioral of TEST_XGMII_TX is
--------------------------------------------------------
--      COMPONENTS
--------------------------------------------------------
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
-- NOTATIONS: 
-- _E as one-CLK early sample
-- _D as one-CLK delayed sample
-- _D2 as two-CLKs delayed sample

signal WORD0: std_logic_vector(63 downto 0) := (others => '0');
signal WORD1: std_logic_vector(63 downto 0) := (others => '0');
signal WORD2: std_logic_vector(63 downto 0) := (others => '0');
signal WORD3: std_logic_vector(63 downto 0) := (others => '0');
signal WORD4: std_logic_vector(63 downto 0) := (others => '0');
signal WORD5: std_logic_vector(63 downto 0) := (others => '0');
signal WORD6: std_logic_vector(63 downto 0) := (others => '0');
signal WORD7: std_logic_vector(63 downto 0) := (others => '0');
signal WORD8: std_logic_vector(63 downto 0) := (others => '0');
signal WORD9: std_logic_vector(63 downto 0) := (others => '0');
signal WORD10: std_logic_vector(63 downto 0) := (others => '0');
signal WORD11: std_logic_vector(63 downto 0) := (others => '0');
signal STATE: unsigned(4 downto 0) := (others => '0');
--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin


STATES_001: process(CLK156g)
begin
	if rising_edge(CLK156g) then
		if(SYNC_RESET156 = '1') then
			STATE <= (others => '0');
		elsif(TX_TRIGGER = '1') then
			STATE <= to_unsigned(1,STATE'length);
		elsif(STATE /= 0) and (STATE(STATE'left) = '0') then
			STATE <= STATE + 1;
		end if;
	end if;
end process;

-- see Xilinx PG053-XAUI for definition of special characters and 64-bit XGMII interface 
-- for each byte, lsb is first serial bit
--WORD0 <= x"0707070707070707";	-- idle
--WORD1 <= x"55555555555555FB";	-- start + preamble
--WORD2 <= x"00FFFFFFFFFFFFD5";	-- preamble + broadcast address + source address
--WORD3 <= x"000608A3BBCA080E";	-- source address
--WORD4 <= x"0001000406000801";	-- data
--WORD5 <= x"0110ACA3BBCA080E";	-- data
--WORD6 <= x"AC0000000000007E";	-- data
--WORD7 <= x"00000000001F0110";	-- data
--WORD8 <= x"0000000000000000";	-- data
--WORD9 <= x"C41B130000000000";	-- data
--WORD10 <= x"070707070707FDD3";	-- data

-- shorter preamble
WORD0 <= x"0707070707070707";	-- idle
WORD1 <= x"0707070707070707";	-- idle
WORD2 <= x"D5555555555555FB";	-- start + preamble
WORD3 <= x"0E00FFFFFFFFFFFF";	-- preamble + broadcast address + source address
WORD4 <= x"01000608A3BBCA08";	-- source address
WORD5 <= x"0E00010004060008";	-- data
WORD6 <= x"7E0110ACA3BBCA08";	-- data
WORD7 <= x"10AC000000000000";	-- data
WORD8 <= x"0000000000001F01";	-- data
WORD9 <= x"0000000000000000";	-- data
WORD10 <= x"D3C41B1300000000";	-- data
WORD11 <= x"07070707070707FD";	-- data


-- offset 1B
--WORD0 <= x"0707070707070707";	-- idle
--WORD1 <= x"FB07070707070707";	-- idle
--WORD2 <= x"D555555555555555";	-- start + preamble
--WORD3 <= x"0E00FFFFFFFFFFFF";	-- preamble + broadcast address + source address
--WORD4 <= x"01000608A3BBCA08";	-- source address
--WORD5 <= x"0E00010004060008";	-- data
--WORD6 <= x"7E0110ACA3BBCA08";	-- data
--WORD7 <= x"10AC000000000000";	-- data
--WORD8 <= x"0000000000001F01";	-- data
--WORD9 <= x"0000000000000000";	-- data
--WORD10 <= x"D3C41B1300000000";	-- data
--WORD11 <= x"07070707070707FD";	-- data



XGMII_TX_001: process(CLK156g)
begin
	if rising_edge(CLK156g) then
		case to_integer(STATE) is
			when 1 => 
				XGMII_TXD <= WORD1;
				XGMII_TXC <= x"FF";
			when 2 => 
				XGMII_TXD <= WORD2;
				XGMII_TXC <= x"01";
			when 3 => 
				XGMII_TXD <= WORD3;
				XGMII_TXC <= x"00";
			when 4 => 
				XGMII_TXD <= WORD4;
				XGMII_TXC <= x"00";
			when 5 => 
				XGMII_TXD <= WORD5;
				XGMII_TXC <= x"00";
			when 6 => 
				XGMII_TXD <= WORD6;
				XGMII_TXC <= x"00";
			when 7 => 
				XGMII_TXD <= WORD7;
				XGMII_TXC <= x"00";
			when 8 => 
				XGMII_TXD <= WORD8;
				XGMII_TXC <= x"00";
			when 9 => 
				XGMII_TXD <= WORD9;
				XGMII_TXC <= x"00";
			when 10 => 
				XGMII_TXD <= WORD10;
				XGMII_TXC <= x"00";
			when 11 => 
				XGMII_TXD <= WORD11;
				XGMII_TXC <= x"FF";
--			when 12 => 
--				XGMII_TXD <= WORD12;
--				XGMII_TXC <= x"00";
--			when 13 => 
--				XGMII_TXD <= WORD13;
--				XGMII_TXC <= x"80";
			when others => 
				XGMII_TXD <= WORD0;
				XGMII_TXC <= x"FF";
		end case;
	end if;
end process;

--// TEST POINTS -------------------------
--TP<= PHY_CONFIG_TP;
TP(1) <= TX_TRIGGER;
TP(2) <= STATE(STATE'left);

end Behavioral;

