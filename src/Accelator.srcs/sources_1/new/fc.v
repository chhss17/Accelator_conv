`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2019 08:32:41 PM
// Design Name: 
// Module Name: fc
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

module fc(
	input 					clk,
	input 					rst_n,
	input 					enable,
	input 					endsignal_saveunit,

	input 			[7:0]	size_act,
	input 			[7:0]	number_pc_line,
	input 			[15:0]	address_read_act_base,
	input 			[15:0]	address_read_kernel_base,

	output	reg 			ena_kernel_sram,
	output 	reg 			wea_kernel_sram,
	output	reg 	[15:0]	address_kernel_sram,

	output 	reg 			ena_act_sram,
	output	reg 			wea_act_sram,
	output	reg 	[15:0]	address_act_sram,

	output	reg 			enable_pe_array,
	output 	reg 			end_signal
    );

reg 			[7:0]		state;
reg 			[7:0]		next_state;

reg 			[7:0]		count_ker;
reg 			[7:0]		count_act;

reg 			[15:0]		reg_address_read_kernel_base;

localparam 		[7:0]
	UNIT_PRE 		=	8'b11111111,
	READ_KER 		=	8'b00000000,
	READ_ACT 		=	8'b00000001,
	WAIT 			=	8'b00000011,
	WAIT_ONE 		=	8'b00000100,
	WAIT_TWO 		=	8'b00000101,
	COMPUTE 		=	8'b00000111,
	UNENABLE 		=	8'b00001000,
	FINISH			=	8'b00000010;

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
							next_state 		=	READ_KER;
						end
						else begin
							next_state		=	UNIT_PRE;
						end
					end
	READ_KER 		:begin
						if(count_ker	<=	number_pc_line*(size_act + 1)- 2)	begin
							next_state		=	READ_KER;
						end
						else begin
							next_state		=	READ_ACT;
						end
					end
	READ_ACT 		:begin
						if(count_act	<=	size_act - 2)	begin
							next_state		=	READ_ACT;
						end
						else begin
							next_state		=	WAIT_ONE;
						end
					end
	WAIT_ONE 		:begin
						next_state 			=	WAIT_TWO;
					end
	WAIT_TWO 		:begin
						next_state 			=	COMPUTE;
					end
	COMPUTE 		:begin
						next_state 			=	WAIT;
					end
    WAIT 			:begin
    					if(`Isenable(endsignal_saveunit))	begin
    						next_state 		=	FINISH;
    					end
    					else begin
    						next_state 		=	WAIT;
    					end
    				end
	FINISH			:begin
						next_state 			=	UNENABLE;
					end
	UNENABLE 		:begin
						if(`Isenable(enable))	begin
							next_state 		=	READ_KER;
						end
						else begin
							next_state		=	UNENABLE;
						end
					end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		count_act 						<=	`EightBInit;
		count_ker						<=	`EightBInit;
		reg_address_read_kernel_base 	<=	`SixteenBInit;

		address_act_sram				<=	`SixteenBInit;
		ena_act_sram 					<=	`SramDisable;
		wea_act_sram 					<=	`SramRead;

		address_kernel_sram 			<=	`SixteenBInit;
		ena_kernel_sram 				<=	`SramDisable;
		wea_kernel_sram 				<=	`SramRead;

		end_signal 						<=	`UnFinish;
		enable_pe_array 				<=	`UnitDisable;
	end
	else begin
		case(state)
		UNIT_PRE 		:begin
							ena_act_sram 					<=	`SramDisable;
							ena_kernel_sram					<=	`SramDisable;

							count_act 						<=	`SixteenBInit;
							count_ker						<=	`SixteenBInit;

							end_signal 						<=	`UnFinish;
							enable_pe_array 				<=	`UnitDisable;
							reg_address_read_kernel_base 	<=	address_read_kernel_base + 1;
						end
		READ_KER 		:begin
							address_kernel_sram 	<=	reg_address_read_kernel_base + count_ker;
							ena_kernel_sram 		<=	`SramEnable;
							count_ker 				<=	count_ker + 1;
						end
		READ_ACT 		:begin
							ena_kernel_sram 		<=	`SramDisable;
							address_act_sram 		<=	address_read_act_base + count_act;
							ena_act_sram 			<=	`SramEnable;
							count_act 				<=	count_act + 1;
						end
		WAIT_ONE		:begin
							ena_act_sram 			<=	`SramDisable;
						end
		COMPUTE 		:begin
							enable_pe_array 		<=	`UnitEnable;
						end
		WAIT 			:begin
							enable_pe_array 		<=	`UnitDisable;
						end
		FINISH 			:begin
							ena_act_sram 			<=	`SramDisable;
							end_signal				<=	`Finish;
						end
		UNENABLE 		:begin
							ena_act_sram 					<=	`SramDisable;
							ena_kernel_sram					<=	`SramDisable;

							count_act 						<=	`SixteenBInit;
							count_ker						<=	`SixteenBInit;

							end_signal 						<=	`UnFinish;
							enable_pe_array 				<=	`UnitDisable;
							reg_address_read_kernel_base 	<=	address_kernel_sram + 1;
						end
		endcase
	end
end

endmodule
