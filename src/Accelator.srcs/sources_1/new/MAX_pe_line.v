`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2019 10:03:23 AM
// Design Name: 
// Module Name: MAX_pe_line
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


module MAX_pe_line(
	input 			[7:0]	enable,

	output			[5:0]	ena_pe_line
    );

assign ena_pe_line = (enable == 8'h00)?6'b000000:(enable == 8'h01)?6'b000001:(enable == 8'h02)?6'b000011:(enable == 8'h03)?6'b000111:(enable == 8'h04)?6'b001111:(enable == 8'h05)?6'b011111:(enable == 8'h06)?6'b111111:6'b000000;
endmodule
