`timescale 1ns / 1ps

module pooler(
    input            clk,
    input            enable,
    input            master_rst,
    input   [ 7:0]   size_act,
    input   [ 7:0]   size_pool_kernel,
    input   [ 7:0]   num_feature,
    input   [15:0]   data_in,
    output  [15:0]   data_out,
    output           valid_op,
    output           end_pool
    );

    wire             load_sr,global_rst;
    wire    [ 1:0]   sel;
    wire    [15:0]   comp_op;
    wire    [15:0]   shift_out;
    wire    [15:0]   reg_op;
    wire    [15:0]   mux_out;

    integer num_feature_tmp = 0;

    control_logic2  control0(
        .clk                (clk),
        .master_rst         (master_rst),
        .enable             (enable),
        .size_act           (size_act),
        .size_pool_kernel   (size_pool_kernel),
        .num_feature        (num_feature),
    
        .sel                (sel),
        .op_en              (valid_op),
        .load_sr            (load_sr),
        .global_rst         (global_rst),
        .end_pool           (end_pool));
    
    comparator2 comparator1(
        .clk                (clk),
        .ip1                (data_in),
        .ip2                (mux_out),
        .shift_out          (shift_out),
        .sel                (sel),

        .mux_out            (mux_out),
        .reg_op             (reg_op),
        .comp_op            (comp_op));

    shifter_row shift3(
        .shift_din          (comp_op), 
        .CE                 (load_sr),
        .rst                (global_rst),
        .delay              (size_act/2),
        .shift_out          (shift_out));

    assign data_out = reg_op;

endmodule
