`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2019 11:26:10 AM
// Design Name: 
// Module Name: pool_logic
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

module pool_logic(
	input 							clk,
	input 							rst_n,
	input 							enable,
	input  				[7:0]		size_act,
	input 				[7:0] 		size_kernel,
	input 				[7:0]		number_feature,
	input 				[15:0]		data_in,

	output 		reg		[15:0] 		data_out,
	output 		reg 				valid_op
    );

reg 					[3:0]		state;
reg 					[3:0]		next_state;

reg 					[7:0]		count;
reg 					[15:0]		number;
reg 					[7:0]		reg_index_shiftreg;
reg 					[15:0]		reg_dataout_1_max;
reg 					[15:0]		reg_datain_1_max;
wire 					[15:0]		wire_dataout_shiftreg;
wire 					[15:0]		wire_dataout_1_max;

wire 					[15:0]		wire_dataout;
reg 								reg_enable_shift_reg;


localparam			[3:0]	
				READ_PRE 				= 4'b0000,
				READ_ONE	 			= 4'b0001,
				READ_TWO 				= 4'b0010,
				WRITE_ONE	 			= 4'b0011,
				WRITE_TWO 				= 4'b0100,
				WRITE_THR 				= 4'b0101,
				WAIT 	 				= 4'b0110,
				FINISH 					= 4'b1000,
				UNIT_PRE				= 4'b1111;


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		state 		<=	UNIT_PRE;
	end
	else begin
		state 		<=	next_state;
	end
end

always@(*)
begin
	next_state		=	state;
	case(state)
	//				pre
	UNIT_PRE		:begin
						if(`Isenable(enable))	begin
							next_state 	=	READ_PRE;
						end
						else begin
							next_state	=	UNIT_PRE;
						end
					end

	//				read
	READ_PRE		:begin
						next_state		=	READ_ONE;
					end

	READ_ONE		:begin
						if(count < size_act - 1)	begin
							next_state 	=	READ_TWO;
						end
						else begin
							next_state	=	WRITE_ONE;
						end
					end
	READ_TWO 		:begin
						next_state		=	READ_ONE;
					end

	//				write
	WRITE_ONE 		:begin
						next_state		=	WRITE_TWO;
					end
	WRITE_TWO		:begin
						if(count < size_act - 1)	begin
							next_state	=	WRITE_THR;
						end
						else begin
							if(number < (size_act*number_feature)>>1)	begin
								next_state	=	READ_PRE;
							end
							else begin
								next_state	=	WAIT;
							end
						end
					end
	WRITE_THR 		:begin
						next_state 		=	WRITE_TWO;
					end

	//				finish
	WAIT 	 		:begin
						next_state		=	FINISH;
					end
	//				
	FINISH 			:begin
						next_state 		=	UNIT_PRE;
					end
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		count 					<=	8'h00;
		reg_index_shiftreg 		<=	8'h00;
		number 					<=	16'h0000;
		valid_op 				<=	`UnFinish;
		reg_enable_shift_reg 	<=	`UnitDisable;
		data_out 				<=	16'h0000;
	end
	else begin
		reg_dataout_1_max 		<=	wire_dataout_1_max;
		data_out 	 			<=	wire_dataout;
		case(state)
		UNIT_PRE 		:begin
							count 					<=	8'h00;
							reg_index_shiftreg 		<=	8'h00;
							number 					<=	16'h0000;
							reg_enable_shift_reg 	<=	`UnitDisable;
							data_out 				<=	16'h0000;
						end
		//				0
		READ_PRE 		:begin
							reg_datain_1_max		<=	data_in;
							reg_index_shiftreg		<=	size_act/2;
							count 					<=	(count + 1)%size_act;
							number 					<=	number + 1;
							valid_op 	 			<=	`UnFinish;
							data_out 				<=	16'h0000;
						end
	    // 				1
		READ_ONE 		:begin
							valid_op 	 			<=	`UnFinish;
							reg_enable_shift_reg	<=	`UnitEnable;
							count 					<=	(count + 1)%size_act;
						end
		//				2
		READ_TWO 		:begin
							reg_enable_shift_reg	<=	`UnitDisable;
							reg_datain_1_max		<=	data_in;
							count 					<=	(count + 1)%size_act;
						end

		//				3
		WRITE_ONE 		:begin
							reg_enable_shift_reg	<=	`UnitEnable;
							reg_dataout_1_max 		<=	16'h8000;
							valid_op 	 			<=	`UnFinish;
							reg_datain_1_max 		<=	data_in;
							count 					<=	(count + 1)%size_act;
						end
		//				4
		WRITE_TWO		:begin
							reg_enable_shift_reg	<=	`UnitDisable;
							valid_op 				<=	`Finish;
							count 					<=	(count + 1)%size_act;
						end
		//				5
		WRITE_THR		:begin
							reg_enable_shift_reg	<=	`UnitEnable;
							reg_dataout_1_max 		<=	16'h8000;
							valid_op 	 			<=	`UnFinish;
							reg_datain_1_max 		<=	data_in;
							count 					<=	(count + 1)%size_act;
						end
		//				6
		WAIT 	 		:begin
							valid_op 	 			<=	`Finish;
							
						end
		//				8
		FINISH 			:begin
							valid_op 	 			<=	`UnFinish;
						end
		endcase
	end
end


comparator2 comparator1(
    .ip1                (data_in),
    .ip2                (reg_datain_1_max),
    .mux_out            (wire_dataout_1_max));

comparator2 comparator2(
    .ip1                (wire_dataout_1_max),
    .ip2                (wire_dataout_shiftreg),
    .mux_out            (wire_dataout));

shifter_row shift3(
	.clk 				(clk),
	.rst_n 				(rst_n),
	.enable 			(reg_enable_shift_reg),
	.data_in 			(reg_dataout_1_max),
	.index 				(reg_index_shiftreg),
	.data_out 			(wire_dataout_shiftreg));

endmodule
