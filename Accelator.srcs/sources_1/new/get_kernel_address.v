`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/13 14:13:42
// Design Name: 
// Module Name: get_kernel_address
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


module get_kernel_address(
	input					clk,
	input					reset,

	output	reg 	[15:0]	result

    );

reg					[15:0]	next_result;

always@(posedge clk or posedge reset)
begin
	if(reset) begin
		result <= 16'hffff;
	end
	else begin
		result <= next_result;
	end
end

always@(*)
begin
	next_result = result + 1;
end
endmodule
