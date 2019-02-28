`timescale 1ns / 1ps

module comparator2(
    input 		[15:0] 	ip1,
    input 		[15:0] 	ip2,

    output		[15:0]	mux_out
    );

assign mux_out = ($signed(ip1)>=$signed(ip2))?ip1:ip2;
endmodule
