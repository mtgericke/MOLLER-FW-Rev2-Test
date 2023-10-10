// -----------------------------------------------------------------------------
// 'moller' Register Definitions
// Revision: 246
// -----------------------------------------------------------------------------
// Generated on 2023-06-15 at 03:41 (UTC) by airhdl version 2023.06.1-893761360
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

#ifndef MOLLER_REGS_H
#define MOLLER_REGS_H

#ifdef __cplusplus
extern "C" {
#endif

/* Revision number of the 'moller' register map */
#define MOLLER_REVISION 249

/* Default base address of the 'moller' register map */
#define MOLLER_DEFAULT_BASEADDR 0x80000000

/* Size of the 'moller' register map, in bytes */
#define MOLLER_RANGE_BYTES 224

/* Register 'adc_test_data' */
#define ADC_TEST_DATA_OFFSET 0x00000000 /* address offset of the 'adc_test_data' register */
#define ADC_TEST_DATA_ARRAY_LENGTH 16 /* length of the 'adc_test_data' register array, in elements */

/* Field  'adc_test_data.bad_pattern_counter' */
#define ADC_TEST_DATA_BAD_PATTERN_COUNTER_BIT_OFFSET 0 /* bit offset of the 'bad_pattern_counter' field */
#define ADC_TEST_DATA_BAD_PATTERN_COUNTER_BIT_WIDTH 16 /* bit width of the 'bad_pattern_counter' field */
#define ADC_TEST_DATA_BAD_PATTERN_COUNTER_BIT_MASK 0x0000FFFF /* bit mask of the 'bad_pattern_counter' field */
#define ADC_TEST_DATA_BAD_PATTERN_COUNTER_RESET 0x0 /* reset value of the 'bad_pattern_counter' field */

/* Field  'adc_test_data.bad_dco_counter' */
#define ADC_TEST_DATA_BAD_DCO_COUNTER_BIT_OFFSET 16 /* bit offset of the 'bad_dco_counter' field */
#define ADC_TEST_DATA_BAD_DCO_COUNTER_BIT_WIDTH 16 /* bit width of the 'bad_dco_counter' field */
#define ADC_TEST_DATA_BAD_DCO_COUNTER_BIT_MASK 0xFFFF0000 /* bit mask of the 'bad_dco_counter' field */
#define ADC_TEST_DATA_BAD_DCO_COUNTER_RESET 0x0 /* reset value of the 'bad_dco_counter' field */

/* Register 'revision' */
#define REVISION_OFFSET 0x00000040 /* address offset of the 'revision' register */

/* Field  'revision.value' */
#define REVISION_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define REVISION_VALUE_BIT_WIDTH 32 /* bit width of the 'value' field */
#define REVISION_VALUE_BIT_MASK 0xFFFFFFFF /* bit mask of the 'value' field */
#define REVISION_VALUE_RESET 0x0 /* reset value of the 'value' field */

/* Register 'stream_ctrl' */
#define STREAM_CTRL_OFFSET 0x00000044 /* address offset of the 'stream_ctrl' register */

/* Field  'stream_ctrl.num_samples' */
#define STREAM_CTRL_NUM_SAMPLES_BIT_OFFSET 0 /* bit offset of the 'num_samples' field */
#define STREAM_CTRL_NUM_SAMPLES_BIT_WIDTH 16 /* bit width of the 'num_samples' field */
#define STREAM_CTRL_NUM_SAMPLES_BIT_MASK 0x0000FFFF /* bit mask of the 'num_samples' field */
#define STREAM_CTRL_NUM_SAMPLES_RESET 0x0 /* reset value of the 'num_samples' field */

/* Field  'stream_ctrl.ch0' */
#define STREAM_CTRL_CH0_BIT_OFFSET 16 /* bit offset of the 'ch0' field */
#define STREAM_CTRL_CH0_BIT_WIDTH 4 /* bit width of the 'ch0' field */
#define STREAM_CTRL_CH0_BIT_MASK 0x000F0000 /* bit mask of the 'ch0' field */
#define STREAM_CTRL_CH0_RESET 0x0 /* reset value of the 'ch0' field */

/* Field  'stream_ctrl.ch1' */
#define STREAM_CTRL_CH1_BIT_OFFSET 20 /* bit offset of the 'ch1' field */
#define STREAM_CTRL_CH1_BIT_WIDTH 4 /* bit width of the 'ch1' field */
#define STREAM_CTRL_CH1_BIT_MASK 0x00F00000 /* bit mask of the 'ch1' field */
#define STREAM_CTRL_CH1_RESET 0x0 /* reset value of the 'ch1' field */

/* Field  'stream_ctrl.rate_div' */
#define STREAM_CTRL_RATE_DIV_BIT_OFFSET 24 /* bit offset of the 'rate_div' field */
#define STREAM_CTRL_RATE_DIV_BIT_WIDTH 7 /* bit width of the 'rate_div' field */
#define STREAM_CTRL_RATE_DIV_BIT_MASK 0x7F000000 /* bit mask of the 'rate_div' field */
#define STREAM_CTRL_RATE_DIV_RESET 0x0 /* reset value of the 'rate_div' field */

/* Field  'stream_ctrl.enable' */
#define STREAM_CTRL_ENABLE_BIT_OFFSET 31 /* bit offset of the 'enable' field */
#define STREAM_CTRL_ENABLE_BIT_WIDTH 1 /* bit width of the 'enable' field */
#define STREAM_CTRL_ENABLE_BIT_MASK 0x80000000 /* bit mask of the 'enable' field */
#define STREAM_CTRL_ENABLE_RESET 0x0 /* reset value of the 'enable' field */

/* Register 'adc_ctrl' */
#define ADC_CTRL_OFFSET 0x00000048 /* address offset of the 'adc_ctrl' register */

/* Field  'adc_ctrl.ch_disable' */
#define ADC_CTRL_CH_DISABLE_BIT_OFFSET 0 /* bit offset of the 'ch_disable' field */
#define ADC_CTRL_CH_DISABLE_BIT_WIDTH 16 /* bit width of the 'ch_disable' field */
#define ADC_CTRL_CH_DISABLE_BIT_MASK 0x0000FFFF /* bit mask of the 'ch_disable' field */
#define ADC_CTRL_CH_DISABLE_RESET 0x0 /* reset value of the 'ch_disable' field */

/* Field  'adc_ctrl.sample_rate' */
#define ADC_CTRL_SAMPLE_RATE_BIT_OFFSET 16 /* bit offset of the 'sample_rate' field */
#define ADC_CTRL_SAMPLE_RATE_BIT_WIDTH 8 /* bit width of the 'sample_rate' field */
#define ADC_CTRL_SAMPLE_RATE_BIT_MASK 0x00FF0000 /* bit mask of the 'sample_rate' field */
#define ADC_CTRL_SAMPLE_RATE_RESET 0x0 /* reset value of the 'sample_rate' field */

/* Field  'adc_ctrl.power_down' */
#define ADC_CTRL_POWER_DOWN_BIT_OFFSET 29 /* bit offset of the 'power_down' field */
#define ADC_CTRL_POWER_DOWN_BIT_WIDTH 1 /* bit width of the 'power_down' field */
#define ADC_CTRL_POWER_DOWN_BIT_MASK 0x20000000 /* bit mask of the 'power_down' field */
#define ADC_CTRL_POWER_DOWN_RESET 0x0 /* reset value of the 'power_down' field */

/* Field  'adc_ctrl.testpattern' */
#define ADC_CTRL_TESTPATTERN_BIT_OFFSET 30 /* bit offset of the 'testpattern' field */
#define ADC_CTRL_TESTPATTERN_BIT_WIDTH 1 /* bit width of the 'testpattern' field */
#define ADC_CTRL_TESTPATTERN_BIT_MASK 0x40000000 /* bit mask of the 'testpattern' field */
#define ADC_CTRL_TESTPATTERN_RESET 0x0 /* reset value of the 'testpattern' field */

/* Field  'adc_ctrl.ena' */
#define ADC_CTRL_ENA_BIT_OFFSET 31 /* bit offset of the 'ena' field */
#define ADC_CTRL_ENA_BIT_WIDTH 1 /* bit width of the 'ena' field */
#define ADC_CTRL_ENA_BIT_MASK 0x80000000 /* bit mask of the 'ena' field */
#define ADC_CTRL_ENA_RESET 0x0 /* reset value of the 'ena' field */

/* Register 'freq_td' */
#define FREQ_TD_OFFSET 0x0000004C /* address offset of the 'freq_td' register */

/* Field  'freq_td.value' */
#define FREQ_TD_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define FREQ_TD_VALUE_BIT_WIDTH 32 /* bit width of the 'value' field */
#define FREQ_TD_VALUE_BIT_MASK 0xFFFFFFFF /* bit mask of the 'value' field */
#define FREQ_TD_VALUE_RESET 0x0 /* reset value of the 'value' field */

/* Register 'freq_osc' */
#define FREQ_OSC_OFFSET 0x00000050 /* address offset of the 'freq_osc' register */

/* Field  'freq_osc.value' */
#define FREQ_OSC_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define FREQ_OSC_VALUE_BIT_WIDTH 32 /* bit width of the 'value' field */
#define FREQ_OSC_VALUE_BIT_MASK 0xFFFFFFFF /* bit mask of the 'value' field */
#define FREQ_OSC_VALUE_RESET 0x0 /* reset value of the 'value' field */

/* Register 'freq_som0' */
#define FREQ_SOM0_OFFSET 0x00000054 /* address offset of the 'freq_som0' register */

/* Field  'freq_som0.value' */
#define FREQ_SOM0_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define FREQ_SOM0_VALUE_BIT_WIDTH 32 /* bit width of the 'value' field */
#define FREQ_SOM0_VALUE_BIT_MASK 0xFFFFFFFF /* bit mask of the 'value' field */
#define FREQ_SOM0_VALUE_RESET 0x0 /* reset value of the 'value' field */

/* Register 'freq_som1' */
#define FREQ_SOM1_OFFSET 0x00000058 /* address offset of the 'freq_som1' register */

/* Field  'freq_som1.value' */
#define FREQ_SOM1_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define FREQ_SOM1_VALUE_BIT_WIDTH 32 /* bit width of the 'value' field */
#define FREQ_SOM1_VALUE_BIT_MASK 0xFFFFFFFF /* bit mask of the 'value' field */
#define FREQ_SOM1_VALUE_RESET 0x0 /* reset value of the 'value' field */

/* Register 'status' */
#define STATUS_OFFSET 0x0000005C /* address offset of the 'status' register */

/* Field  'status.clk_lockdetect' */
#define STATUS_CLK_LOCKDETECT_BIT_OFFSET 0 /* bit offset of the 'clk_lockdetect' field */
#define STATUS_CLK_LOCKDETECT_BIT_WIDTH 1 /* bit width of the 'clk_lockdetect' field */
#define STATUS_CLK_LOCKDETECT_BIT_MASK 0x00000001 /* bit mask of the 'clk_lockdetect' field */
#define STATUS_CLK_LOCKDETECT_RESET 0x0 /* reset value of the 'clk_lockdetect' field */

/* Field  'status.clk_holdover' */
#define STATUS_CLK_HOLDOVER_BIT_OFFSET 1 /* bit offset of the 'clk_holdover' field */
#define STATUS_CLK_HOLDOVER_BIT_WIDTH 1 /* bit width of the 'clk_holdover' field */
#define STATUS_CLK_HOLDOVER_BIT_MASK 0x00000002 /* bit mask of the 'clk_holdover' field */
#define STATUS_CLK_HOLDOVER_RESET 0x0 /* reset value of the 'clk_holdover' field */

/* Field  'status.adc_train_done' */
#define STATUS_ADC_TRAIN_DONE_BIT_OFFSET 2 /* bit offset of the 'adc_train_done' field */
#define STATUS_ADC_TRAIN_DONE_BIT_WIDTH 1 /* bit width of the 'adc_train_done' field */
#define STATUS_ADC_TRAIN_DONE_BIT_MASK 0x00000004 /* bit mask of the 'adc_train_done' field */
#define STATUS_ADC_TRAIN_DONE_RESET 0x0 /* reset value of the 'adc_train_done' field */

/* Register 'adc_delay_in' */
#define ADC_DELAY_IN_OFFSET 0x00000060 /* address offset of the 'adc_delay_in' register */
#define ADC_DELAY_IN_ARRAY_LENGTH 16 /* length of the 'adc_delay_in' register array, in elements */

/* Field  'adc_delay_in.value' */
#define ADC_DELAY_IN_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define ADC_DELAY_IN_VALUE_BIT_WIDTH 9 /* bit width of the 'value' field */
#define ADC_DELAY_IN_VALUE_BIT_MASK 0x000001FF /* bit mask of the 'value' field */
#define ADC_DELAY_IN_VALUE_RESET 0x0 /* reset value of the 'value' field */

/* Register 'adc_delay_out' */
#define ADC_DELAY_OUT_OFFSET 0x000000A0 /* address offset of the 'adc_delay_out' register */
#define ADC_DELAY_OUT_ARRAY_LENGTH 16 /* length of the 'adc_delay_out' register array, in elements */

/* Field  'adc_delay_out.value' */
#define ADC_DELAY_OUT_VALUE_BIT_OFFSET 0 /* bit offset of the 'value' field */
#define ADC_DELAY_OUT_VALUE_BIT_WIDTH 9 /* bit width of the 'value' field */
#define ADC_DELAY_OUT_VALUE_BIT_MASK 0x000001FF /* bit mask of the 'value' field */
#define ADC_DELAY_OUT_VALUE_RESET 0x0 /* reset value of the 'value' field */

#ifdef __cplusplus
}
#endif

#endif  /* MOLLER_REGS_H */