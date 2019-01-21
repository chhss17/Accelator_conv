`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/30 20:55:33
// Design Name: 
// Module Name: sim_top_accelator
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


module sim_top_accelator();

reg							clk;
reg 						reset;
reg 		[7:0]			size_act;
reg			[7:0]			size_kernel;

wire		[15:0]			result;

initial
begin
	size_kernel <= 8'h05;
	size_act	<= 32;
	#10	clk	<=	1'b0;
	#10	clk <=	1'b1;
		reset<=	1'b0;
	#10	reset <= 1'b1;
		clk <= 1'b0;
	#10	reset <= 1'b0;
	#10	clk	<=	1'b1;
end

always
begin
	#30	clk = ~clk;
end

top_accelator U1(
	.clk				(clk),
	.reset				(reset),
	.size_act 			(size_act),
	.size_kernel		(size_kernel),
	.result				(result));
endmodule
