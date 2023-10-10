-------------------------------------------------------------
-- MSS copyright 2012
-- Filename:  INFILE2SIM.VHD
-- Authors: 
--		Alain Zarembowitch / MSS
-- Version: Rev 1
-- Last modified: 7/23/12
-- Inheritance: 	N/A
--
-- description:  import a N_COLS-column tab-delimited file and convert to three std_logic_vector signals.
-- Input must be in the range -2048/+2047
--
-- Rev 2 7/23/12 AZ
-- Added N_COLS as a generic parameter for more flexible use.
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;	-- SIGNED!
use IEEE.std_logic_textio.all;
use STD.textio.all;

entity INFILE2SIM is
	 Generic(
		N_COLS: integer := 3;	-- number of columns
		FILENAME: string := "filein.txt"
	 );
    Port ( 
		--// CLK, RESET
		CLK: in std_logic;
			-- Reference clock
		SAMPLE_CLK_IN: in std_logic;
			-- DATA1 is read at the rising edge of CLK when SAMPLE_CLK_IN = '1'
		DATA1: out std_logic_vector(11 downto 0);
		DATA2: out std_logic_vector(11 downto 0);	-- use if N_COLS = 2 or 3
		DATA3: out std_logic_vector(11 downto 0)	-- use if N_COLS = 3
			-- 12-bit SIGNED 

);
end entity;

architecture Behavioral of INFILE2SIM is
--------------------------------------------------------
--      COMPONENTS
--------------------------------------------------------
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
-- Suffix _D indicates a one CLK delayed version of the net with the same name
-- Suffix _DR indicates rising edge (1st half of the symbol clock)
-- Suffix _DF indicates falling edge (2nd half of the symbol clock)
-- Suffix _X indicates an extended precision version of the net with the same name
-- Suffix _N indicates an inverted version of the net with the same name
-- Suffix _E indicates a one CLK early version of the net with the same name


--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin

READFILE_001: process(CLK)
--	file fileout : TEXT open READ_MODE is FILENAME;
	file filein : TEXT is in FILENAME;
	variable line : LINE;
	variable DATA1_int: integer;
	variable DATA2_int: integer;
	variable DATA3_int: integer;
begin
	if rising_edge(CLK) then
		if(SAMPLE_CLK_IN = '1') then
			readline(filein, line);
			read(line, DATA1_int);	
			if(N_COLS > 1) then
				read(line, DATA2_int);	
			end if;
			if(N_COLS > 2) then
				read(line, DATA3_int);	
			end if;
		end if;
		
		DATA1 <= conv_std_logic_vector(DATA1_int,12);
		if(N_COLS > 1) then
			DATA2 <= conv_std_logic_vector(DATA2_int,12);
		end if;
		if(N_COLS > 2) then
			DATA3 <= conv_std_logic_vector(DATA3_int,12);			
		end if;

	end if;
end process;


end Behavioral;

