`timescale 1ns / 1ps

//1. normal case : just store the max value in the register.  
//2. end of one neighbourhood: store the max value to the shift register.
//3. end of row: store the max value in the shift register and then load the max register from the shift register.
//4. end of neighbourhood in the last row: make output valid and store the max value in the max register.
//5. end of last neighbourhood of last row: make op valid and store the max value in the max register and then reset the entire module.

//SIGNALS TO BE HANDLED IN EACH CASE
//CASE               1		 2		 3 	 	 4		 5 
//1. load _sr       low	    high	high	high	low			
//2. sel			low		low	   	high	high	low
//3. rst_m			low		high	low		low		low
//4. op_en			low		low		low		high	high
//5. global_rst		low		low		low		low		high

module control_logic2(
    input               clk,
    input               pool_ctr_rst,
    input               ce,
    input       [7:0]   m,
    input       [7:0]   p,
    input       [7:0]   num_feature,

    output wire [1:0]   sel,
    output reg          rst_m,
    output reg          op_en,
    output reg          load_sr,
    output reg          global_rst,
    output              end_pool
    );
    //parameter m = 9'h01a;
    //parameter   m = 9'h006;
    //parameter   p = 9'h002;
    //integer clk_temp  =0;
    integer     row_count =0;
    integer     col_count =0;
    integer     count =0;
    integer     nbgh_row_count;

    integer     num_f_tmp = 0;

    wire end_op;

    always@(posedge clk) begin            //counters
        //clk_temp = ~clk_temp;
        if(pool_ctr_rst ) begin
            row_count   <=0;
            col_count   <=-1;//ffffffff;
            count       <=-1;//ffffffff;
            nbgh_row_count <=0;
        end
        else begin
            if(ce) begin
                if(global_rst ) begin
                   row_count <=0;
                   col_count <=0;//ffffffff;
                   count     <=0;//ffffffff;
                   nbgh_row_count <= (nbgh_row_count + 1'b1)%m; //
                end
                else begin
                    if(((col_count+1) % p == 0)&&(count == m/p-1)&&(row_count != p-1)) begin   //col_count and row_count
                        col_count <= 0;
                        row_count <= row_count + 1'b1;
                        count     <=0;
                    end 
                    else begin
                        col_count <=col_count+1'b1;
                        if(((col_count+1) % p == 0)&&(count != m/p-1)) begin
                            count <= count+ 1'b1;
                        end 
                    end
                end
            end
        end  
    end 

     always@(posedge clk) begin 
        if(pool_ctr_rst) begin        //reset
            load_sr     <=0;
            rst_m       <=0;
            op_en       <=0;
            global_rst  <=0;
            //end_op      <=0;
        end
        else begin
            //if(((((col_count>=p)&&((col_count)%p ==0))&&(row_count == p-1))||((col_count == 0)&& (nbgh_row_count>0)&&(row_count==0)))&&ce) begin     //op_en    process ??? (col_count == p*count+ (p-2)
            if(((col_count+1)%p ==0)&&(row_count == p-1)&&(col_count == p*count+ (p-1))&&ce) begin    
                op_en <=1;
            end 
            else begin
                op_en <=0;
            end

            if(ce) begin
                if((col_count == m-2)&&(row_count == p-1)) begin    //global_rst and pause_ip ??? (col_count == m-2)
                    global_rst <= 1;                                //  (reset everything)
                end
                else begin
                    global_rst <= 0;
                end  

                //if((((col_count+1) % p == 0)&&(count != m/p-1)&&(row_count != p-1))||((col_count == m-1)&&(row_count == p-1))) begin     //rst_m
                if((((col_count+1) % p == 0)&&(count != m/p-1)&&(row_count == p-1))||((col_count == m-1)&&(row_count == p-1))) begin     //rst_m
                    rst_m <= 1;              
                end  
                else begin
                    rst_m <= 0;
                end   

            end
        end 
    end

    assign end_op   = (nbgh_row_count == m/p) ? 1 : 0;
    assign end_pool = (num_f_tmp == num_feature && col_count == 0) ? 1 : 0;

    //if((nbgh_row_count == m/p)) num_f_tmp = num_f_tmp + 1;

    always@(*) begin //每块：第一个数与0相比，其他行首与移位寄存器对比；
                if(((col_count+1) % p == 0) && (col_count >= 0)) begin                //load_sr
                    load_sr <= 1;                                 //&&(row_count!=p-1)
                end 
                else begin
                    load_sr <= 0;
                end

    end 

    always @(nbgh_row_count) begin 
                if((nbgh_row_count)%m == 0)begin 
                    num_f_tmp = num_f_tmp + 1;
                end
    end

    assign sel =  (pool_ctr_rst)? 2'b10 :
                  ((col_count % p == 0) && (row_count == 0))? 2'b10 :
                  ((col_count % p == 0) && (row_count != 0))? 2'b01 : 2'b00;


    endmodule
