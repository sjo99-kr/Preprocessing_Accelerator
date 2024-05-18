`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 21:34:19
// Design Name: 
// Module Name: Main_buffer
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


module Main_buffer#(parameter N = 24, M=240)(
    input i_clk,
    input i_rst,
    input [N-1:0] i_data1,
    input [N-1:0] i_data2,
    input [N-1:0] i_data3,
    input [N-1:0] i_data4,
    input [N-1:0] i_data5,
    input [N-1:0] i_data6,
    input [N-1:0] i_data7,
    input [N-1:0] i_data8,
    input i_write,
    
    output  [N-1 : 0] o_data1,
    output  [N-1 : 0] o_data2,
    output  [N-1 : 0] o_data3,
    output  [N-1 : 0] o_data4,
    output  [N-1 : 0] o_data5,
    output  [N-1 : 0] o_data6,
    output  [N-1 : 0] o_data7,
    output  [N-1 : 0] o_data8,
    output o_valid
    );
    reg [$clog2(M / 8) + 1: 0] count;
    reg [1:0] buffer_read;
    reg [1:0] buffer_write;
    reg initial_setting;
    
    wire [N - 1: 0] b0_o_data1;
    wire [N - 1: 0] b0_o_data2;
    wire [N - 1: 0] b0_o_data3;
    wire [N - 1: 0] b0_o_data4;
    wire [N - 1: 0] b0_o_data5;
    wire [N - 1: 0] b0_o_data6;
    wire [N - 1: 0] b0_o_data7;
    wire [N - 1: 0] b0_o_data8;
    
    wire [N - 1: 0] b1_o_data1;
    wire [N - 1: 0] b1_o_data2;
    wire [N - 1: 0] b1_o_data3;
    wire [N - 1: 0] b1_o_data4;
    wire [N - 1: 0] b1_o_data5;
    wire [N - 1: 0] b1_o_data6;
    wire [N - 1: 0] b1_o_data7;
    wire [N - 1: 0] b1_o_data8;
    
    InputBuffer B1(.i_clk(i_clk), .i_rst(i_rst), .i_data1(i_data1), .i_data2(i_data2), .i_data3(i_data3), .i_data4(i_data4), .i_data5(i_data5), .i_data6(i_data6),
    .i_data7(i_data7), .i_data8(i_data8), .i_read(buffer_read[0]), .i_write(buffer_write[0]), .o_data1(b0_o_data1), .o_data2(b0_o_data2), .o_data3(b0_o_data3), 
    .o_data4(b0_o_data4), .o_data5(b0_o_data5), .o_data6(b0_o_data6), .o_data7(b0_o_data7), .o_data8(b0_o_data8));
    
    InputBuffer B2(.i_clk(i_clk), .i_rst(i_rst), .i_data1(i_data1), .i_data2(i_data2), .i_data3(i_data3), .i_data4(i_data4), .i_data5(i_data5), .i_data6(i_data6),
    .i_data7(i_data7), .i_data8(i_data8), .i_read(buffer_read[1]), .i_write(buffer_write[1]), .o_data1(b1_o_data1), .o_data2(b1_o_data2), .o_data3(b1_o_data3), 
    .o_data4(b1_o_data4), .o_data5(b1_o_data5), .o_data6(b1_o_data6), .o_data7(b1_o_data7), .o_data8(b1_o_data8));
    
    
    // count setting
    always@(posedge i_clk)begin
        if(i_rst) begin
            count<=0;
        end
        else begin
            if(i_write)begin
                count<= count +1;
                if(count == M/8 -1)begin
                    count<= 0;
                end
            end
        end
    end
    
    // initial setting 
    always@(posedge i_clk)begin
        if(i_rst)begin
            initial_setting <=0;
            buffer_read <= 2'b00;
            buffer_write <= 2'b01;
        end
        else begin
            if(count== M/8 -1)begin
                initial_setting <=1;
                if(initial_setting ==0)begin
                    buffer_read <= 2'b01;
                    buffer_write <= 2'b10;
                end
                else if(initial_setting == 1 && buffer_read== 2'b01 )begin
                    buffer_read <= 2'b10;
                    buffer_write <= 2'b01;
                end
            end
        end
    end
    
    // valid setting
    assign o_valid = (initial_setting ==1 && buffer_read != 0);
    // output setting
    assign o_data1 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data1 : b1_o_data1;
    assign o_data2 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data2 : b1_o_data2;
    assign o_data3 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data3 : b1_o_data3;
    assign o_data4 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data4 : b1_o_data4;
    assign o_data5 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data5 : b1_o_data5;
    assign o_data6 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data6 : b1_o_data6;
    assign o_data7 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data7 : b1_o_data7;
    assign o_data8 = (initial_setting == 1 && buffer_read == 2'b01) ? b0_o_data8 : b1_o_data8;
     
endmodule
