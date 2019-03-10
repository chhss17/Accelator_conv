`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2019 09:01:35 PM
// Design Name: 
// Module Name: Relu
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

`define  Isenable(enable) 		(enable == 1'b1)

module RE(
	input 					clk,
	input 					rst_n,
	input 					enable,

	input 			[7:0]	size_act,

	input 			[15:0]	data_in,

	output	reg 			ena_output_sram,
	output 	reg 			wea_output_sram,
	output	reg 	[15:0]	address_output_sram,

	output 	reg 			ena_act_sram,
	output	reg 			wea_act_sram,
	output	reg 	[15:0]	address_act_sram,
	output 	wire 	[15:0]	dataout_act_sram,
	
	output 	reg 			end_signal
    );

reg 				[7:0]	state;
reg 				[7:0]	next_state;
reg 				[7:0]	count;

localparam 			[7:0]
	UNIT_PRE 		=	8'b11111111,
	OP_ONE			=	8'b00000000,
	OP_TWO 			=	8'b00000001,
	OP_THR 			=	8'b00000010,
	FINISH 			=	8'b00000011;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		state 			<=	UNIT_PRE;
	end
	else begin
		state 			<=	next_state;
	end
end

always@(*)
begin
	next_state 			=	state;
	case(state)
	UNIT_PRE		:begin
						if(`Isenable(enable))	begin
							next_state 		=	OP_ONE;
						end
						else begin
							next_state		=	UNIT_PRE;
						end
					end
	OP_ONE 			:begin
						next_state 			=	OP_TWO;
					end
	OP_TWO 			:begin
						if(count <=	size_act - 2)	begin
							next_state		=	OP_TWO;
						end
						else begin
							next_state 		=	OP_THR;
						end
					end
	OP_THR 			:begin
						next_state 			=	FINISH;
					end
	FINISH			:begin
						next_state 			=	UNIT_PRE;
					end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		count 					<=	`EightBInit;

		address_act_sram		<=	16'hffff;
		ena_act_sram 			<=	`SramDisable;
		wea_act_sram 			<=	`SramWrite;

		address_output_sram 	<=	16'hffff;
		ena_output_sram			<=	`SramDisable;
		wea_output_sram 		<=	`SramRead;

		end_signal 				<=	`UnFinish;
	end
	else begin
		case(state)
		UNIT_PRE 	:begin
						count 					<=	`EightBInit;

						address_act_sram		<=	16'hffff;
						ena_act_sram 			<=	`SramDisable;
						wea_act_sram 			<=	`SramWrite;

						address_output_sram 	<=	16'hffff;
						ena_output_sram			<=	`SramDisable;
						wea_output_sram 		<=	`SramRead;

						end_signal 				<=	`UnFinish;
					end
		OP_ONE 		:begin
						count					<=	count + 1;
						address_output_sram 	<=	address_output_sram + 1;
						ena_output_sram 		<=	`SramEnable;
						wea_output_sram 		<=	`SramRead;
					end
		OP_TWO 		:begin
						count 					<=	count + 1;
						address_output_sram 	<=	address_output_sram + 1;
						address_act_sram 		<=	address_act_sram + 1;
						ena_act_sram 			<=	`SramEnable;
					end
		OP_THR 		:begin
						ena_output_sram 		<=	`SramDisable;
						address_act_sram 		<=	address_act_sram + 1;
					end
		FINISH 		:begin
						ena_act_sram 			<=	`SramDisable;
						end_signal 				<=	`Finish;
					end
		endcase
	end
end

assign dataout_act_sram = (data_in[15] == 1'b0)?data_in:16'h0000;

endmodule
