//------------------------------------------------------------------------------
//  (c) Copyright 2013-2018 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------


`timescale 1ps/1ps

// =====================================================================================================================
// This example design top module instantiates the example design wrapper; slices vectored ports for per-channel
// assignment; and instantiates example resources such as buffers, pattern generators, and pattern checkers for core
// demonstration purposes
// =====================================================================================================================

module moller_gth_example_top (

  // Differential reference clock inputs
  input  wire mgtrefclk0_x1y3_p,
  input  wire mgtrefclk0_x1y3_n,
  input  wire mgtrefclk1_x1y1_p,
  input  wire mgtrefclk1_x1y1_n,
  input  wire mgtrefclk1_x1y2_p,
  input  wire mgtrefclk1_x1y2_n,

  // Serial data ports for transceiver channel 0
  input  wire ch0_gthrxn_in,
  input  wire ch0_gthrxp_in,
  output wire ch0_gthtxn_out,
  output wire ch0_gthtxp_out,

  // Serial data ports for transceiver channel 1
  input  wire ch1_gthrxn_in,
  input  wire ch1_gthrxp_in,
  output wire ch1_gthtxn_out,
  output wire ch1_gthtxp_out,

  // Serial data ports for transceiver channel 2
  input  wire ch2_gthrxn_in,
  input  wire ch2_gthrxp_in,
  output wire ch2_gthtxn_out,
  output wire ch2_gthtxp_out,

  // Serial data ports for transceiver channel 3
  input  wire ch3_gthrxn_in,
  input  wire ch3_gthrxp_in,
  output wire ch3_gthtxn_out,
  output wire ch3_gthtxp_out,

  // Serial data ports for transceiver channel 4
  input  wire ch4_gthrxn_in,
  input  wire ch4_gthrxp_in,
  output wire ch4_gthtxn_out,
  output wire ch4_gthtxp_out,

  // Serial data ports for transceiver channel 5
  input  wire ch5_gthrxn_in,
  input  wire ch5_gthrxp_in,
  output wire ch5_gthtxn_out,
  output wire ch5_gthtxp_out,

  // Serial data ports for transceiver channel 6
  input  wire ch6_gthrxn_in,
  input  wire ch6_gthrxp_in,
  output wire ch6_gthtxn_out,
  output wire ch6_gthtxp_out,

  // Serial data ports for transceiver channel 7
  input  wire ch7_gthrxn_in,
  input  wire ch7_gthrxp_in,
  output wire ch7_gthtxn_out,
  output wire ch7_gthtxp_out,

  // Serial data ports for transceiver channel 8
  input  wire ch8_gthrxn_in,
  input  wire ch8_gthrxp_in,
  output wire ch8_gthtxn_out,
  output wire ch8_gthtxp_out,

  // User-provided ports for reset helper block(s)
  input  wire hb_gtwiz_reset_clk_freerun_in,
  input  wire hb_gtwiz_reset_all_in,

  // PRBS-based link status ports
  input  wire link_down_latched_reset_in,
  output wire link_status_out,
  output reg  link_down_latched_out = 1'b1

);


  // ===================================================================================================================
  // PER-CHANNEL SIGNAL ASSIGNMENTS
  // ===================================================================================================================

  // The core and example design wrapper vectorize ports across all enabled transceiver channel and common instances for
  // simplicity and compactness. This example design top module assigns slices of each vector to individual, per-channel
  // signal vectors for use if desired. Signals which connect to helper blocks are prefixed "hb#", signals which connect
  // to transceiver common primitives are prefixed "cm#", and signals which connect to transceiver channel primitives
  // are prefixed "ch#", where "#" is the sequential resource number.

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] gthrxn_int;
  assign gthrxn_int[0:0] = ch0_gthrxn_in;
  assign gthrxn_int[1:1] = ch1_gthrxn_in;
  assign gthrxn_int[2:2] = ch2_gthrxn_in;
  assign gthrxn_int[3:3] = ch3_gthrxn_in;
  assign gthrxn_int[4:4] = ch4_gthrxn_in;
  assign gthrxn_int[5:5] = ch5_gthrxn_in;
  assign gthrxn_int[6:6] = ch6_gthrxn_in;
  assign gthrxn_int[7:7] = ch7_gthrxn_in;
  assign gthrxn_int[8:8] = ch8_gthrxn_in;

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] gthrxp_int;
  assign gthrxp_int[0:0] = ch0_gthrxp_in;
  assign gthrxp_int[1:1] = ch1_gthrxp_in;
  assign gthrxp_int[2:2] = ch2_gthrxp_in;
  assign gthrxp_int[3:3] = ch3_gthrxp_in;
  assign gthrxp_int[4:4] = ch4_gthrxp_in;
  assign gthrxp_int[5:5] = ch5_gthrxp_in;
  assign gthrxp_int[6:6] = ch6_gthrxp_in;
  assign gthrxp_int[7:7] = ch7_gthrxp_in;
  assign gthrxp_int[8:8] = ch8_gthrxp_in;

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] gthtxn_int;
  assign ch0_gthtxn_out = gthtxn_int[0:0];
  assign ch1_gthtxn_out = gthtxn_int[1:1];
  assign ch2_gthtxn_out = gthtxn_int[2:2];
  assign ch3_gthtxn_out = gthtxn_int[3:3];
  assign ch4_gthtxn_out = gthtxn_int[4:4];
  assign ch5_gthtxn_out = gthtxn_int[5:5];
  assign ch6_gthtxn_out = gthtxn_int[6:6];
  assign ch7_gthtxn_out = gthtxn_int[7:7];
  assign ch8_gthtxn_out = gthtxn_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] gthtxp_int;
  assign ch0_gthtxp_out = gthtxp_int[0:0];
  assign ch1_gthtxp_out = gthtxp_int[1:1];
  assign ch2_gthtxp_out = gthtxp_int[2:2];
  assign ch3_gthtxp_out = gthtxp_int[3:3];
  assign ch4_gthtxp_out = gthtxp_int[4:4];
  assign ch5_gthtxp_out = gthtxp_int[5:5];
  assign ch6_gthtxp_out = gthtxp_int[6:6];
  assign ch7_gthtxp_out = gthtxp_int[7:7];
  assign ch8_gthtxp_out = gthtxp_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_reset_int;
  wire [0:0] hb0_gtwiz_userclk_tx_reset_int;
  assign gtwiz_userclk_tx_reset_int[0:0] = hb0_gtwiz_userclk_tx_reset_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_srcclk_int;
  wire [0:0] hb0_gtwiz_userclk_tx_srcclk_int;
  assign hb0_gtwiz_userclk_tx_srcclk_int = gtwiz_userclk_tx_srcclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_usrclk_int;
  wire [0:0] hb0_gtwiz_userclk_tx_usrclk_int;
  assign hb0_gtwiz_userclk_tx_usrclk_int = gtwiz_userclk_tx_usrclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_usrclk2_int;
  wire [0:0] hb0_gtwiz_userclk_tx_usrclk2_int;
  assign hb0_gtwiz_userclk_tx_usrclk2_int = gtwiz_userclk_tx_usrclk2_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_active_int;
  wire [0:0] hb0_gtwiz_userclk_tx_active_int;
  assign hb0_gtwiz_userclk_tx_active_int = gtwiz_userclk_tx_active_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_reset_int;
  wire [0:0] hb0_gtwiz_userclk_rx_reset_int;
  assign gtwiz_userclk_rx_reset_int[0:0] = hb0_gtwiz_userclk_rx_reset_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_srcclk_int;
  wire [0:0] hb0_gtwiz_userclk_rx_srcclk_int;
  assign hb0_gtwiz_userclk_rx_srcclk_int = gtwiz_userclk_rx_srcclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_usrclk_int;
  wire [0:0] hb0_gtwiz_userclk_rx_usrclk_int;
  assign hb0_gtwiz_userclk_rx_usrclk_int = gtwiz_userclk_rx_usrclk_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_usrclk2_int;
  wire [0:0] hb0_gtwiz_userclk_rx_usrclk2_int;
  assign hb0_gtwiz_userclk_rx_usrclk2_int = gtwiz_userclk_rx_usrclk2_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_active_int;
  wire [0:0] hb0_gtwiz_userclk_rx_active_int;
  assign hb0_gtwiz_userclk_rx_active_int = gtwiz_userclk_rx_active_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_clk_freerun_int;
  wire [0:0] hb0_gtwiz_reset_clk_freerun_int = 1'b0;
  assign gtwiz_reset_clk_freerun_int[0:0] = hb0_gtwiz_reset_clk_freerun_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_all_int;
  wire [0:0] hb0_gtwiz_reset_all_int = 1'b0;
  assign gtwiz_reset_all_int[0:0] = hb0_gtwiz_reset_all_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_tx_pll_and_datapath_int;
  wire [0:0] hb0_gtwiz_reset_tx_pll_and_datapath_int;
  assign gtwiz_reset_tx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_tx_pll_and_datapath_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_tx_datapath_int;
  wire [0:0] hb0_gtwiz_reset_tx_datapath_int;
  assign gtwiz_reset_tx_datapath_int[0:0] = hb0_gtwiz_reset_tx_datapath_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_pll_and_datapath_int;
  wire [0:0] hb0_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  assign gtwiz_reset_rx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_rx_pll_and_datapath_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_datapath_int;
  wire [0:0] hb0_gtwiz_reset_rx_datapath_int = 1'b0;
  assign gtwiz_reset_rx_datapath_int[0:0] = hb0_gtwiz_reset_rx_datapath_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_cdr_stable_int;
  wire [0:0] hb0_gtwiz_reset_rx_cdr_stable_int;
  assign hb0_gtwiz_reset_rx_cdr_stable_int = gtwiz_reset_rx_cdr_stable_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_tx_done_int;
  wire [0:0] hb0_gtwiz_reset_tx_done_int;
  assign hb0_gtwiz_reset_tx_done_int = gtwiz_reset_tx_done_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_done_int;
  wire [0:0] hb0_gtwiz_reset_rx_done_int;
  assign hb0_gtwiz_reset_rx_done_int = gtwiz_reset_rx_done_int[0:0];

  //--------------------------------------------------------------------------------------------------------------------
  wire [287:0] gtwiz_userdata_tx_int;
  wire [31:0] hb0_gtwiz_userdata_tx_int;
  wire [31:0] hb1_gtwiz_userdata_tx_int;
  wire [31:0] hb2_gtwiz_userdata_tx_int;
  wire [31:0] hb3_gtwiz_userdata_tx_int;
  wire [31:0] hb4_gtwiz_userdata_tx_int;
  wire [31:0] hb5_gtwiz_userdata_tx_int;
  wire [31:0] hb6_gtwiz_userdata_tx_int;
  wire [31:0] hb7_gtwiz_userdata_tx_int;
  wire [31:0] hb8_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[31:0] = hb0_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[63:32] = hb1_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[95:64] = hb2_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[127:96] = hb3_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[159:128] = hb4_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[191:160] = hb5_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[223:192] = hb6_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[255:224] = hb7_gtwiz_userdata_tx_int;
  assign gtwiz_userdata_tx_int[287:256] = hb8_gtwiz_userdata_tx_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [287:0] gtwiz_userdata_rx_int;
  wire [31:0] hb0_gtwiz_userdata_rx_int;
  wire [31:0] hb1_gtwiz_userdata_rx_int;
  wire [31:0] hb2_gtwiz_userdata_rx_int;
  wire [31:0] hb3_gtwiz_userdata_rx_int;
  wire [31:0] hb4_gtwiz_userdata_rx_int;
  wire [31:0] hb5_gtwiz_userdata_rx_int;
  wire [31:0] hb6_gtwiz_userdata_rx_int;
  wire [31:0] hb7_gtwiz_userdata_rx_int;
  wire [31:0] hb8_gtwiz_userdata_rx_int;
  assign hb0_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[31:0];
  assign hb1_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[63:32];
  assign hb2_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[95:64];
  assign hb3_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[127:96];
  assign hb4_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[159:128];
  assign hb5_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[191:160];
  assign hb6_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[223:192];
  assign hb7_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[255:224];
  assign hb8_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[287:256];

  //--------------------------------------------------------------------------------------------------------------------
  wire [2:0] gtrefclk00_int;
  wire [0:0] cm0_gtrefclk00_int;
  wire [0:0] cm1_gtrefclk00_int;
  wire [0:0] cm2_gtrefclk00_int;
  assign gtrefclk00_int[0:0] = cm0_gtrefclk00_int;
  assign gtrefclk00_int[1:1] = cm1_gtrefclk00_int;
  assign gtrefclk00_int[2:2] = cm2_gtrefclk00_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [2:0] qpll0outclk_int;
  wire [0:0] cm0_qpll0outclk_int;
  wire [0:0] cm1_qpll0outclk_int;
  wire [0:0] cm2_qpll0outclk_int;
  assign cm0_qpll0outclk_int = qpll0outclk_int[0:0];
  assign cm1_qpll0outclk_int = qpll0outclk_int[1:1];
  assign cm2_qpll0outclk_int = qpll0outclk_int[2:2];

  //--------------------------------------------------------------------------------------------------------------------
  wire [2:0] qpll0outrefclk_int;
  wire [0:0] cm0_qpll0outrefclk_int;
  wire [0:0] cm1_qpll0outrefclk_int;
  wire [0:0] cm2_qpll0outrefclk_int;
  assign cm0_qpll0outrefclk_int = qpll0outrefclk_int[0:0];
  assign cm1_qpll0outrefclk_int = qpll0outrefclk_int[1:1];
  assign cm2_qpll0outrefclk_int = qpll0outrefclk_int[2:2];

  //--------------------------------------------------------------------------------------------------------------------
  wire [89:0] drpaddr_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] drpclk_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [143:0] drpdi_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] drpen_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] drpwe_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] eyescanreset_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] rxcdrhold_int;
  wire [0:0] ch0_rxcdrhold_int = 1'b0;
  wire [0:0] ch1_rxcdrhold_int = 1'b0;
  wire [0:0] ch2_rxcdrhold_int = 1'b0;
  wire [0:0] ch3_rxcdrhold_int = 1'b0;
  wire [0:0] ch4_rxcdrhold_int = 1'b0;
  wire [0:0] ch5_rxcdrhold_int = 1'b0;
  wire [0:0] ch6_rxcdrhold_int = 1'b0;
  wire [0:0] ch7_rxcdrhold_int = 1'b0;
  wire [0:0] ch8_rxcdrhold_int = 1'b0;
  assign rxcdrhold_int[0:0] = ch0_rxcdrhold_int;
  assign rxcdrhold_int[1:1] = ch1_rxcdrhold_int;
  assign rxcdrhold_int[2:2] = ch2_rxcdrhold_int;
  assign rxcdrhold_int[3:3] = ch3_rxcdrhold_int;
  assign rxcdrhold_int[4:4] = ch4_rxcdrhold_int;
  assign rxcdrhold_int[5:5] = ch5_rxcdrhold_int;
  assign rxcdrhold_int[6:6] = ch6_rxcdrhold_int;
  assign rxcdrhold_int[7:7] = ch7_rxcdrhold_int;
  assign rxcdrhold_int[8:8] = ch8_rxcdrhold_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] rxgearboxslip_int;
  wire [0:0] ch0_rxgearboxslip_int;
  wire [0:0] ch1_rxgearboxslip_int;
  wire [0:0] ch2_rxgearboxslip_int;
  wire [0:0] ch3_rxgearboxslip_int;
  wire [0:0] ch4_rxgearboxslip_int;
  wire [0:0] ch5_rxgearboxslip_int;
  wire [0:0] ch6_rxgearboxslip_int;
  wire [0:0] ch7_rxgearboxslip_int;
  wire [0:0] ch8_rxgearboxslip_int;
  assign rxgearboxslip_int[0:0] = ch0_rxgearboxslip_int;
  assign rxgearboxslip_int[1:1] = ch1_rxgearboxslip_int;
  assign rxgearboxslip_int[2:2] = ch2_rxgearboxslip_int;
  assign rxgearboxslip_int[3:3] = ch3_rxgearboxslip_int;
  assign rxgearboxslip_int[4:4] = ch4_rxgearboxslip_int;
  assign rxgearboxslip_int[5:5] = ch5_rxgearboxslip_int;
  assign rxgearboxslip_int[6:6] = ch6_rxgearboxslip_int;
  assign rxgearboxslip_int[7:7] = ch7_rxgearboxslip_int;
  assign rxgearboxslip_int[8:8] = ch8_rxgearboxslip_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] rxlpmen_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [26:0] rxrate_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [44:0] txdiffctrl_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [53:0] txheader_int;
  wire [5:0] ch0_txheader_int;
  wire [5:0] ch1_txheader_int;
  wire [5:0] ch2_txheader_int;
  wire [5:0] ch3_txheader_int;
  wire [5:0] ch4_txheader_int;
  wire [5:0] ch5_txheader_int;
  wire [5:0] ch6_txheader_int;
  wire [5:0] ch7_txheader_int;
  wire [5:0] ch8_txheader_int;
  assign txheader_int[5:0] = ch0_txheader_int;
  assign txheader_int[11:6] = ch1_txheader_int;
  assign txheader_int[17:12] = ch2_txheader_int;
  assign txheader_int[23:18] = ch3_txheader_int;
  assign txheader_int[29:24] = ch4_txheader_int;
  assign txheader_int[35:30] = ch5_txheader_int;
  assign txheader_int[41:36] = ch6_txheader_int;
  assign txheader_int[47:42] = ch7_txheader_int;
  assign txheader_int[53:48] = ch8_txheader_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [44:0] txpostcursor_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [44:0] txprecursor_int;
  // This vector is not sliced because it is directly assigned in a debug core instance below

  //--------------------------------------------------------------------------------------------------------------------
  wire [62:0] txsequence_int;
  wire [6:0] ch0_txsequence_int;
  wire [6:0] ch1_txsequence_int;
  wire [6:0] ch2_txsequence_int;
  wire [6:0] ch3_txsequence_int;
  wire [6:0] ch4_txsequence_int;
  wire [6:0] ch5_txsequence_int;
  wire [6:0] ch6_txsequence_int;
  wire [6:0] ch7_txsequence_int;
  wire [6:0] ch8_txsequence_int;
  assign txsequence_int[6:0] = ch0_txsequence_int;
  assign txsequence_int[13:7] = ch1_txsequence_int;
  assign txsequence_int[20:14] = ch2_txsequence_int;
  assign txsequence_int[27:21] = ch3_txsequence_int;
  assign txsequence_int[34:28] = ch4_txsequence_int;
  assign txsequence_int[41:35] = ch5_txsequence_int;
  assign txsequence_int[48:42] = ch6_txsequence_int;
  assign txsequence_int[55:49] = ch7_txsequence_int;
  assign txsequence_int[62:56] = ch8_txsequence_int;

  //--------------------------------------------------------------------------------------------------------------------
  wire [143:0] drpdo_int;
  wire [15:0] ch0_drpdo_int;
  wire [15:0] ch1_drpdo_int;
  wire [15:0] ch2_drpdo_int;
  wire [15:0] ch3_drpdo_int;
  wire [15:0] ch4_drpdo_int;
  wire [15:0] ch5_drpdo_int;
  wire [15:0] ch6_drpdo_int;
  wire [15:0] ch7_drpdo_int;
  wire [15:0] ch8_drpdo_int;
  assign ch0_drpdo_int = drpdo_int[15:0];
  assign ch1_drpdo_int = drpdo_int[31:16];
  assign ch2_drpdo_int = drpdo_int[47:32];
  assign ch3_drpdo_int = drpdo_int[63:48];
  assign ch4_drpdo_int = drpdo_int[79:64];
  assign ch5_drpdo_int = drpdo_int[95:80];
  assign ch6_drpdo_int = drpdo_int[111:96];
  assign ch7_drpdo_int = drpdo_int[127:112];
  assign ch8_drpdo_int = drpdo_int[143:128];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] drprdy_int;
  wire [0:0] ch0_drprdy_int;
  wire [0:0] ch1_drprdy_int;
  wire [0:0] ch2_drprdy_int;
  wire [0:0] ch3_drprdy_int;
  wire [0:0] ch4_drprdy_int;
  wire [0:0] ch5_drprdy_int;
  wire [0:0] ch6_drprdy_int;
  wire [0:0] ch7_drprdy_int;
  wire [0:0] ch8_drprdy_int;
  assign ch0_drprdy_int = drprdy_int[0:0];
  assign ch1_drprdy_int = drprdy_int[1:1];
  assign ch2_drprdy_int = drprdy_int[2:2];
  assign ch3_drprdy_int = drprdy_int[3:3];
  assign ch4_drprdy_int = drprdy_int[4:4];
  assign ch5_drprdy_int = drprdy_int[5:5];
  assign ch6_drprdy_int = drprdy_int[6:6];
  assign ch7_drprdy_int = drprdy_int[7:7];
  assign ch8_drprdy_int = drprdy_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] gtpowergood_int;
  wire [0:0] ch0_gtpowergood_int;
  wire [0:0] ch1_gtpowergood_int;
  wire [0:0] ch2_gtpowergood_int;
  wire [0:0] ch3_gtpowergood_int;
  wire [0:0] ch4_gtpowergood_int;
  wire [0:0] ch5_gtpowergood_int;
  wire [0:0] ch6_gtpowergood_int;
  wire [0:0] ch7_gtpowergood_int;
  wire [0:0] ch8_gtpowergood_int;
  assign ch0_gtpowergood_int = gtpowergood_int[0:0];
  assign ch1_gtpowergood_int = gtpowergood_int[1:1];
  assign ch2_gtpowergood_int = gtpowergood_int[2:2];
  assign ch3_gtpowergood_int = gtpowergood_int[3:3];
  assign ch4_gtpowergood_int = gtpowergood_int[4:4];
  assign ch5_gtpowergood_int = gtpowergood_int[5:5];
  assign ch6_gtpowergood_int = gtpowergood_int[6:6];
  assign ch7_gtpowergood_int = gtpowergood_int[7:7];
  assign ch8_gtpowergood_int = gtpowergood_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [17:0] rxdatavalid_int;
  wire [1:0] ch0_rxdatavalid_int;
  wire [1:0] ch1_rxdatavalid_int;
  wire [1:0] ch2_rxdatavalid_int;
  wire [1:0] ch3_rxdatavalid_int;
  wire [1:0] ch4_rxdatavalid_int;
  wire [1:0] ch5_rxdatavalid_int;
  wire [1:0] ch6_rxdatavalid_int;
  wire [1:0] ch7_rxdatavalid_int;
  wire [1:0] ch8_rxdatavalid_int;
  assign ch0_rxdatavalid_int = rxdatavalid_int[1:0];
  assign ch1_rxdatavalid_int = rxdatavalid_int[3:2];
  assign ch2_rxdatavalid_int = rxdatavalid_int[5:4];
  assign ch3_rxdatavalid_int = rxdatavalid_int[7:6];
  assign ch4_rxdatavalid_int = rxdatavalid_int[9:8];
  assign ch5_rxdatavalid_int = rxdatavalid_int[11:10];
  assign ch6_rxdatavalid_int = rxdatavalid_int[13:12];
  assign ch7_rxdatavalid_int = rxdatavalid_int[15:14];
  assign ch8_rxdatavalid_int = rxdatavalid_int[17:16];

  //--------------------------------------------------------------------------------------------------------------------
  wire [53:0] rxheader_int;
  wire [5:0] ch0_rxheader_int;
  wire [5:0] ch1_rxheader_int;
  wire [5:0] ch2_rxheader_int;
  wire [5:0] ch3_rxheader_int;
  wire [5:0] ch4_rxheader_int;
  wire [5:0] ch5_rxheader_int;
  wire [5:0] ch6_rxheader_int;
  wire [5:0] ch7_rxheader_int;
  wire [5:0] ch8_rxheader_int;
  assign ch0_rxheader_int = rxheader_int[5:0];
  assign ch1_rxheader_int = rxheader_int[11:6];
  assign ch2_rxheader_int = rxheader_int[17:12];
  assign ch3_rxheader_int = rxheader_int[23:18];
  assign ch4_rxheader_int = rxheader_int[29:24];
  assign ch5_rxheader_int = rxheader_int[35:30];
  assign ch6_rxheader_int = rxheader_int[41:36];
  assign ch7_rxheader_int = rxheader_int[47:42];
  assign ch8_rxheader_int = rxheader_int[53:48];

  //--------------------------------------------------------------------------------------------------------------------
  wire [17:0] rxheadervalid_int;
  wire [1:0] ch0_rxheadervalid_int;
  wire [1:0] ch1_rxheadervalid_int;
  wire [1:0] ch2_rxheadervalid_int;
  wire [1:0] ch3_rxheadervalid_int;
  wire [1:0] ch4_rxheadervalid_int;
  wire [1:0] ch5_rxheadervalid_int;
  wire [1:0] ch6_rxheadervalid_int;
  wire [1:0] ch7_rxheadervalid_int;
  wire [1:0] ch8_rxheadervalid_int;
  assign ch0_rxheadervalid_int = rxheadervalid_int[1:0];
  assign ch1_rxheadervalid_int = rxheadervalid_int[3:2];
  assign ch2_rxheadervalid_int = rxheadervalid_int[5:4];
  assign ch3_rxheadervalid_int = rxheadervalid_int[7:6];
  assign ch4_rxheadervalid_int = rxheadervalid_int[9:8];
  assign ch5_rxheadervalid_int = rxheadervalid_int[11:10];
  assign ch6_rxheadervalid_int = rxheadervalid_int[13:12];
  assign ch7_rxheadervalid_int = rxheadervalid_int[15:14];
  assign ch8_rxheadervalid_int = rxheadervalid_int[17:16];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] rxpmaresetdone_int;
  wire [0:0] ch0_rxpmaresetdone_int;
  wire [0:0] ch1_rxpmaresetdone_int;
  wire [0:0] ch2_rxpmaresetdone_int;
  wire [0:0] ch3_rxpmaresetdone_int;
  wire [0:0] ch4_rxpmaresetdone_int;
  wire [0:0] ch5_rxpmaresetdone_int;
  wire [0:0] ch6_rxpmaresetdone_int;
  wire [0:0] ch7_rxpmaresetdone_int;
  wire [0:0] ch8_rxpmaresetdone_int;
  assign ch0_rxpmaresetdone_int = rxpmaresetdone_int[0:0];
  assign ch1_rxpmaresetdone_int = rxpmaresetdone_int[1:1];
  assign ch2_rxpmaresetdone_int = rxpmaresetdone_int[2:2];
  assign ch3_rxpmaresetdone_int = rxpmaresetdone_int[3:3];
  assign ch4_rxpmaresetdone_int = rxpmaresetdone_int[4:4];
  assign ch5_rxpmaresetdone_int = rxpmaresetdone_int[5:5];
  assign ch6_rxpmaresetdone_int = rxpmaresetdone_int[6:6];
  assign ch7_rxpmaresetdone_int = rxpmaresetdone_int[7:7];
  assign ch8_rxpmaresetdone_int = rxpmaresetdone_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] rxprgdivresetdone_int;
  wire [0:0] ch0_rxprgdivresetdone_int;
  wire [0:0] ch1_rxprgdivresetdone_int;
  wire [0:0] ch2_rxprgdivresetdone_int;
  wire [0:0] ch3_rxprgdivresetdone_int;
  wire [0:0] ch4_rxprgdivresetdone_int;
  wire [0:0] ch5_rxprgdivresetdone_int;
  wire [0:0] ch6_rxprgdivresetdone_int;
  wire [0:0] ch7_rxprgdivresetdone_int;
  wire [0:0] ch8_rxprgdivresetdone_int;
  assign ch0_rxprgdivresetdone_int = rxprgdivresetdone_int[0:0];
  assign ch1_rxprgdivresetdone_int = rxprgdivresetdone_int[1:1];
  assign ch2_rxprgdivresetdone_int = rxprgdivresetdone_int[2:2];
  assign ch3_rxprgdivresetdone_int = rxprgdivresetdone_int[3:3];
  assign ch4_rxprgdivresetdone_int = rxprgdivresetdone_int[4:4];
  assign ch5_rxprgdivresetdone_int = rxprgdivresetdone_int[5:5];
  assign ch6_rxprgdivresetdone_int = rxprgdivresetdone_int[6:6];
  assign ch7_rxprgdivresetdone_int = rxprgdivresetdone_int[7:7];
  assign ch8_rxprgdivresetdone_int = rxprgdivresetdone_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [17:0] rxstartofseq_int;
  wire [1:0] ch0_rxstartofseq_int;
  wire [1:0] ch1_rxstartofseq_int;
  wire [1:0] ch2_rxstartofseq_int;
  wire [1:0] ch3_rxstartofseq_int;
  wire [1:0] ch4_rxstartofseq_int;
  wire [1:0] ch5_rxstartofseq_int;
  wire [1:0] ch6_rxstartofseq_int;
  wire [1:0] ch7_rxstartofseq_int;
  wire [1:0] ch8_rxstartofseq_int;
  assign ch0_rxstartofseq_int = rxstartofseq_int[1:0];
  assign ch1_rxstartofseq_int = rxstartofseq_int[3:2];
  assign ch2_rxstartofseq_int = rxstartofseq_int[5:4];
  assign ch3_rxstartofseq_int = rxstartofseq_int[7:6];
  assign ch4_rxstartofseq_int = rxstartofseq_int[9:8];
  assign ch5_rxstartofseq_int = rxstartofseq_int[11:10];
  assign ch6_rxstartofseq_int = rxstartofseq_int[13:12];
  assign ch7_rxstartofseq_int = rxstartofseq_int[15:14];
  assign ch8_rxstartofseq_int = rxstartofseq_int[17:16];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] txpmaresetdone_int;
  wire [0:0] ch0_txpmaresetdone_int;
  wire [0:0] ch1_txpmaresetdone_int;
  wire [0:0] ch2_txpmaresetdone_int;
  wire [0:0] ch3_txpmaresetdone_int;
  wire [0:0] ch4_txpmaresetdone_int;
  wire [0:0] ch5_txpmaresetdone_int;
  wire [0:0] ch6_txpmaresetdone_int;
  wire [0:0] ch7_txpmaresetdone_int;
  wire [0:0] ch8_txpmaresetdone_int;
  assign ch0_txpmaresetdone_int = txpmaresetdone_int[0:0];
  assign ch1_txpmaresetdone_int = txpmaresetdone_int[1:1];
  assign ch2_txpmaresetdone_int = txpmaresetdone_int[2:2];
  assign ch3_txpmaresetdone_int = txpmaresetdone_int[3:3];
  assign ch4_txpmaresetdone_int = txpmaresetdone_int[4:4];
  assign ch5_txpmaresetdone_int = txpmaresetdone_int[5:5];
  assign ch6_txpmaresetdone_int = txpmaresetdone_int[6:6];
  assign ch7_txpmaresetdone_int = txpmaresetdone_int[7:7];
  assign ch8_txpmaresetdone_int = txpmaresetdone_int[8:8];

  //--------------------------------------------------------------------------------------------------------------------
  wire [8:0] txprgdivresetdone_int;
  wire [0:0] ch0_txprgdivresetdone_int;
  wire [0:0] ch1_txprgdivresetdone_int;
  wire [0:0] ch2_txprgdivresetdone_int;
  wire [0:0] ch3_txprgdivresetdone_int;
  wire [0:0] ch4_txprgdivresetdone_int;
  wire [0:0] ch5_txprgdivresetdone_int;
  wire [0:0] ch6_txprgdivresetdone_int;
  wire [0:0] ch7_txprgdivresetdone_int;
  wire [0:0] ch8_txprgdivresetdone_int;
  assign ch0_txprgdivresetdone_int = txprgdivresetdone_int[0:0];
  assign ch1_txprgdivresetdone_int = txprgdivresetdone_int[1:1];
  assign ch2_txprgdivresetdone_int = txprgdivresetdone_int[2:2];
  assign ch3_txprgdivresetdone_int = txprgdivresetdone_int[3:3];
  assign ch4_txprgdivresetdone_int = txprgdivresetdone_int[4:4];
  assign ch5_txprgdivresetdone_int = txprgdivresetdone_int[5:5];
  assign ch6_txprgdivresetdone_int = txprgdivresetdone_int[6:6];
  assign ch7_txprgdivresetdone_int = txprgdivresetdone_int[7:7];
  assign ch8_txprgdivresetdone_int = txprgdivresetdone_int[8:8];


  // ===================================================================================================================
  // BUFFERS
  // ===================================================================================================================

  // Buffer the hb_gtwiz_reset_all_in input and logically combine it with the internal signal from the example
  // initialization block as well as the VIO-sourced reset
  wire hb_gtwiz_reset_all_vio_int;
  wire hb_gtwiz_reset_all_buf_int;
  wire hb_gtwiz_reset_all_init_int;
  wire hb_gtwiz_reset_all_int;

  assign hb_gtwiz_reset_all_buf_int = hb_gtwiz_reset_all_in;

  assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int || hb_gtwiz_reset_all_init_int || hb_gtwiz_reset_all_vio_int;

  // Globally buffer the free-running input clock
  wire hb_gtwiz_reset_clk_freerun_buf_int;

  assign hb_gtwiz_reset_clk_freerun_buf_int = hb_gtwiz_reset_clk_freerun_in;
  /*
  BUFG bufg_clk_freerun_inst (
    .I (hb_gtwiz_reset_clk_freerun_in),
    .O (hb_gtwiz_reset_clk_freerun_buf_int)
  );
  */

  // Instantiate a differential reference clock buffer for each reference clock differential pair in this configuration,
  // and assign the single-ended output of each differential reference clock buffer to the appropriate PLL input signal

  // Differential reference clock buffer for MGTREFCLK0_X1Y3
  wire mgtrefclk0_x1y3_int;

  IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0),
    .REFCLK_HROW_CK_SEL (2'b00),
    .REFCLK_ICNTL_RX    (2'b00)
  ) IBUFDS_GTE4_MGTREFCLK0_X1Y3_INST (
    .I     (mgtrefclk0_x1y3_p),
    .IB    (mgtrefclk0_x1y3_n),
    .CEB   (1'b0),
    .O     (mgtrefclk0_x1y3_int),
    .ODIV2 ()
  );

  // Differential reference clock buffer for MGTREFCLK1_X1Y1
  wire mgtrefclk1_x1y1_int;

  IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0),
    .REFCLK_HROW_CK_SEL (2'b00),
    .REFCLK_ICNTL_RX    (2'b00)
  ) IBUFDS_GTE4_MGTREFCLK1_X1Y1_INST (
    .I     (mgtrefclk1_x1y1_p),
    .IB    (mgtrefclk1_x1y1_n),
    .CEB   (1'b0),
    .O     (mgtrefclk1_x1y1_int),
    .ODIV2 ()
  );

  // Differential reference clock buffer for MGTREFCLK1_X1Y2
  wire mgtrefclk1_x1y2_int;

  IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0),
    .REFCLK_HROW_CK_SEL (2'b00),
    .REFCLK_ICNTL_RX    (2'b00)
  ) IBUFDS_GTE4_MGTREFCLK1_X1Y2_INST (
    .I     (mgtrefclk1_x1y2_p),
    .IB    (mgtrefclk1_x1y2_n),
    .CEB   (1'b0),
    .O     (mgtrefclk1_x1y2_int),
    .ODIV2 ()
  );

  assign cm0_gtrefclk00_int = mgtrefclk1_x1y1_int;
  assign cm1_gtrefclk00_int = mgtrefclk1_x1y2_int;
  assign cm2_gtrefclk00_int = mgtrefclk0_x1y3_int;


  // ===================================================================================================================
  // USER CLOCKING RESETS
  // ===================================================================================================================

  // The TX user clocking helper block should be held in reset until the clock source of that block is known to be
  // stable. The following assignment is an example of how that stability can be determined, based on the selected TX
  // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  assign hb0_gtwiz_userclk_tx_reset_int = ~(&txprgdivresetdone_int && &txpmaresetdone_int);

  // The RX user clocking helper block should be held in reset until the clock source of that block is known to be
  // stable. The following assignment is an example of how that stability can be determined, based on the selected RX
  // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  assign hb0_gtwiz_userclk_rx_reset_int = ~(&rxprgdivresetdone_int && &rxpmaresetdone_int);


  // ===================================================================================================================
  // PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT
  // ===================================================================================================================

  // PRBS stimulus
  // -------------------------------------------------------------------------------------------------------------------

  // PRBS-based data stimulus module for transceiver channel 0
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst0 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch0_txheader_int),
    .txsequence_out              (ch0_txsequence_int),
    .txdata_out                  (hb0_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 1
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst1 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch1_txheader_int),
    .txsequence_out              (ch1_txsequence_int),
    .txdata_out                  (hb1_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 2
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst2 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch2_txheader_int),
    .txsequence_out              (ch2_txsequence_int),
    .txdata_out                  (hb2_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 3
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst3 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch3_txheader_int),
    .txsequence_out              (ch3_txsequence_int),
    .txdata_out                  (hb3_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 4
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst4 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch4_txheader_int),
    .txsequence_out              (ch4_txsequence_int),
    .txdata_out                  (hb4_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 5
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst5 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch5_txheader_int),
    .txsequence_out              (ch5_txsequence_int),
    .txdata_out                  (hb5_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 6
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst6 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch6_txheader_int),
    .txsequence_out              (ch6_txsequence_int),
    .txdata_out                  (hb6_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 7
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst7 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch7_txheader_int),
    .txsequence_out              (ch7_txsequence_int),
    .txdata_out                  (hb7_gtwiz_userdata_tx_int)
  );

  // PRBS-based data stimulus module for transceiver channel 8
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_stimulus_64b66b_async example_stimulus_inst8 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int),
    .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
    .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
    .txheader_out                (ch8_txheader_int),
    .txsequence_out              (ch8_txsequence_int),
    .txdata_out                  (hb8_gtwiz_userdata_tx_int)
  );

  // PRBS checking
  // -------------------------------------------------------------------------------------------------------------------

  // Declare a signal vector of PRBS match indicators, with one indicator bit per transceiver channel
  wire [8:0] prbs_match_int;

  // PRBS-based data checking module for transceiver channel 0
  moller_gth_example_checking_64b66b_async example_checking_inst0 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch0_rxdatavalid_int),
    .rxgearboxslip_out           (ch0_rxgearboxslip_int),
    .rxdata_in                   (hb0_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[0])
  );

  // PRBS-based data checking module for transceiver channel 1
  moller_gth_example_checking_64b66b_async example_checking_inst1 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch1_rxdatavalid_int),
    .rxgearboxslip_out           (ch1_rxgearboxslip_int),
    .rxdata_in                   (hb1_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[1])
  );

  // PRBS-based data checking module for transceiver channel 2
  moller_gth_example_checking_64b66b_async example_checking_inst2 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch2_rxdatavalid_int),
    .rxgearboxslip_out           (ch2_rxgearboxslip_int),
    .rxdata_in                   (hb2_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[2])
  );

  // PRBS-based data checking module for transceiver channel 3
  moller_gth_example_checking_64b66b_async example_checking_inst3 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch3_rxdatavalid_int),
    .rxgearboxslip_out           (ch3_rxgearboxslip_int),
    .rxdata_in                   (hb3_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[3])
  );

  // PRBS-based data checking module for transceiver channel 4
  moller_gth_example_checking_64b66b_async example_checking_inst4 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch4_rxdatavalid_int),
    .rxgearboxslip_out           (ch4_rxgearboxslip_int),
    .rxdata_in                   (hb4_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[4])
  );

  // PRBS-based data checking module for transceiver channel 5
  moller_gth_example_checking_64b66b_async example_checking_inst5 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch5_rxdatavalid_int),
    .rxgearboxslip_out           (ch5_rxgearboxslip_int),
    .rxdata_in                   (hb5_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[5])
  );

  // PRBS-based data checking module for transceiver channel 6
  moller_gth_example_checking_64b66b_async example_checking_inst6 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch6_rxdatavalid_int),
    .rxgearboxslip_out           (ch6_rxgearboxslip_int),
    .rxdata_in                   (hb6_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[6])
  );

  // PRBS-based data checking module for transceiver channel 7
  moller_gth_example_checking_64b66b_async example_checking_inst7 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch7_rxdatavalid_int),
    .rxgearboxslip_out           (ch7_rxgearboxslip_int),
    .rxdata_in                   (hb7_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[7])
  );

  // PRBS-based data checking module for transceiver channel 8
  moller_gth_example_checking_64b66b_async example_checking_inst8 (
    .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
    .gtwiz_userclk_rx_usrclk2_in (hb0_gtwiz_userclk_rx_usrclk2_int),
    .gtwiz_userclk_rx_active_in  (hb0_gtwiz_userclk_rx_active_int),
    .rxdatavalid_in              (ch8_rxdatavalid_int),
    .rxgearboxslip_out           (ch8_rxgearboxslip_int),
    .rxdata_in                   (hb8_gtwiz_userdata_rx_int),
    .prbs_match_out              (prbs_match_int[8])
  );

  // PRBS match and related link management
  // -------------------------------------------------------------------------------------------------------------------

  // Perform a bitwise NAND of all PRBS match indicators, creating a combinatorial indication of any PRBS mismatch
  // across all transceiver channels
  wire prbs_error_any_async = ~(&prbs_match_int);
  wire prbs_error_any_sync;

  // Synchronize the PRBS mismatch indicator the free-running clock domain, using a reset synchronizer with asynchronous
  // reset and synchronous removal
  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_reset_synchronizer reset_synchronizer_prbs_match_all_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .rst_in (prbs_error_any_async),
    .rst_out(prbs_error_any_sync)
  );

  // Implement an example link status state machine using a simple leaky bucket mechanism. The link status indicates
  // the continual PRBS match status to both the top-level observer and the initialization state machine, while being
  // tolerant of occasional bit errors. This is an example and can be modified as necessary.
  localparam ST_LINK_DOWN = 1'b0;
  localparam ST_LINK_UP   = 1'b1;
  reg        sm_link      = ST_LINK_DOWN;
  reg [6:0]  link_ctr     = 7'd0;

  always @(posedge hb_gtwiz_reset_clk_freerun_buf_int) begin
    case (sm_link)
      // The link is considered to be down when the link counter initially has a value less than 67. When the link is
      // down, the counter is incremented on each cycle where all PRBS bits match, but reset whenever any PRBS mismatch
      // occurs. When the link counter reaches 67, transition to the link up state.
      ST_LINK_DOWN: begin
        if (prbs_error_any_sync !== 1'b0) begin
          link_ctr <= 7'd0;
        end
        else begin
          if (link_ctr < 7'd67)
            link_ctr <= link_ctr + 7'd1;
          else
            sm_link <= ST_LINK_UP;
        end
      end

      // When the link is up, the link counter is decreased by 34 whenever any PRBS mismatch occurs, but is increased by
      // only 1 on each cycle where all PRBS bits match, up to its saturation point of 67. If the link counter reaches
      // 0 (including rollover protection), transition to the link down state.
      ST_LINK_UP: begin
        if (prbs_error_any_sync !== 1'b0) begin
          if (link_ctr > 7'd33) begin
            link_ctr <= link_ctr - 7'd34;
            if (link_ctr == 7'd34)
              sm_link  <= ST_LINK_DOWN;
          end
          else begin
            link_ctr <= 7'd0;
            sm_link  <= ST_LINK_DOWN;
          end
        end
        else begin
          if (link_ctr < 7'd67)
            link_ctr <= link_ctr + 7'd1;
        end
      end
    endcase
  end

  // Synchronize the latched link down reset input and the VIO-driven signal into the free-running clock domain
  wire link_down_latched_reset_vio_int;
  wire link_down_latched_reset_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_link_down_latched_reset_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (link_down_latched_reset_in || link_down_latched_reset_vio_int),
    .o_out  (link_down_latched_reset_sync)
  );

  // Reset the latched link down indicator when the synchronized latched link down reset signal is high. Otherwise, set
  // the latched link down indicator upon losing link. This indicator is available for user reference.
  always @(posedge hb_gtwiz_reset_clk_freerun_buf_int) begin
    if (link_down_latched_reset_sync)
      link_down_latched_out <= 1'b0;
    else if (!sm_link)
      link_down_latched_out <= 1'b1;
  end

  // Assign the link status indicator to the top-level two-state output for user reference
  assign link_status_out = sm_link;


  // ===================================================================================================================
  // INITIALIZATION
  // ===================================================================================================================

  // Declare the receiver reset signals that interface to the reset controller helper block. For this configuration,
  // which uses the same PLL type for transmitter and receiver, the "reset RX PLL and datapath" feature is not used.
  wire hb_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  wire hb_gtwiz_reset_rx_datapath_int;

  // Declare signals which connect the VIO instance to the initialization module for debug purposes
  wire       init_done_int;
  wire [3:0] init_retry_ctr_int;

  // Combine the receiver reset signals form the initialization module and the VIO to drive the appropriate reset
  // controller helper block reset input
  wire hb_gtwiz_reset_rx_pll_and_datapath_vio_int;
  wire hb_gtwiz_reset_rx_datapath_vio_int;
  wire hb_gtwiz_reset_rx_datapath_init_int;

  assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_vio_int;

  // The example initialization module interacts with the reset controller helper block and other example design logic
  // to retry failed reset attempts in order to mitigate bring-up issues such as initially-unavilable reference clocks
  // or data connections. It also resets the receiver in the event of link loss in an attempt to regain link, so please
  // note the possibility that this behavior can have the effect of overriding or disturbing user-provided inputs that
  // destabilize the data stream. It is a demonstration only and can be modified to suit your system needs.
  moller_gth_example_init example_init_inst (
    .clk_freerun_in  (hb_gtwiz_reset_clk_freerun_buf_int),
    .reset_all_in    (hb_gtwiz_reset_all_int),
    .tx_init_done_in (gtwiz_reset_tx_done_int),
    .rx_init_done_in (gtwiz_reset_rx_done_int),
    .rx_data_good_in (sm_link),
    .reset_all_out   (hb_gtwiz_reset_all_init_int),
    .reset_rx_out    (hb_gtwiz_reset_rx_datapath_init_int),
    .init_done_out   (init_done_int),
    .retry_ctr_out   (init_retry_ctr_int)
  );


  // ===================================================================================================================
  // VIO FOR HARDWARE BRING-UP AND DEBUG
  // ===================================================================================================================

  // Synchronize gtpowergood into the free-running clock domain for VIO usage
  wire [8:0] gtpowergood_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[0]),
    .o_out  (gtpowergood_vio_sync[0])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_1_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[1]),
    .o_out  (gtpowergood_vio_sync[1])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_2_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[2]),
    .o_out  (gtpowergood_vio_sync[2])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_3_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[3]),
    .o_out  (gtpowergood_vio_sync[3])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_4_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[4]),
    .o_out  (gtpowergood_vio_sync[4])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_5_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[5]),
    .o_out  (gtpowergood_vio_sync[5])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_6_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[6]),
    .o_out  (gtpowergood_vio_sync[6])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_7_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[7]),
    .o_out  (gtpowergood_vio_sync[7])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_8_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[8]),
    .o_out  (gtpowergood_vio_sync[8])
  );

  // Synchronize txprgdivresetdone into the free-running clock domain for VIO usage
  wire [8:0] txprgdivresetdone_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[0]),
    .o_out  (txprgdivresetdone_vio_sync[0])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_1_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[1]),
    .o_out  (txprgdivresetdone_vio_sync[1])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_2_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[2]),
    .o_out  (txprgdivresetdone_vio_sync[2])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_3_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[3]),
    .o_out  (txprgdivresetdone_vio_sync[3])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_4_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[4]),
    .o_out  (txprgdivresetdone_vio_sync[4])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_5_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[5]),
    .o_out  (txprgdivresetdone_vio_sync[5])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_6_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[6]),
    .o_out  (txprgdivresetdone_vio_sync[6])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_7_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[7]),
    .o_out  (txprgdivresetdone_vio_sync[7])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_8_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txprgdivresetdone_int[8]),
    .o_out  (txprgdivresetdone_vio_sync[8])
  );

  // Synchronize rxprgdivresetdone into the free-running clock domain for VIO usage
  wire [8:0] rxprgdivresetdone_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[0]),
    .o_out  (rxprgdivresetdone_vio_sync[0])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_1_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[1]),
    .o_out  (rxprgdivresetdone_vio_sync[1])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_2_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[2]),
    .o_out  (rxprgdivresetdone_vio_sync[2])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_3_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[3]),
    .o_out  (rxprgdivresetdone_vio_sync[3])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_4_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[4]),
    .o_out  (rxprgdivresetdone_vio_sync[4])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_5_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[5]),
    .o_out  (rxprgdivresetdone_vio_sync[5])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_6_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[6]),
    .o_out  (rxprgdivresetdone_vio_sync[6])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_7_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[7]),
    .o_out  (rxprgdivresetdone_vio_sync[7])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_8_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxprgdivresetdone_int[8]),
    .o_out  (rxprgdivresetdone_vio_sync[8])
  );

  // Synchronize txpmaresetdone into the free-running clock domain for VIO usage
  wire [8:0] txpmaresetdone_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[0]),
    .o_out  (txpmaresetdone_vio_sync[0])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_1_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[1]),
    .o_out  (txpmaresetdone_vio_sync[1])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_2_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[2]),
    .o_out  (txpmaresetdone_vio_sync[2])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_3_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[3]),
    .o_out  (txpmaresetdone_vio_sync[3])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_4_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[4]),
    .o_out  (txpmaresetdone_vio_sync[4])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_5_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[5]),
    .o_out  (txpmaresetdone_vio_sync[5])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_6_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[6]),
    .o_out  (txpmaresetdone_vio_sync[6])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_7_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[7]),
    .o_out  (txpmaresetdone_vio_sync[7])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_8_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[8]),
    .o_out  (txpmaresetdone_vio_sync[8])
  );

  // Synchronize rxpmaresetdone into the free-running clock domain for VIO usage
  wire [8:0] rxpmaresetdone_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[0]),
    .o_out  (rxpmaresetdone_vio_sync[0])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_1_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[1]),
    .o_out  (rxpmaresetdone_vio_sync[1])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_2_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[2]),
    .o_out  (rxpmaresetdone_vio_sync[2])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_3_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[3]),
    .o_out  (rxpmaresetdone_vio_sync[3])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_4_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[4]),
    .o_out  (rxpmaresetdone_vio_sync[4])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_5_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[5]),
    .o_out  (rxpmaresetdone_vio_sync[5])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_6_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[6]),
    .o_out  (rxpmaresetdone_vio_sync[6])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_7_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[7]),
    .o_out  (rxpmaresetdone_vio_sync[7])
  );

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_8_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[8]),
    .o_out  (rxpmaresetdone_vio_sync[8])
  );

  // Synchronize gtwiz_reset_tx_done into the free-running clock domain for VIO usage
  wire [0:0] gtwiz_reset_tx_done_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtwiz_reset_tx_done_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtwiz_reset_tx_done_int[0]),
    .o_out  (gtwiz_reset_tx_done_vio_sync[0])
  );

  // Synchronize gtwiz_reset_rx_done into the free-running clock domain for VIO usage
  wire [0:0] gtwiz_reset_rx_done_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  moller_gth_example_bit_synchronizer bit_synchronizer_vio_gtwiz_reset_rx_done_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtwiz_reset_rx_done_int[0]),
    .o_out  (gtwiz_reset_rx_done_vio_sync[0])
  );


  // Instantiate the VIO IP core for hardware bring-up and debug purposes, connecting relevant debug and analysis
  // signals which have been enabled during Wizard IP customization. This initial set of connected signals is
  // provided as a convenience and example, but more or fewer ports can be used as needed; simply re-customize and
  // re-generate the VIO instance, then connect any exposed signals that are needed. Signals which are synchronous to
  // clocks other than the free-running clock will require synchronization. For usage, refer to Vivado Design Suite
  // User Guide: Programming and Debugging (UG908)
  moller_gth_vio_0 moller_gth_vio_0_inst (
    .clk (hb_gtwiz_reset_clk_freerun_buf_int)
    ,.probe_in0 (link_status_out)
    ,.probe_in1 (link_down_latched_out)
    ,.probe_in2 (init_done_int)
    ,.probe_in3 (init_retry_ctr_int)
    ,.probe_in4 (gtpowergood_vio_sync)
    ,.probe_in5 (txprgdivresetdone_vio_sync)
    ,.probe_in6 (rxprgdivresetdone_vio_sync)
    ,.probe_in7 (txpmaresetdone_vio_sync)
    ,.probe_in8 (rxpmaresetdone_vio_sync)
    ,.probe_in9 (gtwiz_reset_tx_done_vio_sync)
    ,.probe_in10 (gtwiz_reset_rx_done_vio_sync)
    ,.probe_out0 (hb_gtwiz_reset_all_vio_int)
    ,.probe_out1 (hb0_gtwiz_reset_tx_pll_and_datapath_int)
    ,.probe_out2 (hb0_gtwiz_reset_tx_datapath_int)
    ,.probe_out3 (hb_gtwiz_reset_rx_pll_and_datapath_vio_int)
    ,.probe_out4 (hb_gtwiz_reset_rx_datapath_vio_int)
    ,.probe_out5 (link_down_latched_reset_vio_int)
  );


  // ===================================================================================================================
  // IN-SYSTEM IBERT FOR HARDWARE BRING-UP AND LINK ANALYSIS
  // ===================================================================================================================

  // Instantiate the In-System IBERT IP core for hardware bring-up and link analysis purposes. For usage, refer to
  // Vivado Design Suite User Guide: Programming and Debugging (UG908)
  // In-System IBERT IP instance property dictionary is as follows:
  // CONFIG.C_GT_TYPE {GTH} CONFIG.C_GTS_USED {X1Y4 X1Y5 X1Y6 X1Y7 X1Y8 X1Y9 X1Y10 X1Y11 X1Y12} CONFIG.C_ENABLE_INPUT_PORTS {true}
  moller_gth_in_system_ibert_0 moller_gth_in_system_ibert_0_inst (
    .drpclk_o       (drpclk_int),
    .gt0_drpen_o    (drpen_int[0:0]),
    .gt0_drpwe_o    (drpwe_int[0:0]),
    .gt0_drpaddr_o  (drpaddr_int[9:0]),
    .gt0_drpdi_o    (drpdi_int[15:0]),
    .gt0_drprdy_i   (drprdy_int[0:0]),
    .gt0_drpdo_i    (drpdo_int[15:0]),
    .gt1_drpen_o    (drpen_int[1:1]),
    .gt1_drpwe_o    (drpwe_int[1:1]),
    .gt1_drpaddr_o  (drpaddr_int[19:10]),
    .gt1_drpdi_o    (drpdi_int[31:16]),
    .gt1_drprdy_i   (drprdy_int[1:1]),
    .gt1_drpdo_i    (drpdo_int[31:16]),
    .gt2_drpen_o    (drpen_int[2:2]),
    .gt2_drpwe_o    (drpwe_int[2:2]),
    .gt2_drpaddr_o  (drpaddr_int[29:20]),
    .gt2_drpdi_o    (drpdi_int[47:32]),
    .gt2_drprdy_i   (drprdy_int[2:2]),
    .gt2_drpdo_i    (drpdo_int[47:32]),
    .gt3_drpen_o    (drpen_int[3:3]),
    .gt3_drpwe_o    (drpwe_int[3:3]),
    .gt3_drpaddr_o  (drpaddr_int[39:30]),
    .gt3_drpdi_o    (drpdi_int[63:48]),
    .gt3_drprdy_i   (drprdy_int[3:3]),
    .gt3_drpdo_i    (drpdo_int[63:48]),
    .gt4_drpen_o    (drpen_int[4:4]),
    .gt4_drpwe_o    (drpwe_int[4:4]),
    .gt4_drpaddr_o  (drpaddr_int[49:40]),
    .gt4_drpdi_o    (drpdi_int[79:64]),
    .gt4_drprdy_i   (drprdy_int[4:4]),
    .gt4_drpdo_i    (drpdo_int[79:64]),
    .gt5_drpen_o    (drpen_int[5:5]),
    .gt5_drpwe_o    (drpwe_int[5:5]),
    .gt5_drpaddr_o  (drpaddr_int[59:50]),
    .gt5_drpdi_o    (drpdi_int[95:80]),
    .gt5_drprdy_i   (drprdy_int[5:5]),
    .gt5_drpdo_i    (drpdo_int[95:80]),
    .gt6_drpen_o    (drpen_int[6:6]),
    .gt6_drpwe_o    (drpwe_int[6:6]),
    .gt6_drpaddr_o  (drpaddr_int[69:60]),
    .gt6_drpdi_o    (drpdi_int[111:96]),
    .gt6_drprdy_i   (drprdy_int[6:6]),
    .gt6_drpdo_i    (drpdo_int[111:96]),
    .gt7_drpen_o    (drpen_int[7:7]),
    .gt7_drpwe_o    (drpwe_int[7:7]),
    .gt7_drpaddr_o  (drpaddr_int[79:70]),
    .gt7_drpdi_o    (drpdi_int[127:112]),
    .gt7_drprdy_i   (drprdy_int[7:7]),
    .gt7_drpdo_i    (drpdo_int[127:112]),
    .gt8_drpen_o    (drpen_int[8:8]),
    .gt8_drpwe_o    (drpwe_int[8:8]),
    .gt8_drpaddr_o  (drpaddr_int[89:80]),
    .gt8_drpdi_o    (drpdi_int[143:128]),
    .gt8_drprdy_i   (drprdy_int[8:8]),
    .gt8_drpdo_i    (drpdo_int[143:128]),
    .eyescanreset_o (eyescanreset_int),
    .rxrate_o       (rxrate_int),
    .txdiffctrl_o   (txdiffctrl_int),
    .txprecursor_o  (txprecursor_int),
    .txpostcursor_o (txpostcursor_int),
    .rxlpmen_o      (rxlpmen_int),
    .rxrate_i       ({9{3'b000}}),
    .txdiffctrl_i   ({9{5'b11000}}),
    .txprecursor_i  ({9{5'b00000}}),
    .txpostcursor_i ({9{5'b00000}}),
    .rxlpmen_i      ({9{1'b0}}),
    .rxoutclk_i     ({9{hb0_gtwiz_userclk_rx_usrclk2_int}}),
    .drpclk_i       ({9{hb_gtwiz_reset_clk_freerun_buf_int}}),
    .clk            (hb_gtwiz_reset_clk_freerun_buf_int)
  );


  // ===================================================================================================================
  // EXAMPLE WRAPPER INSTANCE
  // ===================================================================================================================

  // Instantiate the example design wrapper, mapping its enabled ports to per-channel internal signals and example
  // resources as appropriate
  moller_gth_example_wrapper example_wrapper_inst (
    .gthrxn_in                               (gthrxn_int)
   ,.gthrxp_in                               (gthrxp_int)
   ,.gthtxn_out                              (gthtxn_int)
   ,.gthtxp_out                              (gthtxp_int)
   ,.gtwiz_userclk_tx_reset_in               (gtwiz_userclk_tx_reset_int)
   ,.gtwiz_userclk_tx_srcclk_out             (gtwiz_userclk_tx_srcclk_int)
   ,.gtwiz_userclk_tx_usrclk_out             (gtwiz_userclk_tx_usrclk_int)
   ,.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)
   ,.gtwiz_userclk_tx_active_out             (gtwiz_userclk_tx_active_int)
   ,.gtwiz_userclk_rx_reset_in               (gtwiz_userclk_rx_reset_int)
   ,.gtwiz_userclk_rx_srcclk_out             (gtwiz_userclk_rx_srcclk_int)
   ,.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)
   ,.gtwiz_userclk_rx_usrclk2_out            (gtwiz_userclk_rx_usrclk2_int)
   ,.gtwiz_userclk_rx_active_out             (gtwiz_userclk_rx_active_int)
   ,.gtwiz_reset_clk_freerun_in              ({1{hb_gtwiz_reset_clk_freerun_buf_int}})
   ,.gtwiz_reset_all_in                      ({1{hb_gtwiz_reset_all_int}})
   ,.gtwiz_reset_tx_pll_and_datapath_in      (gtwiz_reset_tx_pll_and_datapath_int)
   ,.gtwiz_reset_tx_datapath_in              (gtwiz_reset_tx_datapath_int)
   ,.gtwiz_reset_rx_pll_and_datapath_in      ({1{hb_gtwiz_reset_rx_pll_and_datapath_int}})
   ,.gtwiz_reset_rx_datapath_in              ({1{hb_gtwiz_reset_rx_datapath_int}})
   ,.gtwiz_reset_rx_cdr_stable_out           (gtwiz_reset_rx_cdr_stable_int)
   ,.gtwiz_reset_tx_done_out                 (gtwiz_reset_tx_done_int)
   ,.gtwiz_reset_rx_done_out                 (gtwiz_reset_rx_done_int)
   ,.gtwiz_userdata_tx_in                    (gtwiz_userdata_tx_int)
   ,.gtwiz_userdata_rx_out                   (gtwiz_userdata_rx_int)
   ,.gtrefclk00_in                           (gtrefclk00_int)
   ,.qpll0outclk_out                         (qpll0outclk_int)
   ,.qpll0outrefclk_out                      (qpll0outrefclk_int)
   ,.drpaddr_in                              (drpaddr_int)
   ,.drpclk_in                               (drpclk_int)
   ,.drpdi_in                                (drpdi_int)
   ,.drpen_in                                (drpen_int)
   ,.drpwe_in                                (drpwe_int)
   ,.eyescanreset_in                         (eyescanreset_int)
   ,.rxcdrhold_in                            (rxcdrhold_int)
   ,.rxgearboxslip_in                        (rxgearboxslip_int)
   ,.rxlpmen_in                              (rxlpmen_int)
   ,.rxrate_in                               (rxrate_int)
   ,.txdiffctrl_in                           (txdiffctrl_int)
   ,.txheader_in                             (txheader_int)
   ,.txpostcursor_in                         (txpostcursor_int)
   ,.txprecursor_in                          (txprecursor_int)
   ,.txsequence_in                           (txsequence_int)
   ,.drpdo_out                               (drpdo_int)
   ,.drprdy_out                              (drprdy_int)
   ,.gtpowergood_out                         (gtpowergood_int)
   ,.rxdatavalid_out                         (rxdatavalid_int)
   ,.rxheader_out                            (rxheader_int)
   ,.rxheadervalid_out                       (rxheadervalid_int)
   ,.rxpmaresetdone_out                      (rxpmaresetdone_int)
   ,.rxprgdivresetdone_out                   (rxprgdivresetdone_int)
   ,.rxstartofseq_out                        (rxstartofseq_int)
   ,.txpmaresetdone_out                      (txpmaresetdone_int)
   ,.txprgdivresetdone_out                   (txprgdivresetdone_int)
);


endmodule
