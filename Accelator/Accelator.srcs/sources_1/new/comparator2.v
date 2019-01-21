`timescale 1ns / 1ps

module comparator2(
    input [7:0] ip1,
    input [7:0] ip2,
    output [7:0] comp_op);
    
    assign comp_op = (ip1>ip2)?ip1:ip2;
endmodule
//master_rst?32'h0:(rst?(32'h0):