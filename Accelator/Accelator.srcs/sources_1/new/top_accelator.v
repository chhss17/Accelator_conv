`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/30 20:47:23
// Design Name: 
// Module Name: top_accelator
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


module top_accelator(
	input					clk,
	input					reset,
	input 			[7:0]	size_act,
	input 			[7:0]	size_kernel,

	output	wire 	[15:0]	result
    );

reg 						wea_kernel_sram;
reg 						wea_act_sram;

reg 				[15:0]	reg_kernel_address;
reg 				[7:0]	reg_kernel_data_in;
reg 				[7:0]	reg_kernel_data_out;
reg 				[199:0]	reg_kernel_shift_reg_1;
reg 				[199:0]	reg_kernel_shift_reg_2;
reg 				[199:0]	reg_kernel_shift_reg_3;
reg 				[199:0]	reg_kernel_shift_reg_4;
reg 				[199:0]	reg_kernel_shift_reg_5;
reg 				[199:0]	reg_kernel_shift_reg_6;

reg 				[7:0]	reg_act_data_in;
reg 				[7:0]	reg_act_data_out;
reg 				[15:0]	reg_act_address;
reg 				[199:0]	reg_act_shift_reg;

reg 						enable_act_shift_reg;
wire 				[5:0]	enable_kernel_shift_reg;
reg 				[5:0]	reg_enable_kernel_shift_reg;

wire 				[15:0]	address_kernel;
wire 				[7:0]	kernel_data_out;
wire 				[199:0]	kernel_shift_reg_1;
wire 				[199:0]	kernel_shift_reg_2;
wire 				[199:0]	kernel_shift_reg_3;
wire 				[199:0]	kernel_shift_reg_4;
wire 				[199:0]	kernel_shift_reg_5;
wire 				[199:0]	kernel_shift_reg_6;

wire 				[15:0]	act_address;
wire 				[15:0]	act_data_out;
wire 				[199:0]	act_shift_reg;

wire 				[15:0]	psum_address;
wire 				[7:0]	data_sram_to_save;
wire 				[7:0]	data_save_to_sram;

reg 				[15:0]	psum_in_1;
reg 				[15:0]	psum_in_2;
reg 				[15:0]	psum_in_3;
reg 				[15:0]	psum_in_4;
reg 				[15:0]	psum_in_5;
reg 				[15:0]	psum_in_6;


wire 						end_signal_1;
wire 						end_signal_2;
wire 						end_signal_3;
wire 						end_signal_4;
wire 						end_signal_5;
wire 						end_signal_6;

wire 				[5:0]	enable_pe_array_line;

wire  				[15:0]	pe_array_result_1;
wire  				[15:0]	pe_array_result_2;
wire  				[15:0]	pe_array_result_3;
wire  				[15:0]	pe_array_result_4;
wire  				[15:0]	pe_array_result_5;
wire  				[15:0]	pe_array_result_6;

reg 				[5:0]	enable_save_unit;

reg  				[15:0]	reg_pe_array_result_1;
reg  				[15:0]	reg_pe_array_result_2;
reg  				[15:0]	reg_pe_array_result_3;
reg  				[15:0]	reg_pe_array_result_4;
reg  				[15:0]	reg_pe_array_result_5;
reg  				[15:0]	reg_pe_array_result_6;

reg 				[7:0]	reg_data_save_to_sram;
reg 				[7:0]	reg_data_sram_to_save;
reg 				[15:0]	reg_psum_address;


always@(posedge clk or posedge reset)
begin
	wea_kernel_sram 		= 1'b0;
	wea_act_sram			= 1'b0;

	enable_act_shift_reg 	= enable_act_sram;
	reg_enable_kernel_shift_reg	=	enable_kernel_shift_reg;

	reg_kernel_address		= address_kernel;
	reg_kernel_data_out 	= kernel_data_out;
	reg_kernel_shift_reg_1	= kernel_shift_reg_1;
	reg_kernel_shift_reg_2	= kernel_shift_reg_2;
	reg_kernel_shift_reg_3	= kernel_shift_reg_3;
	reg_kernel_shift_reg_4	= kernel_shift_reg_4;
	reg_kernel_shift_reg_5	= kernel_shift_reg_5;
	reg_kernel_shift_reg_6	= kernel_shift_reg_6;

	reg_act_address			= address_act;
	reg_act_data_out		= act_data_out;
	reg_act_shift_reg		= act_shift_reg;

	reg_pe_array_result_1	= pe_array_result_1;
	reg_pe_array_result_2	= pe_array_result_2;
	reg_pe_array_result_3	= pe_array_result_3;
	reg_pe_array_result_4	= pe_array_result_4;
	reg_pe_array_result_5	= pe_array_result_5;
	reg_pe_array_result_6	= pe_array_result_6;

	psum_in_1				= 16'h0000;
	psum_in_2				= 16'h0000;
	psum_in_3				= 16'h0000;
	psum_in_4				= 16'h0000;
	psum_in_5				= 16'h0000;
	psum_in_6				= 16'h0000;

	enable_save_unit 		= {end_signal_1,end_signal_2,end_signal_3,end_signal_4,end_signal_5,end_signal_6};

	reg_data_sram_to_save	= data_sram_to_save;
	reg_data_save_to_sram	= data_save_to_sram;
	reg_psum_address 		= psum_address;

end

// controller
controller u_controller(
	.clk 					(clk),
	.reset					(reset),
	.size_act 				(size_act),
	.size_kernel			(size_kernel),
	.address_act			(address_act),
	.enable_act_sram		(enable_act_sram),
	.address_kernel			(address_kernel),
	.enable_kernel_sram		(enable_kernel_sram),
	.enable_kernel_shift_reg(enable_kernel_shift_reg),
	.enable_pe_array		(enable_pe_array),
	.enable_pe_array_line	(enable_pe_array_line));


//kernel
blk_mem_kernel_gen u_kernel_sram(
	.clka					(clk),
	.ena 					(enable_kernel_sram),
	.wea					(wea_kernel_sram),
	.addra					(reg_kernel_address),
	.dina					(reg_kernel_data_in),
	.douta					(kernel_data_out));

shift_reg_act	u_kernel_shift_reg_1(
	.clk					(clk),
	.enable 				(reg_enable_kernel_shift_reg[0]),
	.input_data				(reg_kernel_data_out),
	.result					(kernel_shift_reg_1));

shift_reg_act	u_kernel_shift_reg_2(
	.clk					(clk),
	.enable 				(reg_enable_kernel_shift_reg[1]),
	.input_data				(reg_kernel_data_out),
	.result					(kernel_shift_reg_2));

shift_reg_act	u_kernel_shift_reg_3(
	.clk					(clk),
	.enable 				(reg_enable_kernel_shift_reg[2]),
	.input_data				(reg_kernel_data_out),
	.result					(kernel_shift_reg_3));

shift_reg_act	u_kernel_shift_reg_4(
	.clk					(clk),
	.enable 				(reg_enable_kernel_shift_reg[3]),
	.input_data				(reg_kernel_data_out),
	.result					(kernel_shift_reg_4));

shift_reg_act	u_kernel_shift_reg_5(
	.clk					(clk),
	.enable 				(reg_enable_kernel_shift_reg[4]),
	.input_data				(reg_kernel_data_out),
	.result					(kernel_shift_reg_5));

shift_reg_act	u_kernel_shift_reg_6(
	.clk					(clk),
	.enable 				(reg_enable_kernel_shift_reg[5]),
	.input_data				(reg_kernel_data_out),
	.result					(kernel_shift_reg_6));


//act
blk_mem_act_gen	u_act_sram(
	.clka					(clk),
	.ena 					(enable_act_sram),
	.wea					(wea_act_sram),
	.addra					(reg_act_address),
	.dina					(reg_act_data_in),
	.douta					(act_data_out));

shift_reg_act	u_act_shift_reg(
	.clk					(clk),
	.enable 				(enable_act_shift_reg),
	.input_data				(reg_act_data_out),
	.result					(act_shift_reg));


//pe array
pe_array 	u_pe_array(
	.clk					(clk),
	.reset					(reset),
	.enable 				(enable_pe_array),
	.enable_1				(enable_pe_array_line[0]),
	.enable_2				(enable_pe_array_line[1]),
	.enable_3				(enable_pe_array_line[2]),
	.enable_4				(enable_pe_array_line[3]),
	.enable_5				(enable_pe_array_line[4]),
	.enable_6				(enable_pe_array_line[5]),
	.kernel_1 				(reg_kernel_shift_reg_1),
	.kernel_2				(reg_kernel_shift_reg_2),
	.kernel_3 				(reg_kernel_shift_reg_3),
	.kernel_4 				(reg_kernel_shift_reg_4),
	.kernel_5 				(reg_kernel_shift_reg_5),
	.kernel_6 				(reg_kernel_shift_reg_6),
	.act 					(reg_act_shift_reg),
	.psum_in_1				(psum_in_1),
	.psum_in_2				(psum_in_2),
	.psum_in_3				(psum_in_3),
	.psum_in_4				(psum_in_4),
	.psum_in_5				(psum_in_5),
	.psum_in_6				(psum_in_6),
	.end_signal_1			(end_signal_1),
	.end_signal_2			(end_signal_2),
	.end_signal_3			(end_signal_3),
	.end_signal_4			(end_signal_4),
	.end_signal_5			(end_signal_5),
	.end_signal_6			(end_signal_6),
	.result_1				(pe_array_result_1),
	.result_2				(pe_array_result_2),
	.result_3				(pe_array_result_3),
	.result_4				(pe_array_result_4),
	.result_5				(pe_array_result_5),
	.result_6				(pe_array_result_6));


// save unit
save_unit	u_save_unit(
	.clk 					(clk),
	.reset 					(reset),
	.enable 				(enable_save_unit),
	.data_result_1 			(reg_pe_array_result_1),
	.data_result_2 			(reg_pe_array_result_2),
	.data_result_3 			(reg_pe_array_result_3),
	.data_result_4 			(reg_pe_array_result_4),
	.data_result_5 			(reg_pe_array_result_5),
	.data_result_6 			(reg_pe_array_result_6),
	.data_in 				(reg_data_sram_to_save),
	.address   				(psum_address),
	.enable_sram			(enable_sram),
	.wea_sram 				(wea_sram),
	.data_out 				(data_save_to_sram));


blk_mem_output_gen	u_output_sram(
	.clka 					(clk),
	.ena 					(enable_sram),
	.wea 					(wea_sram),
	.addra 					(reg_psum_address),
	.dina 					(reg_data_save_to_sram),
	.douta 					(data_sram_to_save));

endmodule
