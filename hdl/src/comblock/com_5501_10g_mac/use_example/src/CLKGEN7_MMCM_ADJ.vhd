-------------------------------------------------------------
-- MSS copyright 2016
--	Filename:  CLKGEN7_MMCM_ADJ.VHD
-- Author: Alain Zarembowitch / MSS
--	Version: 2
--	Date last modified: 3/15/16
-- Inheritance: 	N/A
-- 
-- Description: -- Adjustable MMCM   output frequency = input frequency * CLKFBOUT_MULT_F / CLKOUT0_DIVIDE_F
-- The output phase is adjustable dynamically. The phase shift PHASE_SHIFT_VAL is relative to the current phase.
-- It is a signed number expressed in time units of 1/(56*fvco)
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library unisim;
use unisim.vcomponents.all;

entity CLKGEN7_MMCM_ADJ is
generic (
	CLKFBOUT_MULT_F: real := 40.000;
	CLKOUT0_DIVIDE_F: real := 2.000;
	CLKIN1_PERIOD: real := 52.083	-- 1/fref in ns
);
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  -- control: relative phase adjust, by steps of 1/56*fvco
  -- dynamic
  PHASE_SHIFT_VAL: in std_logic_vector(7 downto 0);
	-- relative phase shift. signed.
	-- step size is 1/56*fvco
  PHASE_SHIFT_TRIGGER_TOGGLE: in std_logic;
	-- phase shift value must be ready before the trigger toggles
	
  -- Status and control signals
  INPUT_CLK_STOPPED : out    std_logic;
  LOCKED            : out    std_logic;
  
  -- test points
  TP: out std_logic_vector(10 downto 1)
 );
end CLKGEN7_MMCM_ADJ;
architecture xilinx of CLKGEN7_MMCM_ADJ is
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
-- Input clock buffering / unused connectors
signal CLKIN1: std_logic := '0';

--// DYNAMIC PHASE SHIFT
-- Dynamic phase shift unused signals
signal PHASE_SHIFT_TRIGGER_TOGGLE_D: std_logic := '0';
signal PHASE_SHIFT_TRIGGER_TOGGLE_D2: std_logic := '0';
signal PHASE_SHIFT_CNTR: unsigned(7 downto 0) := (others => '0');
signal PSEN: std_logic := '0';
signal PSINCDEC: std_logic := '0';
signal PSDONE: std_logic := '0';
signal PS_STATE: integer range 0 to 2 := 0;

-- Output clock buffering / unused connectors
signal clkfbout         : std_logic;
signal clkfboutb_unused : std_logic;
signal clkout0          : std_logic;
signal clkout0b_unused  : std_logic;
signal clkout1_unused   : std_logic;
signal clkout1b_unused  : std_logic;
signal clkout2_unused   : std_logic;
signal clkout2b_unused  : std_logic;
signal clkout3_unused   : std_logic;
signal clkout3b_unused  : std_logic;
signal clkout4_unused   : std_logic;
signal clkout5_unused   : std_logic;
signal clkout6_unused   : std_logic;
-- Dynamic programming unused signals
signal do_unused        : std_logic_vector(15 downto 0);
signal drdy_unused      : std_logic;

-- Unused status signals
signal clkfbstopped_unused : std_logic := '0';
signal LOCKED_local : std_logic:= '0';
signal INPUT_CLK_STOPPED_local: std_logic := '0';
--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin


  -- Input buffering
  --------------------------------------
--  clkin1_buf : IBUFG
--  port map
--   (O => clkin1,
--    I => CLK_IN1g);
-- bypass IBUFG
	CLKIN1 <= CLK_IN1;


--// DYNAMIC PHASE SHIFT
-- state machine for dynamic phase shift
PHASE_SHIFT_001: process(CLKIN1)
begin
	if rising_edge(CLKIN1) then
		PHASE_SHIFT_TRIGGER_TOGGLE_D <= PHASE_SHIFT_TRIGGER_TOGGLE;
		PHASE_SHIFT_TRIGGER_TOGGLE_D2 <= PHASE_SHIFT_TRIGGER_TOGGLE_D;
		
		if(PHASE_SHIFT_TRIGGER_TOGGLE_D /= PHASE_SHIFT_TRIGGER_TOGGLE_D2) then
			if(signed(PHASE_SHIFT_VAL) /= 0) then
				-- implement phase shift
				PHASE_SHIFT_CNTR <= unsigned(abs(signed(PHASE_SHIFT_VAL)));	-- load count-down counter
				PSINCDEC <= not PHASE_SHIFT_VAL(PHASE_SHIFT_VAL'left);	-- high for increment, low for decrement
				PS_STATE <= 1;
			end if;
		elsif(PS_STATE = 1) then
			PSEN <= '1';
			PS_STATE <= 2;	-- request sent. awaiting done
			PHASE_SHIFT_CNTR <= PHASE_SHIFT_CNTR - 1;
		elsif(PS_STATE = 2) and (PSDONE = '1')  then
			PSEN <= '0';
			if(PHASE_SHIFT_CNTR = 0) then
				-- task complete: all phase shifts done
				PS_STATE <= 0;
			else
				-- do another elementary shift
				PSEN <= '1';
				PHASE_SHIFT_CNTR <= PHASE_SHIFT_CNTR - 1;
			end if;	
		else
			PSEN <= '0';
		end if;
	end if;
end process;


  -- Clocking primitive
  --------------------------------------
  -- Instantiation of the MMCM primitive
  --    * Unused inputs are tied off
  --    * Unused outputs are labeled unused
  mmcm_adv_inst : MMCME2_ADV
  generic map
   (BANDWIDTH            => "OPTIMIZED",
    CLKOUT4_CASCADE      => FALSE,
    COMPENSATION         => "ZHOLD",
    STARTUP_WAIT         => FALSE,
    DIVCLK_DIVIDE        => 1,
    CLKFBOUT_MULT_F      => CLKFBOUT_MULT_F,	
    CLKFBOUT_PHASE       => 0.000,
    CLKFBOUT_USE_FINE_PS => FALSE,
    CLKOUT0_DIVIDE_F     => CLKOUT0_DIVIDE_F,
    CLKOUT0_PHASE        => 0.000,
    CLKOUT0_DUTY_CYCLE   => 0.500,
    CLKOUT0_USE_FINE_PS  => FALSE,
    CLKIN1_PERIOD        => CLKIN1_PERIOD,
    REF_JITTER1          => 0.001)
  port map
    -- Output clocks
   (CLKFBOUT            => clkfbout,
    CLKFBOUTB           => clkfboutb_unused,
    CLKOUT0             => clkout0,
    CLKOUT0B            => clkout0b_unused,
    CLKOUT1             => clkout1_unused,
    CLKOUT1B            => clkout1b_unused,
    CLKOUT2             => clkout2_unused,
    CLKOUT2B            => clkout2b_unused,
    CLKOUT3             => clkout3_unused,
    CLKOUT3B            => clkout3b_unused,
    CLKOUT4             => clkout4_unused,
    CLKOUT5             => clkout5_unused,
    CLKOUT6             => clkout6_unused,
    -- Input clock control
    CLKFBIN             => clkfbout,
    CLKIN1              => clkin1,
    CLKIN2              => '0',
    -- Tied to always select the primary input clock
    CLKINSEL            => '1',
    -- Ports for dynamic reconfiguration
    DADDR               => (others => '0'),
    DCLK                => '0',
    DEN                 => '0',
    DI                  => (others => '0'),
    DO                  => do_unused,
    DRDY                => drdy_unused,
    DWE                 => '0',
    -- Ports for dynamic phase shift
    PSCLK               => CLKIN1,
    PSEN                => PSEN,
    PSINCDEC            => PSINCDEC,
    PSDONE              => PSDONE,
    -- Other control and status signals
    LOCKED              => LOCKED_local,
    CLKINSTOPPED        => INPUT_CLK_STOPPED_local,
    CLKFBSTOPPED        => clkfbstopped_unused,
    PWRDWN              => '0',
    RST                 => '0');
    
    LOCKED <= LOCKED_local;
    INPUT_CLK_STOPPED <= INPUT_CLK_STOPPED_local;
  -- Output buffering
  -------------------------------------

  clkout1_buf : BUFG
  port map
   (O   => CLK_OUT1,
    I   => clkout0);
--CLK_OUT1 <= clkout0;

--// TEST POINTS -------------
TP(1) <= CLKIN1;
TP(2) <= PSEN;
TP(3) <= PSINCDEC;
TP(4) <= PSDONE;
TP(5) <= PHASE_SHIFT_TRIGGER_TOGGLE;
TP(6) <= INPUT_CLK_STOPPED_local;
TP(7) <= '1' when (PS_STATE = 0) else '0';
TP(8) <= '1' when (PS_STATE = 1) else '0';
TP(9) <= '1' when (PS_STATE = 2) else '0';
TP(10) <= LOCKED_local;

end xilinx;
