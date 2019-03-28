`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2019 07:43:46 PM
// Design Name: 
// Module Name: MAX_input
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


module MAX_input(
	input 				ena,
	input 		[1:0]	cs,

	output 				ena1,
	output				ena2,
	output 				ena3
    );

assign ena1 = (cs == 2'b01)?ena:1'b0;
assign ena2 = (cs == 2'b10)?ena:1'b0;
assign ena3 = (cs == 2'b11)?ena:1'b0;

endmodule
