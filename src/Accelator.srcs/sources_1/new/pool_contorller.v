`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/20 02:51:13
// Design Name: 
// Module Name: pooler
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
`define  IsWrite(enable)		(enable == 1'b1)


module pooler_controller(
	input 						clk,
	input 						rst_n,
	input 						enable,
 
	input 				[ 7:0]	size_act,
	input 				[ 7:0]	size_kernel,////
	input 				[ 7:0]	number_feature,

	input 				[15:0]	data_in,

	output 		reg		[15:0]	address_read,
	output 		reg				enable_read_sram,
	output 		reg				wea_read_sram,

	output 		reg		[15:0]	address_write,
	output 		reg 			enable_write_sram,
	output		reg				wea_write_sram,

	output 		reg  	[15:0]	data_out,
	output		reg				endsignal
    );

reg						[3:0]	state;
reg 					[3:0]	next_state;
reg 					[15:0]	count;

wire 					[15:0]	wire_data_out;
wire 							wire_valid_op;
wire 					[15:0]	w_data_out;

reg 							enable_pooler;

localparam			[3:0]	
			READ_ONE 		= 4'b0000,
			READ_TWO 		= 4'b0001,
			WAIT_ONE 		= 4'b0010,
			WAIT_TWO 		= 4'b0011,
			WAIT_THR 		= 4'b0100,
			FINISH 			= 4'b0101,
			UNIT_PRE		= 4'b1111;

always@(negedge rst_n or posedge clk)
begin
	if(!rst_n)	begin
		state 				<=	UNIT_PRE;
	end
	else begin
		state 				<=	next_state;
	end
end

always@(*)
begin
    next_state              =  state;
	case(state)
	//  			
	UNIT_PRE		:begin
						if(`Isenable(enable))	begin
							next_state	=	READ_ONE;
						end
						else begin
							next_state	=	UNIT_PRE;
						end
					end

	//				read one
	READ_ONE 		:begin
						next_state		=	READ_TWO;
					end

	//				read two
	READ_TWO 		:begin			
						if(count	<	number_feature*size_act*size_act - 2)	begin
							next_state		=	READ_TWO;
						end
						else begin
							next_state		=	WAIT_ONE;
						end
					end

	// 				wait
	WAIT_ONE 		:begin
						next_state		=	WAIT_TWO;
					end
	WAIT_TWO 		:begin
						next_state		=	WAIT_THR;
					end
	WAIT_THR 		:begin
						next_state		=	FINISH;
					end

	//				finish
	FINISH 			:begin
						next_state		=	UNIT_PRE;
					end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		address_read 		<=	16'h0000;
		enable_read_sram 	<=	1'b0;
		wea_read_sram 		<=	1'b0;
		address_write		<=	16'hffff;
		enable_write_sram	<=	1'b0;
		wea_write_sram		<=	1'b1;
		endsignal 			<=	1'b0;
		enable_pooler 		<=	1'b0;
		count 				<=	16'h0000;
		data_out 			<=	16'h0000;
	end
	else begin
			data_out 		<=	w_data_out;
			case(state)
			//				pre
			UNIT_PRE 		:begin
								address_read 		<=	16'h0000;
								enable_read_sram 	<=	`SramDisable;
								wea_read_sram 		<=	`SramRead;
								address_write		<=	16'hffff;
								enable_write_sram	<=	`SramDisable;
								wea_write_sram		<=	`SramWrite;
								endsignal 			<=	`UnFinish;
								enable_pooler 		<=	`UnitDisable;
								count 				<=	16'h0000;
							end

			//				read one
			READ_ONE 		:begin
								enable_read_sram	<=	`SramEnable;
								wea_read_sram		<=	`SramRead;
								enable_pooler 		<=	`UnitEnable;
							end

			//				read two
			READ_TWO 		:begin
								enable_pooler 			<=	`UnitDisable;
								address_read			<=	address_read + 1;
								count 					<=	count + 1;
								if(`IsWrite(wire_valid_op))	begin
									address_write		<=	address_write + 1;
									enable_write_sram	<=	`SramEnable;
								end
								else begin
									enable_write_sram	<=	`SramDisable;
								end
							end

			// 				wait one
			WAIT_ONE 		:begin
								enable_read_sram		<=	`SramDisable;
								if(`IsWrite(wire_valid_op))	begin
									address_write		<=	address_write + 1;
									enable_write_sram	<=	`SramEnable;
								end
								else begin
									enable_write_sram	<=	`SramDisable;
								end
							end

			// 				wait two
			WAIT_TWO 		:begin
								if(`IsWrite(wire_valid_op))	begin
									address_write		<=	address_write + 1;
									enable_write_sram	<=	`SramEnable;
								end
								else begin
									enable_write_sram	<=	`SramDisable;
								end
							end

			// 				wait three
			WAIT_THR 		:begin
								if(`IsWrite(wire_valid_op))	begin
									address_write		<=	address_write + 1;
									enable_write_sram	<=	`SramEnable;
								end
								else begin
									enable_write_sram	<=	`SramDisable;
								end
							end

			//				finish
			FINISH 			:begin
								enable_read_sram	<=	`SramDisable;
								enable_write_sram 	<=	`SramDisable;
								endsignal 			<=	`Finish;
								enable_pooler 		<=	`UnitDisable;
								count				<=	16'h0000;
							end
			endcase
	end
end

pool_logic 	u_pooler_logic(
	.clk 					(clk),
	.rst_n 					(rst_n),
	.enable 	 			(enable_pooler),
	.size_act 				(size_act),
	.size_kernel 			(size_kernel),
	.number_feature 		(number_feature),
	.data_in 				(data_in),
	.data_out 				(wire_data_out),
	.valid_op 				(wire_valid_op));


relu	u_relu(
	.din_relu 				(wire_data_out),
	.dout_relu				(w_data_out));

endmodule
