-------------------------------------------------------------
-- MSS copyright 2017-2018
--	Filename:  tbCRC32.VHD
-- Author: Alain Zarembowitch / MSS
--	Version: 0
--	Date last modified: 8/5/18
-- Inheritance: 	n/a
--
-- Description: simple testbench to simulate the high-speed CRC32.vhd (64bits/clock)
-- Two frames, one with space between words, the other with no space between successive words
-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tbCRC32 IS
END tbCRC32;
 
ARCHITECTURE behavior OF tbCRC32 IS 
--------------------------------------------------------
--      COMPONENTS
--------------------------------------------------------
    COMPONENT CRC32
    PORT(
         CLK : IN  std_logic;
         DATA_IN : IN  std_logic_vector(63 downto 0);
         SAMPLE_CLK_IN : IN  std_logic;
			SOF_IN: in std_logic;
			DATA_VALID_IN : IN  std_logic_vector(7 downto 0);
			CRC_INITIALIZATION: in std_logic_vector(31 downto 0);
         CRC_OUT : OUT  std_logic_vector(31 downto 0);
         SAMPLE_CLK_OUT : OUT  std_logic
        );
    END COMPONENT;
    
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
   signal CLK : std_logic := '0';
   signal DATA_IN : std_logic_vector(63 downto 0) := (others => '0');
   signal SAMPLE_CLK_IN : std_logic := '0';
   signal SOF_IN : std_logic := '0';
   signal DATA_VALID_IN : std_logic_vector(7 downto 0) := (others => '0');

   signal DATA0 : std_logic_vector(63 downto 0) := (others => '0');
   signal SAMPLE0_CLK : std_logic := '0';
   signal SOF0 : std_logic := '0';
   signal DATA0_VALID : std_logic_vector(7 downto 0) := (others => '0');

   signal CRC_OUT : std_logic_vector(31 downto 0);
   signal SAMPLE_CLK_OUT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CRC32 PORT MAP (
          CLK => CLK,
          DATA_IN => DATA0,
          SOF_IN => SOF0,
          SAMPLE_CLK_IN => SAMPLE0_CLK,
          DATA_VALID_IN => DATA0_VALID,
			 CRC_INITIALIZATION => x"FFFFFFFF",
          CRC_OUT => CRC_OUT,
          SAMPLE_CLK_OUT => SAMPLE_CLK_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		SAMPLE_CLK_IN <= '0';
		SOF_IN <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		SAMPLE_CLK_IN <= '1';
		SOF_IN <= '1';
		DATA_IN <= x"FFFEFDFCFBFAF9F8";
		DATA_VALID_IN <= x"FF";
      wait for CLK_period;
		SAMPLE_CLK_IN <= '0';
		SOF_IN <= '0';
      wait for CLK_period;
--		SAMPLE_CLK_IN <= '0';
--      wait for CLK_period;
--		SAMPLE_CLK_IN <= '1';
--		DATA_IN <= x"0102030405060708";
--		DATA_VALID_IN <= x"FF";
--      wait for CLK_period;
--		SAMPLE_CLK_IN <= '0';
--      wait for CLK_period;
		SAMPLE_CLK_IN <= '0';
      wait for CLK_period;
		SAMPLE_CLK_IN <= '1';
		DATA_IN <= x"1100000000000000";
		DATA_VALID_IN <= x"80";
      wait for CLK_period;
		SAMPLE_CLK_IN <= '0';

 
 
      wait for 10*CLK_period;
		SAMPLE_CLK_IN <= '0';
		SOF_IN <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		SAMPLE_CLK_IN <= '1';
		SOF_IN <= '1';
		DATA_IN <= x"FFFEFDFCFBFAF9F8";
		DATA_VALID_IN <= x"FF";
      wait for CLK_period;
		SOF_IN <= '0';
--		DATA_IN <= x"0102030405060708";
--      wait for CLK_period;
		DATA_IN <= x"1100000000000000";
		DATA_VALID_IN <= x"80";
      wait for CLK_period;
		SAMPLE_CLK_IN <= '0';
 
 
      wait;
   end process;

-- reclock
process(CLK)
begin
	if rising_edge(CLK) then
		SAMPLE0_CLK <= SAMPLE_CLK_IN;
		DATA0 <= DATA_IN;
		DATA0_VALID <= DATA_VALID_IN;
		SOF0 <= SOF_IN;
	end if;
end process;
END;
