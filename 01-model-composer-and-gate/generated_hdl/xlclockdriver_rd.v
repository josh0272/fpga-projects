`timescale 1 ns / 10 ps
module xlclockdriver (sysclk, sysclr, sysce, clk, clr, ce, ce_logic);
   parameter signed [31:0] log_2_period = 1;
   parameter signed [31:0] period  = 2;
   parameter signed [31:0] use_bufg  = 1'b0;
   parameter signed [31:0] pipeline_regs = 5;
   input sysclk;
   input sysclr;
   input sysce;
   output clk;
   output clr;
   output ce;
   output ce_logic;

   parameter signed [31:0] max_pipeline_regs = 8;
   parameter signed [31:0] num_pipeline_regs = (max_pipeline_regs > pipeline_regs)? pipeline_regs : max_pipeline_regs;
   parameter signed [31:0] factor = num_pipeline_regs/period;
   parameter signed [31:0] rem_pipeline_regs =  num_pipeline_regs - (period * factor) + 1;
   parameter [log_2_period-1:0] trunc_period = ~period + 1;
   parameter signed [31:0] period_floor = (period>2)? period : 2;
   parameter signed [31:0] power_of_2_counter = (trunc_period == period) ? 1 : 0;
   parameter signed [31:0] cnt_width = (power_of_2_counter & (log_2_period>1)) ? (log_2_period - 1) : log_2_period;
   parameter [cnt_width-1:0] clk_for_ce_pulse_minus1 = period_floor-2;
   parameter [cnt_width-1:0] clk_for_ce_pulse_minus_regs = ((period-rem_pipeline_regs)>0)? (period-rem_pipeline_regs) : 0;
   reg [cnt_width-1:0] clk_num;
   reg temp_ce_vec;
   wire [num_pipeline_regs:0] ce_vec;
   wire [num_pipeline_regs:0] ce_vec_logic;
   wire internal_ce;
   wire internal_ce_logic;
   reg cnt_clr;
   wire cnt_clr_dly;
   genvar index;

   initial begin clk_num = 'b0; end
   assign clk = sysclk;
   assign clr = sysclr;

   always @(posedge sysclk) begin : cntr_gen
     if (sysce == 1'b1) begin
       if ((cnt_clr_dly == 1'b1) || (sysclr == 1'b1))
         clk_num = {cnt_width{1'b0}};
       else
         clk_num = clk_num + 1;
     end
   end

   generate
     if (power_of_2_counter == 1) begin:clr_gen_p2
       always @(sysclr) cnt_clr = sysclr;
     end
   endgenerate

   generate
     if (power_of_2_counter == 0) begin:clr_gen
       always @(clk_num or sysclr) begin
         if ((clk_num == clk_for_ce_pulse_minus1) | (sysclr == 1'b1))
           cnt_clr = 1'b1;
         else
           cnt_clr = 1'b0;
       end
     end
   endgenerate

   synth_reg_w_init #(1, 0, 'b0000, 1)
     clr_reg(.i(cnt_clr), .ce(sysce), .clr(sysclr), .clk(sysclk), .o(cnt_clr_dly));

   generate
     if (period > 1) begin:pipelined_ce
       always @(clk_num) begin:np_ce_gen
         if (clk_num == clk_for_ce_pulse_minus_regs) temp_ce_vec = 1'b1;
         else temp_ce_vec = 1'b0;
       end
       for(index=0; index<num_pipeline_regs; index=index+1) begin:ce_pipeline
         synth_reg_w_init #(1, ((((index+1)%period)>0)?0:1), 1'b0, 1)
           ce_reg(.i(ce_vec[index+1]), .ce(sysce), .clr(sysclr), .clk(sysclk), .o(ce_vec[index]));
       end
       for(index=0; index<num_pipeline_regs; index=index+1) begin:ce_pipeline_logic
         synth_reg_w_init #(1, ((((index+1)%period)>0)?0:1), 1'b0, 1)
           ce_reg_logic(.i(ce_vec_logic[index+1]), .ce(sysce), .clr(sysclr), .clk(sysclk), .o(ce_vec_logic[index]));
       end
       assign ce_vec_logic[num_pipeline_regs] = temp_ce_vec;
       assign ce_vec[num_pipeline_regs] = temp_ce_vec;
       assign internal_ce = ce_vec[0];
       assign internal_ce_logic = ce_vec_logic[0];
     end
   endgenerate

   generate
     if (period > 1) begin:period_greater_than_1
       if (use_bufg == 1'b1) begin:use_bufg
         BUFG ce_bufg_inst(.I(internal_ce), .O(ce));
         BUFG ce_logic_bufg_inst(.I(internal_ce_logic), .O(ce_logic));
       end
       else begin:no_bufg
         assign ce = internal_ce & sysce;
         assign ce_logic = internal_ce_logic & sysce;
       end
     end
   endgenerate

   generate
     if (period == 1) begin:period_1
       assign ce = sysce;
       assign ce_logic = sysce;
     end
   endgenerate
endmodule
