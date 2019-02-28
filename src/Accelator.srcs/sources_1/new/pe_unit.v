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
`include "defines.v"

module pe_unit(
    input  					clk, 
    input 					rst_n,
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

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0) begin
		state 		<= 2'b00;
	end
	else begin
		state 		<= next_state;
	end
end

always@(*)
begin
	next_state 				=	state;
	if(state == 2'b00) begin
		if (!enable) begin
			next_state 		= 2'b00;
		end
		else begin
			next_state 		= 2'b01;
		end
	end
	else if(state == 2'b01) begin
		next_state 			= 2'b10;
	end
	else begin
		next_state 			= 2'b00;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)	begin
		reg_psum_in 			<= 8'h00;
		end_signal 				<= `UnFinish;
	end
	else begin
		case(state)
		2'b00	:begin
					reg_psum_in <= psum_in;
					end_signal	<= `UnFinish;
					psum_out 	<= 32'h00000000;
					
				end
		2'b01 	:begin
					psum_out 	<= $signed(kernel)*$signed(act);
					end_signal 	<= `UnFinish;
				end
		2'b10 	:begin
					psum_out 	<= $signed(psum_out) + $signed(reg_psum_in);
					end_signal 	<= `Finish;
				end
		endcase
	end
	
end

endmodule