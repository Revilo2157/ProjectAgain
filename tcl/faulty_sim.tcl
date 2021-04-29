set top_module $::env(top)

set scan_lib ./nangate_scan.v
set stil_file  ./gate/${top_module}/${top_module}.spf 

read_netlist -delete
# read in scan cell library
read_netlist $scan_lib -library
# read in user's synthesized verilog code
#read_netlist $synthesized_files

read_netlist  ./gate/${top_module}/${top_module}_scan.v

run_build_model $top_module
set_drc $stil_file
add_clocks 0 clk
add_pi_constraints 0 test_se
run_drc
read_timing ./SDD/slack.dat

set_delay -max_tmgn $::env(TMGN)

set_faults -model transition
add_faults -all

set_patterns -external ./SDD/pattern_sdd_slack.stil
run_simulation -override_differences
run_fault_sim

report_faults -slack sdql
report_faults -slack effectiveness
