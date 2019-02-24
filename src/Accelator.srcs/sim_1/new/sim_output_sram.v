`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 15:46:35
// Design Name: 
// Module Name: sim_output_sram
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


module sim_output_sram();

reg 						clk;
reg							enable;
reg							wea;
reg				[15:0]		address;
reg				[7:0]		data_save_to_sram;
wire			[7:0]		data_sram_to_save;

initial
begin
	enable	=	1'b1;
	wea		=	1'b0;
	address	=	16'h0000;
	#10	clk =	1'b0;
	#10	clk =	1'b1;
	#10	clk = 	1'b0;
	#10	clk =	1'b1;
	#10	clk = 	1'b0;
	#10	clk =	1'b1;
	#10	clk = 	1'b0;
	#10	clk =	1'b1;
	#10	clk = 	1'b0;
	#10	clk =	1'b1;
	#10	clk = 	1'b0;
end

blk_mem_output_gen	u_output_sram(
	.clka 					(clk),
	.ena 					(enable),
	.wea 					(wea),
	.addra 					(address),
	.dina 					(data_save_to_sram),
	.douta 					(data_sram_to_save));

endmodule
