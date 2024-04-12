set_false_path -from [get_clocks clk_pl_0] -to [get_ports LED2_N_PWR_SYNC]

create_clock -period 8.000 -name SOM_CLK_1 -waveform {0.000 4.000} [get_ports {SOM_IN_CLK_P[1]}]
create_clock -period 8.000 -name SOM_CLK_0 -waveform {0.000 4.000} [get_ports {SOM_IN_CLK_P[0]}]
create_clock -period 4.000 -name TD_CLK -waveform {0.000 2.000} [get_ports FPGA_CLK250_TD_P]
create_clock -period 8.000 -name OSC_CLK -waveform {0.000 4.000} [get_ports CLNR_OSC_P]
create_clock -period 6.400 -name MGT_B228_REFCLK1 -waveform {0.000 3.200} [get_ports MGT_B228_REFCLK1_P]

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

set_false_path -from [get_ports {SW1[5]}] -to [get_ports LMK_STAT_CLKin1]
set_false_path -from [get_ports {SW1[6]}] -to [get_ports LMK_STAT_CLKin0]
set_false_path  -to [get_ports LMK_STAT_HOLDOVER]
set_false_path -to [get_ports {LED_DSP[*]}]

set_output_delay -clock [get_clocks OSC_CLK] -min -add_delay 0.000 [get_ports LMK_UWIRE_CLK]
set_output_delay -clock [get_clocks OSC_CLK] -max -add_delay 0.200 [get_ports LMK_UWIRE_CLK]
set_output_delay -clock [get_clocks OSC_CLK] -min -add_delay 0.000 [get_ports LMK_UWIRE_DATA]
set_output_delay -clock [get_clocks OSC_CLK] -max -add_delay 0.200 [get_ports LMK_UWIRE_DATA]
set_output_delay -clock [get_clocks OSC_CLK] -min -add_delay 0.000 [get_ports LMK_UWIRE_LE]
set_output_delay -clock [get_clocks OSC_CLK] -max -add_delay 0.200 [get_ports LMK_UWIRE_LE]

set_false_path -from [get_clocks OSC_CLK] -to [get_clocks clk_adc_mmcm_adc]
set_false_path -from [get_clocks -of_objects [get_pins clock_subsystem/adc_mmcm/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks OSC_CLK]
set_false_path -from [get_clocks -of_objects [get_pins clock_subsystem/adc_mmcm/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks TD_CLK]



connect_debug_port dbg_hub/clk [get_nets u_ila_1_pl_clk1]

connect_debug_port u_ila_0/clk [get_nets [list bd/zynq_ultra_ps_e/inst/pl_clk1]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list bd/gig_ethernet_pcs_pma_0/inst/core_clocking_i/userclk2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {bd/status_vector[0]} {bd/status_vector[1]} {bd/status_vector[2]} {bd/status_vector[3]} {bd/status_vector[4]} {bd/status_vector[5]} {bd/status_vector[6]} {bd/status_vector[7]} {bd/status_vector[8]} {bd/status_vector[9]} {bd/status_vector[10]} {bd/status_vector[11]} {bd/status_vector[12]} {bd/status_vector[13]} {bd/status_vector[14]} {bd/status_vector[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[0]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[1]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[2]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[3]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[4]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[5]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[6]} {bd/zynq_ultra_ps_e_GMII_ENET1_RXD[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[0]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[1]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[2]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[3]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[4]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[5]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[6]} {bd/zynq_ultra_ps_e_GMII_ENET1_TXD[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 31 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {bd/zynq_ultra_ps_e_emio_gpio_o[1]} {bd/zynq_ultra_ps_e_emio_gpio_o[2]} {bd/zynq_ultra_ps_e_emio_gpio_o[3]} {bd/zynq_ultra_ps_e_emio_gpio_o[4]} {bd/zynq_ultra_ps_e_emio_gpio_o[5]} {bd/zynq_ultra_ps_e_emio_gpio_o[6]} {bd/zynq_ultra_ps_e_emio_gpio_o[7]} {bd/zynq_ultra_ps_e_emio_gpio_o[8]} {bd/zynq_ultra_ps_e_emio_gpio_o[9]} {bd/zynq_ultra_ps_e_emio_gpio_o[10]} {bd/zynq_ultra_ps_e_emio_gpio_o[11]} {bd/zynq_ultra_ps_e_emio_gpio_o[12]} {bd/zynq_ultra_ps_e_emio_gpio_o[13]} {bd/zynq_ultra_ps_e_emio_gpio_o[14]} {bd/zynq_ultra_ps_e_emio_gpio_o[15]} {bd/zynq_ultra_ps_e_emio_gpio_o[16]} {bd/zynq_ultra_ps_e_emio_gpio_o[17]} {bd/zynq_ultra_ps_e_emio_gpio_o[18]} {bd/zynq_ultra_ps_e_emio_gpio_o[19]} {bd/zynq_ultra_ps_e_emio_gpio_o[20]} {bd/zynq_ultra_ps_e_emio_gpio_o[21]} {bd/zynq_ultra_ps_e_emio_gpio_o[22]} {bd/zynq_ultra_ps_e_emio_gpio_o[23]} {bd/zynq_ultra_ps_e_emio_gpio_o[24]} {bd/zynq_ultra_ps_e_emio_gpio_o[25]} {bd/zynq_ultra_ps_e_emio_gpio_o[26]} {bd/zynq_ultra_ps_e_emio_gpio_o[27]} {bd/zynq_ultra_ps_e_emio_gpio_o[28]} {bd/zynq_ultra_ps_e_emio_gpio_o[29]} {bd/zynq_ultra_ps_e_emio_gpio_o[30]} {bd/zynq_ultra_ps_e_emio_gpio_o[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list clk_625]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list bd/mmcm_locked_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list bd/resetdone]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list bd/xlslice_0_Dout]] 
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list bd/zynq_ultra_ps_e_GMII_ENET1_RX_DV]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list bd/zynq_ultra_ps_e_GMII_ENET1_RX_ER]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list bd/zynq_ultra_ps_e_GMII_ENET1_TX_EN]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list bd/zynq_ultra_ps_e_GMII_ENET1_TX_ER]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list clock_subsystem/adc_mmcm/inst/clk_625]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list bd/gtpowergood]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list bd/pma_reset_out]]


set_property C_CLK_INPUT_FREQ_HZ 125000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clnr_osc]
