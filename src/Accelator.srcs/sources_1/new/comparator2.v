`timescale 1ns / 1ps

module comparator2(
	input 				clk,
    input 		[15:0] 	ip1,
    input 		[15:0] 	ip2,
    input		[15:0]	shift_out,
    input		[ 1:0]	sel,

    output		[15:0]	mux_out,
   	output reg 	[15:0] 	reg_op,
    output reg 	[15:0]	comp_op);
    
    always @(clk) begin 
    	if($signed(ip1)>$signed(ip2)) comp_op <= ip1;
    	else 		comp_op <= ip2;
    end

	always @(posedge clk) begin		
			reg_op <= comp_op;
	end

	assign mux_out = (sel == 2'b01)?shift_out:(sel == 2'b00)?reg_op:16'h0000;
endmodule
