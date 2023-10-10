--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:38:45 10/18/2020
-- Design Name:   
-- Module Name:   C:/Users/Alain/Documents/1VHDL/com-5501 10gE MAC/use_example/tb_com1800_XAUI_MAC.vhd
-- Project Name:  com1800_ISE14
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: COM1800_TOP
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_com1800_XAUI_MAC IS
END tb_com1800_XAUI_MAC;
 
ARCHITECTURE behavior OF tb_com1800_XAUI_MAC IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT COM1800_TOP
	generic (
		SIMULATION: std_logic
	);
    PORT(
         CLKREF_TCXO : IN  std_logic;
         CLKREF_EXT : IN  std_logic;
         MGTREFCLK0N : IN  std_logic;
         MGTREFCLK0P : IN  std_logic;
         XAUI_TX_L0_P : OUT  std_logic;
         XAUI_TX_L0_N : OUT  std_logic;
         XAUI_TX_L1_P : OUT  std_logic;
         XAUI_TX_L1_N : OUT  std_logic;
         XAUI_TX_L2_P : OUT  std_logic;
         XAUI_TX_L2_N : OUT  std_logic;
         XAUI_TX_L3_P : OUT  std_logic;
         XAUI_TX_L3_N : OUT  std_logic;
         XAUI_RX_L0_P : IN  std_logic;
         XAUI_RX_L0_N : IN  std_logic;
         XAUI_RX_L1_P : IN  std_logic;
         XAUI_RX_L1_N : IN  std_logic;
         XAUI_RX_L2_P : IN  std_logic;
         XAUI_RX_L2_N : IN  std_logic;
         XAUI_RX_L3_P : IN  std_logic;
         XAUI_RX_L3_N : IN  std_logic;
         LEFT_CONNECTOR_A : INOUT  std_logic_vector(38 downto 1);
         LEFT_CONNECTOR_B1 : INOUT  std_logic_vector(4 downto 1);
         LEFT_CONNECTOR_B2 : INOUT  std_logic_vector(16 downto 6);
         RIGHT_CONNECTOR_A : INOUT  std_logic_vector(38 downto 1);
         RIGHT_CONNECTOR_B1 : INOUT  std_logic_vector(4 downto 1);
         RIGHT_CONNECTOR_B2 : INOUT  std_logic_vector(19 downto 6);
         RIGHT_CONNECTOR_B3 : INOUT  std_logic_vector(30 downto 21);
         RIGHT_CONNECTOR_B4 : INOUT  std_logic_vector(39 downto 32);
         UC_CSIB_IN : IN  std_logic;
         UC_ALE_IN : IN  std_logic;
         UC_REB_IN : IN  std_logic;
         UC_WEB_IN : IN  std_logic;
         UC_AD : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLKREF_TCXO : std_logic := '0';
   signal CLKREF_EXT : std_logic := '0';
	signal MGTREFCLK : std_logic := '0';
   signal MGTREFCLK0N : std_logic := '0';
   signal MGTREFCLK0P : std_logic := '0';
   signal XAUI_RX_L0_P : std_logic := '0';
   signal XAUI_RX_L0_N : std_logic := '0';
   signal XAUI_RX_L1_P : std_logic := '0';
   signal XAUI_RX_L1_N : std_logic := '0';
   signal XAUI_RX_L2_P : std_logic := '0';
   signal XAUI_RX_L2_N : std_logic := '0';
   signal XAUI_RX_L3_P : std_logic := '0';
   signal XAUI_RX_L3_N : std_logic := '0';
   signal UC_CSIB_IN : std_logic := '0';
   signal UC_ALE_IN : std_logic := '0';
   signal UC_REB_IN : std_logic := '0';
   signal UC_WEB_IN : std_logic := '0';

	--BiDirs
   signal LEFT_CONNECTOR_A : std_logic_vector(38 downto 1);
   signal LEFT_CONNECTOR_B1 : std_logic_vector(4 downto 1);
   signal LEFT_CONNECTOR_B2 : std_logic_vector(16 downto 6);
   signal RIGHT_CONNECTOR_A : std_logic_vector(38 downto 1);
   signal RIGHT_CONNECTOR_B1 : std_logic_vector(4 downto 1);
   signal RIGHT_CONNECTOR_B2 : std_logic_vector(19 downto 6);
   signal RIGHT_CONNECTOR_B3 : std_logic_vector(30 downto 21);
   signal RIGHT_CONNECTOR_B4 : std_logic_vector(39 downto 32);
   signal UC_AD : std_logic_vector(7 downto 0);

 	--Outputs
   signal XAUI_TX_L0_P : std_logic;
   signal XAUI_TX_L0_N : std_logic;
   signal XAUI_TX_L1_P : std_logic;
   signal XAUI_TX_L1_N : std_logic;
   signal XAUI_TX_L2_P : std_logic;
   signal XAUI_TX_L2_N : std_logic;
   signal XAUI_TX_L3_P : std_logic;
   signal XAUI_TX_L3_N : std_logic;

   -- Clock period definitions
   constant CLKREF_TCXO_period : time := 52.083 ns;
   constant CLKREF_EXT_period : time := 100.0 ns;
   constant MGTREFCLK_period : time := 6.4 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: COM1800_TOP 
	GENERIC MAP (
		SIMULATION => '1'
	)
	PORT MAP (
          CLKREF_TCXO => CLKREF_TCXO,
          CLKREF_EXT => CLKREF_EXT,
          MGTREFCLK0N => MGTREFCLK0N,
          MGTREFCLK0P => MGTREFCLK0P,
          XAUI_TX_L0_P => XAUI_TX_L0_P,
          XAUI_TX_L0_N => XAUI_TX_L0_N,
          XAUI_TX_L1_P => XAUI_TX_L1_P,
          XAUI_TX_L1_N => XAUI_TX_L1_N,
          XAUI_TX_L2_P => XAUI_TX_L2_P,
          XAUI_TX_L2_N => XAUI_TX_L2_N,
          XAUI_TX_L3_P => XAUI_TX_L3_P,
          XAUI_TX_L3_N => XAUI_TX_L3_N,
          XAUI_RX_L0_P => XAUI_RX_L0_P,
          XAUI_RX_L0_N => XAUI_RX_L0_N,
          XAUI_RX_L1_P => XAUI_RX_L1_P,
          XAUI_RX_L1_N => XAUI_RX_L1_N,
          XAUI_RX_L2_P => XAUI_RX_L2_P,
          XAUI_RX_L2_N => XAUI_RX_L2_N,
          XAUI_RX_L3_P => XAUI_RX_L3_P,
          XAUI_RX_L3_N => XAUI_RX_L3_N,
          LEFT_CONNECTOR_A => LEFT_CONNECTOR_A,
          LEFT_CONNECTOR_B1 => LEFT_CONNECTOR_B1,
          LEFT_CONNECTOR_B2 => LEFT_CONNECTOR_B2,
          RIGHT_CONNECTOR_A => RIGHT_CONNECTOR_A,
          RIGHT_CONNECTOR_B1 => RIGHT_CONNECTOR_B1,
          RIGHT_CONNECTOR_B2 => RIGHT_CONNECTOR_B2,
          RIGHT_CONNECTOR_B3 => RIGHT_CONNECTOR_B3,
          RIGHT_CONNECTOR_B4 => RIGHT_CONNECTOR_B4,
          UC_CSIB_IN => UC_CSIB_IN,
          UC_ALE_IN => UC_ALE_IN,
          UC_REB_IN => UC_REB_IN,
          UC_WEB_IN => UC_WEB_IN,
          UC_AD => UC_AD
        );

   -- Clock process definitions
   CLKREF_TCXO_process :process
   begin
		CLKREF_TCXO <= '0';
		wait for CLKREF_TCXO_period/2;
		CLKREF_TCXO <= '1';
		wait for CLKREF_TCXO_period/2;
   end process;
 
   CLKREF_EXT_process :process
   begin
		CLKREF_EXT <= '0';
		wait for CLKREF_EXT_period/2;
		CLKREF_EXT <= '1';
		wait for CLKREF_EXT_period/2;
   end process;
 
   MGTREFCLK_process :process
   begin
		MGTREFCLK <= '0';
		wait for MGTREFCLK_period/2;
		MGTREFCLK <= '1';
		wait for MGTREFCLK_period/2;
   end process;
	MGTREFCLK0P <= MGTREFCLK;
	MGTREFCLK0N <= not MGTREFCLK;

	-- XAUI loopback
	XAUI_RX_L0_P <= XAUI_TX_L0_P;
	XAUI_RX_L0_N <= XAUI_TX_L0_N;
	XAUI_RX_L1_P <= XAUI_TX_L1_P;
	XAUI_RX_L1_N <= XAUI_TX_L1_N;
	XAUI_RX_L2_P <= XAUI_TX_L2_P;
	XAUI_RX_L2_N <= XAUI_TX_L2_N;
	XAUI_RX_L3_P <= XAUI_TX_L3_P;
	XAUI_RX_L3_N <= XAUI_TX_L3_N;

--   -- Stimulus process
--   stim_proc: process
--   begin		
--      -- hold reset state for 100 ns.
--      wait for 100 ns;	
--
--      wait for CLKREF_TCXO_period*10;
--
--      -- insert stimulus here 
--
--      wait;
--   end process;

END;
