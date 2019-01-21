`timescale 1ns / 1ps

module max_reg(
    input 		clk,
    input [7:0] din,
    //input 		rst_m,
    //input 		global_rst,
    //input 		master_rst,
    output reg [7:0] reg_op
    );

	//integer clk_temp  =0;
	//reg [15:0]	shifter = 15'h0;
	//wire  [7:0]	din_temp;
	//assign din_temp = din;

	always @(posedge clk) begin
		//if(rst_m || master_rst)	reg_op <= 8'h0;
		//else 					
			reg_op <= din;
	end

	//assign 	shifter = {shifter[7:0],din};
	//assign  reg_op = shifter[15:8];

endmodule

