`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 15:50:34
// Design Name: 
// Module Name: sram_act
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


module get_windows_address(
    input       			clk,
    input 					reset,
    
    output	reg 	[15:0]	result
);

reg				[15:0]	next_result;

reg				[7:0]	count;
reg				[7:0]	row;
reg				[7:0]	column;

parameter		size_act 	= 32;
parameter		size_kernel = 5;


always@(posedge clk or posedge reset)
begin
	if(reset) begin
		result		<= 16'hffff;
		row 		<= 8'h01;
		column		<= 8'h01;
		count 		<= 8'hff;
	end
	else begin
		result 		<= next_result;
		if(count 	== 8'h04) begin
			if(column == size_act) begin
				row 	<= row + 1;
				column 	<= 8'h01;
			end
			else begin
				column 	<= column + 1;
			end
			count		<= 8'h00;
		end
		else begin
			count	<= count + 1;
		end
	end
end

always@(*)
begin
	if(count	==	8'h04) begin
		if(column == size_act) begin
			next_result = row;
		end
		else begin
			next_result = result + size_act - size_kernel + 1;
		end
	end
	else begin
		next_result = result + 1;
	end
end

endmodule
