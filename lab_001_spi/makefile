sim:
	xrun -clean -file tb.f spi.v -input waves.tcl -access +r-wc

elab:
	xrun -clean -file tb.f -input waves.tcl -access +r-wc -elaborate

debug:
	xrun -clean -file tb.f -input waves.tcl -access +rwc -gui -linedebug

syn:
	@find . -type d -iname "fv" -exec rm -rv {} +
	@find . -iname "genus.cmd*" -exec rm -v {} +
	@find . -iname "genus.log*" -exec rm -v {} +
	genus -abort_on_error -execute "source -quiet synth.tcl"

sim_syn:
	xrun -clean -file tb.f spi_netlist.v -input waves.tcl -access +r-wc -v /home/icdesign/pdk/stclib/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v

clean:
	@find . -type d -iname ".simvision" -exec rm -rv {} +
	@find . -type d -iname ".cadence" -exec rm -rv {} +
	@find . -type d -iname "xcelium.d" -exec rm -rv {} +
	@find . -type d -iname "waves.shm" -exec rm -rv {} +
	@find . -type d -iname ".bpad" -exec rm -rv {} +
	@find . -type d -iname "Totem" -exec rm -rv {} +
	@find . -iname "*.vcd" -exec rm -v {} +
	@find . -iname "*.trn" -exec rm -v {} +
	@find . -iname "*.dsn" -exec rm -v {} +
	@find . -iname "*.diag" -exec rm -v {} +
	@find . -iname "xrun.*" -exec rm -v {} +
	@find . -iname "*.err" -exec rm -v {} +
	@find . -iname "novas_dump.log" -exec rm -v {} +
	@find . -type d -iname "fv" -exec rm -rv {} +
	@find . -iname "genus.cmd*" -exec rm -v {} +
	@find . -iname "genus.log*" -exec rm -v {} +
