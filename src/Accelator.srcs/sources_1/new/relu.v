`timescale 1ns / 1ps

module relu(
    input 	[15:0] din_relu,
    output 	[15:0] dout_relu
    );

assign dout_relu = (din_relu[15] == 1'b0)? din_relu[15:0] : 16'h0000;//14?

endmodule
