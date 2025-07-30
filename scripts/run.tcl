vlib work
vlog  -f "scripts/list.f" -mfcu +cover -covercells
vsim -sv_seed random -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug 

#*******************************************#
# Code Coverage
coverage save top.ucdb -onexit -du work.APB_Master -du work.APB_Slave -du work.APB_Wrapper
#*******************************************#
vcd file waves/waves.vcd
vcd add -r /* 
run -all
#*******************************************#
# Functional Coverage Report
coverage report -detail -cvg -directive \
    -output "reports/Functional Coverage Report.txt" \
    /APB_env_pkg/APB_coverage/*

coverage report -detail -cvg -directive \
    -html -output "reports/Functional Coverage Report" \
    /APB_env_pkg/APB_coverage/*
# # Exclude Impossible States (Default State) in the Design (Only Included for Safe Design Practices)
# coverage exclude -src design/APB_design/APB_Master.v -line 76 -code b
# coverage exclude -clear -src design/APB_design/APB_Master.v -code b -line 77
# coverage exclude -clear -src design/APB_design/APB_Master.v -code b -line 81
# coverage exclude -clear -src design/APB_design/APB_Master.v -code b -line 90
# # Exclude a false alarm in the fourth conditional coverage of this line, as it is impossible to hit due to the priorities of the if statement
# coverage exclude -src design/APB_design/APB_Master.v -line 54 -code c

#*******************************************#
quit -sim
# Save Coverage Report
vcover report top.ucdb -details -annotate -all -output "reports/Coverage Report - Code, Assertions, and Directives.txt"
vcover report top.ucdb -details -annotate -html -output "reports/Coverage Report - Code, Assertions, and Directives"