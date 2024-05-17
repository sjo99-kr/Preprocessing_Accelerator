`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/16 17:25:44
// Design Name: 
// Module Name: InputBuffer
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


module InputBuffer#(parameter N = 24) (
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
    input i_read,
    input i_write,
    
    output  [N-1 : 0] o_data1,
    output  [N-1 : 0] o_data2,
    output  [N-1 : 0] o_data3,
    output  [N-1 : 0] o_data4,
    output  [N-1 : 0] o_data5,
    output  [N-1 : 0] o_data6,
    output  [N-1 : 0] o_data7,
    output  [N-1 : 0] o_data8
    );
    
    LineBuffer LB1(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data1),
     .o_data(o_data1));

    LineBuffer LB2(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data2),
     .o_data(o_data2));
    
    LineBuffer LB3(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data3),
    .o_data(o_data3));
    
    LineBuffer LB4(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data4),
     .o_data(o_data4));
    
    LineBuffer LB5(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data5),
     .o_data(o_data5));
    
    LineBuffer LB6(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data6),
     .o_data(o_data6));
    
    LineBuffer LB7(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data7),
    .o_data(o_data7));
    
    LineBuffer LB8(.i_clk(i_clk), .i_rst(i_rst),
    .i_read(i_read), .i_write(i_write), .i_data(i_data8),
     .o_data(o_data8));
endmodule
