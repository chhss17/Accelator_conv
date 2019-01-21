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


module pooler_controller(
	input 						clk,
	input 						reset,
	input 						enable,

	input 				[7:0]	size_act,
	input 				[7:0]	size_kernel,
	input 				[7:0]	number_feature,

	input 				[7:0]	data_in,

	output 		reg		[15:0]	address_read,
	output 		reg				enable_read_sram,
	output 		reg				wea_read_sram,

	output 		reg		[15:0]	address_write,
	output 		reg 			enable_write_sram,
	output		reg				wea_write_sram,

	output 		reg 	[7:0]	data_out,
	output		reg				endsignal
    );

reg						[3:0]	state;
reg 					[3:0]	next_state;
reg 					[15:0]	count;

wire 					[7:0]	wire_data_out;
wire 							wire_valid_op;
wire 							wire_endsignal;

reg 							enable_pooler;

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
		address_read 		<=	16'h0000;
		enable_read_sram 	<=	1'b0;
		wea_read_sram 		<=	1'b0;
		address_write		<=	16'h0000;
		enable_write_sram	<=	1'b0;
		wea_write_sram		<=	1'b1;

		data_out			<=	8'h00;
		endsignal			<=	1'b0;

		state 				<=	s15;
		next_state 			<=	s15;
		count 				<=	16'h0000;

		enable_pooler 		<=	1'b0;
	end
	else begin
		state 				<=	next_state;
	end
end

always@(*)
begin
	case(state)
	s15	:begin
			if(enable)	begin
				next_state	=	s0;
			end
			else begin
				next_state	=	s15;
			end
		end
	s0 	:begin
			next_state		=	s1;
		end
	s1 	:begin			
			if(count	<	number_feature*size_act*size_act - 2)	begin
				next_state		=	s1;
			end
			else begin
				next_state		=	s2;
			end
		end
	s2 	:begin
			next_state		=	s3;
		end
	s3 	:begin
			next_state		=	s4;
		end
	s4 	:begin
			next_state		=	s5;
		end
	s5 	:begin
			next_state		=	s15;
		end
	endcase
end

always@(posedge clk)
begin
	case(state)
	s15 :begin
			address_read 		<=	16'h0000;
			enable_read_sram 	<=	1'b0;
			wea_read_sram 		<=	1'b0;
			address_write		<=	16'hffff;
			enable_write_sram	<=	1'b0;
			wea_write_sram		<=	1'b1;
			endsignal 			<=	1'b0;
			enable_pooler 		<=	1'b0;
		end
	s0 	:begin
			enable_read_sram	<=	1'b1;
			wea_read_sram		<=	1'b0;
			enable_pooler 		<=	1'b1;
		end
	s1 	:begin
			enable_pooler 		<=	1'b0;
			address_read		<=	address_read + 1;
			count 				<=	count + 1;
			data_out 			<=	wire_data_out;
			if(wire_valid_op == 1'b1)	begin
				address_write	<=	address_write + 1;
				enable_write_sram	<=	1'b1;
			end
			else begin
				enable_write_sram	<=	1'b0;
			end
		end
	s2 	:begin
			if(wire_valid_op == 1'b1)	begin
				address_write	<=	address_write + 1;
				enable_write_sram	<=	1'b1;
			end
			else begin
				enable_write_sram	<=	1'b0;
			end
		end
	s3 	:begin
			if(wire_valid_op == 1'b1)	begin
				address_write	<=	address_write + 1;
				enable_write_sram	<=	1'b1;
			end
			else begin
				enable_write_sram	<=	1'b0;
			end
		end
	s4 	:begin
			if(wire_valid_op == 1'b1)	begin
				address_write	<=	address_write + 1;
				enable_write_sram	<=	1'b1;
			end
			else begin
				enable_write_sram	<=	1'b0;
			end
		end
	s5 	:begin
			enable_read_sram	<=	1'b0;
			enable_write_sram 	<=	1'b0;
			endsignal 			<=	1'b1;
			count				<=	16'h0000;
		end
	endcase
end

pooler u_pooler(
	.clk 					(clk),
	.enable 				(enable_pooler),
	.master_rst 			(reset),
	.size_act 				(size_act),
	.size_pool_kernel 		(size_kernel),
	.num_feature 			(number_feature),
	.data_in 				(data_in),
	.data_out 				(wire_data_out),
	.valid_op 				(wire_valid_op),
	.end_pool 				(wire_endsignal));

endmodule
