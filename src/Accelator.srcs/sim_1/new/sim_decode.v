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
reg 						rst_n;
reg 						enable;

reg 			[1:0]		cs;
reg 						ena;
reg 						wea;
reg 			[15:0]		data_in;
reg 			[15:0]		address;

wire 			[15:0]		data_out;
wire 						end_mode;

initial
begin
	rst_n		=	1'b1;
	clk 		=	1'b0;
	enable		=	1'b0;
	cs 			=	2'b00;
	ena 		=	1'b0;
	wea 		=	1'b0;
	data_in 	=	16'h0000;
	address 	=	16'h0000;
	#1	rst_n	=	1'b0;
		clk 	=	1'b1;
	#1	rst_n	=	1'b1;
		clk  	=	1'b0;
	#1  clk     =   1'b1;
	#1  clk     =   1'b0;
	#1  clk     =   1'b1;
	    enable  =   1'b1;
	#1  clk     =   1'b0;
end

always
begin
    enable  =   1'b0;
	#10	clk	=	~clk;
end

decode_sram		u_decode_sram(
	.clk 					(clk),
	.rst_n 					(rst_n),
	.enable 				(enable),
	.cs 					(cs),
	.ena 					(ena),
	.wea					(wea),
	.data_in 				(data_in),
	.address 				(address),
	.data_out 				(data_out),
	.end_mode 				(end_mode));


endmodule
