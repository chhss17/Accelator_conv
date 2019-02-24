`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/30 11:14:05
// Design Name: 
// Module Name: sim_act_ram
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


module sim_act_ram();

reg						clk;
reg						wea;

reg			[15:0]		address;
reg			[7:0]		data_in;
wire		[7:0]		result;



initial
begin
	#1	clk <= 1'b0;
	//	address <= 16'b0000000100001010;	// 222
		address <= 16'b0000000100001001;	// 84
		wea <= 1'b0;						// wea = 0 while read data
end

always
begin
	#1 	clk = !clk;
end

blk_mem_act_gen U1(
	.clka				(clk),
	.wea				(wea),
	.addra				(address),
	.dina				(data_in),
	.douta				(result));

endmodule
