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
	input 				reset,
	input 				enable
    );
wire 		[15:0]		wire_pc_sram_to_decode;

wire 					wire_enable_pc_sram;
wire 					wire_wea_pc_sram;
wire 		[15:0]		wire_address_pc_sram;
wire 		[7:0]		wire_size_act;
wire 		[7:0]		wire_size_kernel;
wire 		[7:0]		wire_stride;
wire 		[7:0]		wire_number_pc_line;
wire 		[15:0]		wire_address_read_base;
wire 		[15:0]		wire_address_write_base;

wire 					wire_enable_controller;
wire 					wire_enable_pooler;

wire 					wire_enable_endsignal_saveunit;
wire 		[15:0]		wire_address_controller_to_act_sram;
wire 					wire_enable_controller_to_act_sram;
wire 					wire_wea_controller_to_act_sram;
wire 		[15:0]		wire_address_kernel;
wire 					wire_enable_kernel_sram;
wire 					wire_wea_kernel_sram;

wire 					wire_enable_pe_array;
wire 					wire_endsignal_contorller;
wire 					wire_endsignal_pooler;

wire 					wire_enable_act_sram;
wire 					wire_wea_act_sram;
wire 		[7:0]		wire_datain_act_sram;
wire 		[15:0]		wire_address_act_sram;
wire 		[7:0]		wire_dataout_act_sram;

wire 					wire_enable_output_sram;
wire 					wire_wea_output_sram;
wire 		[7:0]		wire_datain_output_sram;
wire 		[15:0]		wire_address_output_sram;
wire 		[7:0]		wire_dataout_output_sram;

wire 		[7:0]		wire_kernel_data_out;
wire 		[199:0]		wire_act_shift_reg_data_out;
wire 		[1199:0]	wire_kernel_shift_reg_data_out;

reg 		[15:0]		reg_pe_array_psum_in_1;
reg 		[15:0]		reg_pe_array_psum_in_2;
reg 		[15:0]		reg_pe_array_psum_in_3;
reg 		[15:0]		reg_pe_array_psum_in_4;
reg 		[15:0]		reg_pe_array_psum_in_5;
reg 		[15:0]		reg_pe_array_psum_in_6;
wire 					wire_pe_array_end_signal_1;
wire 					wire_pe_array_end_signal_2;
wire 					wire_pe_array_end_signal_3;
wire 					wire_pe_array_end_signal_4;
wire 					wire_pe_array_end_signal_5;
wire 					wire_pe_array_end_signal_6;
wire 		[15:0]		wire_pe_array_pe_array_result_1;
wire 		[15:0]		wire_pe_array_pe_array_result_2;
wire 		[15:0]		wire_pe_array_pe_array_result_3;
wire 		[15:0]		wire_pe_array_pe_array_result_4;
wire 		[15:0]		wire_pe_array_pe_array_result_5;
wire 		[15:0]		wire_pe_array_pe_array_result_6;

wire 					wire_enable_saveunit_to_output_sram;
wire 					wire_wea_saveunit_to_output_sram;
wire 		[7:0]		wire_datain_saveunit_to_output_sram;
wire 		[15:0]		wire_address_saveunit_to_output_sram;

wire 					wire_enable_pooler_to_output_sram;
wire 					wire_wea_pooler_to_output_sram;
wire 		[15:0]		wire_address_pooler_to_output_sram;

wire 					wire_enable_pooler_to_act_sram;
wire 					wire_wea_pooler_to_act_sram;
wire 		[7:0]		wire_datain_pooler_to_act_sram;
wire 		[15:0]		wire_address_pooler_to_act_sram;


//	not important parameter
reg 		[15:0]		reg_pc_sram_data_in;
reg 		[7:0]		reg_act_sram_data_in;
reg 		[7:0]		reg_kernel_sram_data_in;
reg 		[7:0]		reg_output_sram_data_in;

reg 					reg_enable_act_shiftreg;
reg 					reg_enable_kernel_shiftreg;
reg 		[5:0]		enable_pe_array_line;

always@(posedge clk or reset)
begin
	if(reset)	begin
		reg_pc_sram_data_in				<=	8'h00;
		reg_act_sram_data_in			<=	8'h00;
		reg_kernel_sram_data_in			<=	8'h00;
		reg_output_sram_data_in			<=	8'h00;
	end
	reg_enable_act_shiftreg 			<=		wire_enable_act_sram;
	reg_enable_kernel_shiftreg 			<=		wire_enable_kernel_sram;
	case(wire_number_pc_line)
	8'h00 	:begin
				enable_pe_array_line	<=		6'b000000;
			end
	8'h01 	:begin
				enable_pe_array_line	<=		6'b100000;
			end
	8'h02 	:begin
				enable_pe_array_line	<=		6'b110000;
			end
	8'h03 	:begin
				enable_pe_array_line	<=		6'b111000;
			end
	8'h04 	:begin
				enable_pe_array_line	<=		6'b111100;
			end
	8'h05 	:begin
				enable_pe_array_line	<=		6'b111110;
			end
	8'h06 	:begin
				enable_pe_array_line	<=		6'b111111;
			end
	endcase
	reg_pe_array_psum_in_1 				<=		16'h00;
	reg_pe_array_psum_in_2 				<=		16'h00;
	reg_pe_array_psum_in_3 				<=		16'h00;
	reg_pe_array_psum_in_4 				<=		16'h00;
	reg_pe_array_psum_in_5 				<=		16'h00;
	reg_pe_array_psum_in_6 				<=		16'h00;
end

//	decode
decode 	u_decode(
	.clk 				(clk),
	.reset 				(reset),
	.enable				((wire_endsignal_contorller||wire_endsignal_pooler)),
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

	.enable_controller 	(wire_enable_controller),
	.enable_pooler 		(wire_enable_pooler));

//	parameter sram
parameter_sram 	u_parameter_sram(
	.clka 				(clk),
	.ena 				(wire_enable_pc_sram),
	.wea 				(wire_wea_pc_sram),
	.addra 				(wire_address_pc_sram),
	.dina 				(reg_pc_sram_data_in),
	.douta 				(wire_pc_sram_to_decode));


//	controller
controller 	u_controller(
	.clk 					(clk),
	.reset					(reset),

	.enable 				(wire_enable_controller),
	.endsignal_saveunit 	(wire_enable_endsignal_saveunit),

	.size_act 				(wire_size_act),
	.size_kernel			(wire_size_kernel),
	.stride 				(wire_stride),
	.number_pc_line 		(wire_number_pc_line),
	.address_read_base 		(wire_address_read_base),

	.address_act			(wire_address_controller_to_act_sram),
	.enable_act_sram		(wire_enable_controller_to_act_sram),
	.wea_act_sram 			(wire_wea_controller_to_act_sram),

	.address_kernel			(wire_address_kernel),
	.enable_kernel_sram		(wire_enable_kernel_sram),
	.wea_kernel_sram 		(wire_wea_kernel_sram),

	.enable_pe_array		(wire_enable_pe_array),
	.endsignal 				(wire_endsignal_contorller));

//	kernel
blk_mem_kernel_gen u_kernel_sram(
	.clka					(clk),
	.ena 					(wire_enable_kernel_sram),
	.wea					(wire_wea_kernel_sram),
	.addra					(wire_address_kernel),
	.dina					(reg_kernel_sram_data_in),
	.douta					(wire_kernel_data_out));

shift_reg_kernel 	u_kernel_shift_reg(
	.clk 					(clk),
	.enable 				(reg_enable_kernel_shiftreg),
	.input_data 			(wire_kernel_data_out),
	.result 				(wire_kernel_shift_reg_data_out));


//	act
blk_mem_act_gen	u_act_sram(
	.clka					(clk),
	.ena 					(wire_enable_act_sram),
	.wea					(wire_wea_act_sram),
	.addra					(wire_address_act_sram),
	.dina					(wire_datain_act_sram),
	.douta					(wire_dataout_act_sram));

shift_reg_act	u_act_shift_reg(
	.clk					(clk),
	.enable 				(reg_enable_act_shiftreg),
	.input_data				(wire_dataout_act_sram),
	.result					(wire_act_shift_reg_data_out));

//	pe array
pe_array 	u_pe_array(
	.clk					(clk),
	.reset					(reset),
	.enable 				(wire_enable_pe_array),
	.enable_1				(enable_pe_array_line[0]),
	.enable_2				(enable_pe_array_line[1]),
	.enable_3				(enable_pe_array_line[2]),
	.enable_4				(enable_pe_array_line[3]),
	.enable_5				(enable_pe_array_line[4]),
	.enable_6				(enable_pe_array_line[5]),
	.kernel_1 				(wire_kernel_shift_reg_data_out[199:0]),
	.kernel_2				(wire_kernel_shift_reg_data_out[399:200]),
	.kernel_3 				(wire_kernel_shift_reg_data_out[599:400]),
	.kernel_4 				(wire_kernel_shift_reg_data_out[799:600]),
	.kernel_5 				(wire_kernel_shift_reg_data_out[999:800]),
	.kernel_6 				(wire_kernel_shift_reg_data_out[1199:1000]),
	.act 					(wire_act_shift_reg_data_out),
	.psum_in_1				(reg_pe_array_psum_in_1),
	.psum_in_2				(reg_pe_array_psum_in_2),
	.psum_in_3				(reg_pe_array_psum_in_3),
	.psum_in_4				(reg_pe_array_psum_in_4),
	.psum_in_5				(reg_pe_array_psum_in_5),
	.psum_in_6				(reg_pe_array_psum_in_6),
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

//	save unit
save_unit	u_save_unit(
	.clk 					(clk),
	.reset 					(reset),
	.size_act 				(wire_size_act),
	.size_kernel 			(wire_size_kernel),
	.stride 				(wire_stride),
	.address_write_base 	(wire_address_write_base),
	.enable 				({wire_pe_array_end_signal_1,wire_pe_array_end_signal_2,wire_pe_array_end_signal_3,wire_pe_array_end_signal_4,wire_pe_array_end_signal_5,wire_pe_array_end_signal_6}),
	.data_result_1 			(wire_pe_array_pe_array_result_1),
	.data_result_2 			(wire_pe_array_pe_array_result_2),
	.data_result_3 			(wire_pe_array_pe_array_result_3),
	.data_result_4 			(wire_pe_array_pe_array_result_4),
	.data_result_5 			(wire_pe_array_pe_array_result_5),
	.data_result_6 			(wire_pe_array_pe_array_result_6),
	.data_in 				(wire_dataout_output_sram),
	.address   				(wire_address_saveunit_to_output_sram),
	.enable_sram			(wire_enable_saveunit_to_output_sram),
	.wea_sram 				(wire_wea_saveunit_to_output_sram),
	.data_out 				(wire_datain_saveunit_to_output_sram),
	.endsignal 				(wire_enable_endsignal_saveunit));


blk_mem_output_gen	u_output_sram(
	.clka 					(clk),
	.ena 					(wire_enable_output_sram),
	.wea 					(wire_wea_output_sram),
	.addra 					(wire_address_output_sram),
	.dina 					(wire_datain_output_sram),
	.douta 					(wire_dataout_output_sram));

MAX_output_sram 	u_max_output_sram(
	.enable_1				(wire_enable_saveunit_to_output_sram),
	.wea_1 					(wire_wea_saveunit_to_output_sram),
	.data_in_1				(wire_datain_saveunit_to_output_sram),
	.address_1				(wire_address_saveunit_to_output_sram),
	.enable_2				(wire_enable_pooler_to_output_sram),
	.wea_2 					(wire_wea_pooler_to_output_sram),
	.data_in_2 				(reg_output_sram_data_in),
	.address_2 				(wire_address_pooler_to_output_sram),
	.enable 				(wire_enable_output_sram),
	.wea 					(wire_wea_output_sram),
	.data_in 				(wire_datain_output_sram),
	.address 				(wire_address_output_sram)
	);

MAX_output_sram 	u_max_act_sram(
	.enable_1				(wire_enable_controller_to_act_sram),
	.wea_1 					(wire_wea_controller_to_act_sram),
	.data_in_1				(reg_act_sram_data_in),
	.address_1				(wire_address_controller_to_act_sram),
	.enable_2				(wire_enable_pooler_to_act_sram),
	.wea_2 					(wire_wea_pooler_to_act_sram),
	.data_in_2 				(wire_datain_pooler_to_act_sram),
	.address_2 				(wire_address_pooler_to_act_sram),
	.enable 				(wire_enable_act_sram),
	.wea 					(wire_wea_act_sram),
	.data_in 				(wire_datain_act_sram),
	.address 				(wire_address_act_sram)
	);


pooler_controller 	u_pooler(
	.clk 					(clk),
	.reset 					(reset),
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


endmodule
