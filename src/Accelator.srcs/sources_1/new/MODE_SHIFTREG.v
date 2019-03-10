`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2019 09:42:04 AM
// Design Name: 
// Module Name: MODE_SHIFTREG
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
`include "defines.v"

`define 	IsEnable(enable) 		(enable == 1'b1)

module MODE_SHIFTREG(
	input 					clk,
	input 					rst_n,
	input 			[7:0]	size_act,
	input 					enable,

	output 		reg			enable_1,
	output 		reg 		enable_2,
	output 		reg 		enable_3,
	output 		reg 		enable_4,
	output 		reg 		enable_5,
	output 		reg 		enable_6
    );

reg 				[7:0]	count_1;
reg 				[7:0]	count_2;
reg 				[7:0]	count_3;
reg 				[7:0]	count_4;
reg 				[7:0]	count_5;
reg 				[7:0]	count_6;

reg 				[7:0]	state;
reg 				[7:0]	next_state;

localparam 			[7:0]
	UNIT_PRE 		=	8'b11111111,
	LINE_ONE 		=	8'b00000001,
	LINE_TWO 		=	8'b00000010,
	LINE_THR 		=	8'b00000011,
	LINE_FOUR		=	8'b00000100,
	LINE_FIVE 		=	8'b00000101,
	LINE_SIX 		=	8'b00000110,
	FINISH 			=	8'b00000000;

always @(posedge clk or negedge  rst_n) 
begin
	if (!rst_n) begin
		state 		<=	UNIT_PRE;
	end
	else begin
		state 		<=	next_state;
	end
end

always@(*)
begin
	next_state 		=	state;	
	case(state)
	UNIT_PRE 		:begin
						if(`IsEnable(enable))	begin
							next_state 	=	LINE_ONE;
						end
						else begin
							next_state 	=	UNIT_PRE;
						end
					end
	LINE_ONE 		:begin
						if(`IsEnable(enable))	begin
							if(count_1 	<	size_act)	begin
								next_state 	=	LINE_ONE;
							end
							else begin
								next_state	=	LINE_TWO;
							end
						end
						else begin
							next_state 		=	FINISH;
						end
					end
	LINE_TWO 		:begin
						if(`IsEnable(enable))	begin
							if(count_2 	<	size_act)	begin
								next_state 	=	LINE_TWO;
							end
							else begin
								next_state	=	LINE_THR;
							end
						end
						else begin
							next_state 		=	FINISH;
						end
					end
	LINE_THR 		:begin
						if(`IsEnable(enable))	begin
							if(count_3 	<	size_act)	begin
								next_state 	=	LINE_THR;
							end
							else begin
								next_state	=	LINE_FOUR;
							end
						end
						else begin
							next_state 		=	FINISH;
						end
					end
	LINE_FOUR 		:begin
						if(`IsEnable(enable))	begin
							if(count_4 	<	size_act)	begin
								next_state 	=	LINE_FOUR;
							end
							else begin
								next_state	=	LINE_FIVE;
							end
						end
						else begin
							next_state 		=	FINISH;
						end
					end
	LINE_FIVE 		:begin
						if(`IsEnable(enable))	begin
							if(count_5 	<	size_act)	begin
								next_state 	=	LINE_FIVE;
							end
							else begin
								next_state	=	LINE_SIX;
							end
						end
						else begin
							next_state 		=	FINISH;
						end
					end
	LINE_SIX 		:begin
						if(`IsEnable(enable))	begin
							if(count_6 	<	size_act)	begin
								next_state 	=	LINE_SIX;
							end
							else begin
								next_state	=	FINISH;
							end
						end
						else begin
							next_state 		=	FINISH;
						end
					end
	FINISH 			:begin
						if(`IsEnable(enable))	begin
							next_state 	=	LINE_ONE;
						end
						else begin
							next_state 	=	UNIT_PRE;
						end
					end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		count_1			<=	`EightBInit;
		count_2			<=	`EightBInit;
		count_3			<=	`EightBInit;
		count_4			<=	`EightBInit;
		count_5			<=	`EightBInit;
		count_6			<=	`EightBInit;
		enable_1 		<=	`UnitDisable;
		enable_2 		<=	`UnitDisable;
		enable_3 		<=	`UnitDisable;
		enable_4 		<=	`UnitDisable;
		enable_5 		<=	`UnitDisable;
		enable_6 		<=	`UnitDisable;
	end
	else begin
		case(state)
		UNIT_PRE 		:begin
							count_1			<=	`EightBInit;
							count_2			<=	`EightBInit;
							count_3			<=	`EightBInit;
							count_4			<=	`EightBInit;
							count_5			<=	`EightBInit;
							count_6			<=	`EightBInit;
							enable_1 		<=	`UnitDisable;
							enable_2 		<=	`UnitDisable;
							enable_3 		<=	`UnitDisable;
							enable_4 		<=	`UnitDisable;
							enable_5 		<=	`UnitDisable;
							enable_6 		<=	`UnitDisable;
						end
		LINE_ONE 		:begin
							enable_1 		<=	`UnitEnable;
							count_1 		<=	count_1 + 1;
						end
		LINE_TWO 		:begin
							enable_1 		<=	`UnitDisable;
							enable_2 		<=	`UnitEnable;
							count_2 		<=	count_2 + 1;
						end
		LINE_THR 		:begin
							enable_2 		<=	`UnitDisable;
							enable_3 		<=	`UnitEnable;
							count_3 		<=	count_3 + 1;
						end
		LINE_FOUR 		:begin
							enable_3 		<=	`UnitDisable;
							enable_4 		<=	`UnitEnable;
							count_4 		<=	count_4 + 1;
						end
		LINE_FIVE 		:begin
							enable_4 		<=	`UnitDisable;
							enable_5 		<=	`UnitEnable;
							count_5 		<=	count_5 + 1;
						end
		LINE_SIX 		:begin
							enable_5 		<=	`UnitDisable;
							enable_6 		<=	`UnitEnable;
							count_6 		<=	count_6 + 1;
						end
		FINISH 			:begin
							count_1			<=	`EightBInit;
							count_2			<=	`EightBInit;
							count_3			<=	`EightBInit;
							count_4			<=	`EightBInit;
							count_5			<=	`EightBInit;
							count_6			<=	`EightBInit;
							enable_1 		<=	`UnitDisable;
							enable_2 		<=	`UnitDisable;
							enable_3 		<=	`UnitDisable;
							enable_4 		<=	`UnitDisable;
							enable_5 		<=	`UnitDisable;
							enable_6 		<=	`UnitDisable;
						end
		endcase
	end
end
endmodule
