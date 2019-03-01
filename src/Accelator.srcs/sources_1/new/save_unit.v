`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/16 18:51:45
// Design Name: 
// Module Name: save_unit
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

`define  IsEnable(enable) 				(enable[5:0] != 6'b000000)
`define  IsFirstDim(model) 				(model 	==	1'b0)
`define  IsWriteAll(number,count)		(number ==	count)

module save_unit(
	input 					clk,
	input					rst_n,

	input 			[7:0]	size_act,
	input			[7:0]	size_kernel,
	input 			[15:0]	address_write_base,

	input			[5:0]	enable,

	input			[31:0]	data_result_1,
	input			[31:0]	data_result_2,
	input			[31:0]	data_result_3,
	input			[31:0]	data_result_4,
	input			[31:0]	data_result_5,
	input			[31:0]	data_result_6,

	input			[15:0]	data_in,////
	input 					model,

	output	reg 	[15:0]	address,
	output  reg 			enable_sram,
	output 	reg 			wea_sram,
	output	reg		[15:0]	data_out,
	output 	reg 			endsignal
    );

reg					[15:0]	reg_data_result[5:0];

reg 				[3:0]	state;
reg 				[3:0]	next_state;

reg 				[7:0]	count;
reg 				[7:0]	number;
reg  				[7:0]	row;
reg  				[7:0]	column;

localparam			[3:0]	
		WAIT 				= 4'b0000,
		REC_ENA			 	= 4'b0001,
		REC_ONE 		 	= 4'b0010,
		REC_TWO 		 	= 4'b0011,
		WAIT_ONE 			= 4'b0100,
		ADDRESS 		 	= 4'b0110,
		READ 			 	= 4'b0111,
		READ_ONE 		 	= 4'b1000,
		READ_TWO 			= 4'b1011,
		WRITE 			 	= 4'b1001,
		FINISH 				= 4'b1010,
		UNIT_PRE 			= 4'b1111;

reg 				[15:0]	address_init[5:0];
reg 				[15:0]	reg_size_feature_map;


always@(negedge rst_n or posedge clk)
begin
	if(rst_n == 1'b0) begin
		state 				<= 	UNIT_PRE;
	end
	else begin
		state 				<=	next_state;
	end
end

always@(*)
begin
	next_state 				=	state;
	case(state)
	// 			UNIT_PRE
	UNIT_PRE	:begin
					if(`IsEnable(enable))	begin
						next_state 	= 	REC_ENA;
					end
					else begin
						next_state 	= 	UNIT_PRE;
					end
				end
	// 			REC_ENA	input data
	REC_ENA 	:begin
					next_state		= 	REC_ONE;
				end
	// 			REC_ONE	wait
	REC_ONE		:begin
					next_state 		= 	REC_TWO;
				end
	//			REC_TWO  wait
	REC_TWO 	:begin
					if(`IsEnable(enable))	begin
						next_state 	= 	REC_ENA;
					end
					else begin
						next_state 	= 	ADDRESS;
					end
					
				end

	// 			caculater the address
	ADDRESS 	:begin
					if(`IsFirstDim(model))	begin
						next_state 	=	WRITE;
					end
					else begin
						next_state 	=	READ;
					end
				end

	// 			read the data
	READ 		:begin
					next_state 		=	READ_ONE;
				end
	READ_ONE 	:begin
					next_state 		=	READ_TWO;
				end
	READ_TWO 	:begin
					next_state 		=	WRITE;
				end

	// 			write the data
	WRITE 		:begin
					if(`IsWriteAll(number,count))	begin
						next_state 	=	FINISH;
					end
					else begin
						next_state 	=	ADDRESS;
					end
				end

	// 			end signal
	FINISH 		:begin
					next_state 		=	WAIT;
				end

	// 			wait without enable
	WAIT 		:begin
					if(`IsEnable(enable))	begin
						next_state 	=	REC_ENA;
					end
					else begin
						next_state 	=	WAIT;
					end
				end
	endcase
end

always@(posedge clk or posedge rst_n)
begin
	if(!rst_n)	begin
		address					<= 	16'h0000;
		enable_sram	 			<=	`SramDisable;
		wea_sram	 			<=	`SramRead;
		data_out				<=	16'h0000;
		endsignal 				<=	`UnFinish;
		reg_data_result[0] 		<=	8'h00;
		reg_data_result[1]		<=	8'h00;
		reg_data_result[2] 		<=	8'h00;
		reg_data_result[3]		<=	8'h00;
		reg_data_result[4]		<=	8'h00;
		reg_data_result[5]		<=	8'h00;
		row 					<=	8'h00;
		column 					<=	8'h00;
		number 					= 	8'h00;
		count 					=	8'h00;
	end
	else begin
		case(state)
		WAIT 			:begin
							enable_sram				<=	`SramDisable;
							wea_sram				<=	`SramRead;
							data_out				<=	16'h0000;
							endsignal 				<=	`UnFinish;
							number 					<= 	8'h00;
							count 					<=	8'h00;
						end
		REC_ENA			:begin
							address					<= 	16'h0000;
							enable_sram				<=	`SramDisable;
							wea_sram				<=	`SramRead;
							data_out				<=	16'h0000;
							reg_size_feature_map	<=	size_act - size_kernel + 1;
							count 					<=	count + 1;
						end
		REC_ONE 		:begin
							address_init[count - 1]	<=	address_write_base + (count - 1)*reg_size_feature_map*reg_size_feature_map;
						end

		WAIT_ONE 		:begin
							enable_sram 			<=	`SramDisable;
							wea_sram 				<=	`SramRead;
						end
		ADDRESS	 		:begin
							address					<= 	address_init[number] + row + column*reg_size_feature_map;
							enable_sram 			<=	`SramDisable;
							wea_sram 				<=	`SramRead;
							data_out 				<=	reg_data_result[number];
							number	 				<=	number + 1;
						end
		READ 			:begin
							enable_sram 			<=	`SramEnable;
							wea_sram 				<=	`SramRead;
						end
		READ_ONE 		:begin
							enable_sram 			<=	`SramDisable;
						end
		READ_TWO 		:begin
							data_out				<=	$signed(data_out) + $signed(data_in);
						end
		WRITE 			:begin
							enable_sram 			<=	`SramEnable;
							wea_sram 				<=	`SramWrite;
						end

		FINISH 			:begin
							endsignal 				<=	`Finish;
							enable_sram 			<= 	`SramDisable;
							wea_sram 				<=	`SramRead;
							column 					<=	(column + 1)%reg_size_feature_map;
							if(column == size_act - size_kernel)	begin
								if(row	==	reg_size_feature_map - 1)	begin
									row 			<=	8'h00;
								end
								else begin
									row 			<=	row + 1;
								end
							end
						end
		endcase
	end
	
end

always@(posedge enable[0])
begin
	reg_data_result[5] 	<= 	{data_result_6[31],data_result_6[29:15]};
end

always@(posedge enable[1])
begin
	reg_data_result[4] 	<= 	{data_result_5[31],data_result_5[29:15]};
end

always@(posedge enable[2])
begin
	reg_data_result[3] 	<= 	{data_result_4[31],data_result_4[29:15]};
end

always@(posedge enable[3])
begin
	reg_data_result[2] 	<= 	{data_result_3[31],data_result_3[29:15]};
end

always@(posedge enable[4])
begin
	reg_data_result[1] 	<= 	{data_result_2[31],data_result_2[29:15]};
end

always@(posedge enable[5])
begin
	reg_data_result[0] 	<= 	{data_result_1[31],data_result_1[29:15]};
end

endmodule
