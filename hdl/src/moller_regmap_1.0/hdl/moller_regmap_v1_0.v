
`timescale 1 ns / 1 ps

	module moller_regmap_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
		input wire [31:0] revision_value,

    	input wire [15:0] [15:0] adc_test_data_bad_pattern_counter, // value of field 'adc_test_data.bad_pattern_counter'
    	input wire [15:0] [15:0] adc_test_data_bad_dco_counter, // value of field 'adc_test_data.bad_dco_counter'

		output wire [15:0] [8:0] adc_load_value, // value of field 'adc_load'
		input wire [15:0] [8:0] adc_delay_value,  // value of field 'adc_delay'

    	input wire [31:0] freq_td_value, // Value of register 'freq_td', field 'value'
    	input wire [31:0] freq_osc_value, // Value of register 'freq_osc', field 'value'
    	input wire [31:0] freq_som0_value, // Value of register 'freq_som0', field 'value'
    	input wire [31:0] freq_som1_value, // Value of register 'freq_som1', field 'value'

		output wire [15:0] stream_ctrl_num_samples, // Value of register 'stream_ctrl', field 'num_samples'
		output wire [3:0] stream_ctrl_ch0, // Value of register 'stream_ctrl', field 'ch_even'
		output wire [3:0] stream_ctrl_ch1, // Value of register 'stream_ctrl', field 'ch_odd'
		output wire [6:0] stream_ctrl_rate_div, // Value of register 'stream_ctrl', field 'rate_div'
		output wire [0:0] stream_ctrl_enable, // Value of register 'stream_ctrl', field 'enable'

		output wire [7:0] adc_ctrl_sample_rate,
    	output wire [15:0] adc_ctrl_ch_disable, // Value of register 'adc_ctrl', field 'ch_disable'
    	output wire [0:0] adc_ctrl_power_down, // Value of register 'adc_ctrl', field 'power_down'
    	output wire [0:0] adc_ctrl_testpattern, // Value of register 'adc_ctrl', field 'testpattern'
    	output wire [0:0] adc_ctrl_ena, // Value of register 'adc_ctrl', field 'ena'

		input wire [0:0] status_clk_lockdetect, // Value of register 'status', field 'clk_lockdetect'
		input wire [0:0] status_clk_holdover, // Value of register 'status', field 'clk_holdover'
		input wire [0:0] status_adc_train_done, // Value of register 'status', field 'adc_train_done'

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);

	// Instantiation of Axi Bus Interface S00_AXI
	moller_regs # (
		.BASEADDR(0),
		.AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) moller_regs_inst (
		.revision_value(revision_value),

    	.adc_test_data_bad_pattern_counter(adc_test_data_bad_pattern_counter),
		.adc_test_data_bad_dco_counter(adc_test_data_bad_dco_counter),

		.adc_delay_in_value(adc_load_value),
		.adc_delay_out_value(adc_delay_value),

    	.freq_td_value(freq_td_value), // Value of register 'freq_td', field 'value'
    	.freq_osc_value(freq_osc_value), // Value of register 'freq_osc', field 'value'
    	.freq_som0_value(freq_som0_value), // Value of register 'freq_som0', field 'value'
    	.freq_som1_value(freq_som1_value), // Value of register 'freq_som1', field 'value'

		.stream_ctrl_num_samples(stream_ctrl_num_samples),
    	.stream_ctrl_ch0(stream_ctrl_ch0),
    	.stream_ctrl_ch1(stream_ctrl_ch1),
    	.stream_ctrl_rate_div(stream_ctrl_rate_div),
    	.stream_ctrl_enable(stream_ctrl_enable),

		.adc_ctrl_sample_rate(adc_ctrl_sample_rate),
    	.adc_ctrl_ch_disable(adc_ctrl_ch_disable), // Value of register 'adc_ctrl', field 'ch_disable'
    	.adc_ctrl_power_down(adc_ctrl_power_down), // Value of register 'adc_ctrl', field 'power_down'
    	.adc_ctrl_testpattern(adc_ctrl_testpattern), // Value of register 'adc_ctrl', field 'testpattern'
    	.adc_ctrl_ena(adc_ctrl_ena), // Value of register 'adc_ctrl', field 'ena'

		.status_clk_lockdetect(status_clk_lockdetect), // Value of register 'status', field 'clk_lockdetect'
		.status_clk_holdover(status_clk_holdover), // Value of register 'status', field 'clk_holdover'
		.status_adc_train_done(status_adc_train_done), // Value of register 'status', field 'adc_train_done'

		.axi_aclk(s00_axi_aclk),
		.axi_aresetn(s00_axi_aresetn),
		.s_axi_awaddr(s00_axi_awaddr),
		.s_axi_awprot(s00_axi_awprot),
		.s_axi_awvalid(s00_axi_awvalid),
		.s_axi_awready(s00_axi_awready),
		.s_axi_wdata(s00_axi_wdata),
		.s_axi_wstrb(s00_axi_wstrb),
		.s_axi_wvalid(s00_axi_wvalid),
		.s_axi_wready(s00_axi_wready),
		.s_axi_bresp(s00_axi_bresp),
		.s_axi_bvalid(s00_axi_bvalid),
		.s_axi_bready(s00_axi_bready),
		.s_axi_araddr(s00_axi_araddr),
		.s_axi_arprot(s00_axi_arprot),
		.s_axi_arvalid(s00_axi_arvalid),
		.s_axi_arready(s00_axi_arready),
		.s_axi_rdata(s00_axi_rdata),
		.s_axi_rresp(s00_axi_rresp),
		.s_axi_rvalid(s00_axi_rvalid),
		.s_axi_rready(s00_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
