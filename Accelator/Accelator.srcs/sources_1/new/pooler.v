`timescale 1ns / 1ps

module pooler(
    input         clk,
    //input         ce,
    input         enable,
    input         master_rst,
    input  [7:0]  size_act,
    input  [7:0]  size_pool_kernel,
    input  [7:0]  num_feature,
    input  [7:0]  data_in,
    output [7:0]  data_out,
    output        valid_op,
    output        end_pool
    );
    wire rst_m,load_sr,global_rst;
    wire [1:0] sel;
    wire [7:0] comp_op;
    wire [7:0] shift_out;
    wire [7:0] reg_op;
    wire [7:0] mux_out;

    wire [7:0] data_in_temp;
    assign data_in_temp = data_in ;

    //reg temp_rst;

    //parameter delay = 3;
    //assign  master_rst = temp_rst;
    integer num_feature_tmp = 0;

    integer ce;
    always @(*)   if(enable == 1) ce = 1;

    control_logic2  control0(
        .clk            (clk),
        .pool_ctr_rst   (master_rst),
        .ce             (ce),
        .m              (size_act),
        .p              (size_pool_kernel),
        .num_feature    (num_feature),

        .sel            (sel),
        .rst_m          (rst_m),
        .op_en          (valid_op),
        .load_sr        (load_sr),
        .global_rst     (global_rst),
        .end_pool       (end_pool));
    
    comparator2 comparator1(
        data_in_temp,
        mux_out,
        comp_op);
    //wire temp2;
    
    max_reg max_reg2(
        .clk(clk),
        .din(comp_op),
        //.rst_m(rst_m),
        //.global_rst(temp2),
        //.master_rst(master_rst),
        .reg_op(reg_op)
      );
    
    reg [7:0] temp;
    
    shifter_row shift3 ( //shifter_row #(delay) shift3 (

      .in(comp_op), 
      .CE(load_sr), // input wire CE
      .rst(global_rst||temp_rst),  // input wire SCLR
      .delay(size_act/2),
      .shift_out(shift_out)         // output wire [7 : 0] Q
    );
    input_mux mux4(shift_out,reg_op,sel,mux_out);
    assign data_out = reg_op;
   //assign data_out = (valid_op)? reg_op:data_out;
endmodule
