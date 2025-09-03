
build:
	vlib work
	vmap work work
	vlog -f compile.f
run:
	vsim -debugDB -l report.log -voptargs=+acc -assertdebug -c tb_top -do "log -r /*; run -all;"
wave:
	vsim -i -view vsim.wlf -do "add wave /dut/*; radix -hexadecimal" &
