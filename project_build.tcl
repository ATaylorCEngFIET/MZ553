open_project git_demo.xpr
source git_repo.tcl 
upgrade_ip [get_ips *]
reset_run synth_1
launch_runs synth_1
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
puts "Implementation done!"
write_hw_platform -include_bit -force -file ./design_1_wrapper.xsa
