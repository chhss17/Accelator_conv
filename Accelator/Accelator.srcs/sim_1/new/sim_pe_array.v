`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/05 11:44:04
// Design Name: 
// Module Name: sim_pe_array
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


module sim_pe_array();

reg						clk;
reg						reset;
reg						enable;
reg						enable_1;
reg						enable_2;
reg						enable_3;
reg						enable_4;
reg						enable_5;
reg						enable_6;

reg			[199:0]		kernel_1;
reg			[199:0]		kernel_2;
reg			[199:0]		kernel_3;
reg			[199:0]		kernel_4;
reg			[199:0]		kernel_5;
reg			[199:0]		kernel_6;

reg			[199:0]		act;

reg			[15:0]		psum_in_1;
reg			[15:0]		psum_in_2;
reg			[15:0]		psum_in_3;
reg			[15:0]		psum_in_4;
reg			[15:0]		psum_in_5;
reg			[15:0]		psum_in_6;

wire					end_signal_1;
wire					end_signal_2;
wire					end_signal_3;
wire					end_signal_4;
wire					end_signal_5;
wire					end_signal_6;

wire		[15:0]		result_1;
wire		[15:0]		result_2;
wire		[15:0]		result_3;
wire		[15:0]		result_4;
wire		[15:0]		result_5;
wire		[15:0]		result_6;



initial
begin
	reset 	= 1'b0;
	clk 	= 1'b0;
	enable 	= 1'b1;

	enable_1 = 1'b1;
	enable_2 = 1'b1;
	enable_3 = 1'b1;
	enable_4 = 1'b1;
	enable_5 = 1'b1;
	enable_6 = 1'b0;
	
	kernel_1 = 200'h01020102010201020102010201020102010201020102010203;
	kernel_2 = 200'h01020102010201020102010201020102010201020102010203;
	kernel_3 = 200'h01020102010201020102010201020102010201020102010203;
	kernel_4 = 200'h01020102010201020102010201020102010201020102010203;
	kernel_5 = 200'h01020102010201020102010201020102010201020102010203;
	kernel_6 = 200'h01020102010201020102010201020102010201020102010203;
	
	act = 200'h02010201020102010201020102010201020102010201020104;
	
	psum_in_1 = 16'h0a0b;
	psum_in_2 = 16'h0a0b;
	psum_in_3 = 16'h0a0b;
	psum_in_4 = 16'h0a0b;
	psum_in_5 = 16'h0a0b;
	psum_in_6 = 16'h0a0b;
	
	#30	enable = 1'b0;

end

always
begin
	#10	clk = ~clk;
end

pe_array U1(
	.clk			(clk),
	.reset			(reset),
	.enable 		(enable),
	.enable_1		(enable_1),
	.enable_2		(enable_2),
	.enable_3		(enable_3),
	.enable_4		(enable_4),
	.enable_5		(enable_5),
	.enable_6		(enable_6),
	.kernel_1 		(kernel_1),
	.kernel_2		(kernel_2),
	.kernel_3 		(kernel_3),
	.kernel_4 		(kernel_4),
	.kernel_5 		(kernel_5),
	.kernel_6 		(kernel_6),
	.act 			(act),
	.psum_in_1		(psum_in_1),
	.psum_in_2		(psum_in_2),
	.psum_in_3		(psum_in_3),
	.psum_in_4		(psum_in_4),
	.psum_in_5		(psum_in_5),
	.psum_in_6		(psum_in_6),
	.end_signal_1	(end_signal_1),
	.end_signal_2	(end_signal_2),
	.end_signal_3	(end_signal_3),
	.end_signal_4	(end_signal_4),
	.end_signal_5	(end_signal_5),
	.end_signal_6	(end_signal_6),
	.result_1			(result_1),
	.result_2			(result_2),
	.result_3			(result_3),
	.result_4			(result_4),
	.result_5			(result_5),
	.result_6			(result_6));

endmodule
