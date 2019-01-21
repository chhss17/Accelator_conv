`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/30 16:21:25
// Design Name: 
// Module Name: sim_shift_reg_act
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


module sim_shift_reg_act();

reg 						clk;
reg 						enable;
reg 		[7:0]			input_data;

wire		[1199:0]		result;

initial
begin
	input_data <= 2'h00;
end

always
begin
	#3	clk 	= 1'b0;
		enable	= 1'b0;
	#3	clk		= 1'b1;
	#3	clk 	= 1'b0;
		enable	= 1'b0;
	#3	clk		= 1'b1;
		enable	= 1'b1;
		input_data <= input_data + 1;
end

shift_reg_kernel 	U1(
	.clk			(clk),
	.enable 		(enable),
	.input_data		(input_data),
	.result			(result));


endmodule
