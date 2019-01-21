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


module decode(
	input 					clk,
	input					reset,
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

	output	reg 			enable_controller,
	output	reg				enable_pooler
    );

reg					[3:0]		state;
reg 				[3:0]		next_state;
reg					[7:0]		model;
reg					[7:0]		size_act;

localparam			[3:0]	s0 	= 4'b0000,
							s1 	= 4'b0001,
							s2 	= 4'b0010,
							s3 	= 4'b0011,
							s4 	= 4'b0100,
							s5 	= 4'b0101,
							s6 	= 4'b0110,
							s7 	= 4'b0111,
							s8 	= 4'b1000,
							s9 	= 4'b1001,
							s10	= 4'b1010,
							s11	= 4'b1011,
							s12	= 4'b1100,
							s13	= 4'b1101,
							s14	= 4'b1110,
							s15	= 4'b1111;

always@(posedge reset or posedge clk)
begin
	if(reset)	begin
		enable_pc_sram		<=	1'b0;
		wea_pc_sram			<=	1'b0;
		address_pc_sram		<=	16'hffff;

		model 				<=	8'h00;
		state				<=	s15;
		next_state			<=	s0;

		enable_controller 	<=	1'b0;
		enable_pooler 		<=	1'b0;
	end
	else begin
		state 				<=	next_state;
	end
end


always@(*)
begin
	case(state)
	//	start
	s15 :begin
			next_state		=	s0;
		end
	s0	:begin
			next_state		=	s1;
		end
	s1 	:begin
			next_state 		=	s2;
		end
	s2	:begin
			model 			=	data_pc_in[15:8];
			if(model ==	8'hff)	begin
				next_state	=	s14;
			end
			else begin
				next_state	=	s3;
			end
		end

	//	conv
	s3	:begin
			if(model == 8'h01)	begin
				next_state	=	s4;
			end
			else begin
				next_state 	=	s8;
			end
		end
	s4 	:begin
			next_state		=	s5;
		end
	s5 	:begin
			next_state		=	s6;
		end
	s6 	:begin
			next_state 		=	s7;
		end
	s7 	:begin
			next_state 		=	s14;
		end

	//	pooler
	s8 	:begin
			next_state 		=	s9;
		end
	s9 	:begin
			next_state 		=	s14;
		end

	//	wait
	s14 	:begin
			if(enable)	begin
				next_state	=	s0;
			end
			else begin
				next_state	=	s14;
			end
		end
	endcase
end

always@(posedge clk)
begin
	case(state)
	s0	:begin
			enable_pc_sram		=	1'b1;
			wea_pc_sram			=	1'b0;
			address_pc_sram		=	address_pc_sram	+ 1;
		end
	s1	:begin
			enable_pc_sram		=	1'b0;
		end
	//	conv
	s2 	:begin
			enable_pc_sram 		=	1'b0;
		end
	s3	:begin
			enable_pc_sram		=	1'b1;
			wea_pc_sram			=	1'b0;
			address_pc_sram		=	address_pc_sram	+ 1;
			size_act			=	data_pc_in[7:0];
		end
	s4 	:begin
			enable_pc_sram		=	1'b1;
			wea_pc_sram			=	1'b0;
			address_pc_sram		=	address_pc_sram	+ 1;
		end
	s5 	:begin
			enable_pc_sram		=	1'b1;
			wea_pc_sram			=	1'b0;
			address_pc_sram		=	address_pc_sram	+ 1;
			size_kernel			=	data_pc_in[15:8];
			number_pc_line 		=	data_pc_in[7:4];
			stride 				=	data_pc_in[3:0];
		end
	s6 	:begin
			enable_pc_sram		=	1'b0;
			address_read_base	=	data_pc_in;
		end
	s7 	:begin
			address_write_base 	=	data_pc_in;
			enable_controller 	=	1'b1;
		end
	//	pooler
	s8 	:begin
			enable_pc_sram 		=	1'b0;
		end
	s9 	:begin
			size_kernel 		=	data_pc_in[15:8];
			number_pc_line 		=	data_pc_in[7:0];
			enable_pooler   	=	1'b1;
		end
	//	wait
	s14	:begin
			enable_pc_sram		=	1'b0;
			enable_controller 	=	1'b0;
			enable_pooler  		=	1'b0;
		end
	endcase
end

endmodule
