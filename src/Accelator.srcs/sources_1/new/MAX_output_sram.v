`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/20 12:56:28
// Design Name: 
// Module Name: MAX_output_sram
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


module MAX_output_sram(
	input 					enable_1,
	input 					wea_1,
	input 			[15:0]	data_in_1,
	input 			[15:0]	address_1,
	input 					enable_2,
	input 					wea_2,
	input 			[15:0]	data_in_2,
	input 			[15:0]	address_2,

	output 	wire			enable,
	output 	wire 			wea,
	output 	wire 	[15:0]	data_in,
	output 	wire 	[15:0]	address
    );

assign enable 	= (enable_1 == 1'b1)?enable_1:(enable_2 == 1'b1)?enable_2:1'b0;
assign wea 		= (enable_1 == 1'b1)?wea_1:(enable_2 == 1'b1)?wea_2:1'b0;
assign data_in 	= (enable_1 == 1'b1)?data_in_1:(enable_2 == 1'b1)?data_in_2:16'h0000;
assign address 	= (enable_1 == 1'b1)?address_1:(enable_2 == 1'b1)?address_2:16'h0000;

endmodule
