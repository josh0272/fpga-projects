# Recreate and build the Vivado project from the checked-in generated HDL.
# Run from Vivado Tcl mode, for example:
#   vivado -mode batch -source scripts/create_vivado_project.tcl

set repo_dir [file normalize [file join [file dirname [info script]] ..]]
set build_dir [file join $repo_dir build vivado]
set src_dir [file join $repo_dir generated_hdl]
set xdc_file [file join $repo_dir constraints little_logic_clock.xdc]

create_project little_logic $build_dir -part xc7a35tcpg236-1 -force

add_files [glob -nocomplain [file join $src_dir *.v]]
add_files -fileset constrs_1 $xdc_file
set_property top little_logic [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts "Build complete. Bitstream should be under: $build_dir/little_logic.runs/impl_1/"
