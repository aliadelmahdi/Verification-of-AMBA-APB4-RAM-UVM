vlib work
vlog -f "do file/list.list" -mfcu +cover -covercells
vsim -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all
add wave  /tb_top/DUT/* 
coverage save top.ucdb -onexit -du work.APB
run -all
coverage report -detail -cvg -directive -comments -output reports/APB_cover_report.txt /APB_coverage_pkg/APB_coverage/APB_crg
#quit -sim
vcover report top.ucdb -details -annotate -all -output reports/APB_report.txt