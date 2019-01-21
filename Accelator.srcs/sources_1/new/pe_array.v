`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/04 19:09:04
// Design Name: 
// Module Name: pe_array
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


module pe_array(
	input					clk,
	input 					reset,
	input 					enable,

	input 					enable_1,
	input 					enable_2,
	input 					enable_3,
	input 					enable_4,
	input 					enable_5,
	input 					enable_6,

	input			[199:0]	kernel_1,
	input			[199:0]	kernel_2,
	input			[199:0]	kernel_3,
	input			[199:0]	kernel_4,
	input			[199:0]	kernel_5,
	input			[199:0]	kernel_6,

	input			[199:0]	act,

	input			[15:0]	psum_in_1,
	input			[15:0]	psum_in_2,
	input			[15:0]	psum_in_3,
	input			[15:0]	psum_in_4,
	input			[15:0]	psum_in_5,
	input			[15:0]	psum_in_6,

	output	wire			end_signal_1,
	output	wire			end_signal_2,
	output	wire			end_signal_3,
	output	wire			end_signal_4,
	output	wire			end_signal_5,
	output	wire			end_signal_6,

	output	wire	[15:0]	result_1,
	output	wire	[15:0]	result_2,
	output	wire	[15:0]	result_3,
	output	wire	[15:0]	result_4,
	output	wire	[15:0]	result_5,
	output	wire	[15:0]	result_6
);

wire 				[15:0]	out_1_1 ,out_1_2 ,out_1_3 ,out_1_4 ,out_1_5 ,out_1_6 ;
wire 				[15:0]	out_1_7	,out_1_8 ,out_1_9 ,out_1_10,out_1_11,out_1_12;
wire 				[15:0]	out_1_13,out_1_14,out_1_15,out_1_16,out_1_17,out_1_18;
wire 				[15:0]	out_1_19,out_1_20,out_1_21,out_1_22,out_1_23,out_1_24;

wire 				[15:0]	out_2_1 ,out_2_2 ,out_2_3 ,out_2_4 ,out_2_5 ,out_2_6 ;
wire 				[15:0]	out_2_7	,out_2_8 ,out_2_9 ,out_2_10,out_2_11,out_2_12;
wire 				[15:0]	out_2_13,out_2_14,out_2_15,out_2_16,out_2_17,out_2_18;
wire 				[15:0]	out_2_19,out_2_20,out_2_21,out_2_22,out_2_23,out_2_24;

wire 				[15:0]	out_3_1 ,out_3_2 ,out_3_3 ,out_3_4 ,out_3_5 ,out_3_6 ;
wire 				[15:0]	out_3_7	,out_3_8 ,out_3_9 ,out_3_10,out_3_11,out_3_12;
wire 				[15:0]	out_3_13,out_3_14,out_3_15,out_3_16,out_3_17,out_3_18;
wire 				[15:0]	out_3_19,out_3_20,out_3_21,out_3_22,out_3_23,out_3_24;

wire 				[15:0]	out_4_1 ,out_4_2 ,out_4_3 ,out_4_4 ,out_4_5 ,out_4_6 ;
wire 				[15:0]	out_4_7	,out_4_8 ,out_4_9 ,out_4_10,out_4_11,out_4_12;
wire 				[15:0]	out_4_13,out_4_14,out_4_15,out_4_16,out_4_17,out_4_18;
wire 				[15:0]	out_4_19,out_4_20,out_4_21,out_4_22,out_4_23,out_4_24;

wire 				[15:0]	out_5_1 ,out_5_2 ,out_5_3 ,out_5_4 ,out_5_5 ,out_5_6 ;
wire 				[15:0]	out_5_7	,out_5_8 ,out_5_9 ,out_5_10,out_5_11,out_5_12;
wire 				[15:0]	out_5_13,out_5_14,out_5_15,out_5_16,out_5_17,out_5_18;
wire 				[15:0]	out_5_19,out_5_20,out_5_21,out_5_22,out_5_23,out_5_24;

wire 				[15:0]	out_6_1 ,out_6_2 ,out_6_3 ,out_6_4 ,out_6_5 ,out_6_6 ;
wire 				[15:0]	out_6_7	,out_6_8 ,out_6_9 ,out_6_10,out_6_11,out_6_12;
wire 				[15:0]	out_6_13,out_6_14,out_6_15,out_6_16,out_6_17,out_6_18;
wire 				[15:0]	out_6_19,out_6_20,out_6_21,out_6_22,out_6_23,out_6_24;

wire						end_signal_1_1 ,end_signal_1_2 ,end_signal_1_3 ,end_signal_1_4 ;
wire						end_signal_1_5 ,end_signal_1_6 ,end_signal_1_7 ,end_signal_1_8 ;
wire						end_signal_1_9 ,end_signal_1_10,end_signal_1_11,end_signal_1_12;
wire						end_signal_1_13,end_signal_1_14,end_signal_1_15,end_signal_1_16;
wire						end_signal_1_17,end_signal_1_18,end_signal_1_19,end_signal_1_20;
wire						end_signal_1_21,end_signal_1_22,end_signal_1_23,end_signal_1_24;

wire						end_signal_2_1 ,end_signal_2_2 ,end_signal_2_3 ,end_signal_2_4 ;
wire						end_signal_2_5 ,end_signal_2_6 ,end_signal_2_7 ,end_signal_2_8 ;
wire						end_signal_2_9 ,end_signal_2_10,end_signal_2_11,end_signal_2_12;
wire						end_signal_2_13,end_signal_2_14,end_signal_2_15,end_signal_2_16;
wire						end_signal_2_17,end_signal_2_18,end_signal_2_19,end_signal_2_20;
wire						end_signal_2_21,end_signal_2_22,end_signal_2_23,end_signal_2_24;

wire						end_signal_3_1 ,end_signal_3_2 ,end_signal_3_3 ,end_signal_3_4 ;
wire						end_signal_3_5 ,end_signal_3_6 ,end_signal_3_7 ,end_signal_3_8 ;
wire						end_signal_3_9 ,end_signal_3_10,end_signal_3_11,end_signal_3_12;
wire						end_signal_3_13,end_signal_3_14,end_signal_3_15,end_signal_3_16;
wire						end_signal_3_17,end_signal_3_18,end_signal_3_19,end_signal_3_20;
wire						end_signal_3_21,end_signal_3_22,end_signal_3_23,end_signal_3_24;

wire						end_signal_4_1 ,end_signal_4_2 ,end_signal_4_3 ,end_signal_4_4 ;
wire						end_signal_4_5 ,end_signal_4_6 ,end_signal_4_7 ,end_signal_4_8 ;
wire						end_signal_4_9 ,end_signal_4_10,end_signal_4_11,end_signal_4_12;
wire						end_signal_4_13,end_signal_4_14,end_signal_4_15,end_signal_4_16;
wire						end_signal_4_17,end_signal_4_18,end_signal_4_19,end_signal_4_20;
wire						end_signal_4_21,end_signal_4_22,end_signal_4_23,end_signal_4_24;

wire						end_signal_5_1 ,end_signal_5_2 ,end_signal_5_3 ,end_signal_5_4 ;
wire						end_signal_5_5 ,end_signal_5_6 ,end_signal_5_7 ,end_signal_5_8 ;
wire						end_signal_5_9 ,end_signal_5_10,end_signal_5_11,end_signal_5_12;
wire						end_signal_5_13,end_signal_5_14,end_signal_5_15,end_signal_5_16;
wire						end_signal_5_17,end_signal_5_18,end_signal_5_19,end_signal_5_20;
wire						end_signal_5_21,end_signal_5_22,end_signal_5_23,end_signal_5_24;

wire						end_signal_6_1 ,end_signal_6_2 ,end_signal_6_3 ,end_signal_6_4 ;
wire						end_signal_6_5 ,end_signal_6_6 ,end_signal_6_7 ,end_signal_6_8 ;
wire						end_signal_6_9 ,end_signal_6_10,end_signal_6_11,end_signal_6_12;
wire						end_signal_6_13,end_signal_6_14,end_signal_6_15,end_signal_6_16;
wire						end_signal_6_17,end_signal_6_18,end_signal_6_19,end_signal_6_20;
wire						end_signal_6_21,end_signal_6_22,end_signal_6_23,end_signal_6_24;

pe_unit U1_1 (clk,reset,(enable&enable_1),kernel_1[199:192]	,act[199:192]	,psum_in_1	,end_signal_1_1 	,out_1_1 );
pe_unit U1_2 (clk,reset,end_signal_1_1 	,kernel_1[191:184]	,act[191:184]	,out_1_1	,end_signal_1_2 	,out_1_2 );
pe_unit U1_3 (clk,reset,end_signal_1_2 	,kernel_1[183:176]	,act[183:176]	,out_1_2	,end_signal_1_3 	,out_1_3 );
pe_unit U1_4 (clk,reset,end_signal_1_3 	,kernel_1[175:168]	,act[175:168]	,out_1_3 	,end_signal_1_4 	,out_1_4 );
pe_unit U1_5 (clk,reset,end_signal_1_4 	,kernel_1[167:160]	,act[167:160]	,out_1_4 	,end_signal_1_5 	,out_1_5 );
pe_unit U1_6 (clk,reset,end_signal_1_5 	,kernel_1[159:152]	,act[159:152]	,out_1_5 	,end_signal_1_6 	,out_1_6 );
pe_unit U1_7 (clk,reset,end_signal_1_6 	,kernel_1[151:144]	,act[151:144]	,out_1_6 	,end_signal_1_7 	,out_1_7 );
pe_unit U1_8 (clk,reset,end_signal_1_7 	,kernel_1[143:136]	,act[143:136]	,out_1_7 	,end_signal_1_8 	,out_1_8 );
pe_unit U1_9 (clk,reset,end_signal_1_8 	,kernel_1[135:128]	,act[135:128]	,out_1_8 	,end_signal_1_9 	,out_1_9 );
pe_unit U1_10(clk,reset,end_signal_1_9 	,kernel_1[127:120]	,act[127:120]	,out_1_9 	,end_signal_1_10	,out_1_10);
pe_unit U1_11(clk,reset,end_signal_1_10	,kernel_1[119:112]	,act[119:112]	,out_1_10 	,end_signal_1_11 	,out_1_11);
pe_unit U1_12(clk,reset,end_signal_1_11	,kernel_1[111:104]	,act[111:104]	,out_1_11 	,end_signal_1_12 	,out_1_12);
pe_unit U1_13(clk,reset,end_signal_1_12	,kernel_1[103:96]	,act[103:96]	,out_1_12 	,end_signal_1_13 	,out_1_13);
pe_unit U1_14(clk,reset,end_signal_1_13 ,kernel_1[95:88] 	,act[95:88] 	,out_1_13 	,end_signal_1_14 	,out_1_14);
pe_unit U1_15(clk,reset,end_signal_1_14 ,kernel_1[87:80]	,act[87:80]		,out_1_14 	,end_signal_1_15 	,out_1_15);
pe_unit U1_16(clk,reset,end_signal_1_15 ,kernel_1[79:72]	,act[79:72]		,out_1_15 	,end_signal_1_16 	,out_1_16);
pe_unit U1_17(clk,reset,end_signal_1_16 ,kernel_1[71:64]	,act[71:64] 	,out_1_16 	,end_signal_1_17 	,out_1_17);
pe_unit U1_18(clk,reset,end_signal_1_17 ,kernel_1[63:56]	,act[63:56] 	,out_1_17 	,end_signal_1_18 	,out_1_18);
pe_unit U1_19(clk,reset,end_signal_1_18 ,kernel_1[55:48]	,act[55:48]		,out_1_18	,end_signal_1_19 	,out_1_19);
pe_unit U1_20(clk,reset,end_signal_1_19 ,kernel_1[47:40]	,act[47:40]		,out_1_19	,end_signal_1_20 	,out_1_20);
pe_unit U1_21(clk,reset,end_signal_1_20 ,kernel_1[39:32]	,act[39:32]		,out_1_20	,end_signal_1_21 	,out_1_21);
pe_unit U1_22(clk,reset,end_signal_1_21 ,kernel_1[31:24]	,act[31:24]		,out_1_21 	,end_signal_1_22 	,out_1_22);
pe_unit U1_23(clk,reset,end_signal_1_22 ,kernel_1[23:16]	,act[23:16]		,out_1_22	,end_signal_1_23 	,out_1_23);
pe_unit U1_24(clk,reset,end_signal_1_23 ,kernel_1[15:8]		,act[15:8]		,out_1_23	,end_signal_1_24 	,out_1_24);
pe_unit U1_25(clk,reset,end_signal_1_24 ,kernel_1[7:0]		,act[7:0]		,out_1_24	,end_signal_1 	 	,result_1);


pe_unit U2_1 (clk,reset,(enable_2&end_signal_1_1),kernel_2[199:192]	,act[199:192]	,psum_in_2	,end_signal_2_1 	,out_2_1 );
pe_unit U2_2 (clk,reset,end_signal_2_1 	,kernel_2[191:184]	,act[191:184]	,out_2_1	,end_signal_2_2 	,out_2_2 );
pe_unit U2_3 (clk,reset,end_signal_2_2 	,kernel_2[183:176]	,act[183:176]	,out_2_2	,end_signal_2_3 	,out_2_3 );
pe_unit U2_4 (clk,reset,end_signal_2_3 	,kernel_2[175:168]	,act[175:168]	,out_2_3 	,end_signal_2_4 	,out_2_4 );
pe_unit U2_5 (clk,reset,end_signal_2_4 	,kernel_2[167:160]	,act[167:160]	,out_2_4 	,end_signal_2_5 	,out_2_5 );
pe_unit U2_6 (clk,reset,end_signal_2_5 	,kernel_2[159:152]	,act[159:152]	,out_2_5 	,end_signal_2_6 	,out_2_6 );
pe_unit U2_7 (clk,reset,end_signal_2_6 	,kernel_2[151:144]	,act[151:144]	,out_2_6 	,end_signal_2_7 	,out_2_7 );
pe_unit U2_8 (clk,reset,end_signal_2_7 	,kernel_2[143:136]	,act[143:136]	,out_2_7 	,end_signal_2_8 	,out_2_8 );
pe_unit U2_9 (clk,reset,end_signal_2_8 	,kernel_2[135:128]	,act[135:128]	,out_2_8 	,end_signal_2_9 	,out_2_9 );
pe_unit U2_10(clk,reset,end_signal_2_9 	,kernel_2[127:120]	,act[127:120]	,out_2_9 	,end_signal_2_10	,out_2_10);
pe_unit U2_11(clk,reset,end_signal_2_10	,kernel_2[119:112]	,act[119:112]	,out_2_10 	,end_signal_2_11 	,out_2_11);
pe_unit U2_12(clk,reset,end_signal_2_11	,kernel_2[111:104]	,act[111:104]	,out_2_11 	,end_signal_2_12 	,out_2_12);
pe_unit U2_13(clk,reset,end_signal_2_12	,kernel_2[103:96]	,act[103:96]	,out_2_12 	,end_signal_2_13 	,out_2_13);
pe_unit U2_14(clk,reset,end_signal_2_13 ,kernel_2[95:88] 	,act[95:88] 	,out_2_13 	,end_signal_2_14 	,out_2_14);
pe_unit U2_15(clk,reset,end_signal_2_14 ,kernel_2[87:80]	,act[87:80]		,out_2_14 	,end_signal_2_15 	,out_2_15);
pe_unit U2_16(clk,reset,end_signal_2_15 ,kernel_2[79:72]	,act[79:72]		,out_2_15 	,end_signal_2_16 	,out_2_16);
pe_unit U2_17(clk,reset,end_signal_2_16 ,kernel_2[71:64]	,act[71:64] 	,out_2_16 	,end_signal_2_17 	,out_2_17);
pe_unit U2_18(clk,reset,end_signal_2_17 ,kernel_2[63:56]	,act[63:56] 	,out_2_17 	,end_signal_2_18 	,out_2_18);
pe_unit U2_19(clk,reset,end_signal_2_18 ,kernel_2[55:48]	,act[55:48]		,out_2_18	,end_signal_2_19 	,out_2_19);
pe_unit U2_20(clk,reset,end_signal_2_19 ,kernel_2[47:40]	,act[47:40]		,out_2_19	,end_signal_2_20 	,out_2_20);
pe_unit U2_21(clk,reset,end_signal_2_20 ,kernel_2[39:32]	,act[39:32]		,out_2_20	,end_signal_2_21 	,out_2_21);
pe_unit U2_22(clk,reset,end_signal_2_21 ,kernel_2[31:24]	,act[31:24]		,out_2_21 	,end_signal_2_22 	,out_2_22);
pe_unit U2_23(clk,reset,end_signal_2_22 ,kernel_2[23:16]	,act[23:16]		,out_2_22	,end_signal_2_23 	,out_2_23);
pe_unit U2_24(clk,reset,end_signal_2_23 ,kernel_2[15:8]		,act[15:8]		,out_2_23	,end_signal_2_24 	,out_2_24);
pe_unit U2_25(clk,reset,end_signal_2_24 ,kernel_2[7:0]		,act[7:0]		,out_2_24	,end_signal_2 	 	,result_2);


pe_unit U3_1 (clk,reset,(enable_3&end_signal_2_1),kernel_3[199:192]	,act[199:192]	,psum_in_3	,end_signal_3_1 	,out_3_1 );
pe_unit U3_2 (clk,reset,end_signal_3_1 	,kernel_3[191:184]	,act[191:184]	,out_3_1	,end_signal_3_2 	,out_3_2 );
pe_unit U3_3 (clk,reset,end_signal_3_2 	,kernel_3[183:176]	,act[183:176]	,out_3_2	,end_signal_3_3 	,out_3_3 );
pe_unit U3_4 (clk,reset,end_signal_3_3 	,kernel_3[175:168]	,act[175:168]	,out_3_3 	,end_signal_3_4 	,out_3_4 );
pe_unit U3_5 (clk,reset,end_signal_3_4 	,kernel_3[167:160]	,act[167:160]	,out_3_4 	,end_signal_3_5 	,out_3_5 );
pe_unit U3_6 (clk,reset,end_signal_3_5 	,kernel_3[159:152]	,act[159:152]	,out_3_5 	,end_signal_3_6 	,out_3_6 );
pe_unit U3_7 (clk,reset,end_signal_3_6 	,kernel_3[151:144]	,act[151:144]	,out_3_6 	,end_signal_3_7 	,out_3_7 );
pe_unit U3_8 (clk,reset,end_signal_3_7 	,kernel_3[143:136]	,act[143:136]	,out_3_7 	,end_signal_3_8 	,out_3_8 );
pe_unit U3_9 (clk,reset,end_signal_3_8 	,kernel_3[135:128]	,act[135:128]	,out_3_8 	,end_signal_3_9 	,out_3_9 );
pe_unit U3_10(clk,reset,end_signal_3_9 	,kernel_3[127:120]	,act[127:120]	,out_3_9 	,end_signal_3_10	,out_3_10);
pe_unit U3_11(clk,reset,end_signal_3_10	,kernel_3[119:112]	,act[119:112]	,out_3_10 	,end_signal_3_11 	,out_3_11);
pe_unit U3_12(clk,reset,end_signal_3_11	,kernel_3[111:104]	,act[111:104]	,out_3_11 	,end_signal_3_12 	,out_3_12);
pe_unit U3_13(clk,reset,end_signal_3_12	,kernel_3[103:96]	,act[103:96]	,out_3_12 	,end_signal_3_13 	,out_3_13);
pe_unit U3_14(clk,reset,end_signal_3_13 ,kernel_3[95:88] 	,act[95:88] 	,out_3_13 	,end_signal_3_14 	,out_3_14);
pe_unit U3_15(clk,reset,end_signal_3_14 ,kernel_3[87:80]	,act[87:80]		,out_3_14 	,end_signal_3_15 	,out_3_15);
pe_unit U3_16(clk,reset,end_signal_3_15 ,kernel_3[79:72]	,act[79:72]		,out_3_15 	,end_signal_3_16 	,out_3_16);
pe_unit U3_17(clk,reset,end_signal_3_16 ,kernel_3[71:64]	,act[71:64] 	,out_3_16 	,end_signal_3_17 	,out_3_17);
pe_unit U3_18(clk,reset,end_signal_3_17 ,kernel_3[63:56]	,act[63:56] 	,out_3_17 	,end_signal_3_18 	,out_3_18);
pe_unit U3_19(clk,reset,end_signal_3_18 ,kernel_3[55:48]	,act[55:48]		,out_3_18	,end_signal_3_19 	,out_3_19);
pe_unit U3_20(clk,reset,end_signal_3_19 ,kernel_3[47:40]	,act[47:40]		,out_3_19	,end_signal_3_20 	,out_3_20);
pe_unit U3_21(clk,reset,end_signal_3_20 ,kernel_3[39:32]	,act[39:32]		,out_3_20	,end_signal_3_21 	,out_3_21);
pe_unit U3_22(clk,reset,end_signal_3_21 ,kernel_3[31:24]	,act[31:24]		,out_3_21 	,end_signal_3_22 	,out_3_22);
pe_unit U3_23(clk,reset,end_signal_3_22 ,kernel_3[23:16]	,act[23:16]		,out_3_22	,end_signal_3_23 	,out_3_23);
pe_unit U3_24(clk,reset,end_signal_3_23 ,kernel_3[15:8]		,act[15:8]		,out_3_23	,end_signal_3_24 	,out_3_24);
pe_unit U3_25(clk,reset,end_signal_3_24 ,kernel_3[7:0]		,act[7:0]		,out_3_24	,end_signal_3 	 	,result_3);


pe_unit U4_1 (clk,reset,(enable_4&end_signal_3_1),kernel_4[199:192]	,act[199:192]	,psum_in_4	,end_signal_4_1 	,out_4_1 );
pe_unit U4_2 (clk,reset,end_signal_4_1 	,kernel_4[191:184]	,act[191:184]	,out_4_1	,end_signal_4_2 	,out_4_2 );
pe_unit U4_3 (clk,reset,end_signal_4_2 	,kernel_4[183:176]	,act[183:176]	,out_4_2	,end_signal_4_3 	,out_4_3 );
pe_unit U4_4 (clk,reset,end_signal_4_3 	,kernel_4[175:168]	,act[175:168]	,out_4_3 	,end_signal_4_4 	,out_4_4 );
pe_unit U4_5 (clk,reset,end_signal_4_4 	,kernel_4[167:160]	,act[167:160]	,out_4_4 	,end_signal_4_5 	,out_4_5 );
pe_unit U4_6 (clk,reset,end_signal_4_5 	,kernel_4[159:152]	,act[159:152]	,out_4_5 	,end_signal_4_6 	,out_4_6 );
pe_unit U4_7 (clk,reset,end_signal_4_6 	,kernel_4[151:144]	,act[151:144]	,out_4_6 	,end_signal_4_7 	,out_4_7 );
pe_unit U4_8 (clk,reset,end_signal_4_7 	,kernel_4[143:136]	,act[143:136]	,out_4_7 	,end_signal_4_8 	,out_4_8 );
pe_unit U4_9 (clk,reset,end_signal_4_8 	,kernel_4[135:128]	,act[135:128]	,out_4_8 	,end_signal_4_9 	,out_4_9 );
pe_unit U4_10(clk,reset,end_signal_4_9 	,kernel_4[127:120]	,act[127:120]	,out_4_9 	,end_signal_4_10	,out_4_10);
pe_unit U4_11(clk,reset,end_signal_4_10	,kernel_4[119:112]	,act[119:112]	,out_4_10 	,end_signal_4_11 	,out_4_11);
pe_unit U4_12(clk,reset,end_signal_4_11	,kernel_4[111:104]	,act[111:104]	,out_4_11 	,end_signal_4_12 	,out_4_12);
pe_unit U4_13(clk,reset,end_signal_4_12	,kernel_4[103:96]	,act[103:96]	,out_4_12 	,end_signal_4_13 	,out_4_13);
pe_unit U4_14(clk,reset,end_signal_4_13 ,kernel_4[95:88] 	,act[95:88] 	,out_4_13 	,end_signal_4_14 	,out_4_14);
pe_unit U4_15(clk,reset,end_signal_4_14 ,kernel_4[87:80]	,act[87:80]		,out_4_14 	,end_signal_4_15 	,out_4_15);
pe_unit U4_16(clk,reset,end_signal_4_15 ,kernel_4[79:72]	,act[79:72]		,out_4_15 	,end_signal_4_16 	,out_4_16);
pe_unit U4_17(clk,reset,end_signal_4_16 ,kernel_4[71:64]	,act[71:64] 	,out_4_16 	,end_signal_4_17 	,out_4_17);
pe_unit U4_18(clk,reset,end_signal_4_17 ,kernel_4[63:56]	,act[63:56] 	,out_4_17 	,end_signal_4_18 	,out_4_18);
pe_unit U4_19(clk,reset,end_signal_4_18 ,kernel_4[55:48]	,act[55:48]		,out_4_18	,end_signal_4_19 	,out_4_19);
pe_unit U4_20(clk,reset,end_signal_4_19 ,kernel_4[47:40]	,act[47:40]		,out_4_19	,end_signal_4_20 	,out_4_20);
pe_unit U4_21(clk,reset,end_signal_4_20 ,kernel_4[39:32]	,act[39:32]		,out_4_20	,end_signal_4_21 	,out_4_21);
pe_unit U4_22(clk,reset,end_signal_4_21 ,kernel_4[31:24]	,act[31:24]		,out_4_21 	,end_signal_4_22 	,out_4_22);
pe_unit U4_23(clk,reset,end_signal_4_22 ,kernel_4[23:16]	,act[23:16]		,out_4_22	,end_signal_4_23 	,out_4_23);
pe_unit U4_24(clk,reset,end_signal_4_23 ,kernel_4[15:8]		,act[15:8]		,out_4_23	,end_signal_4_24 	,out_4_24);
pe_unit U4_25(clk,reset,end_signal_4_24 ,kernel_4[7:0]		,act[7:0]		,out_4_24	,end_signal_4 	 	,result_4);


pe_unit U5_1 (clk,reset,(enable_5&end_signal_4_1),kernel_5[199:192]	,act[199:192]	,psum_in_5	,end_signal_5_1 	,out_5_1 );
pe_unit U5_2 (clk,reset,end_signal_5_1 	,kernel_5[191:184]	,act[191:184]	,out_5_1	,end_signal_5_2 	,out_5_2 );
pe_unit U5_3 (clk,reset,end_signal_5_2 	,kernel_5[183:176]	,act[183:176]	,out_5_2	,end_signal_5_3 	,out_5_3 );
pe_unit U5_4 (clk,reset,end_signal_5_3 	,kernel_5[175:168]	,act[175:168]	,out_5_3 	,end_signal_5_4 	,out_5_4 );
pe_unit U5_5 (clk,reset,end_signal_5_4 	,kernel_5[167:160]	,act[167:160]	,out_5_4 	,end_signal_5_5 	,out_5_5 );
pe_unit U5_6 (clk,reset,end_signal_5_5 	,kernel_5[159:152]	,act[159:152]	,out_5_5 	,end_signal_5_6 	,out_5_6 );
pe_unit U5_7 (clk,reset,end_signal_5_6 	,kernel_5[151:144]	,act[151:144]	,out_5_6 	,end_signal_5_7 	,out_5_7 );
pe_unit U5_8 (clk,reset,end_signal_5_7 	,kernel_5[143:136]	,act[143:136]	,out_5_7 	,end_signal_5_8 	,out_5_8 );
pe_unit U5_9 (clk,reset,end_signal_5_8 	,kernel_5[135:128]	,act[135:128]	,out_5_8 	,end_signal_5_9 	,out_5_9 );
pe_unit U5_10(clk,reset,end_signal_5_9 	,kernel_5[127:120]	,act[127:120]	,out_5_9 	,end_signal_5_10	,out_5_10);
pe_unit U5_11(clk,reset,end_signal_5_10	,kernel_5[119:112]	,act[119:112]	,out_5_10 	,end_signal_5_11 	,out_5_11);
pe_unit U5_12(clk,reset,end_signal_5_11	,kernel_5[111:104]	,act[111:104]	,out_5_11 	,end_signal_5_12 	,out_5_12);
pe_unit U5_13(clk,reset,end_signal_5_12	,kernel_5[103:96]	,act[103:96]	,out_5_12 	,end_signal_5_13 	,out_5_13);
pe_unit U5_14(clk,reset,end_signal_5_13 ,kernel_5[95:88] 	,act[95:88] 	,out_5_13 	,end_signal_5_14 	,out_5_14);
pe_unit U5_15(clk,reset,end_signal_5_14 ,kernel_5[87:80]	,act[87:80]		,out_5_14 	,end_signal_5_15 	,out_5_15);
pe_unit U5_16(clk,reset,end_signal_5_15 ,kernel_5[79:72]	,act[79:72]		,out_5_15 	,end_signal_5_16 	,out_5_16);
pe_unit U5_17(clk,reset,end_signal_5_16 ,kernel_5[71:64]	,act[71:64] 	,out_5_16 	,end_signal_5_17 	,out_5_17);
pe_unit U5_18(clk,reset,end_signal_5_17 ,kernel_5[63:56]	,act[63:56] 	,out_5_17 	,end_signal_5_18 	,out_5_18);
pe_unit U5_19(clk,reset,end_signal_5_18 ,kernel_5[55:48]	,act[55:48]		,out_5_18	,end_signal_5_19 	,out_5_19);
pe_unit U5_20(clk,reset,end_signal_5_19 ,kernel_5[47:40]	,act[47:40]		,out_5_19	,end_signal_5_20 	,out_5_20);
pe_unit U5_21(clk,reset,end_signal_5_20 ,kernel_5[39:32]	,act[39:32]		,out_5_20	,end_signal_5_21 	,out_5_21);
pe_unit U5_22(clk,reset,end_signal_5_21 ,kernel_5[31:24]	,act[31:24]		,out_5_21 	,end_signal_5_22 	,out_5_22);
pe_unit U5_23(clk,reset,end_signal_5_22 ,kernel_5[23:16]	,act[23:16]		,out_5_22	,end_signal_5_23 	,out_5_23);
pe_unit U5_24(clk,reset,end_signal_5_23 ,kernel_5[15:8]		,act[15:8]		,out_5_23	,end_signal_5_24 	,out_5_24);
pe_unit U5_25(clk,reset,end_signal_5_24 ,kernel_5[7:0]		,act[7:0]		,out_5_24	,end_signal_5 	 	,result_5);


pe_unit U6_1 (clk,reset,(enable_6&end_signal_5_1),kernel_5[199:192]	,act[199:192]	,psum_in_5	,end_signal_6_1 	,out_6_1 );
pe_unit U6_2 (clk,reset,end_signal_6_1 	,kernel_5[191:184]	,act[191:184]	,out_6_1	,end_signal_6_2 	,out_6_2 );
pe_unit U6_3 (clk,reset,end_signal_6_2 	,kernel_5[183:176]	,act[183:176]	,out_6_2	,end_signal_6_3 	,out_6_3 );
pe_unit U6_4 (clk,reset,end_signal_6_3 	,kernel_5[175:168]	,act[175:168]	,out_6_3 	,end_signal_6_4 	,out_6_4 );
pe_unit U6_5 (clk,reset,end_signal_6_4 	,kernel_5[167:160]	,act[167:160]	,out_6_4 	,end_signal_6_5 	,out_6_5 );
pe_unit U6_6 (clk,reset,end_signal_6_5 	,kernel_5[159:152]	,act[159:152]	,out_6_5 	,end_signal_6_6 	,out_6_6 );
pe_unit U6_7 (clk,reset,end_signal_6_6 	,kernel_5[151:144]	,act[151:144]	,out_6_6 	,end_signal_6_7 	,out_6_7 );
pe_unit U6_8 (clk,reset,end_signal_6_7 	,kernel_5[143:136]	,act[143:136]	,out_6_7 	,end_signal_6_8 	,out_6_8 );
pe_unit U6_9 (clk,reset,end_signal_6_8 	,kernel_5[135:128]	,act[135:128]	,out_6_8 	,end_signal_6_9 	,out_6_9 );
pe_unit U6_10(clk,reset,end_signal_6_9 	,kernel_5[127:120]	,act[127:120]	,out_6_9 	,end_signal_6_10	,out_6_10);
pe_unit U6_11(clk,reset,end_signal_6_10	,kernel_5[119:112]	,act[119:112]	,out_6_10 	,end_signal_6_11 	,out_6_11);
pe_unit U6_12(clk,reset,end_signal_6_11	,kernel_5[111:104]	,act[111:104]	,out_6_11 	,end_signal_6_12 	,out_6_12);
pe_unit U6_13(clk,reset,end_signal_6_12	,kernel_5[103:96]	,act[103:96]	,out_6_12 	,end_signal_6_13 	,out_6_13);
pe_unit U6_14(clk,reset,end_signal_6_13 ,kernel_5[95:88] 	,act[95:88] 	,out_6_13 	,end_signal_6_14 	,out_6_14);
pe_unit U6_15(clk,reset,end_signal_6_14 ,kernel_5[87:80]	,act[87:80]		,out_6_14 	,end_signal_6_15 	,out_6_15);
pe_unit U6_16(clk,reset,end_signal_6_15 ,kernel_5[79:72]	,act[79:72]		,out_6_15 	,end_signal_6_16 	,out_6_16);
pe_unit U6_17(clk,reset,end_signal_6_16 ,kernel_5[71:64]	,act[71:64] 	,out_6_16 	,end_signal_6_17 	,out_6_17);
pe_unit U6_18(clk,reset,end_signal_6_17 ,kernel_5[63:56]	,act[63:56] 	,out_6_17 	,end_signal_6_18 	,out_6_18);
pe_unit U6_19(clk,reset,end_signal_6_18 ,kernel_5[55:48]	,act[55:48]		,out_6_18	,end_signal_6_19 	,out_6_19);
pe_unit U6_20(clk,reset,end_signal_6_19 ,kernel_5[47:40]	,act[47:40]		,out_6_19	,end_signal_6_20 	,out_6_20);
pe_unit U6_21(clk,reset,end_signal_6_20 ,kernel_5[39:32]	,act[39:32]		,out_6_20	,end_signal_6_21 	,out_6_21);
pe_unit U6_22(clk,reset,end_signal_6_21 ,kernel_5[31:24]	,act[31:24]		,out_6_21 	,end_signal_6_22 	,out_6_22);
pe_unit U6_23(clk,reset,end_signal_6_22 ,kernel_5[23:16]	,act[23:16]		,out_6_22	,end_signal_6_23 	,out_6_23);
pe_unit U6_24(clk,reset,end_signal_6_23 ,kernel_5[15:8]		,act[15:8]		,out_6_23	,end_signal_6_24 	,out_6_24);
pe_unit U6_25(clk,reset,end_signal_6_24 ,kernel_5[7:0]		,act[7:0]		,out_6_24	,end_signal_6 	 	,result_6);

endmodule
