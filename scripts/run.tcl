# cd {E:/Shared Folders/Uni/courses/Digital circuit/digital github codes/Verification-of-AMPA-APB4-Protocol-UVM}
# gtkwave waves/waves.vcd
# vsim -c do "scripts/run.tcl"
vlib work
vlog +incdir+./interface -f "scripts/list.list" -mfcu +cover -covercells
# Enable the transcript (even in the compile version of questa sim)
transcript on
transcript file scripts/uvm_transcript.log
# Start Simulation
vsim -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug 
log -r /*
# Add signals to the wave window
add wave /tb_top/DUT/Slave/*
add wave /tb_top/DUT/Slave/Cache
add wave /tb_top/DUT/Master/*
# Code Coverage
coverage save top.ucdb -onexit -du work.APB_Master -du work.APB_Slave  -du work.APB_Wrapper

vcd file waves/waves.vcd
vcd add -r /* 
run -all
# Disable the transcript
transcript off
vcd flush
# Functional Coverage Report
coverage report -detail -cvg -directive  \
    -output "reports/Functional Coverage Report.txt" \
    /APB_coverage_pkg/APB_coverage/*
# Exclude Impossible States (Default State) in the Design (Only Included for Safe Design Practices)
coverage exclude -src design/APB_design/APB_Master.v -line 76 -code b
coverage exclude -clear -src design/APB_design/APB_Master.v -code b -line 77
coverage exclude -clear -src design/APB_design/APB_Master.v -code b -line 81
coverage exclude -clear -src design/APB_design/APB_Master.v -code b -line 90
# Exclude a false alarm in the fourth conditional coverage of this line, as it is impossible to hit due to the priorities of the if statement
coverage exclude -src design/APB_design/APB_Master.v -line 54 -code c
#quit -sim
# Save Coverage Report
vcover report top.ucdb -details -annotate -all -output "reports/Coverage Report - Code, Assertions, and Directives.txt"