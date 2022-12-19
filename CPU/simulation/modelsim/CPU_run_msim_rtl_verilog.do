transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/CPU.v}
vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/ROM.v}
vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/Regfile.v}
vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/RAM.v}
vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/CU.v}
vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/ALU.v}

vlog -vlog01compat -work work +incdir+/media/jto/SDXC/Fall2022/CompArc/CPU {/media/jto/SDXC/Fall2022/CompArc/CPU/CPU_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxv_ver -L rtl_work -L work -voptargs="+acc"  CPU_tb

add wave *
view structure
view signals
run -all
