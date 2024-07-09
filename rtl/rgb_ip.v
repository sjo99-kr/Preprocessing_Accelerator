`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/21 21:10:34
// Design Name: 
// Module Name: rgb_ip
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


module rgb_ip(
    input i_clk,
    input i_rst,
    input [23:0] rgb_input,
    input i_read,
    
    output [7:0] o_luma_data1,
    output [7:0] o_luma_data2,
    output [7:0] o_luma_data3,
    output [7:0] o_luma_data4,
    output [7:0] o_luma_data5,
    output [7:0] o_luma_data6,
    output [7:0] o_luma_data7,
    output [7:0] o_luma_data0,
    
    output [7:0] o_cb_data1,
    output [7:0] o_cb_data2,
    output [7:0] o_cb_data3,
    output [7:0] o_cb_data4,
    output [7:0] o_cb_data5,
    output [7:0] o_cb_data6,
    output [7:0] o_cb_data7,
    output [7:0] o_cb_data0,
    
    output [7:0] o_cr_data1,
    output [7:0] o_cr_data2,
    output [7:0] o_cr_data3,
    output [7:0] o_cr_data4,
    output [7:0] o_cr_data5,
    output [7:0] o_cr_data6,
    output [7:0] o_cr_data7,
    output [7:0] o_cr_data0,
    output o_valid   
    );
    wire [23:0] rgb_buffer0, rgb_buffer1, rgb_buffer2, rgb_buffer3, rgb_buffer4, rgb_buffer5, rgb_buffer6, rgb_buffer7;
    wire buffer_out;
    
    rgb_buffer b1(.i_clk(i_clk), .i_rst(i_rst), .i_read(i_read), .rgb_input(rgb_input),
    .rgb_output0(rgb_buffer0), .rgb_output1(rgb_buffer1), .rgb_output2(rgb_buffer2), .rgb_output3(rgb_buffer3), .rgb_output4(rgb_buffer4),
    .rgb_output5(rgb_buffer5), .rgb_output6(rgb_buffer6), .rgb_output7(rgb_buffer7), .o_valid(buffer_out));
    
    RGB2YCbCr c1(.i_clk(i_clk), .i_rst(i_rst), .i_valid(buffer_out), .i_data0(rgb_buffer0), .i_data1(rgb_buffer1), .i_data2(rgb_buffer2), .i_data3(rgb_buffer3),
    .i_data4(rgb_buffer4), .i_data5(rgb_buffer5), .i_data6(rgb_buffer6), .i_data7(rgb_buffer7), 
    .o_luma_data0(o_luma_data0), .o_luma_data1(o_luma_data1), .o_luma_data2(o_luma_data2), .o_luma_data3(o_luma_data3), .o_luma_data4(o_luma_data4),
    .o_luma_data5(o_luma_data5), .o_luma_data6(o_luma_data6), .o_luma_data7(o_luma_data7), .o_cb_data0(o_cb_data0), .o_cb_data1(o_cb_data1),
    .o_cb_data2(o_cb_data2), .o_cb_data3(o_cb_data3), .o_cb_data4(o_cb_data4), .o_cb_data5(o_cb_data5), .o_cb_data6(o_cb_data6), .o_cb_data7(o_cb_data7),
    .o_cr_data0(o_cr_data0), .o_cr_data1(o_cr_data1), .o_cr_data2(o_cr_data2), .o_cr_data3(o_cr_data3), .o_cr_data4(o_cr_data4), .o_cr_data5(o_cr_data5),
    .o_cr_data6(o_cr_data6), .o_cr_data7(o_cr_data7), .o_valid(o_valid));
    
endmodule
