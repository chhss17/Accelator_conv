`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/04 11:19:46
// Design Name: 
// Module Name: sim_pe_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_pe_unit();

reg						clk;
reg 					reset;
reg						enable;

reg			[7:0]		kernel;
reg			[7:0]		act;
reg			[15:0]		psum_in;

wire					end_signal;
wire		[15:0]		psum_out;

initial
begin
	#1	clk <= 1'b0;
		kernel <= 8'h02;
		act	<= 8'h03;
		enable <= 1'b0;
		psum_in <= 16'h03;
	#10	clk <= 1'b1;
		enable <= 1'b1;
	#10	enable <= 1'b0;
		clk <= 1'b0;
end

always
begin
	#100	clk <= ~clk;
			
end

pe_unit U1(
	.clk			(clk),
	.reset			(reset),
	.enable			(enable),
	.kernel			(kernel),
	.act 			(act),
	.psum_in		(psum_in),
	.end_signal		(end_signal),
	.psum_out		(psum_out));
endmodule
