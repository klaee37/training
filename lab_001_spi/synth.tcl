set RTL_PATH		"./"
set DESIGN			"spi"
set DATE_SUFFIX		"[exec date +%m%d%y]_[exec date +%H%M]"
set SUFFIX			"_${DATE_SUFFIX}"

set LIB_LIST        { tcbn65lptc.lib }
set RTL_LIST        { spi.v }

set_db init_lib_search_path /home/icdesign/pdk/stclib/Front_End/timing_power_noise/NLDM/tcbn65lp_220a
set_db init_hdl_search_path $RTL_PATH

suppress_messages { LBR-101 LBR-162 LBR-9 PHYS-12 LBR-155 LBR-415 PHYS-279 CWD-19 CWD-36 }
set_db /messages/CDFG-372 .severity warning
set_db /messages/CDFG2G-622 .severity error
set_db hdl_error_on_latch true

read_libs $LIB_LIST
read_hdl $RTL_LIST
elaborate $DESIGN

init_design

set_dont_use [get_lib_cell DFNCND2*]
set_dont_use [get_lib_cell DFNCND4*]
set_dont_use [get_lib_cell DFCNQD2*]
set_dont_use [get_lib_cell DFCNQD4*]
set_dont_use [get_lib_cell DFCND*]
set_dont_use [get_lib_cell DFSND*]
set_dont_use [get_lib_cell DFSNQD2*]
set_dont_use [get_lib_cell DFSNQD4*]
set_dont_use [get_lib_cell SDF*]
set_dont_use [get_lib_cell SEDF*]
set_dont_use [get_lib_cell EDF*]

syn_generic
syn_map
syn_opt

write_netlist > ${DESIGN}_netlist.v

echo "=================================="
echo "       Synthesis Done"
echo "=================================="

exit
