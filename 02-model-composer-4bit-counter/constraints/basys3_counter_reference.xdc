# Basys 3 — Tutorial 02 four-bit counter I/O mapping
# REFERENCE ONLY: Check the generated top-level port names and all active XDC files.
# Do not load this alongside duplicate or contradictory generated constraints.

# 100 MHz onboard oscillator
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Controls
set_property PACKAGE_PIN R2 [get_ports {gateway_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_in[0]}]
set_property PACKAGE_PIN T1 [get_ports {gateway_in1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_in1[0]}]

# Counter LEDs, MSB to LSB
set_property PACKAGE_PIN L1 [get_ports {gateway_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_out[3]}]
set_property PACKAGE_PIN W3 [get_ports {gateway_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_out[2]}]
set_property PACKAGE_PIN U15 [get_ports {gateway_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_out[1]}]
set_property PACKAGE_PIN U16 [get_ports {gateway_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gateway_out[0]}]

# Required 100 MHz timing constraint:
# create_clock -name clk -period 10.0000000 [get_ports clk]
# Uncomment this ONLY if an equivalent create_clock is not already active
# in the generated subsystem_clock.xdc / other XDC file.
