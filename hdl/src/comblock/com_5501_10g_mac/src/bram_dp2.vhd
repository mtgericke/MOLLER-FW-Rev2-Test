-------------------------------------------------------------
-- Filename:  BRAM_DP2.VHD
-- Authors:
-- 	from http://www.xilinx.com/support/documentation/sw_manuals/xilinx14_4/xst_v6s6.pdf
--		Alain Zarembowitch / MSS
-- Version: Rev 3
-- Last modified: 3/1/20

-- Inheritance: 	BRAM_DP.VHD 5/7/15
--
-- description:  synthesizable generic dual port RAM
--
-- Rev 1b 6/21/16 AZ
-- Switched to numeric_std library
-- Initialize to zero during simulation
--
-- Rev 2 6/29/16 AZ
-- Added asymmetrical case (different data widths on A and B ports)
--
-- Rev 3 3/1/20 AZ
-- enforce write before read as expected (Vivado bad inference otherwise)
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BRAM_DP2 is
	 Generic (
		DATA_WIDTHA: integer := 9;	-- MUST BE <= DATA_WIDTHB
		ADDR_WIDTHA: integer := 11;
		DATA_WIDTHB: integer := 9;
		ADDR_WIDTHB: integer := 11
		-- total size on A size MUST match total size on B side
		-- (DATA_WIDTHA * 2**ADDR_WIDTHA) == (DATA_WIDTHB * 2**ADDR_WIDTHB)
	);
    Port (
			-- chip select, active high

	    -- Port A
		CLKA   : in  std_logic;
		CSA: in std_logic;	-- chip select, active high
		WEA    : in  std_logic;	-- write enable, active high
		OEA : in std_logic;	-- output enable, active high
		ADDRA  : in  std_logic_vector(ADDR_WIDTHA-1 downto 0);
		DIA   : in  std_logic_vector(DATA_WIDTHA-1 downto 0);
		DOA  : out std_logic_vector(DATA_WIDTHA-1 downto 0);

		-- Port B
		CLKB   : in  std_logic;
		CSB: in std_logic;	-- chip select, active high
		WEB    : in  std_logic;	-- write enable, active high
		OEB : in std_logic;	-- output enable, active high
		ADDRB  : in  std_logic_vector(ADDR_WIDTHB-1 downto 0);
		DIB   : in  std_logic_vector(DATA_WIDTHB-1 downto 0);
		DOB  : out std_logic_vector(DATA_WIDTHB-1 downto 0)
		);
end entity;

architecture Behavioral of BRAM_DP2 is
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------function
--function max(L,R:INTEGER) return INTEGER is
--begin
--	if (L > R) then
--		return L;
--	else
--		return R;
--	end if;
--end;
--function min(L,R:INTEGER) return INTEGER is
--begin
--	if(L < R) then
--		return L;
--	else
--		return R;
--	end if;
--end;

-- see users constraints in generic section
constant MIN_DATA_WIDTH: integer := DATA_WIDTHA;
constant MAX_DATA_WIDTH: integer := DATA_WIDTHB;
constant MIN_ADDR_WIDTH: integer := ADDR_WIDTHB;
constant MAX_ADDR_WIDTH: integer := ADDR_WIDTHA;
constant RATIO: integer := MAX_DATA_WIDTH /  MIN_DATA_WIDTH;
constant log2RATIO: integer := ADDR_WIDTHA - ADDR_WIDTHB;

-- infered
type mem_type is array ( (2**MAX_ADDR_WIDTH)-1 downto 0 ) of std_logic_vector(MIN_DATA_WIDTH-1 downto 0);
shared variable MEM : mem_type := (others => (others => '0'));
signal DOA_local: std_logic_vector(DATA_WIDTHA-1 downto 0) := (others => '0');
signal DOB_local: std_logic_vector(DATA_WIDTHB-1 downto 0) := (others => '0');

--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin

-- Port A
process(CLKA)
begin
	if rising_edge(CLKA) then
		if(CSA = '1') then
			if (WEA = '1') then
				mem(to_integer(unsigned(ADDRA))) := DIA;
			end if;
			DOA_local <= mem(to_integer(unsigned(ADDRA)));
		end if;
	end if;
end process;

-- tri-state output
DOA <= DOA_local when (CSA = '1') and (OEA = '1') else (others => 'Z');

-- Port B
process(CLKB)
begin
	if rising_edge(CLKB) then
		if(CSB = '1') then
			for I in 0 to RATIO-1 loop
				if (WEB = '1') then
					mem(to_integer(unsigned(ADDRB) & to_unsigned(I,log2RATIO))) := DIB((I+1)*MIN_DATA_WIDTH - 1 downto I*MIN_DATA_WIDTH);
				end if;
				DOB_local((I+1)*MIN_DATA_WIDTH - 1 downto I*MIN_DATA_WIDTH) <= mem(to_integer(unsigned(ADDRB) & to_unsigned(I,log2RATIO)));
			end loop;
		end if;
	end if;
end process;

-- tri-state output
DOB <= DOB_local when (CSB = '1') and (OEB = '1') else (others => 'Z');

end Behavioral;
