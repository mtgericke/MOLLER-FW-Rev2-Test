
`timescale 1 ns / 1 ps

	module mollerTI_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 9,

		// Parameters of Axi Slave Bus Interface C2H
		parameter integer C_C2H_TDATA_WIDTH	= 64,

		// Parameters of Axi Master Bus Interface H2C
		parameter integer C_H2C_TDATA_WIDTH	= 64
	)
	(
		// Users to add ports here

		input wire TICLK_P, // Trigger MGT reference clock,  to be consistent with the ip core:
		input wire TICLK_N, //   TI1_x0y14 (MGT_x0Y14 for the FMC test board on zcu106)

		input wire TI1RX_P, // serialized trigger/MGT IOB
		input wire TI1RX_N, // QSFP RxTx(0) connection
		output wire TI1TX_P,
		output wire TI1TX_N,

		input wire TI1SYNCRX_P, // TI_SYNC lvds signals
		input wire TI1SYNCRX_N, // QSFP RxTx(2) connection
		output wire TI1SYNCTX_P,
		output wire TI1SYNCTX_N,

		// input wire TI1FMRX_P,   // TI aux, or FiberMeasurement
		// input wire TI1FMRX_N,   // QSFP RxTx(3) connection
		// output wire TI1FMTX_P,
		// output wire TI1FMTX_N,

		output wire CLKREFO_P, // clk_output from FPGA TI receiver
		output wire CLKREFO_N,

		// FPGA / TI logic clocks
		input wire CLK250,  // system clock related to Clk250, 250MHz
		input wire CLK625,  // system clock related to Clk250, 250MHz/4 = 62.5MHz
		input wire CLKPrg,  // Always available clock, 50 MHz prefered.

		// Decoded trigger/Reset, which can be used in the FPGA
		output wire [16:1] GENOUTP,    // equivalent to the TI front panel (34-pin connector) outputs, and LED signals
		output wire [16:1] TCSOUT,    // Some extra RESET signals

		// Trigger inputs, or TS_code inputs, which is similar to the TI front panel (34-pin connector) inputs
		input wire [16:1] GENINP, // ExtraIn(2:1) & TS(6:1) & Trg & BUSY
		inout wire [8:1] SWM,

		// User ports ends
		// Do not modify the ports beyond this line

		// Ports of Axi Slave Bus Interface S_AXI
		input wire  s_axi_aclk,
		input wire  s_axi_aresetn,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
		input wire [2 : 0] s_axi_awprot,
		input wire  s_axi_awvalid,
		output wire  s_axi_awready,
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
		input wire  s_axi_wvalid,
		output wire  s_axi_wready,
		output wire [1 : 0] s_axi_bresp,
		output wire  s_axi_bvalid,
		input wire  s_axi_bready,
		input wire [9 : 0] s_axi_araddr,
		input wire [2 : 0] s_axi_arprot,
		input wire  s_axi_arvalid,
		output wire  s_axi_arready,
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
		output wire [1 : 0] s_axi_rresp,
		output wire  s_axi_rvalid,
		input wire  s_axi_rready,

		// Ports of Axi Slave Bus Interface H2C
		output wire  h2c_tready,
		input wire [C_H2C_TDATA_WIDTH-1 : 0] h2c_tdata,
		input wire  [7:0] h2c_tkeep,
		input wire  h2c_tlast,
		input wire  h2c_tvalid,

		// Ports of Axi Master Bus Interface C2H
		output wire  c2h_tvalid,
		output wire [C_C2H_TDATA_WIDTH-1 : 0] c2h_tdata,
		output wire  c2h_tlast,
		output wire  [7:0] c2h_tkeep,
		input wire  c2h_tready
	);

	// Add user logic here
	tinode_wrapper imp_tinode_wrapper (
		.TICLK_P(TICLK_P),
		.TICLK_N(TICLK_N),

		.TI1RX_P(TI1RX_P),
		.TI1RX_N(TI1RX_N),
		.TI1TX_P(TI1TX_P),
		.TI1TX_N(TI1TX_N),

		.TI1SYNCRX_P(TI1SYNCRX_P),
		.TI1SYNCRX_N(TI1SYNCRX_N),
		.TI1SYNCTX_P(TI1SYNCTX_P),
		.TI1SYNCTX_N(TI1SYNCTX_N),

		// .TI1FMRX_P(TI1FMRX_P),
		// .TI1FMRX_N(TI1FMRX_N),
		// .TI1FMTX_P(TI1FMTX_P),
		// .TI1FMTX_N(TI1FMTX_N),

		.CLKREFO_P(CLKREFO_P),
		.CLKREFO_N(CLKREFO_N),

		// FPGA / TI logic clocks
		.CLK250(CLK250),
		.CLK625(CLK625),
		.CLKPrg(CLKPrg),

		// Decoded trigger/Reset, which can be used in the FPGA
		.GENOUTP(GENOUTP),
		.TCSOUT(TCSOUT),

		// Trigger inputs, or TS_code inputs, which is similar to the TI front panel (34-pin connector) inputs
		.GENINP(GENINP),
		.SWM(SWM),

		// to interface with PCIe for IRQ
		.axi_aresetn(s_axi_aresetn),
		.usr_irq_req(),
		.usr_irq_ack(),
		.msi_enable(),

		// AXI light interface for register READ/WRITE.  512 Bytes are implemented.  (Addr(12:10) == 000, other bits are not checked)
		.CLKReg(s_axi_aclk),
		.m_axil_awaddr({23'h0, s_axi_awaddr}),
		.m_axil_awprot(s_axi_awprot),
		.m_axil_awvalid(s_axi_awvalid),
		.m_axil_awready(s_axi_awready),
		.m_axil_wdata(s_axi_wdata),
		.m_axil_wstrb(s_axi_wstrb),
		.m_axil_wvalid(s_axi_wvalid),
		.m_axil_wready(s_axi_wready),
		.m_axil_araddr({23'h0,s_axi_araddr}),
		.m_axil_arprot(s_axi_arprot),
		.m_axil_arvalid(s_axi_arvalid),
		.m_axil_arready(s_axi_arready),
		.m_axil_rdata(s_axi_rdata),
		.m_axil_rresp(s_axi_rresp),
		.m_axil_rvalid(s_axi_rvalid),
		.m_axil_rready(s_axi_rready),

		.m_axil_bresp(s_axi_bresp),
		.m_axil_bvalid(s_axi_bvalid),
		.m_axil_bready(s_axi_bready),

		// Streaming interface to xDMA data readout, synced on ClkReg, common clock as the m_axi4_light interface
		// C2H: from FPGA to Computer
		.s_axis_c2h_tdata(c2h_tdata),
		.s_axis_c2h_tlast(c2h_tlast),
		.s_axis_c2h_tvalid(c2h_tvalid),
		.s_axis_c2h_tready(c2h_tready),
		.s_axis_c2h_tkeep(c2h_tkeep),

		// H2C: from compputer to FPGA, not used
		.m_axis_h2c_tdata(h2c_tdata),
		.m_axis_h2c_tlast(h2c_tlast),
		.m_axis_h2c_tvalid(h2c_tvalid),
		.m_axis_h2c_tready(h2c_tready),
		.m_axis_h2c_tkeep(h2c_tkeep)
	);

	// User logic ends

	endmodule
