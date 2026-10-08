`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block first_model/Little_Logic_struct
module little_logic_struct (
  input [1-1:0] gateway_in,
  input [1-1:0] gateway_in1,
  input clk_1,
  input ce_1,
  output [1-1:0] gateway_out
);
  wire [1-1:0] gateway_in1_net;
  wire ce_net;
  wire [1-1:0] gateway_in_net;
  wire clk_net;
  wire [1-1:0] logical_y_net;
  assign gateway_in_net = gateway_in;
  assign gateway_in1_net = gateway_in1;
  assign gateway_out = logical_y_net;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sysgen_logical_de1f85cd97 logical (
    .clr(1'b0),
    .d0(gateway_in_net),
    .d1(gateway_in1_net),
    .clk(clk_net),
    .ce(ce_net),
    .y(logical_y_net)
  );
endmodule

`timescale 1 ns / 10 ps
module little_logic_default_clock_driver (
  input little_logic_sysclk,
  input little_logic_sysce,
  input little_logic_sysclr,
  output little_logic_clk1,
  output little_logic_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(little_logic_sysclk),
    .sysce(little_logic_sysce),
    .sysclr(little_logic_sysclr),
    .clk(little_logic_clk1),
    .ce(little_logic_ce1)
  );
endmodule

`timescale 1 ns / 10 ps
(* core_generation_info = "little_logic,sysgen_core_2025_1,{,compilation=HDL Netlist,block_icon_display=Default,family=artix7,part=xc7a35t,speed=-1,package=cpg236,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=0,interface_doc=0,ce_clr=0,clock_period=10,system_simulink_period=1e-08,waveform_viewer=0,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=1e-07,logical=1,}" *)
module little_logic (
  input [1-1:0] gateway_in,
  input [1-1:0] gateway_in1,
  input clk,
  output [1-1:0] gateway_out
);
  wire ce_1_net;
  wire clk_1_net;
  little_logic_default_clock_driver little_logic_default_clock_driver (
    .little_logic_sysclk(clk),
    .little_logic_sysce(1'b1),
    .little_logic_sysclr(1'b0),
    .little_logic_clk1(clk_1_net),
    .little_logic_ce1(ce_1_net)
  );
  little_logic_struct little_logic_struct (
    .gateway_in(gateway_in),
    .gateway_in1(gateway_in1),
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .gateway_out(gateway_out)
  );
endmodule
