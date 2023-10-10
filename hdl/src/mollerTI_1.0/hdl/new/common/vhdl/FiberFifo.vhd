----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:31:50 04/10/2017 
-- Design Name: 
-- Module Name:    FiberFifo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FiberFifo is
   port ( DataA : in std_logic_vector(15 downto 0);
    DataB : in std_logic_vector(15 downto 0);
   WriteA : in std_logic;
   WriteB : in std_logic;
   ClkW   : in std_logic;
   ClkR   : in std_logic;
   ReadAen : in std_logic;
   ReadBen : in std_logic;
    Reset   : in std_logic;
    outA    : out std_logic_vector(35 downto 0);
    outB    : out std_logic_vector(35 downto 0)
    );

end FiberFifo;

architecture Behavioral of FiberFifo is

  COMPONENT BRAM36SC
    PORT (
      rst : IN STD_LOGIC;
      wr_clk : IN STD_LOGIC;
      rd_clk : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC
    );
  END COMPONENT;

  signal Timer : std_logic_vector(15 downto 0) := (others => '0');
  signal FullA : std_logic;
  signal FullB : std_logic;
  signal EmptyA : std_logic;
  signal EmptyB : std_logic;
  signal PFullA : std_logic;
  signal PFullB : std_logic;

begin

  process (ClkW)
  begin
    if (ClkW'event and ClkW = '1') then
-- remove the RESET May 7, 2020
--      if (Reset = '1') then
--        Timer <= (others => '0');
--      else
        Timer <= Timer + 1;
--      end if;
    end if;
  end process;
  
  StatusA : BRAM36SC
    PORT MAP (
      rst => Reset,
      wr_clk => ClkW,
      rd_clk => ClkR,
      din(35 downto 32) => "0000", --' & PFullA & FullA & EmptyA,
    din(31 downto 16) => Timer(15 downto 0),
      din(15 downto 0)  => DataA(15 downto 0),
      wr_en => WriteA,
      rd_en => ReadAen,
    dout(35 downto 34) => open,
      dout(33 downto 0) => OutA(33 downto 0),
      full => FullA,
      empty => EmptyA,
      prog_full => PFullA  );
  OutA(35 downto 34) <= FullA & EmptyA;
  
  StatusB : BRAM36SC
  PORT MAP (
    rst => Reset,
    wr_clk => ClkW,
    rd_clk => ClkR,
    din(35 downto 32) => "1111", --' & PFullB & FullB & EmptyB,
   din(31 downto 16) => Timer(15 downto 0),
   din(15 downto 0)  => DataB(15 downto 0),
    wr_en => WriteB,
    rd_en => ReadBen,
   dout(35 downto 34) => open,
    dout(33 downto 0) => OutB(33 downto 0),
    full => FullB,
    empty => EmptyB,
    prog_full => PFullB
  );
  OutB(35 downto 34) <= FullB & EmptyB;

end Behavioral;

