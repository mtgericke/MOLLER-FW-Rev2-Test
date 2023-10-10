`ifndef MOLLER_REGS_PKG
`define MOLLER_REGS_PKG

// -----------------------------------------------------------------------------
// 'moller' Register Definitions
// Revision: 249
// -----------------------------------------------------------------------------
// Generated on 2023-08-30 at 20:53 (UTC) by airhdl version 2023.07.1-936312266
// -----------------------------------------------------------------------------
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
// -----------------------------------------------------------------------------

package moller_regs_pkg;

    // Revision number of the 'moller' register map
    localparam MOLLER_REVISION = 249;

    // Default base address of the 'moller' register map
    localparam logic [31:0] MOLLER_DEFAULT_BASEADDR = 32'h80010000;

    // Size of the 'moller' register map, in bytes
    localparam MOLLER_RANGE_BYTES = 224;

    // Register 'adc_test_data'
    localparam logic [31:0] ADC_TEST_DATA_OFFSET = 32'h00000000; // address offset of the 'adc_test_data' register
    localparam ADC_TEST_DATA_ARRAY_LENGTH = 16; // length of the 'adc_test_data' register array, in elements
    // Field 'adc_test_data.bad_pattern_counter'
    localparam ADC_TEST_DATA_BAD_PATTERN_COUNTER_BIT_OFFSET = 0; // bit offset of the 'bad_pattern_counter' field
    localparam ADC_TEST_DATA_BAD_PATTERN_COUNTER_BIT_WIDTH = 16; // bit width of the 'bad_pattern_counter' field
    localparam logic [15:0] ADC_TEST_DATA_BAD_PATTERN_COUNTER_RESET = 16'b0000000000000000; // reset value of the 'bad_pattern_counter' field
    // Field 'adc_test_data.bad_dco_counter'
    localparam ADC_TEST_DATA_BAD_DCO_COUNTER_BIT_OFFSET = 16; // bit offset of the 'bad_dco_counter' field
    localparam ADC_TEST_DATA_BAD_DCO_COUNTER_BIT_WIDTH = 16; // bit width of the 'bad_dco_counter' field
    localparam logic [31:16] ADC_TEST_DATA_BAD_DCO_COUNTER_RESET = 16'b0000000000000000; // reset value of the 'bad_dco_counter' field

    // Register 'revision'
    localparam logic [31:0] REVISION_OFFSET = 32'h00000040; // address offset of the 'revision' register
    // Field 'revision.value'
    localparam REVISION_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam REVISION_VALUE_BIT_WIDTH = 32; // bit width of the 'value' field
    localparam logic [31:0] REVISION_VALUE_RESET = 32'b00000000000000000000000000000000; // reset value of the 'value' field

    // Register 'stream_ctrl'
    localparam logic [31:0] STREAM_CTRL_OFFSET = 32'h00000044; // address offset of the 'stream_ctrl' register
    // Field 'stream_ctrl.num_samples'
    localparam STREAM_CTRL_NUM_SAMPLES_BIT_OFFSET = 0; // bit offset of the 'num_samples' field
    localparam STREAM_CTRL_NUM_SAMPLES_BIT_WIDTH = 16; // bit width of the 'num_samples' field
    localparam logic [15:0] STREAM_CTRL_NUM_SAMPLES_RESET = 16'b0000000000000000; // reset value of the 'num_samples' field
    // Field 'stream_ctrl.ch0'
    localparam STREAM_CTRL_CH0_BIT_OFFSET = 16; // bit offset of the 'ch0' field
    localparam STREAM_CTRL_CH0_BIT_WIDTH = 4; // bit width of the 'ch0' field
    localparam logic [19:16] STREAM_CTRL_CH0_RESET = 4'b0000; // reset value of the 'ch0' field
    // Field 'stream_ctrl.ch1'
    localparam STREAM_CTRL_CH1_BIT_OFFSET = 20; // bit offset of the 'ch1' field
    localparam STREAM_CTRL_CH1_BIT_WIDTH = 4; // bit width of the 'ch1' field
    localparam logic [23:20] STREAM_CTRL_CH1_RESET = 4'b0000; // reset value of the 'ch1' field
    // Field 'stream_ctrl.rate_div'
    localparam STREAM_CTRL_RATE_DIV_BIT_OFFSET = 24; // bit offset of the 'rate_div' field
    localparam STREAM_CTRL_RATE_DIV_BIT_WIDTH = 7; // bit width of the 'rate_div' field
    localparam logic [30:24] STREAM_CTRL_RATE_DIV_RESET = 7'b0000000; // reset value of the 'rate_div' field
    // Field 'stream_ctrl.enable'
    localparam STREAM_CTRL_ENABLE_BIT_OFFSET = 31; // bit offset of the 'enable' field
    localparam STREAM_CTRL_ENABLE_BIT_WIDTH = 1; // bit width of the 'enable' field
    localparam logic [31:31] STREAM_CTRL_ENABLE_RESET = 1'b0; // reset value of the 'enable' field

    // Register 'adc_ctrl'
    localparam logic [31:0] ADC_CTRL_OFFSET = 32'h00000048; // address offset of the 'adc_ctrl' register
    // Field 'adc_ctrl.ch_disable'
    localparam ADC_CTRL_CH_DISABLE_BIT_OFFSET = 0; // bit offset of the 'ch_disable' field
    localparam ADC_CTRL_CH_DISABLE_BIT_WIDTH = 16; // bit width of the 'ch_disable' field
    localparam logic [15:0] ADC_CTRL_CH_DISABLE_RESET = 16'b0000000000000000; // reset value of the 'ch_disable' field
    // Field 'adc_ctrl.sample_rate'
    localparam ADC_CTRL_SAMPLE_RATE_BIT_OFFSET = 16; // bit offset of the 'sample_rate' field
    localparam ADC_CTRL_SAMPLE_RATE_BIT_WIDTH = 8; // bit width of the 'sample_rate' field
    localparam logic [23:16] ADC_CTRL_SAMPLE_RATE_RESET = 8'b00000000; // reset value of the 'sample_rate' field
    // Field 'adc_ctrl.power_down'
    localparam ADC_CTRL_POWER_DOWN_BIT_OFFSET = 29; // bit offset of the 'power_down' field
    localparam ADC_CTRL_POWER_DOWN_BIT_WIDTH = 1; // bit width of the 'power_down' field
    localparam logic [29:29] ADC_CTRL_POWER_DOWN_RESET = 1'b0; // reset value of the 'power_down' field
    // Field 'adc_ctrl.testpattern'
    localparam ADC_CTRL_TESTPATTERN_BIT_OFFSET = 30; // bit offset of the 'testpattern' field
    localparam ADC_CTRL_TESTPATTERN_BIT_WIDTH = 1; // bit width of the 'testpattern' field
    localparam logic [30:30] ADC_CTRL_TESTPATTERN_RESET = 1'b0; // reset value of the 'testpattern' field
    // Field 'adc_ctrl.ena'
    localparam ADC_CTRL_ENA_BIT_OFFSET = 31; // bit offset of the 'ena' field
    localparam ADC_CTRL_ENA_BIT_WIDTH = 1; // bit width of the 'ena' field
    localparam logic [31:31] ADC_CTRL_ENA_RESET = 1'b0; // reset value of the 'ena' field

    // Register 'freq_td'
    localparam logic [31:0] FREQ_TD_OFFSET = 32'h0000004C; // address offset of the 'freq_td' register
    // Field 'freq_td.value'
    localparam FREQ_TD_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam FREQ_TD_VALUE_BIT_WIDTH = 32; // bit width of the 'value' field
    localparam logic [31:0] FREQ_TD_VALUE_RESET = 32'b00000000000000000000000000000000; // reset value of the 'value' field

    // Register 'freq_osc'
    localparam logic [31:0] FREQ_OSC_OFFSET = 32'h00000050; // address offset of the 'freq_osc' register
    // Field 'freq_osc.value'
    localparam FREQ_OSC_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam FREQ_OSC_VALUE_BIT_WIDTH = 32; // bit width of the 'value' field
    localparam logic [31:0] FREQ_OSC_VALUE_RESET = 32'b00000000000000000000000000000000; // reset value of the 'value' field

    // Register 'freq_som0'
    localparam logic [31:0] FREQ_SOM0_OFFSET = 32'h00000054; // address offset of the 'freq_som0' register
    // Field 'freq_som0.value'
    localparam FREQ_SOM0_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam FREQ_SOM0_VALUE_BIT_WIDTH = 32; // bit width of the 'value' field
    localparam logic [31:0] FREQ_SOM0_VALUE_RESET = 32'b00000000000000000000000000000000; // reset value of the 'value' field

    // Register 'freq_som1'
    localparam logic [31:0] FREQ_SOM1_OFFSET = 32'h00000058; // address offset of the 'freq_som1' register
    // Field 'freq_som1.value'
    localparam FREQ_SOM1_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam FREQ_SOM1_VALUE_BIT_WIDTH = 32; // bit width of the 'value' field
    localparam logic [31:0] FREQ_SOM1_VALUE_RESET = 32'b00000000000000000000000000000000; // reset value of the 'value' field

    // Register 'status'
    localparam logic [31:0] STATUS_OFFSET = 32'h0000005C; // address offset of the 'status' register
    // Field 'status.clk_lockdetect'
    localparam STATUS_CLK_LOCKDETECT_BIT_OFFSET = 0; // bit offset of the 'clk_lockdetect' field
    localparam STATUS_CLK_LOCKDETECT_BIT_WIDTH = 1; // bit width of the 'clk_lockdetect' field
    localparam logic [0:0] STATUS_CLK_LOCKDETECT_RESET = 1'b0; // reset value of the 'clk_lockdetect' field
    // Field 'status.clk_holdover'
    localparam STATUS_CLK_HOLDOVER_BIT_OFFSET = 1; // bit offset of the 'clk_holdover' field
    localparam STATUS_CLK_HOLDOVER_BIT_WIDTH = 1; // bit width of the 'clk_holdover' field
    localparam logic [1:1] STATUS_CLK_HOLDOVER_RESET = 1'b0; // reset value of the 'clk_holdover' field
    // Field 'status.adc_train_done'
    localparam STATUS_ADC_TRAIN_DONE_BIT_OFFSET = 2; // bit offset of the 'adc_train_done' field
    localparam STATUS_ADC_TRAIN_DONE_BIT_WIDTH = 1; // bit width of the 'adc_train_done' field
    localparam logic [2:2] STATUS_ADC_TRAIN_DONE_RESET = 1'b0; // reset value of the 'adc_train_done' field

    // Register 'adc_delay_in'
    localparam logic [31:0] ADC_DELAY_IN_OFFSET = 32'h00000060; // address offset of the 'adc_delay_in' register
    localparam ADC_DELAY_IN_ARRAY_LENGTH = 16; // length of the 'adc_delay_in' register array, in elements
    // Field 'adc_delay_in.value'
    localparam ADC_DELAY_IN_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam ADC_DELAY_IN_VALUE_BIT_WIDTH = 9; // bit width of the 'value' field
    localparam logic [8:0] ADC_DELAY_IN_VALUE_RESET = 9'b000000000; // reset value of the 'value' field

    // Register 'adc_delay_out'
    localparam logic [31:0] ADC_DELAY_OUT_OFFSET = 32'h000000A0; // address offset of the 'adc_delay_out' register
    localparam ADC_DELAY_OUT_ARRAY_LENGTH = 16; // length of the 'adc_delay_out' register array, in elements
    // Field 'adc_delay_out.value'
    localparam ADC_DELAY_OUT_VALUE_BIT_OFFSET = 0; // bit offset of the 'value' field
    localparam ADC_DELAY_OUT_VALUE_BIT_WIDTH = 9; // bit width of the 'value' field
    localparam logic [8:0] ADC_DELAY_OUT_VALUE_RESET = 9'b000000000; // reset value of the 'value' field

endpackage: moller_regs_pkg

`endif