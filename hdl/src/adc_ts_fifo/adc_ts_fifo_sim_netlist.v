// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Mon Apr 18 16:12:38 2022
// Host        : home running 64-bit unknown
// Command     : write_verilog -force -mode funcsim -rename_top adc_ts_fifo -prefix
//               adc_ts_fifo_ adc_ts_fifo_sim_netlist.v
// Design      : adc_ts_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu6cg-ffvc900-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "adc_ts_fifo,fifo_generator_v13_2_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module adc_ts_fifo
   (srst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    valid,
    wr_rst_busy,
    rd_rst_busy);
  input srst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 250000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [63:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [63:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output valid;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [63:0]din;
  wire [63:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rd_rst_busy;
  wire srst;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire wr_rst_busy;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [8:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [8:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [8:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "9" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "64" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "64" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "1" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "1" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "6" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "4" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "0" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "6" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "7" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "511" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "510" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "9" *) 
  (* C_RD_DEPTH = "512" *) 
  (* C_RD_FREQ = "125" *) 
  (* C_RD_PNTR_WIDTH = "9" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "1" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "9" *) 
  (* C_WR_DEPTH = "512" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "250" *) 
  (* C_WR_PNTR_WIDTH = "9" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  adc_ts_fifo_fifo_generator_v13_2_5 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[8:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[8:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(srst),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(valid),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[8:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
SFoQ2tXDMrL2nCJbfpmHXuteJlKaWDWl3o9OY1miFvmYb8EDywmDpLUHQktJ/VoW+17fK5WHgFVI
FZV1B91GDQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
mxGWDRjEAsKmBqldxevT1RKZvqK7vn0KlTODVXNGlRcGf9zOAmj0Z7Ppu79POBDb8oNQyCY+2q1q
BddzhQfh5WLIVX9BNUMIF6M6IF0elM4GMSLHGeYEwqSaMPC+thuR8FGj1J7z6rH+43gDYhtIeyY+
ZuZUz/Pqg8Lu63Xwe+0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HLwPjQzkuqv5FEDBriEJS2DikBeIHB/bWuVWooHY5ChdoHatcmqCHpSvnGxVzLwObZWHFys2nR9y
P3zxywjtgtOWq/n3cYVa5li6eyiUmGXv2OE8nw1nLnAY1kzBvGd6VwQ45t6l4Hx5+oqpIfuU2KI2
7/Qpj2atiTN3Y+q5He/BMXLIxF9vWuU6XL/+HsxriGAumcZDuESdidlxOztbW1bFhYr1/qWwou2q
wynnRVKYHL41aWycgFdkDoDEFFxv8ft8+F5Ux+J5Hg5XdgRULJc6uUQE/lDG3zOqzPftlODB52zU
d0cm8gFOvSZ2nO8ZB8THnxoAGe33iIZJfMcefA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jlR0iZ4fp9QXiFgaT07DMAK1YFLyBpsOGOOR9j2PWImFEh8oTBt4cvmGo+2z1Umbt9OMQwOhyepO
QIsKLFzUXYUba+SFFLBoCiaww24KICecbUfd3VV5sg2bEJjAdtYTT6mJqyc3vQRvBlONeBFdIGy2
AXqdK7QtXGLsLAIF/z4FG8cfG6nSD6e16gccBC6+kl5MoShdnmebKLyoo6UKFdMbDK88sHvTcD9S
LNCau6RK7FkTZg23FV0tf6cTP9Rray9YEcowm2AAh51Wldo2lGJ2W5iiDatRKH/W1bu7FGWZG+OT
+VZE+Ckiuf4T6cuu+G5IbrtMv6a4U93R0gtxXQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
p/kq+JjPPJbOTWT2SRiPJ99/iH6kkVGEiluRRXpuRN+j+cVPgJD1v4QVjw3zMWLlvTGB7OOqC+JG
Lc62Wiizd/BFfGj2JYkTZMatcOWok7A87HK+vRTjr4nZMApD2jKaneJdU1279KsIEeRfImCQ2uRl
QRNMH3PPdNGYCnOGgNk=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kyyI/O29YYc5VBwhz19i7AV7MC75r43hHVKAOTBiGBhRu8zZxCwGGcNFqc2HgHcWC6nq4jCIbIXf
S3FDzPdasegnERlWvoob9/SXM88zKsyeTbUf+DRu5lB8SPROBMaIhnj375C5XLowL17MXZdmB6fV
X5ukCg7cNhCjssKt/bIJibWkfna7hvj4ye+CLWmi3LdEiix8KTwRoBS3ZJrjM4/N6FfZkXerVxs+
txkhdsmG9ga1g/xErhTRilhqrV2WetlpX86qH/64sRGVxrWeEfNoHhMZsqEK0jWDx4WavKt8XY7W
NDzMXLZ2m5Dv5HMiJWgFG+ntPwgiYYtBuwu7Eg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tv6UL1ZWqo3dAIlhN5UTNGzJyqzdHpCqh217JPvIvHiWJgcFh2tw1n7HWnOPcK3VhCt31AGnCEFe
HpTiinXvHna65L2X2HhtNUrsgvZlUuh/oQR273wp5JPFDPD97NQ4ELkGI+w26HTYLgZ70K5rQo87
D4AkQNRuzTRS5G12yb4RU7ZYgmkYLuq1UyqjlxyN62Del4XoqZyivOGw5H+7wlfkNRu98iQwqq12
jthZbH/ue5wxZJUcb7NmEwL+3abpyDNmWs1qORHOFoE3t97/9XMmeSCpM2+KnSKJvsV5VbuoTCOT
964fsEh7ey4IVb4aum095gQjLCqTmDm8DWFmaw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Oxo3AgNmVWgrXtMKDIThYfXr0YJfyFr7Bsjn2ge/G72mb25MA8Dbkd9ZZPtwqU1poazNnTng5Cx5
s8C1zMNEoo38jNY8zEUBjCCuasJgeMo5xsiha+3ZIBiuHS0KLrjLaPFIQZdsYevb44fg6J5YQLn5
jd1M6YdNMd1VwSezDxtbk9sN8ExPrmtwum/6L1ia9j9UlIzPTEaJ60Xz7tloPsgsbkborO2JLiIk
kIAY2q1b8tuhHzJ5DoXlvIo49wSDj75ncLrkwbAd26huob7aOmX1bS34pJLF17JzqYH0MoPJbHxb
RPdD+qUawXFsMSs2fOLnZrNxeG8L+TyAT0N8tQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CIR/vwxo0IBrPr5+bMp2YuBCQTNBRIIbqgEB18Oewkc8CuHzGCAgPyQUBUKaUG3bBy+KDOPVxBP5
cE/d3QYZAT11fyB1OMMTrjmEIZcr0Vk3nVTAnivoxxxkmdzPjkj0OcGcU9fMArPi3dfTgIsKdtCq
94+mV/70WeprgijzuZFWD7uH+gVioY/+rq/Wc1O6x1n949w8YGgSCTurUvhsobx2bonoC317J0Wm
IX17XRkSBIFgzqA8iC+GV5oCfxIGkihKmXxjIJbMamlOdCOycEkjkh3JYmm7TLNxmI65iffsabR0
t5+iI0l8eJxFhElzWeREqE43cnJYLaKZBUA+DA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 55424)
`pragma protect data_block
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
eYyo6VslspQfCrnUUvVzUP86KwA=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
