`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/13 14:45:18
// Design Name: 
// Module Name: controller
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

module controller(
	input 					clk,
	input					rst_n,
	input 					enable,
	input 					endsignal_saveunit,

	input 			[7:0]	size_act,
	input			[7:0]	size_kernel,
	input 			[7:0]	stride,
	input 			[7:0]	number_pc_line,
	input 			[15:0]	address_read_base,

	output	reg		[15:0]	address_act,
	output	reg				enable_act_sram,
	output 	reg 			wea_act_sram,

	output	reg		[15:0]	address_kernel,
	output	reg				enable_kernel_sram,
	output 	reg 			wea_kernel_sram,

	output	reg				enable_pe_array,
	output 	reg 			endsignal
    );

reg 				[3:0]	state;
reg 				[3:0]	next_state;
reg 				[15:0]	count;
reg 				[15:0]	count_act;

reg					[7:0]	row;
reg					[7:0]	column;

localparam 					ENABLE_EN = 1'b1;
localparam 					ENABLE_UN = 1'b0;

localparam			[3:0]	
				READ_KER 				= 4'b0000,
				READ_ACT_ONE 			= 4'b0001,
				CACULATE 				= 4'b0010,
				READ_ACT_TWO 			= 4'b0011,
				WAIT_ONE 				= 4'b0100,
				WAIT_TWO 				= 4'b0101,
				WAIT_THR 				= 4'b0110,
				FINISH 					= 4'b0111,
				UNIT_PRE				= 4'b1111;

always@(negedge rst_n or posedge clk)
begin
	if(rst_n == 1'b0)	begin
		state 				<=	UNIT_PRE;
	end
	else begin
		state  				<=	next_state;
	end
end

always@(*)
begin
	next_state 					=	state;
	case(state)
	// 				unit pre
	UNIT_PRE  		:begin
						if(`Isenable(enable))	begin
							next_state 		=	READ_KER;
						end
						else begin
							next_state 		=	UNIT_PRE;
						end
					end
	
	//				kernel
	READ_KER 		:begin
						if(count == (size_kernel*size_kernel+1)*number_pc_line - 1)	begin
							next_state 		=	READ_ACT_ONE;
						end
						else begin
							next_state 		=	READ_KER;
						end
					end

	//				column < size_kernel
	READ_ACT_ONE 	:begin
						if(count_act == size_kernel - 1 && column == size_kernel -1)	begin
							next_state		=	WAIT_ONE;
						end
						else begin
							next_state		=	READ_ACT_ONE;
						end
					end

	//				caculater
	CACULATE 		:begin
						if(endsignal_saveunit)	begin
							if(row + size_kernel > size_act)	begin
								next_state 			=	FINISH;
							end
							else begin
								if(column	>=	size_kernel) begin
									next_state 		=	READ_ACT_TWO;
								end
								else begin
									next_state		=	READ_ACT_ONE;
								end
							end
						end
						else begin
							next_state 			=	CACULATE;
						end
					end

	//				column > size_kernel
	READ_ACT_TWO 	:begin
						if(count_act == size_kernel - 1 && count == stride - 1)	begin
							next_state 			=	WAIT_ONE;
						end
						else begin
							next_state  		=	READ_ACT_TWO;
						end
					end

	//				wait time
	WAIT_ONE 		:begin
						next_state 			=	WAIT_TWO;
					end
	WAIT_TWO 		:begin
						next_state 			=	WAIT_THR;
					end
	WAIT_THR 		:begin
						next_state 			=	CACULATE;
					end

 	//				finish
	FINISH 			:begin
						next_state 			=	UNIT_PRE;
					end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		address_kernel				<=	16'hffff;
		wea_kernel_sram 			<=	`SramRead;
		enable_kernel_sram 			<=	`SramDisable;

		address_act 				<=	16'h0000;
		wea_act_sram 				<=	`SramRead;
		enable_act_sram 			<=	`SramDisable;

		row 						<=	8'h00;
		column 						<=	8'h00;

		enable_pe_array				<= 	1'b0;
		endsignal 					<=	`UnFinish;

		count 						<=	16'h0000;
		count_act 					<=	16'h0000;
	end
	else begin
		case(state)
		READ_KER		:begin
							//	kernel
							address_kernel			<=	address_kernel + 1;
							enable_kernel_sram		<=	`SramEnable;
							//	act
							address_act				<=	address_read_base;
							enable_act_sram			<=	`SramDisable;
							if(count  <	(size_kernel*size_kernel + 1)*number_pc_line - 1)	begin
								count 				<=	count + 1;
							end
							else begin
								count 				<=	16'h00;
							end
						end

		READ_ACT_ONE	:begin
							//	kernel
							enable_kernel_sram		<=	`SramDisable;
							//	act
							//	address_act
							if(count_act ==	16'h0000)	begin
								address_act 		<=	address_read_base + row + column *size_act;
							end
							else begin
								address_act 		<=  address_act + 1;
							end
							
							enable_act_sram			<=	`SramEnable;
							count_act 				<=	(count_act + 1)%size_kernel;
							if(count_act ==	size_kernel - 1)	begin
								column 				<= column + 1;
							end
						end

		CACULATE		:begin
							//	kernel
							enable_kernel_sram		<=	`SramDisable;
							//	act
							enable_act_sram			<=	`SramDisable;
							enable_pe_array 		<=	`SramDisable;
							count 					<=	16'h0000;
							count_act				<=	8'h00;
						end

		READ_ACT_TWO 	:begin
							if(count_act == 16'h0000)	begin
								address_act 		<=	address_read_base + row + column*size_act;
							end
							else begin
								address_act 		<=	address_act + 1;
							end
							
							enable_act_sram			<=	`SramEnable;
							count_act 				<=	(count_act + 1)%size_kernel;
							if(count_act ==	size_kernel - 1)	begin
								column 				<= (column + 1)%size_act;
								
								count 				<=	count + 1;
							end
						end

		WAIT_ONE 		:begin
							//	kernel
							enable_kernel_sram		<=	1'b0;
							//	act
							enable_act_sram			<=	1'b0;
							count 					<=	16'h00;
							count_act				<=	16'h00;
							if(column == 8'h00)	begin
								row 				<= row + stride;
							end
						end

		WAIT_THR 		:begin
							enable_pe_array 		<=	1'b1;
						end

		FINISH 			:begin
							endsignal 				<=	1'b1;
						end

		UNIT_PRE 		:begin
							endsignal 				<=	1'b0;
							row 					<= 	8'h00;
							column					<= 	8'h00;
							enable_act_sram			<=	1'b0;
							enable_kernel_sram		<=	1'b0;
						end
		endcase
	end
	
end

endmodule
