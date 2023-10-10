// -------------------------------------------------------------------------------------------------
// 'moller' Register Component
// Revision: 249
// -------------------------------------------------------------------------------------------------
// Generated on 2023-08-30 at 20:53 (UTC) by airhdl version 2023.07.1-936312266
// -------------------------------------------------------------------------------------------------
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// -------------------------------------------------------------------------------------------------

`default_nettype none

module moller_regs #(
    parameter AXI_ADDR_WIDTH = 32, // width of the AXI address bus
    parameter logic [31:0] BASEADDR = 32'h80010000 // the register file's system base address
    ) (
    // Clock and Reset
    input  wire                      axi_aclk,
    input  wire                      axi_aresetn,

    // AXI Write Address Channel
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire [2:0]                s_axi_awprot,
    input  wire                      s_axi_awvalid,
    output wire                      s_axi_awready,

    // AXI Write Data Channel
    input  wire [31:0]               s_axi_wdata,
    input  wire [3:0]                s_axi_wstrb,
    input  wire                      s_axi_wvalid,
    output wire                      s_axi_wready,

    // AXI Read Address Channel
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire [2:0]                s_axi_arprot,
    input  wire                      s_axi_arvalid,
    output wire                      s_axi_arready,

    // AXI Read Data Channel
    output wire [31:0]               s_axi_rdata,
    output wire [1:0]                s_axi_rresp,
    output wire                      s_axi_rvalid,
    input  wire                      s_axi_rready,

    // AXI Write Response Channel
    output wire [1:0]                s_axi_bresp,
    output wire                      s_axi_bvalid,
    input  wire                      s_axi_bready,

    // User Ports
    output wire [15:0] adc_test_data_strobe, // strobe signal for register 'adc_test_data' (pulsed when the register is read from the bus)
    input wire [15:0] [15:0] adc_test_data_bad_pattern_counter, // value of field 'adc_test_data.bad_pattern_counter'
    input wire [15:0] [15:0] adc_test_data_bad_dco_counter, // value of field 'adc_test_data.bad_dco_counter'
    output wire revision_strobe, // strobe signal for register 'revision' (pulsed when the register is read from the bus)
    input wire [31:0] revision_value, // value of field 'revision.value'
    output wire stream_ctrl_strobe, // strobe signal for register 'stream_ctrl' (pulsed when the register is written from the bus)
    output wire [15:0] stream_ctrl_num_samples, // value of field 'stream_ctrl.num_samples'
    output wire [3:0] stream_ctrl_ch0, // value of field 'stream_ctrl.ch0'
    output wire [3:0] stream_ctrl_ch1, // value of field 'stream_ctrl.ch1'
    output wire [6:0] stream_ctrl_rate_div, // value of field 'stream_ctrl.rate_div'
    output wire [0:0] stream_ctrl_enable, // value of field 'stream_ctrl.enable'
    output wire adc_ctrl_strobe, // strobe signal for register 'adc_ctrl' (pulsed when the register is written from the bus)
    output wire [15:0] adc_ctrl_ch_disable, // value of field 'adc_ctrl.ch_disable'
    output wire [7:0] adc_ctrl_sample_rate, // value of field 'adc_ctrl.sample_rate'
    output wire [0:0] adc_ctrl_power_down, // value of field 'adc_ctrl.power_down'
    output wire [0:0] adc_ctrl_testpattern, // value of field 'adc_ctrl.testpattern'
    output wire [0:0] adc_ctrl_ena, // value of field 'adc_ctrl.ena'
    output wire freq_td_strobe, // strobe signal for register 'freq_td' (pulsed when the register is read from the bus)
    input wire [31:0] freq_td_value, // value of field 'freq_td.value'
    output wire freq_osc_strobe, // strobe signal for register 'freq_osc' (pulsed when the register is read from the bus)
    input wire [31:0] freq_osc_value, // value of field 'freq_osc.value'
    output wire freq_som0_strobe, // strobe signal for register 'freq_som0' (pulsed when the register is read from the bus)
    input wire [31:0] freq_som0_value, // value of field 'freq_som0.value'
    output wire freq_som1_strobe, // strobe signal for register 'freq_som1' (pulsed when the register is read from the bus)
    input wire [31:0] freq_som1_value, // value of field 'freq_som1.value'
    output wire status_strobe, // strobe signal for register 'status' (pulsed when the register is read from the bus)
    input wire [0:0] status_clk_lockdetect, // value of field 'status.clk_lockdetect'
    input wire [0:0] status_clk_holdover, // value of field 'status.clk_holdover'
    input wire [0:0] status_adc_train_done, // value of field 'status.adc_train_done'
    output wire [15:0] adc_delay_in_strobe, // strobe signal for register 'adc_delay_in' (pulsed when the register is written from the bus)
    output wire [15:0] [8:0] adc_delay_in_value, // value of field 'adc_delay_in.value'
    output wire [15:0] adc_delay_out_strobe, // strobe signal for register 'adc_delay_out' (pulsed when the register is read from the bus)
    input wire [15:0] [8:0] adc_delay_out_value // value of field 'adc_delay_out.value'
    );

    // Constants
    localparam logic [1:0] AXI_OKAY   = 2'b00;
    localparam logic [1:0] AXI_SLVERR = 2'b10;

    // Registered signals
    logic                           s_axi_awready_r;
    logic                           s_axi_wready_r;
    logic [$bits(s_axi_awaddr)-1:0] s_axi_awaddr_reg_r;
    logic                           s_axi_bvalid_r;
    logic [$bits(s_axi_bresp)-1:0]  s_axi_bresp_r;
    logic                           s_axi_arready_r;
    logic [$bits(s_axi_araddr)-1:0] s_axi_araddr_reg_r;
    logic                           s_axi_rvalid_r;
    logic [$bits(s_axi_rresp)-1:0]  s_axi_rresp_r;
    logic [$bits(s_axi_wdata)-1:0]  s_axi_wdata_reg_r;
    logic [$bits(s_axi_wstrb)-1:0]  s_axi_wstrb_reg_r;
    logic [$bits(s_axi_rdata)-1:0]  s_axi_rdata_r;

    // User-defined registers
    logic [15:0] s_adc_test_data_strobe_r;
    logic [15:0] [15:0] s_reg_adc_test_data_bad_pattern_counter;
    logic [15:0] [15:0] s_reg_adc_test_data_bad_dco_counter;
    logic s_revision_strobe_r;
    logic [31:0] s_reg_revision_value;
    logic s_stream_ctrl_strobe_r;
    logic [15:0] s_reg_stream_ctrl_num_samples_r;
    logic [3:0] s_reg_stream_ctrl_ch0_r;
    logic [3:0] s_reg_stream_ctrl_ch1_r;
    logic [6:0] s_reg_stream_ctrl_rate_div_r;
    logic [0:0] s_reg_stream_ctrl_enable_r;
    logic s_adc_ctrl_strobe_r;
    logic [15:0] s_reg_adc_ctrl_ch_disable_r;
    logic [7:0] s_reg_adc_ctrl_sample_rate_r;
    logic [0:0] s_reg_adc_ctrl_power_down_r;
    logic [0:0] s_reg_adc_ctrl_testpattern_r;
    logic [0:0] s_reg_adc_ctrl_ena_r;
    logic s_freq_td_strobe_r;
    logic [31:0] s_reg_freq_td_value;
    logic s_freq_osc_strobe_r;
    logic [31:0] s_reg_freq_osc_value;
    logic s_freq_som0_strobe_r;
    logic [31:0] s_reg_freq_som0_value;
    logic s_freq_som1_strobe_r;
    logic [31:0] s_reg_freq_som1_value;
    logic s_status_strobe_r;
    logic [0:0] s_reg_status_clk_lockdetect;
    logic [0:0] s_reg_status_clk_holdover;
    logic [0:0] s_reg_status_adc_train_done;
    logic [15:0] s_adc_delay_in_strobe_r;
    logic [15:0] [8:0] s_reg_adc_delay_in_value_r;
    logic [15:0] s_adc_delay_out_strobe_r;
    logic [15:0] [8:0] s_reg_adc_delay_out_value;

    //----------------------------------------------------------------------------------------------
    // Inputs
    //----------------------------------------------------------------------------------------------

    assign s_reg_adc_test_data_bad_pattern_counter = adc_test_data_bad_pattern_counter;
    assign s_reg_adc_test_data_bad_dco_counter = adc_test_data_bad_dco_counter;
    assign s_reg_revision_value = revision_value;
    assign s_reg_freq_td_value = freq_td_value;
    assign s_reg_freq_osc_value = freq_osc_value;
    assign s_reg_freq_som0_value = freq_som0_value;
    assign s_reg_freq_som1_value = freq_som1_value;
    assign s_reg_status_clk_lockdetect = status_clk_lockdetect;
    assign s_reg_status_clk_holdover = status_clk_holdover;
    assign s_reg_status_adc_train_done = status_adc_train_done;
    assign s_reg_adc_delay_out_value = adc_delay_out_value;

    //----------------------------------------------------------------------------------------------
    // Read-transaction FSM
    //----------------------------------------------------------------------------------------------

    localparam MAX_MEMORY_LATENCY = 5;

    typedef enum {
        READ_IDLE,
        READ_REGISTER,
        WAIT_MEMORY_RDATA,
        READ_RESPONSE,
        READ_DONE
    } read_state_t;

    always_ff@(posedge axi_aclk or negedge axi_aresetn) begin: read_fsm
        // Registered state variables
        read_state_t v_state_r;
        logic [31:0] v_rdata_r;
        logic [1:0] v_rresp_r;
        logic [$clog2(MAX_MEMORY_LATENCY)-1:0] v_mem_wait_count_r;
        // Combinatorial helper variables
        logic v_addr_hit;
        logic [AXI_ADDR_WIDTH-1:0] v_mem_addr;
        if (~axi_aresetn) begin
            v_state_r          <= READ_IDLE;
            v_rdata_r          <= '0;
            v_rresp_r          <= '0;
            v_mem_wait_count_r <= '0;
            s_axi_arready_r    <= '0;
            s_axi_rvalid_r     <= '0;
            s_axi_rresp_r      <= '0;
            s_axi_araddr_reg_r <= '0;
            s_axi_rdata_r      <= '0;
            s_adc_test_data_strobe_r <= '0;
            s_revision_strobe_r <= '0;
            s_freq_td_strobe_r <= '0;
            s_freq_osc_strobe_r <= '0;
            s_freq_som0_strobe_r <= '0;
            s_freq_som1_strobe_r <= '0;
            s_status_strobe_r <= '0;
            s_adc_delay_out_strobe_r <= '0;
        end else begin
            // Default values:
            s_axi_arready_r <= 1'b0;
            s_adc_test_data_strobe_r <= '0;
            s_revision_strobe_r <= '0;
            s_freq_td_strobe_r <= '0;
            s_freq_osc_strobe_r <= '0;
            s_freq_som0_strobe_r <= '0;
            s_freq_som1_strobe_r <= '0;
            s_status_strobe_r <= '0;
            s_adc_delay_out_strobe_r <= '0;

            case (v_state_r) // sigasi @suppress "Default clause missing from case statement"

                // Wait for the start of a read transaction, which is
                // initiated by the assertion of ARVALID
                READ_IDLE: begin
                    if (s_axi_arvalid) begin
                        s_axi_araddr_reg_r <= s_axi_araddr;     // save the read address
                        s_axi_arready_r    <= 1'b1;             // acknowledge the read-address
                        v_state_r          <= READ_REGISTER;
                    end
                end

                // Read from the actual storage element
                READ_REGISTER: begin
                    // Defaults:
                    v_addr_hit = 1'b0;
                    v_rdata_r  <= '0;

                    // Register array 'adc_test_data' at address offset 0x0
                    for (int i = 0; i < 16; i++) begin
                        if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::ADC_TEST_DATA_OFFSET[AXI_ADDR_WIDTH-1:2] + (AXI_ADDR_WIDTH-2)'(i * 1)) begin
                            v_addr_hit = 1'b1;
                            v_rdata_r[15:0] <= s_reg_adc_test_data_bad_pattern_counter[i];
                            v_rdata_r[31:16] <= s_reg_adc_test_data_bad_dco_counter[i];
                            s_adc_test_data_strobe_r[i] <= 1'b1;
                            v_state_r <= READ_RESPONSE;
                        end
                    end
                    // Register 'revision' at address offset 0x40
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::REVISION_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[31:0] <= s_reg_revision_value;
                        s_revision_strobe_r <= 1'b1;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'stream_ctrl' at address offset 0x44
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::STREAM_CTRL_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[15:0] <= s_reg_stream_ctrl_num_samples_r;
                        v_rdata_r[19:16] <= s_reg_stream_ctrl_ch0_r;
                        v_rdata_r[23:20] <= s_reg_stream_ctrl_ch1_r;
                        v_rdata_r[30:24] <= s_reg_stream_ctrl_rate_div_r;
                        v_rdata_r[31:31] <= s_reg_stream_ctrl_enable_r;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'adc_ctrl' at address offset 0x48
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::ADC_CTRL_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[15:0] <= s_reg_adc_ctrl_ch_disable_r;
                        v_rdata_r[23:16] <= s_reg_adc_ctrl_sample_rate_r;
                        v_rdata_r[29:29] <= s_reg_adc_ctrl_power_down_r;
                        v_rdata_r[30:30] <= s_reg_adc_ctrl_testpattern_r;
                        v_rdata_r[31:31] <= s_reg_adc_ctrl_ena_r;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'freq_td' at address offset 0x4C
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::FREQ_TD_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[31:0] <= s_reg_freq_td_value;
                        s_freq_td_strobe_r <= 1'b1;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'freq_osc' at address offset 0x50
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::FREQ_OSC_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[31:0] <= s_reg_freq_osc_value;
                        s_freq_osc_strobe_r <= 1'b1;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'freq_som0' at address offset 0x54
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::FREQ_SOM0_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[31:0] <= s_reg_freq_som0_value;
                        s_freq_som0_strobe_r <= 1'b1;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'freq_som1' at address offset 0x58
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::FREQ_SOM1_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[31:0] <= s_reg_freq_som1_value;
                        s_freq_som1_strobe_r <= 1'b1;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register 'status' at address offset 0x5C
                    if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::STATUS_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        v_rdata_r[0:0] <= s_reg_status_clk_lockdetect;
                        v_rdata_r[1:1] <= s_reg_status_clk_holdover;
                        v_rdata_r[2:2] <= s_reg_status_adc_train_done;
                        s_status_strobe_r <= 1'b1;
                        v_state_r <= READ_RESPONSE;
                    end
                    // Register array 'adc_delay_in' at address offset 0x60
                    for (int i = 0; i < 16; i++) begin
                        if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::ADC_DELAY_IN_OFFSET[AXI_ADDR_WIDTH-1:2] + (AXI_ADDR_WIDTH-2)'(i * 1)) begin
                            v_addr_hit = 1'b1;
                            v_rdata_r[8:0] <= s_reg_adc_delay_in_value_r[i];
                            v_state_r <= READ_RESPONSE;
                        end
                    end
                    // Register array 'adc_delay_out' at address offset 0xA0
                    for (int i = 0; i < 16; i++) begin
                        if (s_axi_araddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::ADC_DELAY_OUT_OFFSET[AXI_ADDR_WIDTH-1:2] + (AXI_ADDR_WIDTH-2)'(i * 1)) begin
                            v_addr_hit = 1'b1;
                            v_rdata_r[8:0] <= s_reg_adc_delay_out_value[i];
                            s_adc_delay_out_strobe_r[i] <= 1'b1;
                            v_state_r <= READ_RESPONSE;
                        end
                    end
                    if (v_addr_hit) begin
                        v_rresp_r <= AXI_OKAY;
                    end else begin
                        v_rresp_r <= AXI_SLVERR;
                        // pragma translate_off
                        $warning("ARADDR decode error");
                        // pragma translate_on
                        v_state_r <= READ_RESPONSE;
                    end
                end

                // Wait for memory read data
                WAIT_MEMORY_RDATA: begin
                    if (v_mem_wait_count_r == 0) begin
                        v_state_r <= READ_RESPONSE;
                    end else begin
                        v_mem_wait_count_r <= v_mem_wait_count_r - 1;
                    end
                end

                // Generate read response
                READ_RESPONSE: begin
                    s_axi_rvalid_r <= 1'b1;
                    s_axi_rresp_r  <= v_rresp_r;
                    s_axi_rdata_r  <= v_rdata_r;
                    v_state_r      <= READ_DONE;
                end

                // Write transaction completed, wait for master RREADY to proceed
                READ_DONE: begin
                    if (s_axi_rready) begin
                        s_axi_rvalid_r <= 1'b0;
                        s_axi_rdata_r  <= '0;
                        v_state_r      <= READ_IDLE;
                    end
                end

            endcase
        end
    end: read_fsm

    //----------------------------------------------------------------------------------------------
    // Write-transaction FSM
    //----------------------------------------------------------------------------------------------

    typedef enum {
        WRITE_IDLE,
        WRITE_ADDR_FIRST,
        WRITE_DATA_FIRST,
        WRITE_UPDATE_REGISTER,
        WRITE_DONE
    } write_state_t;

    always_ff@(posedge axi_aclk or negedge axi_aresetn) begin: write_fsm
        // Registered state variables
        write_state_t v_state_r;
        // Combinatorial helper variables
        logic v_addr_hit;
        logic [AXI_ADDR_WIDTH-1:0] v_mem_addr;
        if (~axi_aresetn) begin
            v_state_r                   <= WRITE_IDLE;
            s_axi_awready_r             <= 1'b0;
            s_axi_wready_r              <= 1'b0;
            s_axi_awaddr_reg_r          <= '0;
            s_axi_wdata_reg_r           <= '0;
            s_axi_wstrb_reg_r           <= '0;
            s_axi_bvalid_r              <= 1'b0;
            s_axi_bresp_r               <= '0;

            s_stream_ctrl_strobe_r <= '0;
            s_reg_stream_ctrl_num_samples_r <= moller_regs_pkg::STREAM_CTRL_NUM_SAMPLES_RESET;
            s_reg_stream_ctrl_ch0_r <= moller_regs_pkg::STREAM_CTRL_CH0_RESET;
            s_reg_stream_ctrl_ch1_r <= moller_regs_pkg::STREAM_CTRL_CH1_RESET;
            s_reg_stream_ctrl_rate_div_r <= moller_regs_pkg::STREAM_CTRL_RATE_DIV_RESET;
            s_reg_stream_ctrl_enable_r <= moller_regs_pkg::STREAM_CTRL_ENABLE_RESET;
            s_adc_ctrl_strobe_r <= '0;
            s_reg_adc_ctrl_ch_disable_r <= moller_regs_pkg::ADC_CTRL_CH_DISABLE_RESET;
            s_reg_adc_ctrl_sample_rate_r <= moller_regs_pkg::ADC_CTRL_SAMPLE_RATE_RESET;
            s_reg_adc_ctrl_power_down_r <= moller_regs_pkg::ADC_CTRL_POWER_DOWN_RESET;
            s_reg_adc_ctrl_testpattern_r <= moller_regs_pkg::ADC_CTRL_TESTPATTERN_RESET;
            s_reg_adc_ctrl_ena_r <= moller_regs_pkg::ADC_CTRL_ENA_RESET;
            s_adc_delay_in_strobe_r <= '0;
            for (int i = 0; i < 16; i++) begin
                s_reg_adc_delay_in_value_r[i] <= moller_regs_pkg::ADC_DELAY_IN_VALUE_RESET;
            end

        end else begin
            // Default values:
            s_axi_awready_r <= 1'b0;
            s_axi_wready_r  <= 1'b0;
            s_stream_ctrl_strobe_r <= '0;
            s_adc_ctrl_strobe_r <= '0;
            s_adc_delay_in_strobe_r <= '0;
            v_addr_hit = 1'b0;

            case (v_state_r) // sigasi @suppress "Default clause missing from case statement"

                // Wait for the start of a write transaction, which may be
                // initiated by either of the following conditions:
                //   * assertion of both AWVALID and WVALID
                //   * assertion of AWVALID
                //   * assertion of WVALID
                WRITE_IDLE: begin
                    if (s_axi_awvalid && s_axi_wvalid) begin
                        s_axi_awaddr_reg_r <= s_axi_awaddr; // save the write-address
                        s_axi_awready_r    <= 1'b1; // acknowledge the write-address
                        s_axi_wdata_reg_r  <= s_axi_wdata; // save the write-data
                        s_axi_wstrb_reg_r  <= s_axi_wstrb; // save the write-strobe
                        s_axi_wready_r     <= 1'b1; // acknowledge the write-data
                        v_state_r          <= WRITE_UPDATE_REGISTER;
                    end else if (s_axi_awvalid) begin
                        s_axi_awaddr_reg_r <= s_axi_awaddr; // save the write-address
                        s_axi_awready_r    <= 1'b1; // acknowledge the write-address
                        v_state_r          <= WRITE_ADDR_FIRST;
                    end else if (s_axi_wvalid) begin
                        s_axi_wdata_reg_r <= s_axi_wdata; // save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; // save the write-strobe
                        s_axi_wready_r    <= 1'b1; // acknowledge the write-data
                        v_state_r         <= WRITE_DATA_FIRST;
                    end
                end

                // Address-first write transaction: wait for the write-data
                WRITE_ADDR_FIRST: begin
                    if (s_axi_wvalid) begin
                        s_axi_wdata_reg_r <= s_axi_wdata; // save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; // save the write-strobe
                        s_axi_wready_r    <= 1'b1; // acknowledge the write-data
                        v_state_r         <= WRITE_UPDATE_REGISTER;
                    end
                end

                // Data-first write transaction: wait for the write-address
                WRITE_DATA_FIRST: begin
                    if (s_axi_awvalid) begin
                        s_axi_awaddr_reg_r <= s_axi_awaddr; // save the write-address
                        s_axi_awready_r    <= 1'b1; // acknowledge the write-address
                        v_state_r          <= WRITE_UPDATE_REGISTER;
                    end
                end

                // Update the actual storage element
                WRITE_UPDATE_REGISTER: begin
                    s_axi_bresp_r  <= AXI_OKAY; // default value, may be overriden in case of decode error
                    s_axi_bvalid_r <= 1'b1;



                    // Register  'stream_ctrl' at address offset 0x44
                    if (s_axi_awaddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::STREAM_CTRL_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        s_stream_ctrl_strobe_r <= 1'b1;
                        // field 'num_samples':
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[0] <= s_axi_wdata_reg_r[0]; // num_samples[0]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[1] <= s_axi_wdata_reg_r[1]; // num_samples[1]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[2] <= s_axi_wdata_reg_r[2]; // num_samples[2]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[3] <= s_axi_wdata_reg_r[3]; // num_samples[3]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[4] <= s_axi_wdata_reg_r[4]; // num_samples[4]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[5] <= s_axi_wdata_reg_r[5]; // num_samples[5]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[6] <= s_axi_wdata_reg_r[6]; // num_samples[6]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_stream_ctrl_num_samples_r[7] <= s_axi_wdata_reg_r[7]; // num_samples[7]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[8] <= s_axi_wdata_reg_r[8]; // num_samples[8]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[9] <= s_axi_wdata_reg_r[9]; // num_samples[9]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[10] <= s_axi_wdata_reg_r[10]; // num_samples[10]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[11] <= s_axi_wdata_reg_r[11]; // num_samples[11]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[12] <= s_axi_wdata_reg_r[12]; // num_samples[12]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[13] <= s_axi_wdata_reg_r[13]; // num_samples[13]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[14] <= s_axi_wdata_reg_r[14]; // num_samples[14]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_stream_ctrl_num_samples_r[15] <= s_axi_wdata_reg_r[15]; // num_samples[15]
                        end
                        // field 'ch0':
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch0_r[0] <= s_axi_wdata_reg_r[16]; // ch0[0]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch0_r[1] <= s_axi_wdata_reg_r[17]; // ch0[1]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch0_r[2] <= s_axi_wdata_reg_r[18]; // ch0[2]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch0_r[3] <= s_axi_wdata_reg_r[19]; // ch0[3]
                        end
                        // field 'ch1':
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch1_r[0] <= s_axi_wdata_reg_r[20]; // ch1[0]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch1_r[1] <= s_axi_wdata_reg_r[21]; // ch1[1]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch1_r[2] <= s_axi_wdata_reg_r[22]; // ch1[2]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_stream_ctrl_ch1_r[3] <= s_axi_wdata_reg_r[23]; // ch1[3]
                        end
                        // field 'rate_div':
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[0] <= s_axi_wdata_reg_r[24]; // rate_div[0]
                        end
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[1] <= s_axi_wdata_reg_r[25]; // rate_div[1]
                        end
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[2] <= s_axi_wdata_reg_r[26]; // rate_div[2]
                        end
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[3] <= s_axi_wdata_reg_r[27]; // rate_div[3]
                        end
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[4] <= s_axi_wdata_reg_r[28]; // rate_div[4]
                        end
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[5] <= s_axi_wdata_reg_r[29]; // rate_div[5]
                        end
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_rate_div_r[6] <= s_axi_wdata_reg_r[30]; // rate_div[6]
                        end
                        // field 'enable':
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_stream_ctrl_enable_r[0] <= s_axi_wdata_reg_r[31]; // enable[0]
                        end
                    end

                    // Register  'adc_ctrl' at address offset 0x48
                    if (s_axi_awaddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::ADC_CTRL_OFFSET[AXI_ADDR_WIDTH-1:2]) begin
                        v_addr_hit = 1'b1;
                        s_adc_ctrl_strobe_r <= 1'b1;
                        // field 'ch_disable':
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[0] <= s_axi_wdata_reg_r[0]; // ch_disable[0]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[1] <= s_axi_wdata_reg_r[1]; // ch_disable[1]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[2] <= s_axi_wdata_reg_r[2]; // ch_disable[2]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[3] <= s_axi_wdata_reg_r[3]; // ch_disable[3]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[4] <= s_axi_wdata_reg_r[4]; // ch_disable[4]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[5] <= s_axi_wdata_reg_r[5]; // ch_disable[5]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[6] <= s_axi_wdata_reg_r[6]; // ch_disable[6]
                        end
                        if (s_axi_wstrb_reg_r[0]) begin
                            s_reg_adc_ctrl_ch_disable_r[7] <= s_axi_wdata_reg_r[7]; // ch_disable[7]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[8] <= s_axi_wdata_reg_r[8]; // ch_disable[8]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[9] <= s_axi_wdata_reg_r[9]; // ch_disable[9]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[10] <= s_axi_wdata_reg_r[10]; // ch_disable[10]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[11] <= s_axi_wdata_reg_r[11]; // ch_disable[11]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[12] <= s_axi_wdata_reg_r[12]; // ch_disable[12]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[13] <= s_axi_wdata_reg_r[13]; // ch_disable[13]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[14] <= s_axi_wdata_reg_r[14]; // ch_disable[14]
                        end
                        if (s_axi_wstrb_reg_r[1]) begin
                            s_reg_adc_ctrl_ch_disable_r[15] <= s_axi_wdata_reg_r[15]; // ch_disable[15]
                        end
                        // field 'sample_rate':
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[0] <= s_axi_wdata_reg_r[16]; // sample_rate[0]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[1] <= s_axi_wdata_reg_r[17]; // sample_rate[1]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[2] <= s_axi_wdata_reg_r[18]; // sample_rate[2]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[3] <= s_axi_wdata_reg_r[19]; // sample_rate[3]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[4] <= s_axi_wdata_reg_r[20]; // sample_rate[4]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[5] <= s_axi_wdata_reg_r[21]; // sample_rate[5]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[6] <= s_axi_wdata_reg_r[22]; // sample_rate[6]
                        end
                        if (s_axi_wstrb_reg_r[2]) begin
                            s_reg_adc_ctrl_sample_rate_r[7] <= s_axi_wdata_reg_r[23]; // sample_rate[7]
                        end
                        // field 'power_down':
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_adc_ctrl_power_down_r[0] <= s_axi_wdata_reg_r[29]; // power_down[0]
                        end
                        // field 'testpattern':
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_adc_ctrl_testpattern_r[0] <= s_axi_wdata_reg_r[30]; // testpattern[0]
                        end
                        // field 'ena':
                        if (s_axi_wstrb_reg_r[3]) begin
                            s_reg_adc_ctrl_ena_r[0] <= s_axi_wdata_reg_r[31]; // ena[0]
                        end
                    end






                    // Register array 'adc_delay_in' at address offset 0x60
                    for (int i = 0; i < 16; i++) begin
                        if (s_axi_awaddr_reg_r[AXI_ADDR_WIDTH-1:2] == BASEADDR[AXI_ADDR_WIDTH-1:2] + moller_regs_pkg::ADC_DELAY_IN_OFFSET[AXI_ADDR_WIDTH-1:2] + (AXI_ADDR_WIDTH-2)'(i * 1)) begin
                            v_addr_hit = 1'b1;
                            s_adc_delay_in_strobe_r[i] <= 1'b1;
                            // field 'value':
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][0] <= s_axi_wdata_reg_r[0]; // value[0]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][1] <= s_axi_wdata_reg_r[1]; // value[1]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][2] <= s_axi_wdata_reg_r[2]; // value[2]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][3] <= s_axi_wdata_reg_r[3]; // value[3]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][4] <= s_axi_wdata_reg_r[4]; // value[4]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][5] <= s_axi_wdata_reg_r[5]; // value[5]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][6] <= s_axi_wdata_reg_r[6]; // value[6]
                            end
                            if (s_axi_wstrb_reg_r[0]) begin
                                s_reg_adc_delay_in_value_r[i][7] <= s_axi_wdata_reg_r[7]; // value[7]
                            end
                            if (s_axi_wstrb_reg_r[1]) begin
                                s_reg_adc_delay_in_value_r[i][8] <= s_axi_wdata_reg_r[8]; // value[8]
                            end
                        end
                    end


                    if (!v_addr_hit) begin
                        s_axi_bresp_r   <= AXI_SLVERR;
                        // pragma translate_off
                        $warning("AWADDR decode error");
                        // pragma translate_on
                    end
                    v_state_r <= WRITE_DONE;
                end

                // Write transaction completed, wait for master BREADY to proceed
                WRITE_DONE: begin
                    if (s_axi_bready) begin
                        s_axi_bvalid_r <= 1'b0;
                        v_state_r      <= WRITE_IDLE;
                    end
                end
            endcase


        end
    end: write_fsm

    //----------------------------------------------------------------------------------------------
    // Outputs
    //----------------------------------------------------------------------------------------------

    assign s_axi_awready = s_axi_awready_r;
    assign s_axi_wready  = s_axi_wready_r;
    assign s_axi_bvalid  = s_axi_bvalid_r;
    assign s_axi_bresp   = s_axi_bresp_r;
    assign s_axi_arready = s_axi_arready_r;
    assign s_axi_rvalid  = s_axi_rvalid_r;
    assign s_axi_rresp   = s_axi_rresp_r;
    assign s_axi_rdata   = s_axi_rdata_r;

    assign adc_test_data_strobe = s_adc_test_data_strobe_r;
    assign revision_strobe = s_revision_strobe_r;
    assign stream_ctrl_strobe = s_stream_ctrl_strobe_r;
    assign stream_ctrl_num_samples = s_reg_stream_ctrl_num_samples_r;
    assign stream_ctrl_ch0 = s_reg_stream_ctrl_ch0_r;
    assign stream_ctrl_ch1 = s_reg_stream_ctrl_ch1_r;
    assign stream_ctrl_rate_div = s_reg_stream_ctrl_rate_div_r;
    assign stream_ctrl_enable = s_reg_stream_ctrl_enable_r;
    assign adc_ctrl_strobe = s_adc_ctrl_strobe_r;
    assign adc_ctrl_ch_disable = s_reg_adc_ctrl_ch_disable_r;
    assign adc_ctrl_sample_rate = s_reg_adc_ctrl_sample_rate_r;
    assign adc_ctrl_power_down = s_reg_adc_ctrl_power_down_r;
    assign adc_ctrl_testpattern = s_reg_adc_ctrl_testpattern_r;
    assign adc_ctrl_ena = s_reg_adc_ctrl_ena_r;
    assign freq_td_strobe = s_freq_td_strobe_r;
    assign freq_osc_strobe = s_freq_osc_strobe_r;
    assign freq_som0_strobe = s_freq_som0_strobe_r;
    assign freq_som1_strobe = s_freq_som1_strobe_r;
    assign status_strobe = s_status_strobe_r;
    assign adc_delay_in_strobe = s_adc_delay_in_strobe_r;
    assign adc_delay_in_value = s_reg_adc_delay_in_value_r;
    assign adc_delay_out_strobe = s_adc_delay_out_strobe_r;

endmodule: moller_regs

`resetall