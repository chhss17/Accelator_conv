`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/19 16:13:00
// Design Name: 
// Module Name: shift_reg_kernel
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


module shift_reg_kernel(
	input						clk,
	input 						reset,
	input 						enable,
	input 			[15:0]		input_data,

	output	reg 	[2495:0]	result
    );

reg                         state;
reg                         next_state;

always@(posedge clk or posedge reset)
begin
	if(reset)	begin
		next_state 			<=	1'b0;
		state 				<=	1'b0;
		result 				<=	0;
	end
	else begin
		state 				<=	next_state;
	end
end

always@(*)
begin
	if(enable)	begin
		next_state			<=	1'b1;
	end
	else begin
		next_state 			<=	1'b0;
	end
end

always@(posedge clk)
begin
	case(state)
	1'b0 	:begin
				result 		<=	result;
			end
	1'b1 	:begin
				result 	<=	{result[2479:0],input_data};
			end
	endcase
end


endmodule
