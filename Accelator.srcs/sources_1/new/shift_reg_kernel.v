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
	input 						enable,
	input 			[7:0]		input_data,

	output	reg 	[1199:0]	result
    );

always@(posedge clk or posedge enable)
begin
	if(enable)	begin
		result 	<=	{result[1191:0],input_data};
	end
end

endmodule
