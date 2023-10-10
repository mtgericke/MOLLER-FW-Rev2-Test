-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
-- Date        : Wed Sep 20 19:03:37 2023
-- Host        : home running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub -rename_top fifo_10g -prefix
--               fifo_10g_ fifo_10g_stub.vhdl
-- Design      : fifo_10g
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu6cg-ffvc900-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_10g is
  Port ( 
    srst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 287 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 287 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    wr_rst_busy : out STD_LOGIC;
    rd_rst_busy : out STD_LOGIC
  );

end fifo_10g;

architecture stub of fifo_10g is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "srst,wr_clk,rd_clk,din[287:0],wr_en,rd_en,dout[287:0],full,empty,wr_rst_busy,rd_rst_busy";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_5,Vivado 2020.2";
begin
end;
