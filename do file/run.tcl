# cd {E:/Shared Folders/Uni/courses/Digital circuit/digital github codes/Verification-of-AMPA-APB4-Protocol-UVM}
# gtkwave waves.vcd
# vsim -c do "do file/run.tcl"
vlib work
vlog -f "do file/list.list" -mfcu +cover -covercells
vsim -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all
log -r /*
coverage save top.ucdb -onexit -du work.APB
vcd file waves.vcd
vcd add -r /* 
run -all
vcd flush
coverage report -detail -cvg -directive -comments -output reports/APB_cover_report.txt /APB_coverage_pkg/APB_coverage/APB_crg
#quit -sim
vcover report top.ucdb -details -annotate -all -output reports/APB_report.txt