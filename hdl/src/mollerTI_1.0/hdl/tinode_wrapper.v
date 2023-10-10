module tinode_wrapper (
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
    inout wire [6:1] SWM,

    // to interface with PCIe for IRQ
    input wire axi_aresetn, // out axi_aresetn, synced with axi_aclk for axi interfaces reset
    output wire [3:0] usr_irq_req, // Interrupt(3 downto 0),
    output wire [3:0] usr_irq_ack, // PcieInterrupt_Ackd,
    output wire msi_enable, //    => Interrupt(15),

    // AXI light interface for register READ/WRITE.  512 Bytes are implemented.  (Addr(12:10) == 000, other bits are not checked)
    input wire CLKReg,
    input wire [31:0] m_axil_awaddr,    // This signal is the address for a memory mapped write to the user logic from the HOST
    input wire [2:0] m_axil_awprot,     // 3'h0
    input wire m_axil_awvalid,          // the assertion of this signal means there is a valid write request to the address on m_axi_aWaddr
    output wire m_axil_awready,         // Master write address ready
    input wire [31:0] m_axil_wdata,     // master write data
    input wire [3:0] m_axil_wstrb,      // master write strobe
    input wire m_axil_wvalid,           // master write valid
    output wire m_axil_wready,          // master write ready
    input wire [31:0] m_axil_araddr,    // THis signal is the address for a memory mapped read to user logic from the host
    input wire [2:0] m_axil_arprot,     // 3'h0
    input wire m_axil_arvalid,          // the assertion of this signal means there is a valid read request to the address on m_axil_araddr
    output wire m_axil_arready,         // master read address ready
    output wire [31:0] m_axil_rdata,    // master read data
    output wire [1:0] m_axil_rresp,     // master read response
    output wire m_axil_rvalid,          // master read valid
    input wire m_axil_rready,           // master  read ready

	output wire [1 : 0] m_axil_bresp,
	output wire  m_axil_bvalid,
	input wire   m_axil_bready,

    // Streaming interface to xDMA data readout, synced on ClkReg, common clock as the m_axi4_light interface
    // C2H: from FPGA to Computer
    output wire [63:0] s_axis_c2h_tdata,    // transmit data from the user logic to the DMA
    output wire s_axis_c2h_tlast,           // The user logic asserts this signal to indicate the end of the DMA packet
    output wire s_axis_c2h_tvalid,          // The user logic asserts this whenever it is driving valid data on s_axis_c2h_tdata
    input wire s_axis_c2h_tready,           // DMA is ready to accept data.  If the DMA deassert this when the valid is high,
                                            // the user logic must keep the valid signal asserted until the ready signal is asserted.
    output wire [7:0] s_axis_c2h_tkeep,     // Bytes to keep, should be all 1s except the last word, where the 1s are LSB aligned

    // H2C: from compputer to FPGA, not used
    input wire [63:0] m_axis_h2c_tdata,     // Transmit data from the DMA to the user logic
    input wire m_axis_h2c_tlast,            // DMA asserts this siganl in the last beat of the DMApacket to indicate the end of the packet
    input wire m_axis_h2c_tvalid,           // The DMA asserts this whenever it is driving valid data on axis_h2c_tdata
    output wire m_axis_h2c_tready,          // Assertion of this signal by user logic indicates that it is ready to accept data. If the user logic deasserts the signal
                                            // when the valid signal is high, the DMA keeps the valid signal asserted until the ready signal is asserted.
    input wire [7:0] m_axis_h2c_tkeep       // Bytes to keep, should be all 1s except the last word, where the 1s are LSB aligned
);

TInode imp_TInode(
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
    .axi_aresetn(axi_aresetn),
    .usr_irq_req(usr_irq_req),
    .usr_irq_ack(usr_irq_ack),
    .msi_enable(msi_enable),

    // AXI light interface for register READ/WRITE.  512 Bytes are implemented.  (Addr(12:10) == 000, other bits are not checked)
    .CLKReg(CLKReg),
    .m_axil_awaddr(m_axil_awaddr),
    .m_axil_awprot(m_axil_awprot),
    .m_axil_awvalid(m_axil_awvalid),
    .m_axil_awready(m_axil_awready),
    .m_axil_wdata(m_axil_wdata),
    .m_axil_wstrb(m_axil_wstrb),
    .m_axil_wvalid(m_axil_wvalid),
    .m_axil_wready(m_axil_wready),
    .m_axil_araddr(m_axil_araddr),
    .m_axil_arprot(m_axil_arprot),
    .m_axil_arvalid(m_axil_arvalid),
    .m_axil_arready(m_axil_arready),
    .m_axil_rdata(m_axil_rdata),
    .m_axil_rresp(m_axil_rresp),
    .m_axil_rvalid(m_axil_rvalid),
    .m_axil_rready(m_axil_rready),

	.m_axil_bresp(m_axil_bresp),
	.m_axil_bvalid(m_axil_bvalid),
	.m_axil_bready(m_axil_bready),

    // Streaming interface to xDMA data readout, synced on ClkReg, common clock as the m_axi4_light interface
    // C2H: from FPGA to Computer
    .s_axis_c2h_tdata(s_axis_c2h_tdata),
    .s_axis_c2h_tlast(s_axis_c2h_tlast),
    .s_axis_c2h_tvalid(s_axis_c2h_tvalid),
    .s_axis_c2h_tready(s_axis_c2h_tready),
    .s_axis_c2h_tkeep(s_axis_c2h_tkeep),

    // H2C: from compputer to FPGA, not used
    .m_axis_h2c_tdata(m_axis_h2c_tdata),
    .m_axis_h2c_tlast(m_axis_h2c_tlast),
    .m_axis_h2c_tvalid(m_axis_h2c_tvalid),
    .m_axis_h2c_tready(m_axis_h2c_tready),
    .m_axis_h2c_tkeep(m_axis_h2c_tkeep)
);

endmodule