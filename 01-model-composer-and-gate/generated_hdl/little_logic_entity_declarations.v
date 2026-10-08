`include "conv_pkg.v"
`timescale 1 ns / 10 ps
module sysgen_logical_de1f85cd97 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  wire d0_1_24;
  wire d1_1_27;
  reg latency_pipe_5_26[0:(1 - 1)];
  initial begin
    latency_pipe_5_26[0] = 1'b0;
  end
  wire latency_pipe_5_26_front_din;
  wire latency_pipe_5_26_back;
  wire latency_pipe_5_26_push_front_pop_back_en;
  wire fully_2_1_bit;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign latency_pipe_5_26_back = latency_pipe_5_26[0];
  always @(posedge clk) begin:proc_latency_pipe_5_26
    integer i;
    if (((ce == 1'b1) && (latency_pipe_5_26_push_front_pop_back_en == 1'b1))) begin
      latency_pipe_5_26[0] <= latency_pipe_5_26_front_din;
    end
  end
  assign fully_2_1_bit = d0_1_24 & d1_1_27;
  assign latency_pipe_5_26_front_din = fully_2_1_bit;
  assign latency_pipe_5_26_push_front_pop_back_en = 1'b1;
  assign y = latency_pipe_5_26_back;
endmodule
