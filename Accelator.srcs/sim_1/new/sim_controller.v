`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/13 21:54:42
// Design Name: 
// Module Name: sim_controller
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


module sim_controller;

reg				clk;
reg			        reset;
reg                             enable;
reg                             endsignal_saveunit;

reg			[7:0]	size_kernel;
reg                     [7:0]   size_act;
reg                     [7:0]   stride;
reg                     [7:0]   number_pc_line;


wire				clk_act_address;
wire				clk_act_sram;

wire				clk_kernel_address;
wire				clk_kernel_sram;

wire				clk_pe_array;
wire                            endsignal;

initial
begin

	#10	reset = 1'b1;
	#10	reset = 1'b0;
		clk 	= 1'b0;
		reset 	= 1'b0;

		size_kernel = 8'h19;
end

always
begin
	#30	clk = ~clk;
end

always
begin
        #1000   enable  = 1'b1;
        #10     enable  = 1'b0;
end

controller U1(
        .clk 			(clk),
        .reset                  (reset),
        .enable                 (enable),
        .endsignal_saveunit     (endsignal_saveunit),
        .size_act               (size_act),
        .size_kernel            (size_kernel),
        .stride                 (stride),
        .number_pc_line         (number_pc_line),
        .address_act            (address_act),
        .enable_act_sram        (enable_act_sram),
        .address_kernel         (address_kernel),
        .enable_kernel_sram     (enable_kernel_sram),
        .enable_pe_array        (enable_pe_array),
        .endsignal              (endsignal));

endmodule
