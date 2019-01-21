`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/18 23:01:29
// Design Name: 
// Module Name: test_controller
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


module test_controller(
	input 					clk,
	input 					reset,
	input 					enable,

	output 		reg			endsignal
    );

reg 			[15:0]		count;

always@(posedge clk or posedge reset or posedge enable) begin
	if(reset) begin
		count		<=	16'h00;
		endsignal	<=	1'b0;
	end
	if(enable)	begin
		count	 	<=	16'h01;
	end
	else begin
		if(count	>	16'h00)	begin
			count	<=	count + 1;
			if(count	==	16'h30)	begin
				endsignal	<=	1'b1;
				count		<=	16'h00;
			end
		end
		else begin
			endsignal	<=	1'b0;
		end
	end
end


endmodule
