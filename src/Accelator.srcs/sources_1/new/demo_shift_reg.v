`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2019 05:15:34 PM
// Design Name: 
// Module Name: demo_shift_reg
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


module demo_shift_reg(
	input					clk,
	input                   rst_n,
	input 					enable,
	input 			[15:0]	input_data,

	output	reg		[415:0]	result
    );

reg                         state;
reg                         next_state;

reg  				[15:0]	reg_datain;

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)	begin
		state 				<=	1'b0;
	end
	else begin
		state 				<=	next_state;
	end
end

always@(*)
begin
	next_state 				=	state;
	if(enable)	begin
		next_state			=	1'b1;
	end
	else begin
		next_state 			=	1'b0;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		result				<=	0;
		reg_datain 			<=	16'h0000;
	end
	else begin
		case(state)
		1'b0 	:begin
					result 		<=	result;
					reg_datain	<= 	input_data;
				end
		1'b1 	:begin
					result 		<=	{result[399:0],reg_datain};
					reg_datain	<= 	input_data;
				end
		endcase
	end
	
end
endmodule
