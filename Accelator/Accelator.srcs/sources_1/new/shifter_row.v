`timescale 1ns / 1ps

module  shifter_row(
		//input				clk,
		//input 	[7:0]		delay,
		input	[7:0]		in,
		input				CE,
		input				rst,
		input	[7:0]		delay,

		output wire	[7:0]	shift_out
	);

	//parameter delay = 3;
	//integer 	i   = delay-1;
	//reg [7:0]	i;
	//always @(delay) i   = delay-1; 
	//assign 	i   = delay-1;
	reg [7: 0] shifter [15: 0] ;

	always @(rst or CE) begin
		if(rst)	begin
			shifter[0 ] = 8'h0;
			shifter[1 ] = 8'h0;
			shifter[2 ] = 8'h0;
			shifter[3 ] = 8'h0;
			shifter[4 ] = 8'h0;
			shifter[5 ] = 8'h0;
			shifter[6 ] = 8'h0;
			shifter[7 ] = 8'h0;
			shifter[8 ] = 8'h0;
			shifter[9 ] = 8'h0;
			shifter[10] = 8'h0;
			shifter[11] = 8'h0;
			shifter[12] = 8'h0;
			shifter[13] = 8'h0;
			shifter[14] = 8'h0;
			shifter[15] = 8'h0;
		end

		else if(CE)begin
			shifter[15] = shifter[14];
			shifter[14] = shifter[13];
			shifter[13] = shifter[12];
			shifter[12] = shifter[11];
			shifter[11] = shifter[10];
			shifter[10] = shifter[9 ];
			shifter[9 ] = shifter[8 ];
			shifter[8 ] = shifter[7 ];
			shifter[7 ] = shifter[6 ];
			shifter[6 ] = shifter[5 ];
			shifter[5 ] = shifter[4 ];
			shifter[4 ] = shifter[3 ];
			shifter[3 ] = shifter[2 ];
			shifter[2 ] = shifter[1 ];
			shifter[1 ] = shifter[0 ];
			shifter[0 ] = in;
			/*
			while(i > 0)begin
				shifter[i] = shifter[i-1];
				i = i-1;
			end
			if(i == 0) i = delay-1;
			shifter[0] 	= in; */
		end
		
		else begin
			
		end
	end

	assign shift_out = shifter[delay-1];

endmodule