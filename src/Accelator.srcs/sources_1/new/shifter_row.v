`timescale 1ns / 1ps

module  shifter_row(
		input 				clk,
		input 				rst_n,
		input 				enable,
		input	[15:0]		data_in,
		input 	[7:0]		index,

		output wire	[15:0]	data_out
	);

reg 				[15: 0] shifter [15: 0] ;

always@(posedge clk or negedge rst_n or posedge enable)	begin
	if(!rst_n)	begin
		shifter[0 ] <= 16'h0000;
		shifter[1 ] <= 16'h0000;
		shifter[2 ] <= 16'h0000;
		shifter[3 ] <= 16'h0000;
		shifter[4 ] <= 16'h0000;
		shifter[5 ] <= 16'h0000;
		shifter[6 ] <= 16'h0000;
		shifter[7 ] <= 16'h0000;
		shifter[8 ] <= 16'h0000;
		shifter[9 ] <= 16'h0000;
		shifter[10] <= 16'h0000;
		shifter[11] <= 16'h0000;
		shifter[12] <= 16'h0000;
		shifter[13] <= 16'h0000;
		shifter[14] <= 16'h0000;
		shifter[15] <= 16'h0000;
	end
	else begin
		
	end
end

always@(posedge enable)	begin
	shifter[15] <= shifter[14];
	shifter[14] <= shifter[13];
	shifter[13] <= shifter[12];
	shifter[12] <= shifter[11];
	shifter[11] <= shifter[10];
	shifter[10] <= shifter[9 ];
	shifter[9 ] <= shifter[8 ];
	shifter[8 ] <= shifter[7 ];
	shifter[7 ] <= shifter[6 ];
	shifter[6 ] <= shifter[5 ];
	shifter[5 ] <= shifter[4 ];
	shifter[4 ] <= shifter[3 ];
	shifter[3 ] <= shifter[2 ];
	shifter[2 ] <= shifter[1 ];
	shifter[1 ] <= shifter[0 ];
	shifter[0 ] <= data_in;
end
assign data_out = shifter[index - 1];
endmodule