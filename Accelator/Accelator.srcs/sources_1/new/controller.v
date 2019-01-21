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


module controller(
	input 					clk,
	input					reset,
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
reg 				[7:0]	count;
reg 				[7:0]	count_act;

reg					[7:0]	row;
reg					[7:0]	column;

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
		address_act					<=	16'hffff;
		enable_act_sram				<=	1'b0;
		wea_act_sram 				<=	1'b0;

		address_kernel				<=	16'hffff;
		enable_kernel_sram			<=	1'b0;
		wea_kernel_sram 			<=	1'b0;
		
		enable_pe_array				<= 	1'b0;
		endsignal 					<=	1'b0;

		state						<=	s15;
		next_state 					<=	s15;
		count 						<=	8'h00;
		count_act 					<=	8'h00;

		row 						<= 	8'h00;
		column						<= 	8'h00;
	end
	else begin
		state  						<=	next_state;
	end
end

always@(*)
begin
	case(state)
	s15 :begin
			if(enable == 1'b1)	begin
				next_state 		=	s0;
			end
			else begin
				next_state 		=	s15;
			end
		end
	//	kernel
	s0 	:begin
			if(count == size_kernel*size_kernel*number_pc_line - 1)	begin
				next_state 	=	s1;
			end
			else begin
				next_state 	=	s0;
			end
		end
	//	column < size_kernel
	s1 	:begin
			if(count_act == size_kernel - 1 && column == size_kernel -1)	begin
				next_state	=	s4;
			end
			else begin
				next_state	=	s1;
			end
		end
	//	caculater
	s2 	:begin
			if(endsignal_saveunit)	begin
				if(row + size_kernel > size_act)	begin
					next_state 			=	s7;
				end
				else begin
					if(column	>=	size_kernel) begin
						next_state 		=	s3;
					end
					else begin
						next_state		=	s1;
					end
				end
			end
			else begin
				next_state 			=	s2;
			end
		end
	//	column > size_kernel
	s3 	:begin
			if(count_act == size_kernel - 1 && count == stride - 1)	begin
				next_state 			=	s4;
			end
			else begin
				next_state  		=	s3;
			end
		end

	//	wait time
	s4 	:begin
			next_state 			=	s5;
		end
	s5 	:begin
			next_state 			=	s6;
		end
	s6 	:begin
			next_state 			=	s2;
		end
	s7 	:begin
			next_state 			=	s15;
		end
	endcase
end

always@(posedge clk)
begin
	case(state)
	s0	:begin
			//	kernel
			address_kernel			=	address_kernel + 1;
			enable_kernel_sram 		=	1'b1;
			
			//	act
			address_act				=	address_read_base;
			enable_act_sram			=	1'b0;

			//	count
			if(count  <	size_kernel*size_kernel*number_pc_line)	begin
				count 	=	count + 1;
			end
			else begin
				count 	=	8'h00;
			end
		end
	s1	:begin
			//	kernel
			enable_kernel_sram		=	1'b0;
			//	act
			//	address_act
			address_act 			=	address_read_base + row + column *size_act + count_act;
			enable_act_sram			=	1'b1;
			count_act 				=	(count_act + 1)%size_kernel;
			if(count_act ==	8'h00)	begin
				column = column + 1;
			end

		end
	s2	:begin
			//	kernel
			enable_kernel_sram		=	1'b0;
			//	act
			enable_act_sram			=	1'b0;
			enable_pe_array 		=	1'b0;
			count 					=	8'h00;
			count_act				=	8'h00;
		end
	s3 	:begin
			address_act 			=	address_read_base + row + column*size_act + count_act;
			enable_act_sram			=	1'b1;
			count_act 				=	(count_act + 1)%size_kernel;
			if(count_act ==	8'h00)	begin
				column = (column + 1)%size_act;
				if(column == 8'h00)	begin
					row = row + stride;
				end
				count  = count + 1;
			end
		end
	s4 	:begin
			//	kernel
			enable_kernel_sram		=	1'b0;
			//	act
			enable_act_sram			=	1'b0;
			count 					=	8'h00;
			count_act				=	8'h00;
		end
	s6 	:begin
			enable_pe_array 	=	1'b1;
		end
	s7 	:begin
			endsignal 			=	1'b1;
		end
	s15 :begin
			endsignal 			=	1'b0;
			row 				= 	8'h00;
			column				= 	8'h00;
		end
	endcase
end

endmodule
