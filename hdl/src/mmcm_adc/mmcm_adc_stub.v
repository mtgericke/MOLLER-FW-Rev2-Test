// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Sep  7 03:08:23 2023
// Host        : home running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub /home/xil/hdl/src/mmcm_adc/mmcm_adc_stub.v
// Design      : mmcm_adc
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu6cg-ffvc900-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module mmcm_adc(clk_adc_cnv, clk_adc, clk_625, reset, locked, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_adc_cnv,clk_adc,clk_625,reset,locked,clk_in1" */;
  output clk_adc_cnv;
  output clk_adc;
  output clk_625;
  input reset;
  output locked;
  input clk_in1;
endmodule
