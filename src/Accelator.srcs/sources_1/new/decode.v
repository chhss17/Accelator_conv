`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/10 10:26:45
// Design Name: 
// Module Name: decode
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

module decode(
	input 					clk,
	input					rst_n,
	input					enable,

	input 			[15:0]	data_pc_in,


	output 	reg				enable_pc_sram,
	output 	reg				wea_pc_sram,
	output	reg		[15:0]	address_pc_sram,

	output	reg		[7:0]	size_act,
	output 	reg 	[7:0]	size_kernel,
	output	reg		[7:0]	stride,
	output	reg		[7:0]	number_pc_line,

	output	reg		[15:0]	address_read_base,
	output	reg		[15:0]	address_write_base,

	output 	reg 			model_saveunit,
	output 	reg 	[7:0]	model_size_pe,

	output	reg 			enable_controller,
	output	reg				enable_pooler,
	output 	reg 			enable_fc,
	output 	reg 			enable_relu,

	output 	reg 			end_signal
    );

reg					[7:0]		state;
reg 				[7:0]		next_state;
reg					[3:0]		model;

localparam			[7:0]	
		READ_ONE 		= 	8'b00000000,
		WAIT_ONE 		= 	8'b00000001,
		JUDGE 			= 	8'b00000010,
		READ_TWO 		= 	8'b00000011,
		READ_THR 		= 	8'b00000100,
		READ_FOU 		= 	8'b00000101,
		WAIT_TWO 		= 	8'b00000110,
		ENA_CONV 		= 	8'b00000111,
		WAIT_FIV 		= 	8'b00001000,
		ENA_POOL 		= 	8'b00001001,
		WAIT			= 	8'b00001110,
		RELU 			= 	8'b00010111,
		FINISH 			=	8'b00011000,
		UNIT_PRE		= 	8'b00001111;

always@(negedge rst_n or posedge clk)
begin
	if(!rst_n)	begin
		state				<=	UNIT_PRE;
	end
	else begin
		state 				<=	next_state;
	end
end


always@(*)
begin
	next_state 				=	state;
	case(state)
	//	start
	UNIT_PRE 	:begin
					if(enable)		begin
						next_state	=	READ_ONE;
					end
					else begin
						next_state	=	UNIT_PRE;
					end
				end
	READ_ONE	:begin
					next_state		=	WAIT_ONE;
				end
	WAIT_ONE 	:begin
					next_state 		=	JUDGE;
				end
	JUDGE		:begin
					model 			=	data_pc_in[11:8];
					if(model ==	4'hf)	begin
						next_state	=	FINISH;
					end
					else if(model == 4'h4) begin
						next_state 	=	RELU;
					end
					else begin
						next_state	=	READ_TWO;
					end
				end

	//	conv
	READ_TWO	:begin
					if(model == 4'h1 || model == 4'h3)	begin
						next_state	=	READ_THR;
					end
					else begin
						next_state 	=	WAIT_FIV;
					end
				end
	READ_THR 	:begin
					next_state		=	READ_FOU;
				end
	READ_FOU 	:begin
					next_state		=	WAIT_TWO;
				end
	WAIT_TWO 	:begin
					next_state 		=	ENA_CONV;
				end
	ENA_CONV 	:begin
					next_state 		=	WAIT;
				end

	//	pooler
	WAIT_FIV 	:begin
					next_state 		=	ENA_POOL;
				end
	ENA_POOL 	:begin
					next_state 		=	WAIT;
				end

	//	relu
	RELU 		:begin
					next_state 		=	WAIT;
				end

	//	finish
	FINISH 		:begin
					next_state 		=	UNIT_PRE;
				end

	//	wait
	WAIT 		:begin
					if(enable)	begin
						next_state	=	READ_ONE;
					end
					else begin
						next_state	=	WAIT;
					end
				end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		enable_pc_sram		<=	`SramDisable;
		wea_pc_sram			<=	`SramRead;
		address_pc_sram		<=	16'hffff;
		size_kernel 		<=	`EightBInit;
		size_act 			<=	`EightBInit;
		model_saveunit 		<= 	1'b0;
		model_size_pe 		<=	`EightBInit;
		enable_controller 	<=	`UnitDisable;
		enable_pooler 		<=	`UnitDisable;
		enable_fc 			<=	`UnitDisable;
		enable_relu 		<=	`UnitDisable;
		end_signal 			<=	`UnFinish;
	end
	else begin
	case(state)
		READ_ONE	:begin
						enable_pc_sram		<=	`SramEnable;
						wea_pc_sram			<=	`SramRead;
						address_pc_sram		<=	address_pc_sram	+ 1;
					end
		WAIT_ONE	:begin
						enable_pc_sram		<=	`SramDisable;
					end
		//	conv
		JUDGE 		:begin
						enable_pc_sram 		<=	`SramDisable;
						size_act			<=	data_pc_in[7:0];
					end
		READ_TWO	:begin
						enable_pc_sram		<=	`SramEnable;
						wea_pc_sram			<=	`SramRead;
						address_pc_sram		<=	address_pc_sram	+ 1;
						size_act			<=	data_pc_in[7:0];
						model_saveunit 		<=	data_pc_in[12];
					end
		READ_THR 	:begin
						enable_pc_sram		<=	`SramEnable;
						wea_pc_sram			<=	`SramRead;
						address_pc_sram		<=	address_pc_sram	+ 1;
					end
		READ_FOU 	:begin
						enable_pc_sram		<=	`SramEnable;
						wea_pc_sram			<=	`SramRead;
						address_pc_sram		<=	address_pc_sram	+ 1;
						size_kernel			<=	data_pc_in[15:8];
						if(model == 4'h1)	begin
							number_pc_line 	<=	data_pc_in[7:4];
							stride 			<=	data_pc_in[3:0];
						end
						else if(model == 4'h3)	begin
							number_pc_line 	<=	data_pc_in[7:0];
							stride 			<=	8'h00;
						end
						
					end
		WAIT_TWO 	:begin
						enable_pc_sram		<=	`SramDisable;
						address_read_base	<=	data_pc_in;
						if(model ==	4'h1)	begin
							model_size_pe 		<=	size_kernel*size_kernel;
						end
						else begin
							model_size_pe 		<=	size_kernel;
						end
						
					end
		ENA_CONV 	:begin
						address_write_base 	<=	data_pc_in;
						if(model ==	4'h1)	begin
							enable_controller 	<=	`UnitEnable;
						end
						else begin
							enable_fc 			<=	`UnitEnable;
						end
						
					end
		//	pooler
		WAIT_FIV 	:begin
						enable_pc_sram 		<=	`SramDisable;
					end
		ENA_POOL 	:begin
						size_kernel 		<=	data_pc_in[15:8];
						number_pc_line 		<=	data_pc_in[7:0];
						enable_pooler   	<=	`UnitEnable;
					end
		//	relu
		RELU 		:begin
						enable_relu 		<=	`UnitEnable;
					end

		//	finish
		FINISH 		:begin
						end_signal 			<=	`Finish;
					end

		//	wait
		WAIT		:begin
						enable_pc_sram		<=	`SramDisable;
						enable_controller 	<=	`UnitDisable;
						enable_fc 			<=	`UnitDisable;
						enable_relu 		<=	`UnitDisable;
						enable_pooler  		<=	`UnitDisable;
						end_signal 			<=	`UnFinish;
					end
		UNIT_PRE 	:begin
						enable_pc_sram		<=	`SramDisable;
						wea_pc_sram			<=	`SramRead;
						address_pc_sram		<=	16'hffff;
						model_saveunit 		<= 	1'b0;
						model_size_pe 		<=	`EightBInit;
						enable_controller 	<=	`UnitDisable;
						enable_pooler 		<=	`UnitDisable;
						enable_fc 			<=	`UnitDisable;
						enable_relu 		<=	`UnitDisable;
						end_signal 			<=	`UnFinish;
					end
		endcase
	end
end

endmodule
