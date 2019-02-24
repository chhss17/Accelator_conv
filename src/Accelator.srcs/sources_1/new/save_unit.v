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


module save_unit(
	input 					clk,
	input					reset,

	input 			[7:0]	size_act,
	input			[7:0]	size_kernel,
	input 			[7:0]	stride,
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

reg 				[2:0]	count;
reg 				[2:0]	number;
reg  				[7:0]	row;
reg  				[7:0]	column;

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

reg 				[15:0]	address_init[5:0];
reg 				[15:0]	reg_size_feature_map;


always@(posedge reset or posedge clk)
begin
	if(reset) begin
		reg_data_result[0] 	<=	8'h00;
		reg_data_result[1]	<=	8'h00;
		reg_data_result[2] 	<=	8'h00;
		reg_data_result[3]	<=	8'h00;
		reg_data_result[4]	<=	8'h00;
		reg_data_result[5]	<=	8'h00;
		address_init[0]		<=	16'h0000;
		address_init[1]		<=	16'h2aaa;
		address_init[2]		<=	16'h5554;
		address_init[3]		<=	16'h7ffe;
		address_init[4]		<=	16'haaa8;
		address_init[5]		<=	16'hd662;
		count 				<=	3'b000; 
		number 				<= 	3'b001;
		enable_sram			<= 	1'b0;
		state 				<= 	s15;
		next_state			<=	s15;
		row 				<=	8'h00;
		column 				<=	8'h00;
		endsignal 			<=	1'b0;
	end
	else begin
		state 				<=	next_state;
	end
end

always@(*)
begin
	case(state)
	// 	s0	start
	s15	:begin
			if(enable 		!= 6'b000000)	begin
				next_state 	 = s1;
			end
			else begin
				next_state 	 = s15;
			end
		end
	s0 	:begin
			if(enable 		!= 6'b000000)	begin
				next_state 	 = s1;
			end
			else begin
				next_state 	 = s0;
			end
		end
	// 	s1	input data
	s1	:begin
			next_state		= s2;
		end
	// 	s2	wait
	s2	:begin
			if(enable 		!= 6'b000000)	begin
				next_state 	 = s1;
			end
			else begin
				next_state 	 = s3;
			end
		end
	// 	s3	address
	s3	:begin
			if(model == 1'b1)	begin
				next_state		= s4;
			end
			else begin
				next_state 		= s9;
			end
		end
	// 	s4	read
	s4	:begin
			next_state		= s5;
		end
	s5 	:begin
			next_state 		= s6;
		end
	//	s6	add
	s6	:begin
			next_state		= s7;
		end
	// 	s6	write back
	s7	:begin
			if(number 	< 	count)	begin
				next_state	= s3;
				number 		= number + 1;
			end
			else begin
				next_state	= s8;
				count 		= 0;
				number 		= 1;
			end
		end
	s9 	:begin
			next_state 		= s10;
		end
	s10	:begin
			if(number 	< 	count)	begin
				next_state	= s3;
				number 		= number + 1;
			end
			else begin
				next_state	= s8;
				count 		= 0;
				number 		= 1;
			end
		end
	s8 	:begin
			next_state 		=	s0;
		end
	endcase
end

always@(posedge clk)
begin
	case(state)
	s15	:begin
			address		= 	16'h0000;
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	16'h0000;
			endsignal 		=	1'b0;
			reg_size_feature_map	=	size_act - size_kernel + 1;
			address_init[0]	=	address_write_base;
			address_init[1]	=	address_write_base + reg_size_feature_map*reg_size_feature_map;
			address_init[2]	=	address_write_base + 2*reg_size_feature_map*reg_size_feature_map;
			address_init[3]	=	address_write_base + 3*reg_size_feature_map*reg_size_feature_map;
			address_init[4]	=	address_write_base + 4*reg_size_feature_map*reg_size_feature_map;
			address_init[5]	=	address_write_base + 5*reg_size_feature_map*reg_size_feature_map;
		end
	s0 	:begin
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	16'h0000;
			endsignal 		=	1'b0;
			reg_size_feature_map	=	size_act - size_kernel + 1;
			address_init[0]	=	address_write_base;
			address_init[1]	=	address_write_base + reg_size_feature_map*reg_size_feature_map;
			address_init[2]	=	address_write_base + 2*reg_size_feature_map*reg_size_feature_map;
			address_init[3]	=	address_write_base + 3*reg_size_feature_map*reg_size_feature_map;
			address_init[4]	=	address_write_base + 4*reg_size_feature_map*reg_size_feature_map;
			address_init[5]	=	address_write_base + 5*reg_size_feature_map*reg_size_feature_map;
			
		end
	s1	:begin
			address		= 	16'h0000;
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	16'h0000;
			
		end
	s2	:begin
			address		= 	16'h0000;
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	16'h0000;
		end
	s3	:begin
			address		= 	address_init[number - 1] + row + column*reg_size_feature_map;
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	16'h0000;
		end
	s4	:begin
			enable_sram =	1'b1;
			wea_sram	=	1'b0;
		end
	s5 	:begin
			enable_sram =	1'b0;
			wea_sram	=	1'b0;
		end
	s6	:begin
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	$signed(reg_data_result[number - 1]) + $signed(data_in);
		end
	s7	:begin
			enable_sram	=	1'b1;
			wea_sram	=	1'b1;
		end
	s9 	:begin
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			data_out	=	reg_data_result[number - 1];
		end
	s10 :begin
			enable_sram	=	1'b1;
			wea_sram	=	1'b1;
		end
	s8 	:begin
			address		= 	16'h0000;
			enable_sram	=	1'b0;
			wea_sram	=	1'b0;
			endsignal 	=	1'b1;
			column = (column + 1)%(size_act - size_kernel + 1);
			if(column == 8'h00)	begin
				if(row < size_act - size_kernel) begin
					row = row + 1;
				end
				else begin
					row = 8'h00;
				end
			end
		end
	endcase
end

always@(posedge enable[0])
begin
	reg_data_result[5]	=	{data_result_6[31],data_result_6[29:15]};
	count 				=	count + 1;
end

always@(posedge enable[1])
begin
	reg_data_result[4]	=	{data_result_5[31],data_result_5[29:15]};
	count 				=	count + 1;
end

always@(posedge enable[2])
begin
	reg_data_result[3]	=	{data_result_4[31],data_result_4[29:15]};
	count 				=	count + 1;
end

always@(posedge enable[3])
begin
	reg_data_result[2]	=	{data_result_3[31],data_result_3[29:15]};
	count 				=	count + 1;
end

always@(posedge enable[4])
begin
	reg_data_result[1]	=	{data_result_2[31],data_result_2[29:15]};
	count 				=	count + 1;
end

always@(posedge enable[5])
begin
	reg_data_result[0]	=	{data_result_1[31],data_result_1[29:15]};
	count 				=	count + 1;
end

endmodule
