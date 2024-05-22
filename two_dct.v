`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/22 16:59:54
// Design Name: 
// Module Name: twoD-DCT
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


module twoD_DCT(
     input i_clk,
    input i_rst,
    input i_valid,
    input [7:0] i_data0,
    input [7:0] i_data1,
    input [7:0] i_data2,
    input [7:0] i_data3,
    input [7:0] i_data4,
    input [7:0] i_data5,
    input [7:0] i_data6,
    input [7:0] i_data7,
    
    output  o_valid,
    // reflects 1d-dct result 
    output [13:0] o_data0,
    output [13:0] o_data1,
    output [13:0] o_data2,
    output [13:0] o_data3,
    output [13:0] o_data4,
    output [13:0] o_data5,
    output [13:0] o_data6,
    output [13:0] o_data7
    );
    
    wire col_dct_valid;
    wire trans_valid;
    
    wire [10:0] col_out0;
    wire [10:0] col_out1;
    wire [10:0] col_out2;
    wire [10:0] col_out3;
    wire [10:0] col_out4;
    wire [10:0] col_out5;
    wire [10:0] col_out6;
    wire [10:0] col_out7;  
    
    wire [10:0] trans_out0;
    wire [10:0] trans_out1;
    wire [10:0] trans_out2;
    wire [10:0] trans_out3;
    wire [10:0] trans_out4;
    wire [10:0] trans_out5;
    wire [10:0] trans_out6;
    wire [10:0] trans_out7;       
    

             
    
    
    col_dct dct1(.i_clk(i_clk), .i_rst(i_rst), .i_valid(i_valid), .i_data0(i_data0), .i_data1(i_data1), .i_data2(i_data2), .i_data3(i_data3), .i_data4(i_data4), .i_data5(i_data5), .i_data6(i_data6), .i_data7(i_data7),
    .o_valid(col_dct_valid), .o_data0(col_out0), .o_data1(col_out1), .o_data2(col_out2), .o_data3(col_out3), .o_data4(col_out4), .o_data5(col_out5), .o_data6(col_out6), .o_data7(col_out7));
    
   TransposeBuffer buffer1 (.i_clk(i_clk), .i_rst(i_rst), .i_valid(col_dct_valid), .i_data0(col_out0), .i_data1(col_out1), .i_data2(col_out2), .i_data3(col_out3), .i_data4(col_out4), .i_data5(col_out5), .i_data6(col_out6), .i_data7(col_out7),
   .o_data0(trans_out0), .o_data1(trans_out1), .o_data2(trans_out2), .o_data3(trans_out3), .o_data4(trans_out4), .o_data5(trans_out5), .o_data6(trans_out6), .o_data7(trans_out7), .o_valid(trans_valid));
   
   row_dct dct2(.i_clk(i_clk), .i_rst(i_rst), .i_valid(trans_valid), .i_data0(trans_out0), .i_data1(trans_out1), .i_data2(trans_out2), .i_data3(trans_out3), .i_data4(trans_out4), .i_data5(trans_out5), .i_data6(trans_out6), .i_data7(trans_out7),
   .o_data0(o_data0), .o_data1(o_data1), .o_data2(o_data2), .o_data3(o_data3), .o_data4(o_data4), .o_data5(o_data5), .o_data6(o_data6), .o_data7(o_data7), .o_valid(o_valid));
   
    
endmodule
