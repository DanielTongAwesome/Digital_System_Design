onerror {exit -code 1}
vlib work
vlog -work work Basic_Organ_Solution.vo
vlog -work work Clock_Divider_Simulation.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.Clock_Divider_vlg_vec_tst -voptargs="+acc"
vcd file -direction Basic_Organ_Solution.msim.vcd
vcd add -internal Clock_Divider_vlg_vec_tst/*
vcd add -internal Clock_Divider_vlg_vec_tst/i1/*
run -all
quit -f
