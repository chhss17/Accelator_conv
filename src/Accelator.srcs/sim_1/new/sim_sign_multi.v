`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/22 16:41:52
// Design Name: 
// Module Name: sim_sign_multi
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


module sim_sign_multi();

reg	 				clk;

reg 				[15:0]		ina;
reg 				[15:0]		inb;
wire 				[31:0]		outa;

initial 
begin
	ina = 16'hF149;
	inb = 16'h187A;
end

sign_multi u1(
	.clk 			(clk),
	.ina 			(ina),
	.inb 			(inb),
	.outa	 		(outa));

endmodule
