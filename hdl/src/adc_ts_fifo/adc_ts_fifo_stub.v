// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Mon Apr 18 16:12:38 2022
// Host        : home running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub -rename_top adc_ts_fifo -prefix
//               adc_ts_fifo_ adc_ts_fifo_stub.v
// Design      : adc_ts_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu6cg-ffvc900-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *)
module adc_ts_fifo(srst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, valid, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="srst,wr_clk,rd_clk,din[63:0],wr_en,rd_en,dout[63:0],full,empty,valid,wr_rst_busy,rd_rst_busy" */;
  input srst;
  input wr_clk;
  input rd_clk;
  input [63:0]din;
  input wr_en;
  input rd_en;
  output [63:0]dout;
  output full;
  output empty;
  output valid;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
