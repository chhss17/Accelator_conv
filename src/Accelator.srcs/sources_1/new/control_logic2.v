`timescale 1ns / 1ps

module control_logic2(
    input               clk,
    input               master_rst,
    input               enable,
    input       [7:0]   size_act,
    input       [7:0]   size_pool_kernel,
    input       [7:0]   num_feature,

    output wire [1:0]   sel,
    output reg          op_en,
    output reg          load_sr,
    output reg          global_rst,
    output              end_pool
    );

    integer     row_count;
    integer     col_count;
    integer     count;
    integer     nbgh_row_count;

    integer     num_f_tmp;
    integer     m,p,n;

    integer ce;
    always @(*)  begin 
        if(master_rst)              ce = 0;
        else if(enable == 1)        ce = 1;
        else if(end_pool == 1 )     ce = 0;
    end

    wire        pool_ctr_rst;
    assign      pool_ctr_rst = (master_rst || enable);

    always@(posedge clk) begin           
        if(pool_ctr_rst) begin
            row_count       <= 0;
            col_count       <= 0;
            count           <= 0;
            nbgh_row_count  <= 0;

            m = size_act;
            p = size_pool_kernel;
            n = num_feature; 
        end
        else begin
            if(ce) begin
                if(global_rst ) begin
                   row_count <= 0;
                   col_count <= 0;
                   count     <= 0;
                   nbgh_row_count <= nbgh_row_count + 1; 
                end
                else begin
                    if(((col_count+1) % p == 0)&&(count == m/p-1)&&(row_count != p-1)) begin   //col_count and row_count
                        col_count <= 0;
                        row_count <= row_count + 1;
                        count     <= 0;
                    end 
                    else begin
                        col_count <=col_count+1;
                        if(((col_count+1) % p == 0)&&(count != m/p-1)) begin
                            count <= count+ 1;
                        end 
                    end
                end
            end
        end  
    end 

     always@(posedge clk) begin 
        if(pool_ctr_rst) begin       
            load_sr     <= 0;
            op_en       <= 0;
            global_rst  <= 0;
        end
        else begin
            if(((col_count+1)%p ==0)&&(row_count == p-1)&&(col_count == p*count+ (p-1))&&ce) begin    
                op_en <=1;
            end 
            else begin
                op_en <= 0;
            end

            if(ce) begin
                if((col_count == m-2)&&(row_count == p-1)) begin    //global_rst and pause_ip ??? (col_count == m-2)
                    global_rst <= 1;                                //  (reset everything)
                end
                else begin
                    global_rst <= 0;
                end  
            end
        end 
    end
    reg end_op;
    integer num_clk;
    always @(posedge clk) begin
        if(pool_ctr_rst) begin
            end_op    <= 0;
            num_clk    = 0;
            num_f_tmp  = 0;
        end 
        else if(nbgh_row_count == m/p) begin
            if(num_clk == 0)    end_op <= 1;
            else                end_op <= 0;

            nbgh_row_count = 0;
            num_clk        = num_clk + 1;

        end
        else    begin 
                num_clk = 0;
                end_op <= 0;
        end 
            
    end

    assign end_pool = (num_f_tmp == n && end_op == 1) ? 1 : 0;

    always @(end_op) begin 
                if((end_op) == 1)begin 
                    num_f_tmp = num_f_tmp + 1;
                end
    end

    always@(col_count) begin 
                if(((col_count) % p == 0) && (col_count >= 0)) begin               
                    load_sr <= 1;                                
                end 
                else begin
                    load_sr <= 0;
                end
    end 

    assign sel =  (pool_ctr_rst)? 2'b10 :
                  ((col_count % p == 0) && (row_count == 0))? 2'b10 :
                  ((col_count % p == 0) && (row_count != 0))? 2'b01 : 2'b00;


    endmodule
