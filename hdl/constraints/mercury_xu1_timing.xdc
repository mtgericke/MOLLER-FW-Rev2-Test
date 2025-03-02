#create_clock -period 8.000 -name SOM_CLK_1 -waveform {0.000 4.000} [get_ports {SOM_IN_CLK_P[1]}]
#create_clock -period 8.000 -name SOM_CLK_0 -waveform {0.000 4.000} [get_ports {SOM_IN_CLK_P[0]}]
create_clock -period 4.000 -name TD_CLK -waveform {0.000 2.000} [get_ports FPGA_CLK250_TD_P]
create_clock -period 8.000 -name OSC_CLK -waveform {0.000 4.000} [get_ports CLNR_OSC_P]
create_clock -period 8.000 -name MGT_B228_REFCLK1 -waveform {0.000 4.000} [get_ports MGT_B228_REFCLK1_P]

# create_clock -period 8.000 -name {ADC_DCO[1]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[1]}]
# create_clock -period 8.000 -name {ADC_DCO[2]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[2]}]
# create_clock -period 8.000 -name {ADC_DCO[3]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[3]}]
# create_clock -period 8.000 -name {ADC_DCO[4]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[4]}]
# create_clock -period 8.000 -name {ADC_DCO[5]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[5]}]
# create_clock -period 8.000 -name {ADC_DCO[6]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[6]}]
# create_clock -period 8.000 -name {ADC_DCO[7]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[7]}]
# create_clock -period 8.000 -name {ADC_DCO[8]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[8]}]
# create_clock -period 8.000 -name {ADC_DCO[9]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[9]}]
# create_clock -period 8.000 -name {ADC_DCO[10]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[10]}]
# create_clock -period 8.000 -name {ADC_DCO[11]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[11]}]
# create_clock -period 8.000 -name {ADC_DCO[12]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[12]}]
# create_clock -period 8.000 -name {ADC_DCO[13]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[13]}]
# create_clock -period 8.000 -name {ADC_DCO[14]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[14]}]
# create_clock -period 8.000 -name {ADC_DCO[15]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[15]}]
# create_clock -period 8.000 -name {ADC_DCO[16]} -waveform {0.000 4.000} [get_ports {ADC_DCO_P[16]}]

# set_clock_groups -asynchronous -group clk_pl_0 -group SOM_CLK_0 -group SOM_CLK_1 -group TD_CLK -group OSC_CLK -group ADC_DCO[1] -group ADC_DCO[2] -group ADC_DCO[3] -group ADC_DCO[4] -group ADC_DCO[5] -group ADC_DCO[6] -group ADC_DCO[7] -group ADC_DCO[8] -group ADC_DCO[9] -group ADC_DCO[10] -group ADC_DCO[11] -group ADC_DCO[12] -group ADC_DCO[13] -group ADC_DCO[14] -group ADC_DCO[15] -group ADC_DCO[16]
set_clock_groups -asynchronous -group clk_pl_0 -group clk_pl_1 -group TD_CLK -group OSC_CLK

# set_false_path -from [get_ports LMK_STAT_HOLDOVER]
# set_false_path -from [get_ports LMK_STAT_LD]
# set_false_path -from [get_ports {SW1[*]}]
# set_false_path -to [get_ports {LED_DSP[*]}]
# set_false_path -to [get_ports LMK_UWIRE_CLK]
# set_false_path -to [get_ports LMK_UWIRE_DATA]
# set_false_path -to [get_ports LMK_UWIRE_LE]

set_false_path -from [get_clocks clk_pl_0] -to [get_ports LED2_N_PWR_SYNC]
set_false_path -from [get_ports {SW1[5]}] -to [get_ports LMK_STAT_CLKin1]
set_false_path -from [get_ports {SW1[6]}] -to [get_ports LMK_STAT_CLKin0]
set_false_path -from [get_ports LMK_STAT_HOLDOVER]
set_false_path -from [get_ports LMK_STAT_LD]
set_false_path -from [get_ports DATA_ModPRSn]
set_false_path -from [get_ports {TTL_INPUT[*]}]
set_false_path -from [get_ports {ADC_DA_P[*]}]
set_false_path -from [get_ports {ADC_DB_P[*]}]
set_false_path -from [get_ports {ADC_DCO_P[*]}]
set_false_path -from [get_ports RX_TI_SYNC_P]
set_false_path -to [get_ports {LED_DSP[*]}]
set_false_path -to [get_ports ADC_PDn]
set_false_path -to [get_ports ADC_TESTPAT]
set_false_path -to [get_ports SOM_OUT_CLKA_P]
set_false_path -to [get_ports SOM_OUT_CLKB_P]
set_false_path -to [get_ports SOM_OUT_CNVA_P]
set_false_path -to [get_ports SOM_OUT_CNVB_P]

set_output_delay -clock [get_clocks OSC_CLK] -min -add_delay 0.000 [get_ports LMK_UWIRE_CLK]
set_output_delay -clock [get_clocks OSC_CLK] -max -add_delay 0.200 [get_ports LMK_UWIRE_CLK]
set_output_delay -clock [get_clocks OSC_CLK] -min -add_delay 0.000 [get_ports LMK_UWIRE_DATA]
set_output_delay -clock [get_clocks OSC_CLK] -max -add_delay 0.200 [get_ports LMK_UWIRE_DATA]
set_output_delay -clock [get_clocks OSC_CLK] -min -add_delay 0.000 [get_ports LMK_UWIRE_LE]
set_output_delay -clock [get_clocks OSC_CLK] -max -add_delay 0.200 [get_ports LMK_UWIRE_LE]

set_false_path -from [get_clocks OSC_CLK] -to [get_clocks clk_adc_mmcm_adc]
set_false_path -from [get_clocks -of_objects [get_pins clock_subsystem/adc_mmcm/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks OSC_CLK]
set_false_path -from [get_clocks -of_objects [get_pins clock_subsystem/adc_mmcm/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks TD_CLK]


















set_property C_CLK_INPUT_FREQ_HZ 125000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clnr_osc]
