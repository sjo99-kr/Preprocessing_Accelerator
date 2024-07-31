`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2024 03:38:17 PM
// Design Name: 
// Module Name: preprocessing_top
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


module preprocessing_top(
        input axi_clk,
        input axi_rst,
        
        // s_axis port
        input [31:0] s_axis_data,
        input s_axis_valid,
        output s_axis_ready,
        
        
        // m_axis_port
        output [31:0] m_axis_data,
        output m_axis_valid,
        input m_axis_ready,
        
        // interrupt
        output o_intr
    );
    
    wire [23:0] buf_out0, buf_out1, buf_out2, buf_out3, buf_out4, buf_out5, buf_out6, buf_out7;
    wire buf_valid;
    
    Buffer_8x8 buffer0(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .s_axis_data(s_axis_data),
        .s_axis_valid(s_axis_valid),
        
        .s_axis_ready(s_axis_ready),
        
        .o_intr(o_intr),
        .output_data1(buf_out0),
        .output_data2(buf_out1),
        .output_data3(buf_out2),
        .output_data4(buf_out3),
        .output_data5(buf_out4),
        .output_data6(buf_out5),
        .output_data7(buf_out6),
        .output_data8(buf_out7),
        .output_valid(buf_valid)
    );
    
    wire [7:0] luma_out0, luma_out1, luma_out2, luma_out3, luma_out4, luma_out5, luma_out6, luma_out7;
    wire [7:0] cr_out0, cr_out1, cr_out2, cr_out3,cr_out4, cr_out5, cr_out6, cr_out7;
    wire [7:0] cb_out0, cb_out1, cb_out2, cb_out3,cb_out4, cb_out5, cb_out6, cb_out7;
    wire rgb_out;
    
    RGB2YCbCr rgb_module(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .i_data0(buf_out0),
        .i_data1(buf_out1),
        .i_data2(buf_out2),
        .i_data3(buf_out3),
        .i_data4(buf_out4),
        .i_data5(buf_out5),
        .i_data6(buf_out6),
        .i_data7(buf_out7),
        .i_valid(buf_valid),
        
        
        .o_luma_data0(luma_out0),
        .o_luma_data1(luma_out1),
        .o_luma_data2(luma_out2),
        .o_luma_data3(luma_out3),
        .o_luma_data4(luma_out4),
        .o_luma_data5(luma_out5),
        .o_luma_data6(luma_out6),
        .o_luma_data7(luma_out7),
        
        .o_cb_data0(cb_out0),
        .o_cb_data1(cb_out1),
        .o_cb_data2(cb_out2),
        .o_cb_data3(cb_out3),
        .o_cb_data4(cb_out4),
        .o_cb_data5(cb_out5),
        .o_cb_data6(cb_out6),
        .o_cb_data7(cb_out7),
        
        .o_cr_data0(cr_out0),
        .o_cr_data1(cr_out1),
        .o_cr_data2(cr_out2),
        .o_cr_data3(cr_out3),
        .o_cr_data4(cr_out4),
        .o_cr_data5(cr_out5),
        .o_cr_data6(cr_out6),
        .o_cr_data7(cr_out7),
        .o_valid(rgb_out)  
    );
    
    wire [11:0] dct_out0, dct_out1, dct_out2, dct_out3, dct_out4, dct_out5,dct_out6, dct_out7;
    wire dct_val0, dct_val1, dct_val2, dct_val3, dct_val4, dct_val5, dct_val6, dct_val7;
    
    twoD_DCT tD (
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .i_valid(rgb_out),
        .i_data0(luma_out0),
        .i_data1(luma_out1),
        .i_data2(luma_out2),
        .i_data3(luma_out3),
        .i_data4(luma_out4),
        .i_data5(luma_out5),
        .i_data6(luma_out6),
        .i_data7(luma_out7),
        
        .o_valid1(dct_val0),
        .o_valid2(dct_val1),
        .o_valid3(dct_val2),
        .o_valid4(dct_val3),
        .o_valid5(dct_val4),
        .o_valid6(dct_val5),
        .o_valid7(dct_val6),
        .o_valid8(dct_val7),
        
        .o_data0(dct_out0),
        .o_data1(dct_out1),
        .o_data2(dct_out2),
        .o_data3(dct_out3),
        .o_data4(dct_out4),
        .o_data5(dct_out5),
        .o_data6(dct_out6),
        .o_data7(dct_out7)
    );
    wire cr_valid;
    wire [11:0] kron_cr_out0, kron_cr_out1, kron_cr_out2, kron_cr_out3, kron_cr_out4, kron_cr_out5, kron_cr_out6, kron_cr_out7;
    
    kronecker cr(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .i_valid(rgb_out),
        
        .i_data0(cr_out0),
        .i_data1(cr_out1),
        .i_data2(cr_out2),
        .i_data3(cr_out3),
        .i_data4(cr_out4),
        .i_data5(cr_out5),
        .i_data6(cr_out6),
        .i_data7(cr_out7),
        
        .o_valid(cr_valid),
        .o_data0(kron_cr_out0),
        .o_data1(kron_cr_out1),
        .o_data2(kron_cr_out2),
        .o_data3(kron_cr_out3),
        .o_data4(kron_cr_out4),
        .o_data5(kron_cr_out5),
        .o_data6(kron_cr_out6),
        .o_data7(kron_cr_out7)
    );
    wire cb_valid;
    wire [11:0] kron_cb_out0, kron_cb_out1, kron_cb_out2, kron_cb_out3, kron_cb_out4, kron_cb_out5, kron_cb_out6, kron_cb_out7;
        kronecker cb(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .i_valid(rgb_out),
        
        .i_data0(cb_out0),
        .i_data1(cb_out1),
        .i_data2(cb_out2),
        .i_data3(cb_out3),
        .i_data4(cb_out4),
        .i_data5(cb_out5),
        .i_data6(cb_out6),
        .i_data7(cb_out7),
        
        .o_valid(cb_valid),
        .o_data0(kron_cb_out0),
        .o_data1(kron_cb_out1),
        .o_data2(kron_cb_out2),
        .o_data3(kron_cb_out3),
        .o_data4(kron_cb_out4),
        .o_data5(kron_cb_out5),
        .o_data6(kron_cb_out6),
        .o_data7(kron_cb_out7)
    );
    
    axi_stream_buffer axi_buf(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .m_axis_ready(m_axis_ready),
        .cr_kron_data1(kron_cr_out0),
        .cr_kron_data2(kron_cr_out1),
        .cr_kron_data3(kron_cr_out2),
        .cr_kron_data4(kron_cr_out3),
        .cr_kron_data5(kron_cr_out4),
        .cr_kron_data6(kron_cr_out5),
        .cr_kron_data7(kron_cr_out6),
        .cr_kron_data8(kron_cr_out7),
        .cr_kron_valid(cr_valid),
        
        .cb_kron_data1(kron_cb_out0),
        .cb_kron_data2(kron_cb_out1),
        .cb_kron_data3(kron_cb_out2),
        .cb_kron_data4(kron_cb_out3),
        .cb_kron_data5(kron_cb_out4),
        .cb_kron_data6(kron_cb_out5),
        .cb_kron_data7(kron_cb_out6),
        .cb_kron_data8(kron_cb_out7),
        .cb_kron_valid(cb_valid),
        
        .dct_data1(dct_out0),
        .dct_data2(dct_out1),
        .dct_data3(dct_out2),
        .dct_data4(dct_out3),
        .dct_data5(dct_out4),
        .dct_data6(dct_out5),
        .dct_data7(dct_out6),
        .dct_data8(dct_out7),
        
        .dct_o1(dct_val0),
        .dct_o2(dct_val1),
        .dct_o3(dct_val2),
        .dct_o4(dct_val3),
        .dct_o5(dct_val4),
        .dct_o6(dct_val5),
        .dct_o7(dct_val6),
        
        .m_axis_valid(m_axis_valid),
        .m_axis_data(m_axis_data)
    );
    
endmodule
