`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/03 21:54:56
// Design Name: 
// Module Name: sim_kernel_ram
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


module sim_kernel_ram();

reg						clk;
reg						wea;

reg			[15:0]		address;
reg			[7:0]		data_in;
wire		[7:0]		result;



initial
begin
	#1	clk <= 1'b0;
		address <= 4'h0000;
		wea <= 1'b0;						// wea = 0 while read data
end

always
begin
	#1 	clk = !clk;
end

blk_mem_kernel_gen U1(
	.clka				(clk),
	.wea				(wea),
	.addra				(address),
	.dina				(data_in),
	.douta				(result));
endmodule
