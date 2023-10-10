-------------------------------------------------------------
--	Filename:  COMSCOPE2.VHD
-- Authors: Alain Zarembowitch / MSS
-- 			Bengt Bengtson / MSS
--	Version: 0
--	Date last modified: 11/23/15
-- Inheritance: 	COMSCOPE.vhd
--
-- Usage: For each custom application, the user should
-- 1) define the number of traces, up to 4, through the constants TRACEx_ENABLED below. '1' for enabled '0' for disabled;
-- 2) for each enabled trace, define the maximum data width (in bits) and capture length (in number of address bits)
-- 3) for each enabled trace, connect the input ports
--
-- FPGA resources (2 traces, data width 8, address width 9)
-- Number of Slice Registers 1380
-- Number of Slice LUTs 857
-- Number of Block RAM/FIFO 1
-- Number of BUFG/BUFGCTRLs 1

---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COMSCOPE2 is 
generic (
	-- enable individual traces. '1' for enable, '0' for disable
	TRACE1_ENABLED: std_logic := '1';	
	TRACE2_ENABLED: std_logic := '1';	
	TRACE3_ENABLED: std_logic := '0';	
	TRACE4_ENABLED: std_logic := '0';
	-- define the maximum capture width and depth for each trace
	DATA_WIDTH1A: integer := 8;
	ADDR_WIDTH1A: integer := 9;
	ADDR_WIDTH1B: integer := 9;
	DATA_WIDTH2A: integer := 8;
	ADDR_WIDTH2A: integer := 9;
	ADDR_WIDTH2B: integer := 9;
	DATA_WIDTH3A: integer := 8;
	ADDR_WIDTH3A: integer := 9;
	ADDR_WIDTH3B: integer := 9;
	DATA_WIDTH4A: integer := 8;
	ADDR_WIDTH4A: integer := 9;
	ADDR_WIDTH4B: integer := 9
);	
port ( 
	--GLOBAL CLOCKS
   CLK : in std_logic;				-- reference clock
	SYNC_RESET: in std_logic;		-- Synchronous reset active high

	-- Control registers
	REG238: in std_logic_vector(7 downto 0);	
		-- bits 2:1 read trace selection
		--		00 trace 1
		--		01 trace 2
		--		10 trace 3
		--		11 trace 4
	REG239: in std_logic_vector(7 downto 0);	
		-- new in Comscope2  
		-- bits 1:0 acquire modes
		--		00 sample
		--		01 peak detect
		--		10 average over decimation period
		--		11 undefined
		-- other bits: undefined
		
	REG240: in std_logic_vector(7 downto 0);
	REG241: in std_logic_vector(7 downto 0);
	REG242: in std_logic_vector(7 downto 0);
	REG243: in std_logic_vector(7 downto 0);
	REG244: in std_logic_vector(7 downto 0);
	REG245: in std_logic_vector(7 downto 0);
	REG246: in std_logic_vector(7 downto 0);
	REG247: in std_logic_vector(7 downto 0);
	REG248: in std_logic_vector(7 downto 0);
		-- bits 5:0 trigger signal selection
		-- bit 6: unused
		-- bit 7: rising edge (1) or falling edge (0)
	REG249: in std_logic_vector(7 downto 0);

	-- All Sx_y input signals in 2's complement format
	-- Trace 1 input signals
	S1_1: in std_logic_vector((DATA_WIDTH1A-1) downto 0);
	S1_1_VALID: in std_logic;
	S1_2: in std_logic_vector((DATA_WIDTH1A-1) downto 0);
	S1_2_VALID: in std_logic;
	S1_3: in std_logic_vector((DATA_WIDTH1A-1) downto 0);
	S1_3_VALID: in std_logic;
	S1_4: in std_logic_vector((DATA_WIDTH1A-1) downto 0);
	S1_4_VALID: in std_logic;

	-- Trace 2 input signals
	S2_1: in std_logic_vector((DATA_WIDTH2A-1) downto 0);
	S2_1_VALID: in std_logic;
	S2_2: in std_logic_vector((DATA_WIDTH2A-1) downto 0);
	S2_2_VALID: in std_logic;
	S2_3: in std_logic_vector((DATA_WIDTH2A-1) downto 0);
	S2_3_VALID: in std_logic;
	S2_4: in std_logic_vector((DATA_WIDTH2A-1) downto 0);
	S2_4_VALID: in std_logic;

	-- Trace 3 input signals
	S3_1: in std_logic_vector((DATA_WIDTH3A-1) downto 0);
	S3_1_VALID: in std_logic;
	S3_2: in std_logic_vector((DATA_WIDTH3A-1) downto 0);
	S3_2_VALID: in std_logic;
	S3_3: in std_logic_vector((DATA_WIDTH3A-1) downto 0);
	S3_3_VALID: in std_logic;
	S3_4: in std_logic_vector((DATA_WIDTH3A-1) downto 0);
	S3_4_VALID: in std_logic;

	-- Trace 4 input signals
	S4_1: in std_logic_vector((DATA_WIDTH4A-1) downto 0);
	S4_1_VALID: in std_logic;
	S4_2: in std_logic_vector((DATA_WIDTH4A-1) downto 0);
	S4_2_VALID: in std_logic;
	S4_3: in std_logic_vector((DATA_WIDTH4A-1) downto 0);
	S4_3_VALID: in std_logic;
	S4_4: in std_logic_vector((DATA_WIDTH4A-1) downto 0);
	S4_4_VALID: in std_logic;

	-- Trigger signals
	-- 16-bit Trigger signals (select 1-4). 
	T16b_1: in std_logic_vector(15 downto 0);
	T16b_1_VALID: in std_logic;
	T16b_2: in std_logic_vector(15 downto 0);
	T16b_2_VALID: in std_logic;
	T16b_3: in std_logic_vector(15 downto 0);
	T16b_3_VALID: in std_logic;
	T16b_4: in std_logic_vector(15 downto 0);
	T16b_4_VALID: in std_logic;
	-- Add triggers as necessary (up to 127 trigger signals total)

	-- Monitoring registers
	SREG250: out std_logic_vector(7 downto 0);
	SREG251: out std_logic_vector(7 downto 0);

	-- Other input signals
	START_CAPTURE_TOGGLE: in std_logic;
	TRIGGER_REARM_TOGGLE: in std_logic;
	FORCE_TRIGGER_TOGGLE: in std_logic;
	SREG250_READ_TOGGLE: in std_logic;	-- new. replaces REG250_READ
	
	-- test points
	TP: out std_logic_vector(16 downto 1)
);
end entity;

architecture behavioral of COMSCOPE2 is
--------------------------------------------------------
--      COMPONENTS
--------------------------------------------------------
	COMPONENT BRAM_DP2
	 GENERIC(
		DATA_WIDTHA: integer;
		ADDR_WIDTHA: integer;
		DATA_WIDTHB: integer;
		ADDR_WIDTHB: integer
	 );
	 PORT(
		CSA : IN std_logic;
		CLKA   : in  std_logic;
		WEA    : in  std_logic;
		OEA : IN std_logic;
		ADDRA  : in  std_logic_vector(ADDR_WIDTHA-1 downto 0);
		DIA   : in  std_logic_vector(DATA_WIDTHA-1 downto 0);
		DOA  : out std_logic_vector(DATA_WIDTHA-1 downto 0);
		CSB : IN std_logic;
		CLKB   : in  std_logic;
		WEB    : in  std_logic;
		OEB : IN std_logic;
		ADDRB  : in  std_logic_vector(ADDR_WIDTHB-1 downto 0);
		DIB   : in  std_logic_vector(DATA_WIDTHB-1 downto 0);
		DOB  : out std_logic_vector(DATA_WIDTHB-1 downto 0)
		  );
	 END COMPONENT;

--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------

--//-- CONTROLS ------------------------------------------------
signal NEXT_WORD_PLEASE: std_logic;
signal TRIGGER_REARM_TOGGLE_D: std_logic:= '0';
signal TRIGGER_REARM_TOGGLE_D2: std_logic:= '0';
signal TRIGGER_REARM: std_logic;
signal FORCE_TRIGGER_TOGGLE_D: std_logic:= '0';
signal FORCE_TRIGGER_TOGGLE_D2: std_logic:= '0';
signal FORCE_TRIGGER: std_logic:= '0';
signal SREG250_READ_TOGGLE_D: std_logic;
signal SREG250_READ_TOGGLE_D2: std_logic;
signal START_CAPTURE_TOGGLE_D: std_logic:= '0';
signal START_CAPTURE_TOGGLE_D2: std_logic:= '0';
signal START_CAPTURE: std_logic;

--//-- TRACE 1 -------------------------------------------------
signal S1: signed((DATA_WIDTH1A-1) downto 0) := (others => '0');
signal S1_VALID: std_logic := '0';
signal DECIM1_PERIOD: unsigned(31 downto 0) := (others => '0');
signal DECIM1_CNTR: unsigned(31 downto 0) := (others => '0');
signal S1B_VALID: std_logic := '0';
signal S1B: signed((DATA_WIDTH1A-1) downto 0) := (others => '0');
signal S1ABSMAX: signed((DATA_WIDTH1A-1) downto 0) := (others => '0');
signal S1AVERAGE: signed((DATA_WIDTH1A-1) downto 0) := (others => '0');
signal S1_ACC: signed((DATA_WIDTH1A+30) downto 0) := (others => '0');
signal S1_ACC_D: signed((DATA_WIDTH1A+30) downto 0) := (others => '0');
signal S1_AVR_CNTR: unsigned(4 downto 0):= (others => '0');
signal RAMB1_ADDRA: unsigned((ADDR_WIDTH1A-1) downto 0):= (others => '0');
signal RAMB1_ADDRA_INC: unsigned((ADDR_WIDTH1A-1) downto 0):= (others => '0');
signal RAMB1_ADDRB: unsigned((ADDR_WIDTH1B-1) downto 0):= (others => '0');
signal RAMB1_TRIGGER_OFFSET: unsigned((ADDR_WIDTH1A-1) downto 0):= (others => '0');
signal RAMB1_START_ADDR: unsigned((ADDR_WIDTH1A-1) downto 0):= (others => '0');
signal RAMB1_START_ADDR_RDY: std_logic := '0';
signal S1C: std_logic_vector(7 downto 0) := (others => '0');
signal S1C_VALID: std_logic := '0';
signal S1C_VALID_E: std_logic := '0';
signal SM1: integer range 0 to 3 := 0;
signal CAPTURE1_DONE: std_logic := '0';

--//-- TRACE 2 -------------------------------------------------
signal S2: signed((DATA_WIDTH2A-1) downto 0) := (others => '0');
signal S2_VALID: std_logic := '0';
signal DECIM2_PERIOD: unsigned(31 downto 0) := (others => '0');
signal DECIM2_CNTR: unsigned(31 downto 0) := (others => '0');
signal S2B_VALID: std_logic := '0';
signal S2B: signed((DATA_WIDTH2A-1) downto 0) := (others => '0');
signal S2ABSMAX: signed((DATA_WIDTH2A-1) downto 0) := (others => '0');
signal S2AVERAGE: signed((DATA_WIDTH2A-1) downto 0) := (others => '0');
signal S2_ACC: signed((DATA_WIDTH2A+30) downto 0) := (others => '0');
signal S2_ACC_D: signed((DATA_WIDTH2A+30) downto 0) := (others => '0');
signal S2_AVR_CNTR: unsigned(4 downto 0):= (others => '0');
signal RAMB2_ADDRA: unsigned((ADDR_WIDTH2A-1) downto 0):= (others => '0');
signal RAMB2_ADDRA_INC: unsigned((ADDR_WIDTH2A-1) downto 0):= (others => '0');
signal RAMB2_ADDRB: unsigned((ADDR_WIDTH2B-1) downto 0):= (others => '0');
signal RAMB2_TRIGGER_OFFSET: unsigned((ADDR_WIDTH2A-1) downto 0):= (others => '0');
signal RAMB2_START_ADDR: unsigned((ADDR_WIDTH2A-1) downto 0):= (others => '0');
signal RAMB2_START_ADDR_RDY: std_logic := '0';
signal S2C: std_logic_vector(7 downto 0) := (others => '0');
signal S2C_VALID: std_logic := '0';
signal S2C_VALID_E: std_logic := '0';
signal SM2: integer range 0 to 3 := 0;
signal CAPTURE2_DONE: std_logic := '0';

--//-- TRACE 3 -------------------------------------------------
signal S3: signed((DATA_WIDTH3A-1) downto 0) := (others => '0');
signal S3_VALID: std_logic := '0';
signal DECIM3_PERIOD: unsigned(31 downto 0) := (others => '0');
signal DECIM3_CNTR: unsigned(31 downto 0) := (others => '0');
signal S3B_VALID: std_logic := '0';
signal S3B: signed((DATA_WIDTH3A-1) downto 0) := (others => '0');
signal S3ABSMAX: signed((DATA_WIDTH3A-1) downto 0) := (others => '0');
signal S3AVERAGE: signed((DATA_WIDTH3A-1) downto 0) := (others => '0');
signal S3_ACC: signed((DATA_WIDTH3A+30) downto 0) := (others => '0');
signal S3_ACC_D: signed((DATA_WIDTH3A+30) downto 0) := (others => '0');
signal S3_AVR_CNTR: unsigned(4 downto 0):= (others => '0');
signal RAMB3_ADDRA: unsigned((ADDR_WIDTH3A-1) downto 0):= (others => '0');
signal RAMB3_ADDRA_INC: unsigned((ADDR_WIDTH3A-1) downto 0):= (others => '0');
signal RAMB3_ADDRB: unsigned((ADDR_WIDTH3B-1) downto 0):= (others => '0');
signal RAMB3_TRIGGER_OFFSET: unsigned((ADDR_WIDTH3A-1) downto 0):= (others => '0');
signal RAMB3_START_ADDR: unsigned((ADDR_WIDTH3A-1) downto 0):= (others => '0');
signal RAMB3_START_ADDR_RDY: std_logic := '0';
signal S3C: std_logic_vector(7 downto 0) := (others => '0');
signal S3C_VALID: std_logic := '0';
signal S3C_VALID_E: std_logic := '0';
signal SM3: integer range 0 to 3 := 0;
signal CAPTURE3_DONE: std_logic := '0';

--//-- TRACE 4 -------------------------------------------------
signal S4C: std_logic_vector(7 downto 0) := (others => '0');
signal SM4: integer range 0 to 3 := 0;

--//-- TRIGGERS ------------------------------------------------
signal T1: signed(15 downto 0):= (others => '0');
signal T1_VALID: std_logic := '0';
signal TRIGGER_FOUND: std_logic := '0';
signal TRIGGER_THRESHOLD: signed(15 downto 0):= (others => '0');
signal TRIGGER_LEVEL: std_logic := '0';
signal TRIGGER_LEVEL_D: std_logic := '0';
signal TRIGGER_EDGE: std_logic := '0';
signal TRIGGER: std_logic;

--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------

begin

--//-- CONTROLS ------------------------------------------------
CONTROLS_001: process(CLK)
begin
	if rising_edge(CLK) then
		if(SYNC_RESET = '1') then
			TRIGGER_REARM_TOGGLE_D <= '0';
			TRIGGER_REARM_TOGGLE_D2 <= '0';
			TRIGGER_REARM <= '0';
			FORCE_TRIGGER_TOGGLE_D <= '0';
			FORCE_TRIGGER_TOGGLE_D2 <= '0';
			FORCE_TRIGGER <= '0';
			START_CAPTURE_TOGGLE_D <= '0';
			START_CAPTURE_TOGGLE_D2 <= '0';
			START_CAPTURE <= '0';
			SREG250_READ_TOGGLE_D <= '0';
			SREG250_READ_TOGGLE_D2 <= '0';
			NEXT_WORD_PLEASE <= '0';
			
		else
			TRIGGER_REARM_TOGGLE_D <= TRIGGER_REARM_TOGGLE;
			TRIGGER_REARM_TOGGLE_D2 <= TRIGGER_REARM_TOGGLE_D;
			FORCE_TRIGGER_TOGGLE_D <= FORCE_TRIGGER_TOGGLE;
			FORCE_TRIGGER_TOGGLE_D2 <= FORCE_TRIGGER_TOGGLE_D;
			START_CAPTURE_TOGGLE_D <= START_CAPTURE_TOGGLE;
			START_CAPTURE_TOGGLE_D2 <= START_CAPTURE_TOGGLE_D;
			SREG250_READ_TOGGLE_D <= SREG250_READ_TOGGLE;
			SREG250_READ_TOGGLE_D2 <= SREG250_READ_TOGGLE_D;
			
			if(TRIGGER_REARM_TOGGLE_D /= TRIGGER_REARM_TOGGLE_D2) then
				TRIGGER_REARM <= '1';
			else
				TRIGGER_REARM <= '0';
			end if;

			if(FORCE_TRIGGER_TOGGLE_D /= FORCE_TRIGGER_TOGGLE_D2) then
				FORCE_TRIGGER <= '1';
			else
				FORCE_TRIGGER <= '0';
			end if;

			if(START_CAPTURE_TOGGLE_D /= START_CAPTURE_TOGGLE_D2)then
				START_CAPTURE <= '1';
			else
				START_CAPTURE <= '0';
			end if;

			if(SREG250_READ_TOGGLE_D /= SREG250_READ_TOGGLE_D2)then
				NEXT_WORD_PLEASE <= '1';
			else
				NEXT_WORD_PLEASE <= '0';
			end if;
			
		end if;
	end if;
end process;


--//-- TRACE 1 -------------------------------------------------
TRACE1_GEN: if(TRACE1_ENABLED = '1') generate
	-- 1. input signal selection
	-- Also select nominal input sampling clock (_VALID) or the master clock CLK
	INPUT_SEL_001: process(CLK)
	begin
		if rising_edge(CLK) then
			case REG240(6 downto 0) is
				when b"0000001" => 	S1 <= signed(S1_1);
									S1_VALID <= S1_1_VALID or REG240(7);
				when b"0000010" => 	S1 <= signed(S1_2);
									S1_VALID <= S1_2_VALID or REG240(7);
				when b"0000011" => 	S1 <= signed(S1_3);
									S1_VALID <= S1_3_VALID or REG240(7);
				when b"0000100" => 	S1 <= signed(S1_4);
									S1_VALID <= S1_4_VALID or REG240(7);
				when others => S1 <= (others => '0');
									S1_VALID <= '0';
			end case;
		end if;
	end process;
	
	-- 2. decimation 
	-- DECIM1_PERIOD = decimation period - 1
	DECIMATION_001: process(CLK)
	begin
		if rising_edge(CLK) then
			case REG241(4 downto 0) is
				when b"00000" => DECIM1_PERIOD <= x"00000000";
				when b"00001" => DECIM1_PERIOD <= x"00000001";
				when b"00010" => DECIM1_PERIOD <= x"00000003";
				when b"00011" => DECIM1_PERIOD <= x"00000007";
				when b"00100" => DECIM1_PERIOD <= x"0000000f";
				when b"00101" => DECIM1_PERIOD <= x"0000001f";
				when b"00110" => DECIM1_PERIOD <= x"0000003f";
				when b"00111" => DECIM1_PERIOD <= x"0000007f";
				when b"01000" => DECIM1_PERIOD <= x"000000ff";
				when b"01001" => DECIM1_PERIOD <= x"000001ff";
				when b"01010" => DECIM1_PERIOD <= x"000003ff";
				when b"01011" => DECIM1_PERIOD <= x"000007ff";
				when b"01100" => DECIM1_PERIOD <= x"00000fff";
				when b"01101" => DECIM1_PERIOD <= x"00001fff";
				when b"01110" => DECIM1_PERIOD <= x"00003fff";
				when b"01111" => DECIM1_PERIOD <= x"00007fff";
				when b"10000" => DECIM1_PERIOD <= x"0000ffff";
				when b"10001" => DECIM1_PERIOD <= x"0001ffff";
				when b"10010" => DECIM1_PERIOD <= x"0003ffff";
				when b"10011" => DECIM1_PERIOD <= x"0007ffff";
				when b"10100" => DECIM1_PERIOD <= x"000fffff";
				when b"10101" => DECIM1_PERIOD <= x"001fffff";
				when b"10110" => DECIM1_PERIOD <= x"003fffff";
				when b"10111" => DECIM1_PERIOD <= x"007fffff";
				when b"11000" => DECIM1_PERIOD <= x"00ffffff";
				when b"11001" => DECIM1_PERIOD <= x"01ffffff";
				when b"11010" => DECIM1_PERIOD <= x"03ffffff";
				when b"11011" => DECIM1_PERIOD <= x"07ffffff";
				when b"11100" => DECIM1_PERIOD <= x"0fffffff";
				when b"11101" => DECIM1_PERIOD <= x"1fffffff";
				when b"11110" => DECIM1_PERIOD <= x"3fffffff";
				when others => DECIM1_PERIOD <= x"7fffffff";
			end case;
		end if;
	end process;

	DECIMATION_002: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				DECIM1_CNTR <= (others => '0');
			elsif(S1_VALID = '1') then
				if(DECIM1_CNTR = 0) then
					-- rearm decimation counter
					DECIM1_CNTR <= DECIM1_PERIOD;
				else
					-- decrement decimation counter
					DECIM1_CNTR <= DECIM1_CNTR -1;
				end if;
			end if;

		end if;
	end process;
	
	--3. Acquire mode: sample, peak, average 
	ACQUIRE_001: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S1B <= (others => '0');
				S1ABSMAX <= (others => '0');
			elsif(S1_VALID = '1') then
				if(DECIM1_CNTR = 0) then
					-- decimated sample
					S1ABSMAX <= (others => '0');
					if(REG239(1 downto 0) = "01") and (abs(S1) < abs(S1ABSMAX) ) then
						-- acquire mode: peak detect
						S1B <= S1ABSMAX;
					elsif(REG239(1 downto 0) = "10") then
						-- acquire mode: average
						S1B <= S1AVERAGE;
					else
						-- acquire mode: sample
						S1B <= S1;
					end if;
				elsif(REG239(1 downto 0) = "01") and (abs(S1) > abs(S1ABSMAX) ) then
					-- peak detect mode: Keep track of peak.
					S1ABSMAX <= S1;
				end if;
			end if;
		end if;
	end process;

	ACQUIRE_002: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S1B_VALID <= '0';
			elsif(S1_VALID = '1') and (DECIM1_CNTR = 0) then
				-- decimated sample
				S1B_VALID <= '1';
			else
				S1B_VALID <= '0';
			end if;
		end if;
	end process;

	-- 4. Averaging mode
	-- process dedicated to the averaging of samples over the decimation period
	-- use integrate and dump
	AVERAGING_001: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S1_ACC <= (others => '0');
			elsif(S1_VALID = '1') and (REG239(1 downto 0) = "10")  then
				if (DECIM1_CNTR = 0) then
					S1_ACC <= resize(S1,S1_ACC'length);
				else
					S1_ACC <= S1_ACC + resize(S1,S1_ACC'length);
				end if;
			end if;
		end if;
	end process;
	
	-- use shift to divide, more efficient than a large (32) case statement
	-- For example, if REG241(4:0) = 2, decimation is 4
	-- S1_AVR_CNTR counts down from 2 to 0
	-- S1_ACC_D is shifted right twice (thus dividing by 4)
	AVERAGING_002: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S1_AVR_CNTR <= (others => '0');
			elsif(S1_VALID = '1') and (REG239(1 downto 0) = "10") and (DECIM1_CNTR = 0) then
				S1_AVR_CNTR <= unsigned(REG241(4 downto 0));
				S1_ACC_D <= S1_ACC;	-- latch previous sum
			elsif(S1_AVR_CNTR /= 0) then
				S1_AVR_CNTR <= S1_AVR_CNTR - 1;
				S1_ACC_D(S1_ACC_D'left -1 downto 0) <= S1_ACC_D(S1_ACC_D'left downto 1);
			end if;
		end if;
	end process;
	S1AVERAGE <= S1_ACC_D((DATA_WIDTH1A-1) downto 0);
	
	-- 5. capture
	BRAM_DP2_001: BRAM_DP2 
	GENERIC MAP(
		DATA_WIDTHA => DATA_WIDTH1A,		
		ADDR_WIDTHA => ADDR_WIDTH1A,
		DATA_WIDTHB => 8,		 	-- output is always byte-wide
		ADDR_WIDTHB => ADDR_WIDTH1B
	)
	PORT MAP(
		 CSA => '1',
		 CLKA => CLK,
		 WEA => S1B_VALID,
		 OEA => '0',
		 ADDRA => std_logic_vector(RAMB1_ADDRA),  
		 DIA => std_logic_vector(S1B),
		 DOA => open,
		 CSB => '1',
		 CLKB => CLK,
		 WEB => '0',
		 OEB => '1',
		 ADDRB => std_logic_vector(RAMB1_ADDRB),
		 DIB => (others => '0'),
		 DOB => S1C
	);
	
	-- write pointer management
	RAMB1_ADDRA_INC <= RAMB1_ADDRA + 1;
	WPTR_GEN_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				RAMB1_ADDRA <= (others => '0');
			elsif(S1B_VALID = '1') and ((SM1 = 1)  or (SM1 = 2)) then
				-- capture in progress
				RAMB1_ADDRA <= RAMB1_ADDRA_INC;
			elsif(S1B_VALID = '1') and (SM1 = 3) and (CAPTURE1_DONE = '0') then
				-- capture in progress
				RAMB1_ADDRA <= RAMB1_ADDRA_INC;
			end if;
		end if;
	end process;
	
	-- capture done?
	CAPTURE1_DONE <= '1' when (RAMB1_ADDRA_INC = RAMB1_START_ADDR) else '0'; 
	
	-- read pointer management
	RPTR_GEN_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			S1C_VALID <= S1C_VALID_E;	-- 1 CLK delay latency in reading BRAM
			
			if(RAMB1_START_ADDR_RDY = '1') then
				-- pre-position the read pointer at 0,10,50,90% before the current trigger
				RAMB1_ADDRB <= RAMB1_START_ADDR - 1;
				S1C_VALID_E <= '0';
			elsif(REG238(2 downto 1) = "00") and (NEXT_WORD_PLEASE = '1') then
				-- trace selected for reading
				RAMB1_ADDRB <= RAMB1_ADDRB + 1;
				S1C_VALID_E <= '1';
			else
				S1C_VALID_E <= '0';
			end if;
		end if;
	end process;

	-- 6. floor/ceiling bounds
	-- Upon receiving a trigger, determine the memory bounds for this capture
	BOUNDS_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(REG241(7 downto 5) = "000") then
				-- trigger set at 0%
				RAMB1_TRIGGER_OFFSET <= (others => '0');
			elsif(REG241(7 downto 5) = "001") then
				-- trigger set at 10%
				RAMB1_TRIGGER_OFFSET((ADDR_WIDTH1A-1) downto (ADDR_WIDTH1A-6)) <= "000110";
				RAMB1_TRIGGER_OFFSET((ADDR_WIDTH1A-7) downto 0) <= (others => '0');
			elsif(REG241(7 downto 5) = "010") then
				-- trigger set at 50%
				RAMB1_TRIGGER_OFFSET((ADDR_WIDTH1A-1) downto (ADDR_WIDTH1A-2)) <= "10";
				RAMB1_TRIGGER_OFFSET((ADDR_WIDTH1A-3) downto 0) <= (others => '0');
			else
			--elsif(REG241(7 downto 5) = "010") then
				-- trigger set at 90%
				RAMB1_TRIGGER_OFFSET((ADDR_WIDTH1A-1) downto (ADDR_WIDTH1A-6)) <= "111010";
				RAMB1_TRIGGER_OFFSET((ADDR_WIDTH1A-7) downto 0) <= (others => '0');
			end if;
		end if;
	end process;

	BOUNDS_002: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SM1 = 2) and (TRIGGER = '1') then
				RAMB1_START_ADDR <= RAMB1_ADDRA - RAMB1_TRIGGER_OFFSET;
					-- offset depends on trigger position (0,10,50,90%)
				RAMB1_START_ADDR_RDY <= '1';
			else
				RAMB1_START_ADDR_RDY <= '0';
			end if;
		end if;
	end process;

	-- 7. State machine
	SM_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				SM1 <= 0;	-- idle
			elsif(SM1 = 0) and (unsigned(REG240(6 downto 0)) /= 0) and (START_CAPTURE = '1') then
				SM1 <= 1;	-- capture in progress pre-trigger
			elsif(SM1 = 1) and (TRIGGER_REARM = '1') then
				SM1 <= 2;	-- capture in progress, waiting for trigger
			elsif(SM1 = 2) and (TRIGGER = '1') then
				SM1 <= 3;	-- capturing after trigger
			elsif(SM1 = 3) and (CAPTURE1_DONE = '1') then
				SM1 <= 0;
			end if;
		end if;
	end process;
	

end generate;

--//-- TRACE 2 -------------------------------------------------
TRACE2_GEN: if(TRACE2_ENABLED = '1') generate
	-- 1. input signal selection
	-- Also select nominal input sampling clock (_VALID) or the master clock CLK
	INPUT_SEL_001: process(CLK)
	begin
		if rising_edge(CLK) then
			case REG242(6 downto 0) is
				when b"0000001" => 	S2 <= signed(S2_1);
									S2_VALID <= S2_1_VALID or REG242(7);
				when b"0000010" => 	S2 <= signed(S2_2);
									S2_VALID <= S2_2_VALID or REG242(7);
				when b"0000011" => 	S2 <= signed(S2_3);
									S2_VALID <= S2_3_VALID or REG242(7);
				when b"0000100" => 	S2 <= signed(S2_4);
									S2_VALID <= S2_4_VALID or REG242(7);
				when others => S2 <= (others => '0');
									S2_VALID <= '0';
			end case;
		end if;
	end process;
	
	-- 2. decimation 
	-- DECIM2_PERIOD = decimation period - 1
	DECIMATION_001: process(CLK)
	begin
		if rising_edge(CLK) then
			case REG243(4 downto 0) is
				when b"00000" => DECIM2_PERIOD <= x"00000000";
				when b"00001" => DECIM2_PERIOD <= x"00000001";
				when b"00010" => DECIM2_PERIOD <= x"00000003";
				when b"00011" => DECIM2_PERIOD <= x"00000007";
				when b"00100" => DECIM2_PERIOD <= x"0000000f";
				when b"00101" => DECIM2_PERIOD <= x"0000001f";
				when b"00110" => DECIM2_PERIOD <= x"0000003f";
				when b"00111" => DECIM2_PERIOD <= x"0000007f";
				when b"01000" => DECIM2_PERIOD <= x"000000ff";
				when b"01001" => DECIM2_PERIOD <= x"000001ff";
				when b"01010" => DECIM2_PERIOD <= x"000003ff";
				when b"01011" => DECIM2_PERIOD <= x"000007ff";
				when b"01100" => DECIM2_PERIOD <= x"00000fff";
				when b"01101" => DECIM2_PERIOD <= x"00001fff";
				when b"01110" => DECIM2_PERIOD <= x"00003fff";
				when b"01111" => DECIM2_PERIOD <= x"00007fff";
				when b"10000" => DECIM2_PERIOD <= x"0000ffff";
				when b"10001" => DECIM2_PERIOD <= x"0001ffff";
				when b"10010" => DECIM2_PERIOD <= x"0003ffff";
				when b"10011" => DECIM2_PERIOD <= x"0007ffff";
				when b"10100" => DECIM2_PERIOD <= x"000fffff";
				when b"10101" => DECIM2_PERIOD <= x"001fffff";
				when b"10110" => DECIM2_PERIOD <= x"003fffff";
				when b"10111" => DECIM2_PERIOD <= x"007fffff";
				when b"11000" => DECIM2_PERIOD <= x"00ffffff";
				when b"11001" => DECIM2_PERIOD <= x"01ffffff";
				when b"11010" => DECIM2_PERIOD <= x"03ffffff";
				when b"11011" => DECIM2_PERIOD <= x"07ffffff";
				when b"11100" => DECIM2_PERIOD <= x"0fffffff";
				when b"11101" => DECIM2_PERIOD <= x"1fffffff";
				when b"11110" => DECIM2_PERIOD <= x"3fffffff";
				when others => DECIM2_PERIOD <= x"7fffffff";
			end case;
		end if;
	end process;
	
	DECIMATION_002: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				DECIM2_CNTR <= (others => '0');
			elsif(S2_VALID = '1') then
				if(DECIM2_CNTR = 0) then
					-- rearm decimation counter
					DECIM2_CNTR <= DECIM2_PERIOD;
				else
					-- decrement decimation counter
					DECIM2_CNTR <= DECIM2_CNTR -1;
				end if;
			end if;

		end if;
	end process;

	--3. Acquire mode: sample, peak, average 
	ACQUIRE_001: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S2B <= (others => '0');
				S2ABSMAX <= (others => '0');
			elsif(S2_VALID = '1') then
				if(DECIM2_CNTR = 0) then
					-- decimated sample
					S2ABSMAX <= (others => '0');
					if(REG239(3 downto 2) = "01") and (abs(S2) < abs(S2ABSMAX) ) then
						-- acquire mode: peak detect
						S2B <= S2ABSMAX;
					elsif(REG239(3 downto 2) = "10") then
						-- acquire mode: average
						S2B <= S2AVERAGE;
					else
						-- acquire mode: sample
						S2B <= S2;
					end if;
				elsif(REG239(3 downto 2) = "01") and (abs(S2) > abs(S2ABSMAX) ) then
					-- peak detect mode: Keep track of peak.
					S2ABSMAX <= S2;
				end if;
			end if;
		end if;
	end process;

	ACQUIRE_002: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S2B_VALID <= '0';
			elsif(S2_VALID = '1') and (DECIM2_CNTR = 0) then
				-- decimated sample
				S2B_VALID <= '1';
			else
				S2B_VALID <= '0';
			end if;
		end if;
	end process;

	-- 4. Averaging mode
	-- process dedicated to the averaging of samples over the decimation period
	-- use integrate and dump
	AVERAGING_001: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S2_ACC <= (others => '0');
			elsif(S2_VALID = '1') and (REG239(3 downto 2) = "10")  then
				if (DECIM2_CNTR = 0) then
					S2_ACC <= resize(S2,S2_ACC'length);
				else
					S2_ACC <= S2_ACC + resize(S2,S2_ACC'length);
				end if;
			end if;
		end if;
	end process;
	
	-- use shift to divide, more efficient than a large (32) case statement
	-- For example, if REG243(4:0) = 2, decimation is 4
	-- S2_AVR_CNTR counts down from 2 to 0
	-- S2_ACC_D is shifted right twice (thus dividing by 4)
	AVERAGING_002: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S2_AVR_CNTR <= (others => '0');
			elsif(S2_VALID = '1') and (REG239(3 downto 2) = "10") and (DECIM2_CNTR = 0) then
				S2_AVR_CNTR <= unsigned(REG243(4 downto 0));
				S2_ACC_D <= S2_ACC;	-- latch previous sum
			elsif(S2_AVR_CNTR /= 0) then
				S2_AVR_CNTR <= S2_AVR_CNTR - 1;
				S2_ACC_D(S2_ACC_D'left -1 downto 0) <= S2_ACC_D(S2_ACC_D'left downto 1);
			end if;
		end if;
	end process;
	S2AVERAGE <= S2_ACC_D((DATA_WIDTH2A-1) downto 0);
	
	-- 5. capture
	BRAM_DP2_001: BRAM_DP2 
	GENERIC MAP(
		DATA_WIDTHA => DATA_WIDTH2A,		
		ADDR_WIDTHA => ADDR_WIDTH2A,
		DATA_WIDTHB => 8,		 	-- output is always byte-wide
		ADDR_WIDTHB => ADDR_WIDTH2B
	)
	PORT MAP(
		 CSA => '1',
		 CLKA => CLK,
		 WEA => S2B_VALID,
		 OEA => '0',
		 ADDRA => std_logic_vector(RAMB2_ADDRA),  
		 DIA => std_logic_vector(S2B),
		 DOA => open,
		 CSB => '1',
		 CLKB => CLK,
		 WEB => '0',
		 OEB => '1',
		 ADDRB => std_logic_vector(RAMB2_ADDRB),
		 DIB => (others => '0'),
		 DOB => S2C
	);
	
	-- write pointer management
	RAMB2_ADDRA_INC <= RAMB2_ADDRA + 1;
	WPTR_GEN_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				RAMB2_ADDRA <= (others => '0');
			elsif(S2B_VALID = '1') and ((SM2 = 1)  or (SM2 = 2)) then
				-- capture in progress
				RAMB2_ADDRA <= RAMB2_ADDRA_INC;
			elsif(S2B_VALID = '1') and (SM2 = 3) and (CAPTURE2_DONE = '0') then
				-- capture in progress
				RAMB2_ADDRA <= RAMB2_ADDRA_INC;
			end if;
		end if;
	end process;
	
	-- capture done?
	CAPTURE2_DONE <= '1' when (RAMB2_ADDRA_INC = RAMB2_START_ADDR) else '0'; 
	
	-- read pointer management
	RPTR_GEN_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			S2C_VALID <= S2C_VALID_E;	-- 1 CLK delay latency in reading BRAM
			
			if(RAMB2_START_ADDR_RDY = '1') then
				-- pre-position the read pointer at 0,10,50,90% before the current trigger
				RAMB2_ADDRB <= RAMB2_START_ADDR - 1;
				S2C_VALID_E <= '0';
			elsif(REG238(2 downto 1) = "01") and (NEXT_WORD_PLEASE = '1') then
				-- trace selected for reading
				RAMB2_ADDRB <= RAMB2_ADDRB + 1;
				S2C_VALID_E <= '1';
			else
				S2C_VALID_E <= '0';
			end if;
		end if;
	end process;

	-- 6. floor/ceiling bounds
	-- Upon receiving a trigger, determine the memory bounds for this capture
	BOUNDS_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(REG243(7 downto 5) = "000") then
				-- trigger set at 0%
				RAMB2_TRIGGER_OFFSET <= (others => '0');
			elsif(REG243(7 downto 5) = "001") then
				-- trigger set at 10%
				RAMB2_TRIGGER_OFFSET((ADDR_WIDTH2A-1) downto (ADDR_WIDTH2A-6)) <= "000110";
				RAMB2_TRIGGER_OFFSET((ADDR_WIDTH2A-7) downto 0) <= (others => '0');
			elsif(REG243(7 downto 5) = "010") then
				-- trigger set at 50%
				RAMB2_TRIGGER_OFFSET((ADDR_WIDTH2A-1) downto (ADDR_WIDTH2A-2)) <= "10";
				RAMB2_TRIGGER_OFFSET((ADDR_WIDTH2A-3) downto 0) <= (others => '0');
			else
			--elsif(REG243(7 downto 5) = "010") then
				-- trigger set at 90%
				RAMB2_TRIGGER_OFFSET((ADDR_WIDTH2A-1) downto (ADDR_WIDTH2A-6)) <= "111010";
				RAMB2_TRIGGER_OFFSET((ADDR_WIDTH2A-7) downto 0) <= (others => '0');
			end if;
		end if;
	end process;

	BOUNDS_002: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SM2 = 2) and (TRIGGER = '1') then
				RAMB2_START_ADDR <= RAMB2_ADDRA - RAMB2_TRIGGER_OFFSET;
					-- offset depends on trigger position (0,10,50,90%)
				RAMB2_START_ADDR_RDY <= '1';
			else
				RAMB2_START_ADDR_RDY <= '0';
			end if;
		end if;
	end process;

	-- 7. State machine
	SM_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				SM2 <= 0;	-- idle
			elsif(SM2 = 0) and (unsigned(REG242(6 downto 0)) /= 0) and (START_CAPTURE = '1') then
				SM2 <= 1;	-- capture in progress pre-trigger
			elsif(SM2 = 1) and (TRIGGER_REARM = '1') then
				SM2 <= 2;	-- capture in progress, waiting for trigger
			elsif(SM2 = 2) and (TRIGGER = '1') then
				SM2 <= 3;	-- capturing after trigger
			elsif(SM2 = 3) and (CAPTURE2_DONE = '1') then
				SM2 <= 0;
			end if;
		end if;
	end process;
	
end generate;

--//-- TRACE 3 -------------------------------------------------
TRACE3_GEN: if(TRACE3_ENABLED = '1') generate
	-- 1. input signal selection
	-- Also select nominal input sampling clock (_VALID) or the master clock CLK
	INPUT_SEL_001: process(CLK)
	begin
		if rising_edge(CLK) then
			case REG244(6 downto 0) is
				when b"0000001" => 	S3 <= signed(S3_1);
									S3_VALID <= S3_1_VALID or REG244(7);
				when b"0000010" => 	S3 <= signed(S3_2);
									S3_VALID <= S3_2_VALID or REG244(7);
				when b"0000011" => 	S3 <= signed(S3_3);
									S3_VALID <= S3_3_VALID or REG244(7);
				when b"0000100" => 	S3 <= signed(S3_4);
									S3_VALID <= S3_4_VALID or REG244(7);
				when others => S3 <= (others => '0');
									S3_VALID <= '0';
			end case;
		end if;
	end process;
	
	-- 2. decimation 
	-- DECIM3_PERIOD = decimation period - 1
	DECIMATION_001: process(CLK)
	begin
		if rising_edge(CLK) then
			case REG245(4 downto 0) is
				when b"00000" => DECIM3_PERIOD <= x"00000000";
				when b"00001" => DECIM3_PERIOD <= x"00000001";
				when b"00010" => DECIM3_PERIOD <= x"00000003";
				when b"00011" => DECIM3_PERIOD <= x"00000007";
				when b"00100" => DECIM3_PERIOD <= x"0000000f";
				when b"00101" => DECIM3_PERIOD <= x"0000001f";
				when b"00110" => DECIM3_PERIOD <= x"0000003f";
				when b"00111" => DECIM3_PERIOD <= x"0000007f";
				when b"01000" => DECIM3_PERIOD <= x"000000ff";
				when b"01001" => DECIM3_PERIOD <= x"000001ff";
				when b"01010" => DECIM3_PERIOD <= x"000003ff";
				when b"01011" => DECIM3_PERIOD <= x"000007ff";
				when b"01100" => DECIM3_PERIOD <= x"00000fff";
				when b"01101" => DECIM3_PERIOD <= x"00001fff";
				when b"01110" => DECIM3_PERIOD <= x"00003fff";
				when b"01111" => DECIM3_PERIOD <= x"00007fff";
				when b"10000" => DECIM3_PERIOD <= x"0000ffff";
				when b"10001" => DECIM3_PERIOD <= x"0001ffff";
				when b"10010" => DECIM3_PERIOD <= x"0003ffff";
				when b"10011" => DECIM3_PERIOD <= x"0007ffff";
				when b"10100" => DECIM3_PERIOD <= x"000fffff";
				when b"10101" => DECIM3_PERIOD <= x"001fffff";
				when b"10110" => DECIM3_PERIOD <= x"003fffff";
				when b"10111" => DECIM3_PERIOD <= x"007fffff";
				when b"11000" => DECIM3_PERIOD <= x"00ffffff";
				when b"11001" => DECIM3_PERIOD <= x"01ffffff";
				when b"11010" => DECIM3_PERIOD <= x"03ffffff";
				when b"11011" => DECIM3_PERIOD <= x"07ffffff";
				when b"11100" => DECIM3_PERIOD <= x"0fffffff";
				when b"11101" => DECIM3_PERIOD <= x"1fffffff";
				when b"11110" => DECIM3_PERIOD <= x"3fffffff";
				when others => DECIM3_PERIOD <= x"7fffffff";
			end case;
		end if;
	end process;
	
	DECIMATION_002: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				DECIM3_CNTR <= (others => '0');
			elsif(S3_VALID = '1') then
				if(DECIM3_CNTR = 0) then
					-- rearm decimation counter
					DECIM3_CNTR <= DECIM3_PERIOD;
				else
					-- decrement decimation counter
					DECIM3_CNTR <= DECIM3_CNTR -1;
				end if;
			end if;

		end if;
	end process;

	--3. Acquire mode: sample, peak, average 
	ACQUIRE_001: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S3B <= (others => '0');
				S3ABSMAX <= (others => '0');
			elsif(S3_VALID = '1') then
				if(DECIM3_CNTR = 0) then
					-- decimated sample
					S3ABSMAX <= (others => '0');
					if(REG239(5 downto 4) = "01") and (abs(S3) < abs(S3ABSMAX) ) then
						-- acquire mode: peak detect
						S3B <= S3ABSMAX;
					elsif(REG239(5 downto 4) = "10") then
						-- acquire mode: average
						S3B <= S3AVERAGE;
					else
						-- acquire mode: sample
						S3B <= S3;
					end if;
				elsif(REG239(5 downto 4) = "01") and (abs(S3) > abs(S3ABSMAX) ) then
					-- peak detect mode: Keep track of peak.
					S3ABSMAX <= S3;
				end if;
			end if;
		end if;
	end process;

	ACQUIRE_002: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S3B_VALID <= '0';
			elsif(S3_VALID = '1') and (DECIM3_CNTR = 0) then
				-- decimated sample
				S3B_VALID <= '1';
			else
				S3B_VALID <= '0';
			end if;
		end if;
	end process;

	-- 4. Averaging mode
	-- process dedicated to the averaging of samples over the decimation period
	-- use integrate and dump
	AVERAGING_001: process(CLK)
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S3_ACC <= (others => '0');
			elsif(S3_VALID = '1') and (REG239(5 downto 4) = "10")  then
				if (DECIM3_CNTR = 0) then
					S3_ACC <= resize(S3,S3_ACC'length);
				else
					S3_ACC <= S3_ACC + resize(S3,S3_ACC'length);
				end if;
			end if;
		end if;
	end process;
	
	-- use shift to divide, more efficient than a large (32) case statement
	-- For example, if REG245(4:0) = 2, decimation is 4
	-- S3_AVR_CNTR counts down from 2 to 0
	-- S3_ACC_D is shifted right twice (thus dividing by 4)
	AVERAGING_002: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				S3_AVR_CNTR <= (others => '0');
			elsif(S3_VALID = '1') and (REG239(5 downto 4) = "10") and (DECIM3_CNTR = 0) then
				S3_AVR_CNTR <= unsigned(REG245(4 downto 0));
				S3_ACC_D <= S3_ACC;	-- latch previous sum
			elsif(S3_AVR_CNTR /= 0) then
				S3_AVR_CNTR <= S3_AVR_CNTR - 1;
				S3_ACC_D(S3_ACC_D'left -1 downto 0) <= S3_ACC_D(S3_ACC_D'left downto 1);
			end if;
		end if;
	end process;
	S3AVERAGE <= S3_ACC_D((DATA_WIDTH3A-1) downto 0);
	
	-- 5. capture
	BRAM_DP2_001: BRAM_DP2 
	GENERIC MAP(
		DATA_WIDTHA => DATA_WIDTH3A,		
		ADDR_WIDTHA => ADDR_WIDTH3A,
		DATA_WIDTHB => 8,		 	-- output is always byte-wide
		ADDR_WIDTHB => ADDR_WIDTH3B
	)
	PORT MAP(
		 CSA => '1',
		 CLKA => CLK,
		 WEA => S3B_VALID,
		 OEA => '0',
		 ADDRA => std_logic_vector(RAMB3_ADDRA),  
		 DIA => std_logic_vector(S3B),
		 DOA => open,
		 CSB => '1',
		 CLKB => CLK,
		 WEB => '0',
		 OEB => '1',
		 ADDRB => std_logic_vector(RAMB3_ADDRB),
		 DIB => (others => '0'),
		 DOB => S3C
	);
	
	-- write pointer management
	RAMB3_ADDRA_INC <= RAMB3_ADDRA + 1;
	WPTR_GEN_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				RAMB3_ADDRA <= (others => '0');
			elsif(S3B_VALID = '1') and ((SM3 = 1)  or (SM3 = 2)) then
				-- capture in progress
				RAMB3_ADDRA <= RAMB3_ADDRA_INC;
			elsif(S3B_VALID = '1') and (SM3 = 3) and (CAPTURE3_DONE = '0') then
				-- capture in progress
				RAMB3_ADDRA <= RAMB3_ADDRA_INC;
			end if;
		end if;
	end process;
	
	-- capture done?
	CAPTURE3_DONE <= '1' when (RAMB3_ADDRA_INC = RAMB3_START_ADDR) else '0'; 
	
	-- read pointer management
	RPTR_GEN_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			S3C_VALID <= S3C_VALID_E;	-- 1 CLK delay latency in reading BRAM
			
			if(RAMB3_START_ADDR_RDY = '1') then
				-- pre-position the read pointer at 0,10,50,90% before the current trigger
				RAMB3_ADDRB <= RAMB3_START_ADDR - 1;
				S3C_VALID_E <= '0';
			elsif(REG238(2 downto 1) = "10") and (NEXT_WORD_PLEASE = '1') then
				-- trace selected for reading
				RAMB3_ADDRB <= RAMB3_ADDRB + 1;
				S3C_VALID_E <= '1';
			else
				S3C_VALID_E <= '0';
			end if;
		end if;
	end process;

	-- 6. floor/ceiling bounds
	-- Upon receiving a trigger, determine the memory bounds for this capture
	BOUNDS_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(REG245(7 downto 5) = "000") then
				-- trigger set at 0%
				RAMB3_TRIGGER_OFFSET <= (others => '0');
			elsif(REG245(7 downto 5) = "001") then
				-- trigger set at 10%
				RAMB3_TRIGGER_OFFSET((ADDR_WIDTH3A-1) downto (ADDR_WIDTH3A-6)) <= "000110";
				RAMB3_TRIGGER_OFFSET((ADDR_WIDTH3A-7) downto 0) <= (others => '0');
			elsif(REG245(7 downto 5) = "010") then
				-- trigger set at 50%
				RAMB3_TRIGGER_OFFSET((ADDR_WIDTH3A-1) downto (ADDR_WIDTH3A-2)) <= "10";
				RAMB3_TRIGGER_OFFSET((ADDR_WIDTH3A-3) downto 0) <= (others => '0');
			else
			--elsif(REG245(7 downto 5) = "010") then
				-- trigger set at 90%
				RAMB3_TRIGGER_OFFSET((ADDR_WIDTH3A-1) downto (ADDR_WIDTH3A-6)) <= "111010";
				RAMB3_TRIGGER_OFFSET((ADDR_WIDTH3A-7) downto 0) <= (others => '0');
			end if;
		end if;
	end process;

	BOUNDS_002: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SM3 = 2) and (TRIGGER = '1') then
				RAMB3_START_ADDR <= RAMB3_ADDRA - RAMB3_TRIGGER_OFFSET;
					-- offset depends on trigger position (0,10,50,90%)
				RAMB3_START_ADDR_RDY <= '1';
			else
				RAMB3_START_ADDR_RDY <= '0';
			end if;
		end if;
	end process;

	-- 7. State machine
	SM_001: process(CLK) 
	begin
		if rising_edge(CLK) then
			if(SYNC_RESET = '1') then
				SM3 <= 0;	-- idle
			elsif(SM3 = 0) and (unsigned(REG244(6 downto 0)) /= 0)  and (START_CAPTURE = '1') then
				SM3 <= 1;	-- capture in progress pre-trigger
			elsif(SM3 = 1) and (TRIGGER_REARM = '1') then
				SM3 <= 2;	-- capture in progress, waiting for trigger
			elsif(SM3 = 2) and (TRIGGER = '1') then
				SM3 <= 3;	-- capturing after trigger
			elsif(SM3 = 3) and (CAPTURE3_DONE = '1') then
				SM3 <= 0;
			end if;
		end if;
	end process;
	
end generate;

-- TODO: TRACE 4

--//-- READ INTERFACE ------------------------
SREG250 <= 	S1C when (REG238(2 downto 1) = "00") else
				S2C when (REG238(2 downto 1) = "01") else
				S3C when (REG238(2 downto 1) = "10") else
				S4C;

--//-- TRIGGERS ------------------------------------------------
-- 1. trigger signal selection
TRIGGER_SEL_001: process(CLK)
begin
	if rising_edge(CLK) then
		case REG248(5 downto 0) is
			when b"000001" => 	T1 <= signed(T16b_1);
								T1_VALID <= T16b_1_VALID;
			when b"000010" => 	T1 <= signed(T16b_2);
								T1_VALID <= T16b_2_VALID;
			when b"000011" => 	T1 <= signed(T16b_3);
								T1_VALID <= T16b_3_VALID;
			when b"000100" => 	T1 <= signed(T16b_4);
								T1_VALID <= T16b_4_VALID;
			when others => T1 <= x"0000";
								T1_VALID <= '0';
		end case;
	end if;
end process;

-- 2. trigger threshold. Always 16-bit signed
TRIGGER_TH_001: process(CLK)
begin
	if rising_edge(CLK) then
		TRIGGER_THRESHOLD <= resize(signed(REG249),16);	-- TODO extend range beyond +/-127
		
		if(T1_VALID = '1') then
			TRIGGER_LEVEL_D <= TRIGGER_LEVEL;

			if (T1 > TRIGGER_THRESHOLD) then
				-- above threshold
				TRIGGER_LEVEL <= '1';
				if(TRIGGER_LEVEL_D = '0') and (REG248(7) = '1') then
					-- rising edge trigger
					TRIGGER_EDGE <= '1';
				else
					TRIGGER_EDGE <= '0';
				end if;
			else
				TRIGGER_LEVEL <= '0';
				if(TRIGGER_LEVEL_D = '1') and (REG248(7) = '0') then
					-- falling edge trigger
					TRIGGER_EDGE <= '1';
				else
					TRIGGER_EDGE <= '0';
				end if;
			end if;
		else
			TRIGGER_EDGE <= '0';
		
		end if;
	end if;
end process;

TRIGGER_GEN_001: process(CLK) 
begin
	if rising_edge(CLK) then
		if(SYNC_RESET = '1') or (START_CAPTURE = '1') then
			-- trigger found. This bit is cleared upon resuming capture.
			TRIGGER_FOUND <= '0';
		elsif(SM1 = 3) or (SM2 = 3) or (SM3 = 3) or (SM4 = 3) then
			TRIGGER_FOUND <= '1';
		end if;
	end if;
end process;

TRIGGER <= FORCE_TRIGGER or TRIGGER_EDGE;

--//-- MONITORING ------------------------------------------------
SREG251(0) <= '1' when (SM1 /= 0) or (SM2 /= 0) or (SM3 /= 0) or (SM4 /= 0) else '0';
	-- capture in progress. '1' when at least one trace is capturing
SREG251(1) <= TRIGGER_FOUND;
		-- trigger found. This bit is cleared upon resuming capture.
SREG251(2) <= START_CAPTURE_TOGGLE_D2;
	-- start capture toggle
SREG251(3) <= TRIGGER_REARM_TOGGLE_D2;
	-- trigger rearm toggle
	
--//  test points ---------------------------------
TP(1) <= RAMB1_ADDRA(0);
TP(2) <= RAMB1_ADDRB(0);
TP(3) <= S1_1_VALID;
TP(4) <= '1' when (SM1 = 0) else '0';
TP(5) <= '1' when (SM1 = 1) else '0';
TP(6) <= '1' when (SM1 = 2) else '0';
TP(7) <= '1' when (SM1 = 3) else '0';
TP(8) <= S1B_VALID;
TP(9) <= S1_VALID;
TP(10) <= '1' when (DECIM1_CNTR = 0) else '0';
-- TEST TEST TEST
TP(11) <= TRIGGER_LEVEL;
TP(12) <= TRIGGER_LEVEL_D;
TP(13) <= TRIGGER_EDGE;
TP(14) <= TRIGGER_FOUND;
TP(15) <= TRIGGER;
TP(16) <= START_CAPTURE;

end behavioral;