`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/15 14:30:41
// Design Name: 
// Module Name: decode_sram
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


module decode_sram(
	input 				clk,
	input 				rst_n,
	input 				enable,

	input 		[1:0]	mode,
	input 				ena,
	input 				wea,
	input 		[15:0]	data_in,
	input 		[16:0]	address,

	output 				end_mode
    );
//	pc_paramater
wire 		[15:0]		wire_pc_sram_to_decode;


//	decode
wire 					wire_enable_pc_sram;
wire 					wire_wea_pc_sram;
wire 		[15:0]		wire_address_pc_sram;
wire 		[7:0]		wire_size_act;
wire 		[7:0]		wire_size_kernel;
wire 		[7:0]		wire_stride;
wire 		[7:0]		wire_number_pc_line;
wire 		[15:0]		wire_address_read_base;
wire 		[15:0]		wire_address_write_base;
wire 					wire_mode_saveunit;
wire 		[7:0]		wire_model_size_pe;
wire 					wire_enable_controller;
wire 					wire_enable_pooler;
wire 					wire_enable_fc;
wire 					wire_enable_relu;

//	controller
wire 		[15:0]		wire_address_controller_to_act_sram;
wire 					wire_enable_controller_to_act_sram;
wire 					wire_wea_controller_to_act_sram;
wire 		[15:0]		wire_address_controller_to_kernel_sram;
wire 					wire_enable_controller_to_kernel_sram;
wire 					wire_wea_controller_to_kernel_sram;
wire 					wire_enable_controller_pe_array;
wire 					wire_endsignal_contorller;

//	act sram
wire 					wire_enable_act_sram;
wire 					wire_wea_act_sram;
wire 		[15:0]		wire_datain_act_sram;////
wire 		[15:0]		wire_address_act_sram;
wire 		[15:0]		wire_dataout_act_sram;////

//	output sram
wire 					wire_enable_output_sram;
wire 					wire_wea_output_sram;
wire 		[15:0]		wire_datain_output_sram;////
wire 		[15:0]		wire_address_output_sram;
wire 		[15:0]		wire_dataout_output_sram;////

//	kernel sram
wire 					wire_enable_kernel_sram;
wire 					wire_wea_kernel_sram;
wire 		[15:0]		wire_datain_kernel_sram;
wire 		[15:0]		wire_address_kernel_sram;
wire 		[15:0]		wire_dataout_kernel_sram;

//	kernerl shiftreg
// wire 		[2495:0]	wire_kernel_shift_reg_data_out;
wire 					wire_enable_kernel_shiftreg_1;
wire 					wire_enable_kernel_shiftreg_2;
wire 					wire_enable_kernel_shiftreg_3;
wire 					wire_enable_kernel_shiftreg_4;
wire 					wire_enable_kernel_shiftreg_5;
wire 					wire_enable_kernel_shiftreg_6;
wire 		[415:0] 	wire_kernel_shift_reg_data_out_1;
wire 		[415:0] 	wire_kernel_shift_reg_data_out_2;
wire 		[415:0] 	wire_kernel_shift_reg_data_out_3;
wire 		[415:0] 	wire_kernel_shift_reg_data_out_4;
wire 		[415:0] 	wire_kernel_shift_reg_data_out_5;
wire 		[415:0] 	wire_kernel_shift_reg_data_out_6;

//	act shiftreg
wire 		[399:0]		wire_act_shift_reg_data_out;////

//	pe array
wire 					wire_pe_array_end_signal_1;
wire 					wire_pe_array_end_signal_2;
wire 					wire_pe_array_end_signal_3;
wire 					wire_pe_array_end_signal_4;
wire 					wire_pe_array_end_signal_5;
wire 					wire_pe_array_end_signal_6;
wire 		[31:0]		wire_pe_array_pe_array_result_1;
wire 		[31:0]		wire_pe_array_pe_array_result_2;
wire 		[31:0]		wire_pe_array_pe_array_result_3;
wire 		[31:0]		wire_pe_array_pe_array_result_4;
wire 		[31:0]		wire_pe_array_pe_array_result_5;
wire 		[31:0]		wire_pe_array_pe_array_result_6;

//	save unit
wire 					wire_endsignal_saveunit;
wire 					wire_enable_saveunit_to_output_sram;
wire 					wire_wea_saveunit_to_output_sram;
wire 		[15:0]		wire_datain_saveunit_to_output_sram;///
wire 		[15:0]		wire_address_saveunit_to_output_sram;

//	pooler
wire 					wire_endsignal_pooler;
wire 					wire_enable_pooler_to_output_sram;
wire 					wire_wea_pooler_to_output_sram;
wire 		[15:0]		wire_address_pooler_to_output_sram;
wire 					wire_enable_pooler_to_act_sram;
wire 					wire_wea_pooler_to_act_sram;
wire 		[15:0]		wire_datain_pooler_to_act_sram;////
wire 		[15:0]		wire_address_pooler_to_act_sram;


//	fc
wire 		[15:0]		wire_address_fc_to_kernel_sram;
wire 					wire_enable_fc_to_kernel_sram;
wire 					wire_wea_fc_to_kernel_sram;
wire 		[15:0]		wire_address_fc_to_act_sram;
wire 					wire_enable_fc_to_act_sram;
wire 					wire_wea_fc_to_act_sram;
wire 					wire_enable_fc_to_pe_array;
wire 					wire_endsignal_fc;

//	relu
wire 		[15:0]		wire_address_relu_to_output_sram;
wire 					wire_enable_relu_to_output_sram;
wire 					wire_wea_relu_to_output_sram;
wire 		[15:0]		wire_address_relu_to_act_sram;
wire 					wire_enable_relu_to_act_sram;
wire 					wire_wea_relu_to_act_sram;
wire 		[15:0]		wire_datain_relu_to_act_sram;
wire 					wire_endsignal_relu;


//	not important parameter
reg 		[15:0]		reg_datain_pc_sram;
reg 		[15:0]		reg_datain_act_sram;
reg 		[15:0]		reg_datain_kernel_sram;
reg 		[15:0]		reg_datain_output_sram;

wire  		[5:0]		wire_enable_pe_line;

reg 		[15:0]		reg_pe_array_psum_in_0;
reg 		[15:0]		reg_pe_array_psum_in_1;
reg 		[15:0]		reg_dataout_kernel_sram;


always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		reg_datain_pc_sram				<=	16'h00;
		reg_datain_act_sram				<=	16'h00;
		reg_datain_kernel_sram			<=	16'h00;
		reg_datain_output_sram			<=	16'h00;
	end
	else begin
		reg_dataout_kernel_sram 			<=		wire_dataout_kernel_sram;

		reg_pe_array_psum_in_0 				<=		16'h0000;
		reg_pe_array_psum_in_1 				<=		16'hffff;
	end
end

/*******************************	DECODE 	*********************************/
//	decode
decode 	u_decode(
	.clk 				(clk),
	.rst_n 				(rst_n),
	.enable				((enable||wire_endsignal_contorller||wire_endsignal_pooler||wire_endsignal_fc||wire_endsignal_relu)),
	.data_pc_in 		(wire_pc_sram_to_decode),

	.enable_pc_sram 	(wire_enable_pc_sram),
	.wea_pc_sram 		(wire_wea_pc_sram),
	.address_pc_sram	(wire_address_pc_sram),

	.size_act 			(wire_size_act),
	.size_kernel 		(wire_size_kernel),
	.stride 			(wire_stride),
	.number_pc_line 	(wire_number_pc_line),

	.address_read_base 	(wire_address_read_base),
	.address_write_base (wire_address_write_base),

	.model_saveunit 	(wire_mode_saveunit),
	.model_size_pe 	 	(wire_model_size_pe),

	.enable_controller 	(wire_enable_controller),
	.enable_pooler 		(wire_enable_pooler),
	.enable_fc 			(wire_enable_fc),
	.enable_relu 		(wire_enable_relu),
	.end_signal 		(end_mode));



/*******************************	MODULE 	*********************************/
//	controller
controller 	u_controller(
	.clk 					(clk),
	.rst_n					(rst_n),

	.enable 				(wire_enable_controller),
	.endsignal_saveunit 	(wire_endsignal_saveunit),

	.size_act 				(wire_size_act),
	.size_kernel			(wire_size_kernel),
	.stride 				(wire_stride),
	.number_pc_line 		(wire_number_pc_line),
	.address_read_base 		(wire_address_read_base),

	.address_act			(wire_address_controller_to_act_sram),
	.enable_act_sram		(wire_enable_controller_to_act_sram),
	.wea_act_sram 			(wire_wea_controller_to_act_sram),

	.address_kernel			(wire_address_controller_to_kernel_sram),
	.enable_kernel_sram		(wire_enable_controller_to_kernel_sram),
	.wea_kernel_sram 		(wire_wea_controller_to_kernel_sram),

	.enable_pe_array		(wire_enable_controller_pe_array),
	.endsignal 				(wire_endsignal_contorller));

//	pooler
pooler_controller 	u_pooler_controller(
	.clk 					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_pooler),

	.size_act 				(wire_size_act),
	.size_kernel 			(wire_size_kernel),
	.number_feature 		(wire_number_pc_line),
	.data_in 				(wire_dataout_output_sram),

	.address_read 			(wire_address_pooler_to_output_sram),
	.enable_read_sram  		(wire_enable_pooler_to_output_sram),
	.wea_read_sram 			(wire_wea_pooler_to_output_sram),

	.address_write 			(wire_address_pooler_to_act_sram),
	.enable_write_sram		(wire_enable_pooler_to_act_sram),
	.wea_write_sram 		(wire_wea_pooler_to_act_sram),
	.data_out 				(wire_datain_pooler_to_act_sram),

	.endsignal 				(wire_endsignal_pooler));

//	full connect
fc 	u_fc(
	.clk 						(clk),
	.rst_n 						(rst_n),
	.enable 					(wire_enable_fc),
	.endsignal_saveunit 		(wire_endsignal_saveunit),

	.size_act 					(wire_size_act),
	.number_pc_line 			(wire_number_pc_line),
	.address_read_act_base 		(wire_address_read_base),
	.address_read_kernel_base	(wire_address_controller_to_kernel_sram),

	.ena_kernel_sram 			(wire_enable_fc_to_kernel_sram),
	.wea_kernel_sram 			(wire_wea_fc_to_kernel_sram),
	.address_kernel_sram 		(wire_address_fc_to_kernel_sram),

	.ena_act_sram 				(wire_enable_fc_to_act_sram),
	.wea_act_sram 				(wire_wea_fc_to_act_sram),
	.address_act_sram 			(wire_address_fc_to_act_sram),

	.enable_pe_array 			(wire_enable_fc_to_pe_array),
	.end_signal 				(wire_endsignal_fc));

//	relu
RE 	u_relu(
	.clk 						(clk),
	.rst_n 						(rst_n),
	.enable 					(wire_enable_relu),
	.size_act 					(wire_size_act),
	.data_in 					(wire_dataout_output_sram),
	.ena_output_sram 			(wire_enable_relu_to_output_sram),
	.wea_output_sram 			(wire_wea_relu_to_output_sram),
	.address_output_sram 		(wire_address_relu_to_output_sram),
	.ena_act_sram 				(wire_enable_relu_to_act_sram),
	.wea_act_sram 				(wire_wea_relu_to_act_sram),
	.address_act_sram 			(wire_address_relu_to_act_sram),
	.dataout_act_sram 			(wire_datain_relu_to_act_sram),
	.end_signal 				(wire_endsignal_relu));


/*******************************	SHIFT REG 	*********************************/

MODE_SHIFTREG 	u_kernel_model(
	.clk 					(clk),
	.rst_n 					(rst_n),
	.size_act 				(wire_model_size_pe),
	.enable 				(wire_enable_kernel_sram),
	.enable_1 				(wire_enable_kernel_shiftreg_1),
	.enable_2 				(wire_enable_kernel_shiftreg_2),
	.enable_3 				(wire_enable_kernel_shiftreg_3),
	.enable_4 				(wire_enable_kernel_shiftreg_4),
	.enable_5 				(wire_enable_kernel_shiftreg_5),
	.enable_6 				(wire_enable_kernel_shiftreg_6));

demo_shift_reg 	u_kernel_shift_reg_1(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_kernel_shiftreg_1),
	.input_data				(reg_dataout_kernel_sram),
	.result					(wire_kernel_shift_reg_data_out_1));

demo_shift_reg 	u_kernel_shift_reg_2(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_kernel_shiftreg_2),
	.input_data				(reg_dataout_kernel_sram),
	.result					(wire_kernel_shift_reg_data_out_2));

demo_shift_reg 	u_kernel_shift_reg_3(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_kernel_shiftreg_3),
	.input_data				(reg_dataout_kernel_sram),
	.result					(wire_kernel_shift_reg_data_out_3));

demo_shift_reg 	u_kernel_shift_reg_4(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_kernel_shiftreg_4),
	.input_data				(reg_dataout_kernel_sram),
	.result					(wire_kernel_shift_reg_data_out_4));

demo_shift_reg 	u_kernel_shift_reg_5(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_kernel_shiftreg_5),
	.input_data				(reg_dataout_kernel_sram),
	.result					(wire_kernel_shift_reg_data_out_5));

demo_shift_reg 	u_kernel_shift_reg_6(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_kernel_shiftreg_6),
	.input_data				(reg_dataout_kernel_sram),
	.result					(wire_kernel_shift_reg_data_out_6));

shift_reg_act	u_act_shift_reg(
	.clk					(clk),
	.rst_n 					(rst_n),
	.enable 				(wire_enable_act_sram),
	.input_data				(wire_dataout_act_sram),
	.result					(wire_act_shift_reg_data_out));

/*******************************	PE ARRAY 	*********************************/
MAX_pe_line 	u_max_pe_line(
	.enable 				(wire_number_pc_line),
	.ena_pe_line 			(wire_enable_pe_line));

//	pe array
pe_array 	u_pe_array(
	.clk					(clk),
	.rst_n					(rst_n),
	.enable 				(wire_enable_controller_pe_array||wire_enable_fc_to_pe_array),
	.enable_pc_line			(wire_enable_pe_line),
	.kernel_1 				(wire_kernel_shift_reg_data_out_1[415:16]),
	.kernel_2 				(wire_kernel_shift_reg_data_out_2[415:16]),
	.kernel_3 				(wire_kernel_shift_reg_data_out_3[415:16]),
	.kernel_4 				(wire_kernel_shift_reg_data_out_4[415:16]),
	.kernel_5 				(wire_kernel_shift_reg_data_out_5[415:16]),
	.kernel_6 				(wire_kernel_shift_reg_data_out_6[415:16]),
	.act 					(wire_act_shift_reg_data_out),
	.psum_in_1 				((wire_kernel_shift_reg_data_out_1[15] == 1'b0)?{1'b0,reg_pe_array_psum_in_0[15:0],wire_kernel_shift_reg_data_out_1[14:0]}:{1'b1,reg_pe_array_psum_in_1[15:0],wire_kernel_shift_reg_data_out_1[14:0]}),
	.psum_in_2 				((wire_kernel_shift_reg_data_out_2[15] == 1'b0)?{1'b0,reg_pe_array_psum_in_0[15:0],wire_kernel_shift_reg_data_out_2[14:0]}:{1'b1,reg_pe_array_psum_in_1[15:0],wire_kernel_shift_reg_data_out_2[14:0]}),
	.psum_in_3 				((wire_kernel_shift_reg_data_out_3[15] == 1'b0)?{1'b0,reg_pe_array_psum_in_0[15:0],wire_kernel_shift_reg_data_out_3[14:0]}:{1'b1,reg_pe_array_psum_in_1[15:0],wire_kernel_shift_reg_data_out_3[14:0]}),
	.psum_in_4 				((wire_kernel_shift_reg_data_out_4[15] == 1'b0)?{1'b0,reg_pe_array_psum_in_0[15:0],wire_kernel_shift_reg_data_out_4[14:0]}:{1'b1,reg_pe_array_psum_in_1[15:0],wire_kernel_shift_reg_data_out_4[14:0]}),
	.psum_in_5 				((wire_kernel_shift_reg_data_out_5[15] == 1'b0)?{1'b0,reg_pe_array_psum_in_0[15:0],wire_kernel_shift_reg_data_out_5[14:0]}:{1'b1,reg_pe_array_psum_in_1[15:0],wire_kernel_shift_reg_data_out_5[14:0]}),
	.psum_in_6 				((wire_kernel_shift_reg_data_out_6[15] == 1'b0)?{1'b0,reg_pe_array_psum_in_0[15:0],wire_kernel_shift_reg_data_out_6[14:0]}:{1'b1,reg_pe_array_psum_in_1[15:0],wire_kernel_shift_reg_data_out_6[14:0]}),
	.model 					(wire_model_size_pe),
	.end_signal_1			(wire_pe_array_end_signal_1),
	.end_signal_2			(wire_pe_array_end_signal_2),
	.end_signal_3			(wire_pe_array_end_signal_3),
	.end_signal_4			(wire_pe_array_end_signal_4),
	.end_signal_5			(wire_pe_array_end_signal_5),
	.end_signal_6			(wire_pe_array_end_signal_6),
	.result_1				(wire_pe_array_pe_array_result_1),
	.result_2				(wire_pe_array_pe_array_result_2),
	.result_3				(wire_pe_array_pe_array_result_3),
	.result_4				(wire_pe_array_pe_array_result_4),
	.result_5				(wire_pe_array_pe_array_result_5),
	.result_6				(wire_pe_array_pe_array_result_6));

/*******************************	SAVE UNIT 	*********************************/
//	save unit
save_unit	u_save_unit(
	.clk 					(clk),
	.rst_n 					(rst_n),
	.size_act 				(wire_size_act),
	.size_kernel 			(wire_size_kernel),
	.address_write_base 	(wire_address_write_base),
	.enable 				({wire_pe_array_end_signal_1,wire_pe_array_end_signal_2,wire_pe_array_end_signal_3,wire_pe_array_end_signal_4,wire_pe_array_end_signal_5,wire_pe_array_end_signal_6}),
	.data_result_1 			(wire_pe_array_pe_array_result_1),
	.data_result_2 			(wire_pe_array_pe_array_result_2),
	.data_result_3 			(wire_pe_array_pe_array_result_3),
	.data_result_4 			(wire_pe_array_pe_array_result_4),
	.data_result_5 			(wire_pe_array_pe_array_result_5),
	.data_result_6 			(wire_pe_array_pe_array_result_6),
	.data_in 				(wire_dataout_output_sram),
	.model 					(wire_mode_saveunit),
	.address   				(wire_address_saveunit_to_output_sram),
	.enable_sram			(wire_enable_saveunit_to_output_sram),
	.wea_sram 				(wire_wea_saveunit_to_output_sram),
	.data_out 				(wire_datain_saveunit_to_output_sram),
	.endsignal 				(wire_endsignal_saveunit));


/*******************************	SRAM 	*********************************/
//	kernel sram
blk_mem_kernel_gen u_kernel_sram(
	.clka					(clk),
	.ena 					(wire_enable_kernel_sram),
	.wea					(wire_wea_kernel_sram),
	.addra					(wire_address_kernel_sram),
	.dina					(wire_datain_kernel_sram),
	.douta					(wire_dataout_kernel_sram));

//	output sram
blk_mem_output_gen	u_output_sram(
	.clka 					(clk),
	.ena 					(wire_enable_output_sram),
	.wea 					(wire_wea_output_sram),
	.addra 					(wire_address_output_sram),
	.dina 					(wire_datain_output_sram),
	.douta 					(wire_dataout_output_sram));

//	parameter sram
parameter_sram 	u_parameter_sram(
	.clka 					(clk),
	.ena 					(wire_enable_pc_sram),
	.wea 					(wire_wea_pc_sram),
	.addra 					(wire_address_pc_sram),
	.dina 					(reg_datain_pc_sram),
	.douta 					(wire_pc_sram_to_decode));

//	act sram
blk_mem_act_gen	u_act_sram(
	.clka					(clk),
	.ena 					(wire_enable_act_sram),
	.wea					(wire_wea_act_sram),
	.addra					(wire_address_act_sram),
	.dina					(wire_datain_act_sram),
	.douta					(wire_dataout_act_sram));

/*******************************	MAX FOR SRAM 	*********************************/
//	2 TO 1 for kernel sram
MAX_kernel 	u_max_kernel_sram(
	//	from controller 	read
	.enable_1				(wire_enable_controller_to_kernel_sram),
	.wea_1 					(wire_wea_controller_to_kernel_sram),
	.data_in_1				(reg_datain_kernel_sram),
	.address_1				(wire_address_controller_to_kernel_sram),
	//	from fc 			read
	.enable_2				(wire_enable_fc_to_kernel_sram),
	.wea_2 					(wire_wea_fc_to_kernel_sram),
	.data_in_2 				(reg_datain_kernel_sram),
	.address_2 				(wire_address_fc_to_kernel_sram),
	//	to kernel sram 
	.enable 				(wire_enable_kernel_sram),
	.wea 					(wire_wea_kernel_sram),
	.data_in 				(wire_datain_kernel_sram),
	.address 				(wire_address_kernel_sram));

//	3 TO 1 for output sram
MAX_output 	u_max_output_sram(
	//	from save unit 		read and write
	.enable_1				(wire_enable_saveunit_to_output_sram),
	.wea_1 					(wire_wea_saveunit_to_output_sram),
	.data_in_1				(wire_datain_saveunit_to_output_sram),
	.address_1				(wire_address_saveunit_to_output_sram),
	//	from pooler 		read
	.enable_2				(wire_enable_pooler_to_output_sram),
	.wea_2 					(wire_wea_pooler_to_output_sram),
	.data_in_2 				(reg_datain_output_sram),
	.address_2 				(wire_address_pooler_to_output_sram),
	//	from relu 			read
	.enable_3				(wire_enable_relu_to_output_sram),
	.wea_3 					(wire_wea_relu_to_output_sram),
	.data_in_3 				(reg_datain_output_sram),
	.address_3 				(wire_address_relu_to_output_sram),
	//	to output sram 
	.enable 				(wire_enable_output_sram),
	.wea 					(wire_wea_output_sram),
	.data_in 				(wire_datain_output_sram),
	.address 				(wire_address_output_sram));

//	4 TO 1 for act sram
MAX_act 	u_max_act_sram(
	//	from controller 	read
	.enable_1				(wire_enable_controller_to_act_sram),
	.wea_1 					(wire_wea_controller_to_act_sram),
	.data_in_1				(reg_datain_act_sram),
	.address_1				(wire_address_controller_to_act_sram),
	//	from pooler 		write
	.enable_2				(wire_enable_pooler_to_act_sram),
	.wea_2 					(wire_wea_pooler_to_act_sram),
	.data_in_2 				(wire_datain_pooler_to_act_sram),
	.address_2 				(wire_address_pooler_to_act_sram),
	//	from fc 			read
	.enable_3 				(wire_enable_fc_to_act_sram),
	.wea_3 					(wire_wea_fc_to_act_sram),
	.data_in_3 				(reg_datain_act_sram),
	.address_3 				(wire_address_fc_to_act_sram),
	//	from relu 			write
	.enable_4 				(wire_enable_relu_to_act_sram),
	.wea_4 					(wire_wea_relu_to_act_sram),
	.data_in_4 				(wire_datain_relu_to_act_sram),
	.address_4 				(wire_address_relu_to_act_sram),
	//	to act sram
	.enable 				(wire_enable_act_sram),
	.wea 					(wire_wea_act_sram),
	.data_in 				(wire_datain_act_sram),
	.address 				(wire_address_act_sram));
endmodule
