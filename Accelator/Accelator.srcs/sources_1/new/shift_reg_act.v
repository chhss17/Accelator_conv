`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/30 16:06:08
// Design Name: 
// Module Name: shift_reg_act
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


module shift_reg_act(
	input					clk,
	input 					enable,
	input 			[7:0]	input_data,

	output	wire	[199:0]	result
    );

reg 				[7:0]	shift_reg_0;
reg 				[7:0]	shift_reg_1;
reg 				[7:0]	shift_reg_2;
reg 				[7:0]	shift_reg_3;
reg 				[7:0]	shift_reg_4;
reg 				[7:0]	shift_reg_5;
reg 				[7:0]	shift_reg_6;
reg 				[7:0]	shift_reg_7;
reg 				[7:0]	shift_reg_8;
reg 				[7:0]	shift_reg_9;
reg 				[7:0]	shift_reg_10;
reg 				[7:0]	shift_reg_11;
reg 				[7:0]	shift_reg_12;
reg 				[7:0]	shift_reg_13;
reg 				[7:0]	shift_reg_14;
reg 				[7:0]	shift_reg_15;
reg 				[7:0]	shift_reg_16;
reg 				[7:0]	shift_reg_17;
reg 				[7:0]	shift_reg_18;
reg 				[7:0]	shift_reg_19;
reg 				[7:0]	shift_reg_20;
reg 				[7:0]	shift_reg_21;
reg 				[7:0]	shift_reg_22;
reg 				[7:0]	shift_reg_23;
reg 				[7:0]	shift_reg_24;

always@(posedge clk or posedge enable)
begin
	if(enable) begin
		shift_reg_24 <= shift_reg_23;
		shift_reg_23 <= shift_reg_22;
		shift_reg_22 <= shift_reg_21;
		shift_reg_21 <= shift_reg_20;
		shift_reg_20 <= shift_reg_19;
		shift_reg_19 <= shift_reg_18;
		shift_reg_18 <= shift_reg_17;
		shift_reg_17 <= shift_reg_16;
		shift_reg_16 <= shift_reg_15;
		shift_reg_15 <= shift_reg_14;
		shift_reg_14 <= shift_reg_13;
		shift_reg_13 <= shift_reg_12;
		shift_reg_12 <= shift_reg_11;
		shift_reg_11 <= shift_reg_10;
		shift_reg_10 <= shift_reg_9;
		shift_reg_9 <= shift_reg_8;
		shift_reg_8 <= shift_reg_7;
		shift_reg_7 <= shift_reg_6;
		shift_reg_6 <= shift_reg_5;
		shift_reg_5 <= shift_reg_4;
		shift_reg_4 <= shift_reg_3;
		shift_reg_3 <= shift_reg_2;
		shift_reg_2 <= shift_reg_1;
		shift_reg_1 <= shift_reg_0;
		shift_reg_0 <= input_data;
	end
end


assign result[199:192] 	= shift_reg_24;
assign result[191:184] 	= shift_reg_23;
assign result[183:176] 	= shift_reg_22;
assign result[175:168] 	= shift_reg_21;
assign result[167:160] 	= shift_reg_20;
assign result[159:152] 	= shift_reg_19;
assign result[151:144] 	= shift_reg_18;
assign result[143:136] 	= shift_reg_17;
assign result[135:128] 	= shift_reg_16;
assign result[127:120] 	= shift_reg_15;
assign result[119:112] 	= shift_reg_14;
assign result[111:104] 	= shift_reg_13;
assign result[103:96] 	= shift_reg_12;
assign result[95:88] 	= shift_reg_11;
assign result[87:80] 	= shift_reg_10;
assign result[79:72] 	= shift_reg_9;
assign result[71:64] 	= shift_reg_8;
assign result[63:56] 	= shift_reg_7;
assign result[55:48] 	= shift_reg_6;
assign result[47:40] 	= shift_reg_5;
assign result[39:32] 	= shift_reg_4;
assign result[31:24] 	= shift_reg_3;
assign result[23:16] 	= shift_reg_2;
assign result[15:8] 	= shift_reg_1;
assign result[7:0] 		= shift_reg_0;

endmodule
