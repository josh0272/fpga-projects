# Basys 3 pin constraints for little_logic
# SW0 -> gateway_in[0]
set_property PACKAGE_PIN V17 [get_ports {gateway_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_in[0]}]

# SW1 -> gateway_in1[0]
set_property PACKAGE_PIN V16 [get_ports {gateway_in1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_in1[0]}]

# 100 MHz onboard clock
create_clock -name clk -period 10.0000000 [get_ports clk]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# LED0 -> gateway_out[0]
set_property PACKAGE_PIN U16 [get_ports {gateway_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_out[0]}]
