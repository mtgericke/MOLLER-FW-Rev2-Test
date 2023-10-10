--------------------------------------------------------------------------------
-- Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.5
--  \   \         Application : sch2hdl
--  /   /         Filename : PreTableED.vhf
-- /___/   /\     Timestamp : 12/11/2019 14:54:54
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -sympath C:/fpga/common/ipcores/TrgDlyFifo -sympath C:/fpga/common/ipcores/bram18to36 -sympath C:/fpga/common/ipcores/BRAM36SC -sympath C:/fpga/common/ipcores/buf72to36 -sympath C:/fpga/common/ipcores/bram36to9 -sympath C:/fpga/TIFPGAC/buf36to9 -sympath C:/fpga/common/ipcores/Ram16to32 -sympath C:/fpga/common/ipcores -sympath C:/fpga/common/ipcores/ram12 -sympath C:/fpga/common/ipcores/BRAM36 -sympath C:/fpga/common/ipcores/DataBuffer -sympath C:/fpga/common/ipcores/fifo4k36 -sympath C:/fpga/common/ipcores/trgtable -sympath C:/fpga/common/ipcores/GTPTILE -intstyle ise -family virtex5 -flat -suppress -vhdl C:/fpga/TIFPGAC/PreTableED.vhf -w C:/fpga/common/schematic/PreTableED.sch
--Design Name: PreTableED
--Device: virtex5
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL CB8CE_HXILINX_PreTableED -----

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity PreTableED is
  port ( Clock : in    std_logic; 
    Delay : in    std_logic_vector (7 downto 0); 
    Sin   : in    std_logic; 
    Width : in    std_logic_vector (4 downto 0); 
    SOut  : out   std_logic);
end PreTableED;

architecture BEHAVIORAL of PreTableED is

  component SigDelay is
    Port (SigIn : in STD_LOGIC;
      Clock     : in STD_LOGIC;
      DelayVal  : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax : out std_logic;
      SigOut    : out STD_LOGIC);
  end component SigDelay;

  signal SigInt   : std_logic_vector(7 downto 0);
  signal WidthRst : std_logic;
  
begin

  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (WidthRst = '1') then
        SigInt(0) <= '0';
      elsif (Sin = '1') then
        SigInt(0) <= '1';
      end if;
      SigInt(3) <= Sin and (not SigInt(0));
      SigInt(1) <= SigInt(0);
      SigInt(2) <= SigInt(1);
      SOut <= SigInt(2);
    end if;
  end process;
  
  SignalDelay : SigDelay
    port map (SigIn => SigInt(3), -- in STD_LOGIC;
      Clock     => Clock, --  in STD_LOGIC;
      DelayVal  => Delay(7 downto 0), --  in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax => open, -- out std_logic;
      SigOut    => SigInt(4) );  -- out STD_LOGIC);

  FurtherDelay :  SRLC32E
    generic map (INIT => X"00000000",    -- Initial contents of shift register
      IS_CLK_INVERTED => '0')  -- Initial contents of shift register
    port map (Q => WidthRst,       -- 1-bit output: SRL Data
      Q31  => open,
      CE   => '1',       -- 1-bit input: Clock enable
      CLK  => Clock,    -- 1-bit input: Clock
      D    => SigInt(4),  -- 1-bit input: SRL Data
      A    => Width(4 downto 0) );
      
end BEHAVIORAL;


