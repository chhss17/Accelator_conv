`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/02 19:11:48
// Design Name: 
// Module Name: PE
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


module pe_unit(
    input  					clk, 
    input 					reset,
    input					enable,
    input  		[15:0]		kernel,////
    input  		[15:0]		act,
    input  		[31:0] 		psum_in,////
    
    output	reg		 		end_signal,
    output	reg		[31:0] 	psum_out////
);

reg				[1:0]		state;
reg				[1:0]		next_state;
reg				[31:0]		reg_psum_in;

always@(posedge clk or posedge reset)
begin
	if(reset) begin
		state <= 2'b00;
	end
	else begin
		state <= next_state;
	end
end

always@(*)
begin
	if(state == 2'b00) begin
		if (!enable) begin
			next_state <= 2'b00;
		end
		else begin
			next_state <= 2'b01;
		end
	end
	else if(state == 2'b01) begin
		next_state <= 2'b10;
	end
	else begin
		next_state <= 2'b00;
	end
end

always@(*)
begin
	case(state)
	2'b00	:begin
				psum_out = 0;
				end_signal = 1'b0;
				reg_psum_in = psum_in;
			end
	2'b01 	:begin
				psum_out = $signed(kernel)*$signed(act);
				end_signal = 1'b0;
			end
	2'b10 	:begin
				psum_out = $signed(psum_out) + $signed(reg_psum_in);
				end_signal = 1'b1;
			end
	endcase
end

endmodule