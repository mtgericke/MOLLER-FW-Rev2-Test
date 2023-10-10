// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Wed Sep 20 19:03:37 2023
// Host        : home running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub -rename_top fifo_10g -prefix
//               fifo_10g_ fifo_10g_stub.v
// Design      : fifo_10g
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu6cg-ffvc900-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *)
module fifo_10g(srst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="srst,wr_clk,rd_clk,din[287:0],wr_en,rd_en,dout[287:0],full,empty,wr_rst_busy,rd_rst_busy" */;
  input srst;
  input wr_clk;
  input rd_clk;
  input [287:0]din;
  input wr_en;
  input rd_en;
  output [287:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
