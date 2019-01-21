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

	input 			[7:0]	size_act,
	input			[7:0]	size_kernel,

	output	reg		[15:0]	address_act,
	output	reg				enable_act_sram,

	output	reg		[15:0]	address_kernel,
	output	reg				enable_kernel_sram,
	output	reg		[5:0]	enable_kernel_shift_reg,

	output	reg				enable_pe_array,

	output	reg 	[5:0]	enable_pe_array_line
    );

reg 				[1:0]	state;
reg 				[7:0]	count;
reg 				[7:0]	count_act;

reg					[7:0]	row;
reg					[7:0]	column;

localparam			[1:0]	s0	=	2'b00,
							s1	=	2'b01,
							s2	=	2'b10;

always@(posedge reset)
begin
	address_act					=	16'hffff;
	enable_act_sram				=	1'b0;

	address_kernel				=	16'hffff;
	enable_kernel_sram			=	1'b0;
	enable_kernel_shift_reg		=	6'b000000;
	
	enable_pe_array				= 	1'b0;
	enable_pe_array_line		=	6'b000000;

	state						=	s0;
	count 						=	8'h00;
	count_act 					=	8'hff;

	row 						= 8'h01;
	column						= 8'h00;
end

always@(posedge clk)
begin
	//	s0
	if(state			==	s0)	begin
		if(count 		<=	151)	begin  			//	5*5*6
			state		<=	s0;
			count		<=	count + 1;
		end
		else begin
			state		<=	s1;
			count 		<=	8'h00;
		end
	end
	//	s1
	if(state 			==	s1)	begin
		if(count_act 	==	8'h04) begin
			if(column == size_act) begin
				row 	<= row + 1;
				column 	<= 8'h00;
			end
			else begin
				column 	<= column + 1;
			end
			if(column	>=	8'h04)	begin
				state	<=	s2;
				count_act 	<=	8'hff;
			end
			else begin
				state	<=	s1;
				count_act 	<=	8'h00;
			end
			
		end
		else begin
			count_act	<=	count_act + 1;
			state		<=	s1;
		end
	end
	//	s2
	if(state			==	s2)	begin
		if(count 		<=	60)	begin
			state		<=	s2;
			count		<=	count + 1;
		end
		else begin
			state 		<=	s1;
			count 		<=	8'h00;
		end
	end
end

always@(posedge clk)
begin
	case(state)
	s0	:begin
			//	kernel
			//	address_kernel
			if(count 	<=	150)	begin
				address_kernel	=	address_kernel + 1;	
			end
			//	enable_kernel_sram
			if(count 		<=	150)	begin
				enable_kernel_sram	=	1'b1;
			end
			else begin
				enable_kernel_sram	=	1'b0;
			end
			//	enable_kernel_shift_reg
			if(count	> 	1 && count	<=	26)		begin
				enable_kernel_shift_reg	=	6'b000001;
			end
			else if(count	>	26 && count	<=	51)	begin
				enable_kernel_shift_reg	=	6'b000010;
			end
			else if(count	>	51 && count	<=	76)	begin
				enable_kernel_shift_reg	=	6'b000100;
			end
			else if(count	>	76 && count	<=	101)begin
				enable_kernel_shift_reg	=	6'b001000;
			end
			else if(count	>  101 && count	<=	126)begin
				enable_kernel_shift_reg	=	6'b010000;
			end
			else if(count	>  126 && count	<=	151)begin
				enable_kernel_shift_reg	=	6'b100000;
			end
			//	act
			address_act				=	16'hffff;
			enable_act_sram			=	1'b0;
		end
	s1	:begin
			//	kernel
			address_kernel			=	16'h0000;
			enable_kernel_sram		=	1'b0;
			enable_kernel_shift_reg	=	6'b000000;
			//	act
			//	address_act
			if(count_act		==	8'h04) begin
				if(column 		== size_act) begin
					address_act = row;
				end
				else begin
					address_act = address_act + size_act - size_kernel + 1;
				end
			end
			else begin
				address_act 	= address_act + 1;
			end
			enable_act_sram			=	1'b1;
		end
	s2	:begin
			//	kernel
			address_kernel			=	16'hffff;
			enable_kernel_sram		=	1'b0;
			enable_kernel_shift_reg	=	1'b0;
			//	act
			enable_act_sram			=	1'b0;
			//	pe array
			if(count ==	3)	begin
				enable_pe_array 	=	1'b1;
			end
			else begin
				enable_pe_array 	=	1'b0;
			end
			enable_pe_array_line 	=	6'b111111;
		end
	endcase
end

endmodule
