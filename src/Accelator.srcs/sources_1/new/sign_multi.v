`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/22 16:39:24
// Design Name: 
// Module Name: sign_multi
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


module sign_multi(
	input 				clk,
	input 		[15:0]	ina,
	input		[15:0]	inb,

	output 		[31:0]	outa
    );

wire 			[31:0]	outa;

assign outa = $signed(ina) + $signed(inb);

endmodule
