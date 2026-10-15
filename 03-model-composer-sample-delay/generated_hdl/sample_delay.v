`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block delay_block/Sample_Delay_struct
module sample_delay_struct (
  input [1-1:0] gateway_in,
  input clk_1,
  input ce_1,
  output [1-1:0] gateway_out
);
  wire [1-1:0] gateway_in_net;
  wire clk_net;
  wire [1-1:0] delayed;
  wire ce_net;
  assign gateway_in_net = gateway_in;
  assign gateway_out = delayed;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  sample_delay_xldelay #(
    .latency(4),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  delay (
    .en(1'b1),
    .rst(1'b0),
    .d(gateway_in_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delayed)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block
module sample_delay_default_clock_driver (
  input sample_delay_sysclk,
  input sample_delay_sysce,
  input sample_delay_sysclr,
  output sample_delay_clk1,
  output sample_delay_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(sample_delay_sysclk),
    .sysce(sample_delay_sysce),
    .sysclr(sample_delay_sysclr),
    .clk(sample_delay_clk1),
    .ce(sample_delay_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block
(* core_generation_info = "sample_delay,sysgen_core_2025_1,{,compilation=HDL Netlist,block_icon_display=Default,family=artix7,part=xc7a35t,speed=-1,package=cpg236,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=0,interface_doc=0,ce_clr=0,clock_period=10,system_simulink_period=1e-08,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=2e-07,delay=1,}" *)
module sample_delay (
  input [1-1:0] gateway_in,
  input clk,
  output [1-1:0] gateway_out
);
  wire clk_1_net;
  wire ce_1_net;
  sample_delay_default_clock_driver sample_delay_default_clock_driver (
    .sample_delay_sysclk(clk),
    .sample_delay_sysce(1'b1),
    .sample_delay_sysclr(1'b0),
    .sample_delay_clk1(clk_1_net),
    .sample_delay_ce1(ce_1_net)
  );
  sample_delay_struct sample_delay_struct (
    .gateway_in(gateway_in),
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .gateway_out(gateway_out)
  );
endmodule
