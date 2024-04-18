set outputDir ./output
file mkdir $outputDir

set exportDir ./export
file mkdir $exportDir

set_part xczu6cg-ffvc900-1-e
# maxThreads fixes a crash in Ubuntu 18.04 LTS
# set_param general.maxThreads 1

# STEP 1: setup design sources and constraints

set_property "ip_repo_paths" "./src/moller_regmap_1.0 ./src/mollerTI_1.0 " [current_fileset]
update_ip_catalog

# Need the moller_regs_pkg.sv file to pass in the revision info back into the register map
read_verilog -sv "./src/moller_regmap_1.0/src/moller_regs_pkg.sv"

read_verilog -sv [glob -type f -directory ./src *.{sv,v}]
read_verilog -sv [glob -type f -directory ./src/uwire *.{sv,v}]
read_verilog -sv [glob -type f -directory ./src/util *.{sv,v}]

read_bd [ glob ./src/bd/Mercury_XU1/*.bd ]
open_bd_design [ glob ./src/bd/Mercury_XU1/*.bd ]
write_bd_tcl -force ./scripts/moller_bd.tcl

generate_target -force all [ get_files ./src/bd/Mercury_XU1/Mercury_XU1.bd ]
export_ip_user_files -of_objects [get_files ./src/bd/Mercury_XU1/Mercury_XU1.bd] -no_script -sync -force -quiet
# read_bd [ glob ./src/bd/Mercury_XU1/*.bd ]
# validate_bd_design -force


read_ip [ glob ./src/mmcm_adc/*.xci]
generate_target all [get_files *mmcm_adc.xci]
synth_ip [get_files *mmcm_adc.xci]

read_ip [ glob ./src/adc_ts_fifo/*.xci]
generate_target all [get_files *adc_ts_fifo.xci]
synth_ip [get_files *adc_ts_fifo.xci]

# read_ip [ glob ./src/fifo_10g/*.xci]
# generate_target all [get_files *fifo_10g.xci]
# synth_ip [get_files *fifo_10g.xci]

report_ip_status

read_xdc [glob -type f -directory ./constraints *.{tcl,xdc}]


# STEP 2: run synthesis, report utilization and timing estimates, write checkpoint design
synth_design -top system_top
write_checkpoint -force $outputDir/post_synth
report_utilization -file $outputDir/post_synth_util.rpt
report_timing -sort_by group -max_paths 5 -path_type summary -file $outputDir/post_synth_timing.rpt

# STEP 3: run placement and logic optimization, report utilization and timing estimates
opt_design
power_opt_design
place_design

write_debug_probes -force $outputDir/system.ltx

phys_opt_design

write_checkpoint -force $outputDir/post_place
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_place_util.rpt
report_timing -sort_by group -max_paths 5 -path_type summary -file $outputDir/post_place_timing.rpt

# STEP 4: run router, report actual utilization and timing, write checkpoint design, run DRCs
route_design
write_checkpoint -force $outputDir/post_route
report_route_status -file $outputDir/post_route_status.rpt
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_bus_skew -input_pins -file $outputDir/post_bus_skew.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_methodology -file $outputDir/post_impl_checks.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/system_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/system_impl.xdc

write_checkpoint -force "$outputDir/platform.dcp"
open_checkpoint "$outputDir/platform.dcp"
write_hw_platform -fixed -force -include_bit -file $exportDir/system.xsa

# STEP 5: generate a bitstream
write_bitstream -force $outputDir/system.bit
