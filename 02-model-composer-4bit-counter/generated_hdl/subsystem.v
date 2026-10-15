`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block couter_test/Subsystem_struct
module subsystem_struct (
  input [1-1:0] gateway_in,
  input [1-1:0] gateway_in1,
  input clk_50000000,
  input ce_50000000,
  output [4-1:0] gateway_out
);
  wire [4-1:0] counter_op_net;
  wire [1-1:0] gateway_in1_net;
  wire ce_net;
  wire clk_net;
  wire [1-1:0] gateway_in_net;
  assign gateway_in_net = gateway_in;
  assign gateway_in1_net = gateway_in1;
  assign gateway_out = counter_op_net;
  assign clk_net = clk_50000000;
  assign ce_net = ce_50000000;
  subsystem_xlcounter_free #(
    .core_name0("subsystem_c_counter_binary_v12_0_i0"),
    .op_arith(`xlUnsigned),
    .op_width(4)
  )
  counter (
    .clr(1'b0),
    .rst(gateway_in_net),
    .en(gateway_in1_net),
    .clk(clk_net),
    .ce(ce_net),
    .op(counter_op_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block
module subsystem_default_clock_driver (
  input subsystem_sysclk,
  input subsystem_sysce,
  input subsystem_sysclr,
  output subsystem_clk50000000,
  output subsystem_ce50000000
);
  xlclockdriver #(
    .period(50000000),
    .log_2_period(26)
  )
  clockdriver (
    .sysclk(subsystem_sysclk),
    .sysce(subsystem_sysce),
    .sysclr(subsystem_sysclr),
    .clk(subsystem_clk50000000),
    .ce(subsystem_ce50000000)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block
(* core_generation_info = "subsystem,sysgen_core_2025_1,{,compilation=HDL Netlist,block_icon_display=Default,family=artix7,part=xc7a35t,speed=-1,package=cpg236,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=0,interface_doc=0,ce_clr=0,clock_period=10,system_simulink_period=1e-08,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=6.4e-07,counter=1,}" *)
module subsystem (
  input [1-1:0] gateway_in,
  input [1-1:0] gateway_in1,
  input clk,
  output [4-1:0] gateway_out
);
  wire ce_50000000_net;
  wire clk_50000000_net;
  subsystem_default_clock_driver subsystem_default_clock_driver (
    .subsystem_sysclk(clk),
    .subsystem_sysce(1'b1),
    .subsystem_sysclr(1'b0),
    .subsystem_clk50000000(clk_50000000_net),
    .subsystem_ce50000000(ce_50000000_net)
  );
  subsystem_struct subsystem_struct (
    .gateway_in(gateway_in),
    .gateway_in1(gateway_in1),
    .clk_50000000(clk_50000000_net),
    .ce_50000000(ce_50000000_net),
    .gateway_out(gateway_out)
  );
endmodule
