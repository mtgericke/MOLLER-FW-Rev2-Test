-------------------------------------------------------------
--	Filename:  DNA_ID.VHD
-- Author: 
--		Alain Zarembowitch / MSS, 
--	Version: 3
--	Date last modified: 6/28/14
-- Inheritance: 	none
--
-- description:  Read the 57-bit unique ID
--
-- Rev 1 3/23/12 AZ
-- 1 bit off.
-- Reduced speed for better timing.
-- Initialized variables for simulation.
--
-- Rev 2 1/8/14 AZ
-- Switched from ASYNC_RESET to SYNC_RESET (ISE complained about "Unusually high hold time violation"
-- Switched to IEEE.NUMERIC_STD.ALL library
-- Reduce DNA_PORT clock speed to 20 MHz to meet all Xilinx devices timing
--
-- Rev 3 6/28/14 AZ
-- Corrected length error in 57-bit initialization
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity DNA_ID is
	generic (
		CLK_FREQUENCY: integer := 160
			-- CLK frequency in MHz. 
	 );
    port ( 
			--// Clocks Resets
			CLK: in std_logic;
			SYNC_RESET: in std_logic;

			--// Output
			ID_OUT: out std_logic_vector(56 downto 0);
			ID_VALID_OUT: out std_logic;
				-- '1' when the ID is valid
			ID_SAMPLE_CLK_OUT: out std_logic
				-- 1 CLK wide pulse when the ID is ready (one time after power up or reset)
			
			);
end entity;

architecture Behavioral of DNA_ID is
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
-- Suffix _D indicates a one clock delay
constant CLK_DIV: integer := CLK_FREQUENCY/40;	
	-- Reduce DNA_PORT clock speed to 20 MHz to meet all Xilinx devices timing
signal CNTR: integer range 0 to (CLK_DIV-1) := 0;
signal CLK_DIV2: std_logic := '0';
signal STATE: integer range 0 to 60 := 0;
signal ID: std_logic_vector(56 downto 0) := (others => '0');
signal DNA_READ: std_logic := '0';
signal DNA_SHIFT: std_logic := '0';
signal DNA_DOUT: std_logic := '0';

--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin

-- reduce clock speed to 20 MHz max. Should work for all Xilinx families supporting DNA_PORT
CLK_DIV2_GEN: process(CLK)
begin
	if rising_edge(CLK) then
		if(SYNC_RESET = '1') then
			CNTR <= 0;
		elsif(CNTR = (CLK_DIV-1)) then
			CNTR <= 0;
			CLK_DIV2 <= not CLK_DIV2;
		else
			CNTR <= CNTR + 1;
		end if;
	end if;
end process;


-- state machine. counts from 0 to 60
STATE_001: process(CLK)
begin
	if rising_edge(CLK) then
		if(SYNC_RESET = '1') then
			STATE <= 0;
		elsif(CLK_DIV2 = '0') and (CNTR = (CLK_DIV-1)) then
			-- rising edge of CLK_DIV2
			if(STATE < 60) then
				STATE <= STATE + 1;
			end if;
		end if;
	end if;
end process;

-- read the DNA
DNA_READ_001: process(CLK)
begin
	if rising_edge(CLK) then
		if(SYNC_RESET = '1') then
			DNA_READ <= '0';
		elsif(CLK_DIV2 = '1') and (CNTR = (CLK_DIV-1)) then
			-- falling edge of CLK_DIV2
			if(STATE = 1) then
				DNA_READ <= '1';
			else
				DNA_READ <= '0';
			end if;
		end if;
	end if;
end process;

SHIFT_GEN: process(CLK)
begin
	if rising_edge(CLK) then
		if(CLK_DIV2 = '1') and (CNTR = (CLK_DIV-1)) then
			-- note the falling edge of CLK_DIV2, as per Xilinx recommendation
			-- shift 55 times
			if(STATE = 2) then
				DNA_SHIFT <= '1';
			elsif(STATE = 58) then
				DNA_SHIFT <= '0';
			end if;
		end if;
	end if;
end process;

DNA_PORT_inst : DNA_PORT
generic map (
	SIM_DNA_VALUE => "0" & x"DCBA9876543210"  -- 57-bit constant Specifies a DNA value for simulation purposes (the actual value
													  -- will be specific to the particular device used).
)
port map (
	DOUT => DNA_DOUT,   -- 1-bit Serial shifted output data
	CLK => CLK_DIV2,     -- 1-bit Clock input
	DIN => '0',     -- 1-bit Data input to the shift register
	READ => DNA_READ,   -- 1-bit Synchronous load of the shift register with the Device DNA data
	SHIFT => DNA_SHIFT  -- 1-bit Active high shift enable input
);

ID_001: process(CLK)
begin
	if rising_edge(CLK) then
		if(CLK_DIV2 = '0') and (CNTR = (CLK_DIV-1)) then
			-- rising edge of CLK_DIV2
			if (DNA_SHIFT = '1') or (STATE = 58) then
				ID(0) <= DNA_DOUT;
				ID(56 downto 1) <= ID(55 downto 0);
			end if;
		end if;
	end if;
end process;

ID_002: process(CLK)
begin
	if rising_edge(CLK) then
		if(SYNC_RESET = '1') then
			ID_VALID_OUT <= '0';
			ID_SAMPLE_CLK_OUT <= '0';
		elsif (STATE = 58) and (CLK_DIV2 = '0') and (CNTR = (CLK_DIV-1)) then
			-- just read last bit.
			ID_VALID_OUT <= '1';
			ID_SAMPLE_CLK_OUT <= '1';
		else
			ID_SAMPLE_CLK_OUT <= '0';
		end if;
	end if;
end process;

ID_OUT <= ID;



end Behavioral;

