//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
//Date        : Thu Nov 16 10:07:56 2023
//Host        : home running 64-bit unknown
//Command     : generate_target Mercury_XU1_wrapper.bd
//Design      : Mercury_XU1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Mercury_XU1_wrapper
   (CLK250,
    CLK625,
    CLKPrg,
    CLKREFO_N,
    CLKREFO_P,
    GENINP,
    GENOUTP,
    SWM,
    TCSOUT,
    TI1RX_N,
    TI1RX_P,
    TI1SYNCRX_N,
    TI1SYNCRX_P,
    TI1SYNCTX_N,
    TI1SYNCTX_P,
    TI1TX_N,
    TI1TX_P,
    TICLK_N,
    TICLK_P,
    adc_ctrl_ch_disable,
    adc_ctrl_clear_counters,
    adc_ctrl_ena,
    adc_ctrl_power_down,
    adc_ctrl_sample_rate,
    adc_ctrl_testpattern,
    adc_delay_value,
    adc_fifo_tdata,
    adc_fifo_tlast,
    adc_fifo_tready,
    adc_fifo_tvalid,
    adc_load_value,
    adc_test_data_bad_dco_counter,
    adc_test_data_bad_pattern_counter,
    clk_125,
    freq_osc_value,
    freq_som0_value,
    freq_som1_value,
    freq_td_value,
    revision_value,
    rst_125_n,
    run_fifo_tdata,
    run_fifo_tlast,
    run_fifo_tready,
    run_fifo_tvalid,
    sfp_data_refclk_clk_n,
    sfp_data_refclk_clk_p,
    sfp_data_rx_gt_port_0_n,
    sfp_data_rx_gt_port_0_p,
    sfp_data_tx_gt_port_0_n,
    sfp_data_tx_gt_port_0_p,
    sfp_reset,
    soc_in_reset,
    status_adc_train_done,
    status_clk_holdover,
    status_clk_lockdetect,
    stream_ctrl_ch0,
    stream_ctrl_ch1,
    stream_ctrl_enable,
    stream_ctrl_num_samples,
    stream_ctrl_rate_div,
    udp_tx_ack,
    udp_tx_clk,
    udp_tx_cts,
    udp_tx_data,
    udp_tx_data_valid,
    udp_tx_dest_ipv4_6n,
    udp_tx_eof,
    udp_tx_nak,
    udp_tx_sof);
  input CLK250;
  input CLK625;
  input CLKPrg;
  output CLKREFO_N;
  output CLKREFO_P;
  input [16:1]GENINP;
  output [16:1]GENOUTP;
  inout [8:1]SWM;
  output [16:1]TCSOUT;
  input TI1RX_N;
  input TI1RX_P;
  input TI1SYNCRX_N;
  input TI1SYNCRX_P;
  output TI1SYNCTX_N;
  output TI1SYNCTX_P;
  output TI1TX_N;
  output TI1TX_P;
  input TICLK_N;
  input TICLK_P;
  output [15:0]adc_ctrl_ch_disable;
  output [0:0]adc_ctrl_clear_counters;
  output [0:0]adc_ctrl_ena;
  output [0:0]adc_ctrl_power_down;
  output [7:0]adc_ctrl_sample_rate;
  output [0:0]adc_ctrl_testpattern;
  input [143:0]adc_delay_value;
  input [63:0]adc_fifo_tdata;
  input adc_fifo_tlast;
  output adc_fifo_tready;
  input adc_fifo_tvalid;
  output [143:0]adc_load_value;
  input [255:0]adc_test_data_bad_dco_counter;
  input [255:0]adc_test_data_bad_pattern_counter;
  input clk_125;
  input [31:0]freq_osc_value;
  input [31:0]freq_som0_value;
  input [31:0]freq_som1_value;
  input [31:0]freq_td_value;
  input [31:0]revision_value;
  input rst_125_n;
  input [63:0]run_fifo_tdata;
  input run_fifo_tlast;
  output run_fifo_tready;
  input run_fifo_tvalid;
  input sfp_data_refclk_clk_n;
  input sfp_data_refclk_clk_p;
  input sfp_data_rx_gt_port_0_n;
  input sfp_data_rx_gt_port_0_p;
  output sfp_data_tx_gt_port_0_n;
  output sfp_data_tx_gt_port_0_p;
  input sfp_reset;
  output soc_in_reset;
  input [0:0]status_adc_train_done;
  input [0:0]status_clk_holdover;
  input [0:0]status_clk_lockdetect;
  output [3:0]stream_ctrl_ch0;
  output [3:0]stream_ctrl_ch1;
  output [0:0]stream_ctrl_enable;
  output [15:0]stream_ctrl_num_samples;
  output [6:0]stream_ctrl_rate_div;
  output udp_tx_ack;
  output udp_tx_clk;
  output udp_tx_cts;
  input [63:0]udp_tx_data;
  input [7:0]udp_tx_data_valid;
  input udp_tx_dest_ipv4_6n;
  input udp_tx_eof;
  output udp_tx_nak;
  input udp_tx_sof;

  wire CLK250;
  wire CLK625;
  wire CLKPrg;
  wire CLKREFO_N;
  wire CLKREFO_P;
  wire [16:1]GENINP;
  wire [16:1]GENOUTP;
  wire [8:1]SWM;
  wire [16:1]TCSOUT;
  wire TI1RX_N;
  wire TI1RX_P;
  wire TI1SYNCRX_N;
  wire TI1SYNCRX_P;
  wire TI1SYNCTX_N;
  wire TI1SYNCTX_P;
  wire TI1TX_N;
  wire TI1TX_P;
  wire TICLK_N;
  wire TICLK_P;
  wire [15:0]adc_ctrl_ch_disable;
  wire [0:0]adc_ctrl_clear_counters;
  wire [0:0]adc_ctrl_ena;
  wire [0:0]adc_ctrl_power_down;
  wire [7:0]adc_ctrl_sample_rate;
  wire [0:0]adc_ctrl_testpattern;
  wire [143:0]adc_delay_value;
  wire [63:0]adc_fifo_tdata;
  wire adc_fifo_tlast;
  wire adc_fifo_tready;
  wire adc_fifo_tvalid;
  wire [143:0]adc_load_value;
  wire [255:0]adc_test_data_bad_dco_counter;
  wire [255:0]adc_test_data_bad_pattern_counter;
  wire clk_125;
  wire [31:0]freq_osc_value;
  wire [31:0]freq_som0_value;
  wire [31:0]freq_som1_value;
  wire [31:0]freq_td_value;
  wire [31:0]revision_value;
  wire rst_125_n;
  wire [63:0]run_fifo_tdata;
  wire run_fifo_tlast;
  wire run_fifo_tready;
  wire run_fifo_tvalid;
  wire sfp_data_refclk_clk_n;
  wire sfp_data_refclk_clk_p;
  wire sfp_data_rx_gt_port_0_n;
  wire sfp_data_rx_gt_port_0_p;
  wire sfp_data_tx_gt_port_0_n;
  wire sfp_data_tx_gt_port_0_p;
  wire sfp_reset;
  wire soc_in_reset;
  wire [0:0]status_adc_train_done;
  wire [0:0]status_clk_holdover;
  wire [0:0]status_clk_lockdetect;
  wire [3:0]stream_ctrl_ch0;
  wire [3:0]stream_ctrl_ch1;
  wire [0:0]stream_ctrl_enable;
  wire [15:0]stream_ctrl_num_samples;
  wire [6:0]stream_ctrl_rate_div;
  wire udp_tx_ack;
  wire udp_tx_clk;
  wire udp_tx_cts;
  wire [63:0]udp_tx_data;
  wire [7:0]udp_tx_data_valid;
  wire udp_tx_dest_ipv4_6n;
  wire udp_tx_eof;
  wire udp_tx_nak;
  wire udp_tx_sof;

  Mercury_XU1 Mercury_XU1_i
       (.CLK250(CLK250),
        .CLK625(CLK625),
        .CLKPrg(CLKPrg),
        .CLKREFO_N(CLKREFO_N),
        .CLKREFO_P(CLKREFO_P),
        .GENINP(GENINP),
        .GENOUTP(GENOUTP),
        .SWM(SWM),
        .TCSOUT(TCSOUT),
        .TI1RX_N(TI1RX_N),
        .TI1RX_P(TI1RX_P),
        .TI1SYNCRX_N(TI1SYNCRX_N),
        .TI1SYNCRX_P(TI1SYNCRX_P),
        .TI1SYNCTX_N(TI1SYNCTX_N),
        .TI1SYNCTX_P(TI1SYNCTX_P),
        .TI1TX_N(TI1TX_N),
        .TI1TX_P(TI1TX_P),
        .TICLK_N(TICLK_N),
        .TICLK_P(TICLK_P),
        .adc_ctrl_ch_disable(adc_ctrl_ch_disable),
        .adc_ctrl_clear_counters(adc_ctrl_clear_counters),
        .adc_ctrl_ena(adc_ctrl_ena),
        .adc_ctrl_power_down(adc_ctrl_power_down),
        .adc_ctrl_sample_rate(adc_ctrl_sample_rate),
        .adc_ctrl_testpattern(adc_ctrl_testpattern),
        .adc_delay_value(adc_delay_value),
        .adc_fifo_tdata(adc_fifo_tdata),
        .adc_fifo_tlast(adc_fifo_tlast),
        .adc_fifo_tready(adc_fifo_tready),
        .adc_fifo_tvalid(adc_fifo_tvalid),
        .adc_load_value(adc_load_value),
        .adc_test_data_bad_dco_counter(adc_test_data_bad_dco_counter),
        .adc_test_data_bad_pattern_counter(adc_test_data_bad_pattern_counter),
        .clk_125(clk_125),
        .freq_osc_value(freq_osc_value),
        .freq_som0_value(freq_som0_value),
        .freq_som1_value(freq_som1_value),
        .freq_td_value(freq_td_value),
        .revision_value(revision_value),
        .rst_125_n(rst_125_n),
        .run_fifo_tdata(run_fifo_tdata),
        .run_fifo_tlast(run_fifo_tlast),
        .run_fifo_tready(run_fifo_tready),
        .run_fifo_tvalid(run_fifo_tvalid),
        .sfp_data_refclk_clk_n(sfp_data_refclk_clk_n),
        .sfp_data_refclk_clk_p(sfp_data_refclk_clk_p),
        .sfp_data_rx_gt_port_0_n(sfp_data_rx_gt_port_0_n),
        .sfp_data_rx_gt_port_0_p(sfp_data_rx_gt_port_0_p),
        .sfp_data_tx_gt_port_0_n(sfp_data_tx_gt_port_0_n),
        .sfp_data_tx_gt_port_0_p(sfp_data_tx_gt_port_0_p),
        .sfp_reset(sfp_reset),
        .soc_in_reset(soc_in_reset),
        .status_adc_train_done(status_adc_train_done),
        .status_clk_holdover(status_clk_holdover),
        .status_clk_lockdetect(status_clk_lockdetect),
        .stream_ctrl_ch0(stream_ctrl_ch0),
        .stream_ctrl_ch1(stream_ctrl_ch1),
        .stream_ctrl_enable(stream_ctrl_enable),
        .stream_ctrl_num_samples(stream_ctrl_num_samples),
        .stream_ctrl_rate_div(stream_ctrl_rate_div),
        .udp_tx_ack(udp_tx_ack),
        .udp_tx_clk(udp_tx_clk),
        .udp_tx_cts(udp_tx_cts),
        .udp_tx_data(udp_tx_data),
        .udp_tx_data_valid(udp_tx_data_valid),
        .udp_tx_dest_ipv4_6n(udp_tx_dest_ipv4_6n),
        .udp_tx_eof(udp_tx_eof),
        .udp_tx_nak(udp_tx_nak),
        .udp_tx_sof(udp_tx_sof));
endmodule
