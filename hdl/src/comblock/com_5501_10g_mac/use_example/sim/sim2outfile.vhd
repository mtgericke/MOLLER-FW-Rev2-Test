-------------------------------------------------------------
-- MSS copyright 2011-2014
-- Filename:  SIM2OUTFILE.VHD
-- Authors: 
--		Alain Zarembowitch / MSS
-- Version: Rev 2
-- Last modified: 3/25/14
-- Inheritance: 	N/A
--
-- description:  save one std_logic_vector variable to a 3-column tab-delimited file for subsequent plot.
--
-- Rev 1 12/23/11 AZ
-- Corrected sensitivity list
--
-- Rev 2 3/25/14 AZ
-- switched to numeric_std library
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

entity SIM2OUTFILE is
	 Generic(
		FILENAME: string := "fileout.txt"
	 );
    Port ( 
		--// CLK, RESET
		CLK: in std_logic;
			-- Reference clock
		DATA1: in std_logic_vector(11 downto 0);
		DATA2: in std_logic_vector(11 downto 0);
		DATA3: in std_logic_vector(11 downto 0);
			-- 12-bit SIGNED 
		SAMPLE_CLK_IN: in std_logic
			-- DATA1 is read at the rising edge of CLK when SAMPLE_CLK_IN = '1'

);
end entity;

architecture Behavioral of SIM2OUTFILE is
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

WRITE2FILE_001: process(CLK, DATA1, DATA2, DATA3)
--	file fileout : TEXT open WRITE_MODE is FILENAME;
	file fileout : TEXT is out FILENAME;
	variable line : LINE;
begin

	if rising_edge(CLK) then
		if(SAMPLE_CLK_IN = '1') then
			--write(line, DATA1);	-- binary format  0's and 1's
			--hwrite(line, DATA1);	-- hex format
			write(line, integer'image(to_integer(signed(DATA1))), right, 10);	-- unsigned integer format, right-justified
			write(line,HT);			-- tab delimited file format. HT = tab character. See package "standard"
			write(line, integer'image(to_integer(signed(DATA2))), right, 10);	-- unsigned integer format, right-justified
			write(line,HT);			-- tab delimited file format. HT = tab character. See package "standard"
			write(line, integer'image(to_integer(signed(DATA3))), right, 10);	-- unsigned integer format, right-justified
			writeline(fileout, line);
		end if;
	end if;
end process;

end Behavioral;

