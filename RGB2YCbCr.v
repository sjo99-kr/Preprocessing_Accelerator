`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/17 16:45:09
// Design Name: 
// Module Name: RGB2YCbCr
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


module RGB2YCbCr(
    input i_clk,
    input i_rst, 
    input [23:0] i_data1,
    input [23:0] i_data2,
    input [23:0] i_data3,
    input [23:0] i_data4,
    input [23:0] i_data5,
    input [23:0] i_data6,
    input [23:0] i_data7,
    input [23:0] i_data8,
    input i_valid,
    
    output [7:0] o_luma_data1,
    output [7:0] o_luma_data2,
    output [7:0] o_luma_data3,
    output [7:0] o_luma_data4,
    output [7:0] o_luma_data5,
    output [7:0] o_luma_data6,
    output [7:0] o_luma_data7,
    output [7:0] o_luma_data8,
    
    output [7:0] o_cb_data1,
    output [7:0] o_cb_data2,
    output [7:0] o_cb_data3,
    output [7:0] o_cb_data4,
    output [7:0] o_cb_data5,
    output [7:0] o_cb_data6,
    output [7:0] o_cb_data7,
    output [7:0] o_cb_data8,
    
    output [7:0] o_cr_data1,
    output [7:0] o_cr_data2,
    output [7:0] o_cr_data3,
    output [7:0] o_cr_data4,
    output [7:0] o_cr_data5,
    output [7:0] o_cr_data6,
    output [7:0] o_cr_data7,
    output [7:0] o_cr_data8,
    output o_valid    
    );
    
    
    RGB2YCbCrModule m1(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data1), .i_valid(i_valid), .o_LUMA_data(o_luma_data1), .o_CB_data(o_cb_data1), .o_CR_data(o_cr_data1));
    RGB2YCbCrModule m2(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data2), .i_valid(i_valid), .o_LUMA_data(o_luma_data2), .o_CB_data(o_cb_data2), .o_CR_data(o_cr_data2));
    RGB2YCbCrModule m3(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data3), .i_valid(i_valid), .o_LUMA_data(o_luma_data3), .o_CB_data(o_cb_data3), .o_CR_data(o_cr_data3));
    RGB2YCbCrModule m4(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data4), .i_valid(i_valid), .o_LUMA_data(o_luma_data4), .o_CB_data(o_cb_data4), .o_CR_data(o_cr_data4));
    RGB2YCbCrModule m5(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data5), .i_valid(i_valid), .o_LUMA_data(o_luma_data5), .o_CB_data(o_cb_data5), .o_CR_data(o_cr_data5));
    RGB2YCbCrModule m6(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data6), .i_valid(i_valid), .o_LUMA_data(o_luma_data6), .o_CB_data(o_cb_data6), .o_CR_data(o_cr_data6));
    RGB2YCbCrModule m7(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data7), .i_valid(i_valid), .o_LUMA_data(o_luma_data7), .o_CB_data(o_cb_data7), .o_CR_data(o_cr_data7));
    RGB2YCbCrModule m8(.i_clk(i_clk), .i_rst(i_rst), .i_data(i_data8), .i_valid(i_valid), .o_LUMA_data(o_luma_data8), .o_CB_data(o_cb_data8), .o_CR_data(o_cr_data8));
    
    
    
endmodule
