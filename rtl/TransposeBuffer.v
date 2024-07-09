`timescale 1ns / 1ps

module TransposeBuffer(
    input i_clk,
    input i_rst,
    input i_valid,
    input [11:0] i_data0,
    input [11:0] i_data1,
    input [11:0] i_data2,
    input [11:0] i_data3,
    input [11:0] i_data4,
    input [11:0] i_data5,
    input [11:0] i_data6,
    input [11:0] i_data7,
    
    output [11:0] o_data0,
    output [11:0] o_data1,
    output [11:0] o_data2,
    output [11:0] o_data3,
    output [11:0] o_data4,
    output [11:0] o_data5,
    output [11:0] o_data6,
    output [11:0] o_data7,
    output o_valid
    );
    reg [1:0] read;
    reg [1:0] write;
    reg [2:0] finish;
    reg f_flag;
    
    wire [1:0] buf_valid;
    wire signed [11:0] o_buf0_out0;
    wire signed [11:0] o_buf0_out1;
    wire signed [11:0] o_buf0_out2;
    wire signed [11:0] o_buf0_out3;
    wire signed [11:0] o_buf0_out4;
    wire signed [11:0] o_buf0_out5;
    wire signed [11:0] o_buf0_out6;
    wire signed [11:0] o_buf0_out7;
    
    wire signed [11:0] o_buf1_out0;
    wire signed [11:0] o_buf1_out1;
    wire signed [11:0] o_buf1_out2;
    wire signed [11:0] o_buf1_out3;
    wire signed [11:0] o_buf1_out4;
    wire signed [11:0] o_buf1_out5;
    wire signed [11:0] o_buf1_out6;
    wire signed [11:0] o_buf1_out7;
    
    reg [2:0] count;
    reg initial_flag;
    
    //count setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            count <=0;
        end
        else begin
            if(i_valid) begin
                count <= count +1;
                if(count == 7) begin
                    count<=0;
                end
            end
        end
    end
    
    // flag_setting
    always@(posedge i_clk) begin
        if(i_rst) begin
            initial_flag <= 0;
        end
        else begin
            if(count ==7)begin
                initial_flag <=1;
            end
        end
    end
    
    // write setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            write <= 2'b01;
        end
        else begin
            if(count==7 && i_valid)begin
                if(write== 2'b01)begin
                    write <= 2'b10;
                end
                else begin
                    write <= 2'b01;
                end
            end
        end
    end
    
    // read setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            read <= 2'b00;
        end
        else begin
            if(count == 7)begin
                read <= 2'b01; 
            end
            else begin
                if(read == 2'b01 && count == 7)begin
                    read <= 2'b10;
                end
                else if(read == 2'b10 && count == 7) begin
                    read <= 2'b01;
                end
            end
        end
    end
    
    //finish setting 
    always@(posedge i_clk)begin
        if(i_rst)begin
            finish <=0;
            f_flag<=0;
        end
        else begin
            if( ~i_valid && initial_flag)begin
                finish <= finish +1;
                if(finish == 7)begin
                    f_flag <=1;
                end
            end 
        end
    end
    
    dct_linebuffer LB0 (.i_clk(i_clk), .i_rst(i_rst), .i_read(read[0] & ~f_flag), .i_write(write[0] & i_valid), .i_data0(i_data0), .i_data1(i_data1), .i_data2(i_data2), .i_data3(i_data3), .i_data4(i_data4), .i_data5(i_data5), .i_data6(i_data6), .i_data7(i_data7),
    .o_data0(o_buf0_out0), .o_data1(o_buf0_out1), .o_data2(o_buf0_out2), .o_data3(o_buf0_out3), .o_data4(o_buf0_out4), .o_data5(o_buf0_out5), .o_data6(o_buf0_out6), .o_data7(o_buf0_out7), .o_valid(buf_valid[0]));
    
    dct_linebuffer LB1 (.i_clk(i_clk), .i_rst(i_rst), .i_read(read[1] & ~f_flag), .i_write(write[1] & i_valid), .i_data0(i_data0), .i_data1(i_data1), .i_data2(i_data2), .i_data3(i_data3), .i_data4(i_data4), .i_data5(i_data5), .i_data6(i_data6), .i_data7(i_data7),
    .o_data0(o_buf1_out0), .o_data1(o_buf1_out1), .o_data2(o_buf1_out2), .o_data3(o_buf1_out3), .o_data4(o_buf1_out4), .o_data5(o_buf1_out5), .o_data6(o_buf1_out6), .o_data7(o_buf1_out7), .o_valid(buf_valid[1]));    
    
    assign o_data0 = read[1] ? o_buf1_out0 : o_buf0_out0;
    assign o_data1 = read[1] ? o_buf1_out1 : o_buf0_out1;
    assign o_data2 = read[1] ? o_buf1_out2 : o_buf0_out2;
    assign o_data3 = read[1] ? o_buf1_out3 : o_buf0_out3;
    assign o_data4 = read[1] ? o_buf1_out4 : o_buf0_out4;
    assign o_data5 = read[1] ? o_buf1_out5 : o_buf0_out5;
    assign o_data6 = read[1] ? o_buf1_out6 : o_buf0_out6;
    assign o_data7 = read[1] ? o_buf1_out7 : o_buf0_out7;
    assign o_valid = read[1] ? buf_valid[1] : buf_valid[0];
    
endmodule
