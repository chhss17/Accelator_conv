`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:31:01
// Design Name: 
// Module Name: sim_decode
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


module sim_decode();

reg							clk;
reg 						reset;
reg 						enable;

initial
begin
	reset		=	1'b0;
	clk 		=	1'b0;
	enable		=	1'b0;
	#1	reset	=	1'b1;
		clk 	=	1'b1;
	#1	reset	=	1'b0;
		clk  	=	1'b0;
end

always
begin
	#10	clk	=	~clk;
end

/*
always
begin
	#1000	enable	=	1'b1;
	#10 	enable	=	1'b0;
end
*/

decode_sram		u_decode_sram(
	.clk 					(clk),
	.reset 					(reset),
	.enable 				(enable));


endmodule
