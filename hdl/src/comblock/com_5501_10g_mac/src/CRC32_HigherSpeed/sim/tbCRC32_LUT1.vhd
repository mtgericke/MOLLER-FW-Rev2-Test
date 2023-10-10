--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:29:22 12/12/2017
-- Design Name:   
-- Module Name:   C:/Users/Alain/Documents/1VHDL/com-5501 10gE MAC/src/CRC32/tbCRC32_LUT1.vhd
-- Project Name:  com1800_ISE14
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CRC32_LUT1
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
 
ENTITY tbCRC32_LUT1 IS
END tbCRC32_LUT1;
 
ARCHITECTURE behavior OF tbCRC32_LUT1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CRC32_LUT1
    PORT(
         CLK : IN  std_logic;
         DATA_IN : IN  std_logic_vector(31 downto 0);
         SAMPLE_CLK_IN : IN  std_logic;
         CRC_OUT : OUT  std_logic_vector(31 downto 0);
         SAMPLE_CLK_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SYNC_RESET : std_logic := '0';
   signal CLK : std_logic := '0';
   signal DATA_IN : std_logic_vector(31 downto 0) := (others => '0');
   signal SAMPLE_CLK_IN : std_logic := '0';

 	--Outputs
   signal CRC_OUT : std_logic_vector(31 downto 0);
   signal SAMPLE_CLK_OUT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CRC32_LUT1 PORT MAP (
          CLK => CLK,
          DATA_IN => DATA_IN,
          SAMPLE_CLK_IN => SAMPLE_CLK_IN,
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
		DATA_IN <= x"00000000";
      wait for 100 ns;	

      wait for CLK_period*10;
      SAMPLE_CLK_IN <= '1';
		DATA_IN <= x"00000001";
      wait for CLK_period;
      SAMPLE_CLK_IN <= '0';

      wait;
   end process;

END;
