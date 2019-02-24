`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 13:38:51
// Design Name: 
// Module Name: sim_accelator
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


module sim_windows_address;


reg						clk;
reg						reset;

wire		[15:0]		result;


initial
begin
	#5 	clk <= 1'b0;
		reset <= 1'b1;
	#5	reset <= 1'b0;
end

always 
begin
	#10 clk = ~clk;
end

get_windows_address u1(
	.clk				(clk),
	.reset				(reset),
	.result			 	(result));

endmodule
