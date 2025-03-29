# cd {E:/Shared Folders/Uni/courses/Digital circuit/digital github codes/Verification-of-AMPA-APB4-Protocol-UVM}
# gtkwave waves/waves.vcd
# vsim -c do "scripts/run.tcl"
vlib work
vlog +incdir+./interface -f "scripts/list.list" -mfcu +cover -covercells
transcript on
transcript file scripts/uvm_transcript.log
vsim -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all -fsmdebug 
log -r /*
add wave /tb_top/DUT/Slave/*
add wave /tb_top/DUT/Slave/Cache
add wave /tb_top/DUT/Master/*
coverage save top.ucdb -onexit -du work.APB_Master -du work.APB_Slave  -du work.APB_Wrapper
vcd file reports/waves.vcd
vcd add -r /* 
run -all
transcript off
vcd flush
coverage report -detail -cvg -directive -comments -output reports/APB_cover_report.txt /APB_coverage_pkg/APB_coverage/apb_cov_grp
quit -sim
vcover report top.ucdb -details -annotate -all -output reports/APB_report.txt