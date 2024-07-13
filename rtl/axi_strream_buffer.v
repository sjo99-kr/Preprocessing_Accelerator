`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2024 06:32:21 PM
// Design Name: 
// Module Name: last_buffer
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


module axi_stream_buffer(
    input i_clk,
    input i_rst,
    
    // input data
    input signed [11:0] cr_kron_data1,
    input signed [11:0] cr_kron_data2,
    input signed [11:0] cr_kron_data3,
    input signed [11:0] cr_kron_data4,
    input signed [11:0] cr_kron_data5,
    input signed [11:0] cr_kron_data6,
    input signed [11:0] cr_kron_data7,
    input signed [11:0] cr_kron_data8,
    input cr_kron_valid,
    
    input signed [11:0] cb_kron_data1,
    input signed [11:0] cb_kron_data2,
    input signed [11:0] cb_kron_data3,
    input signed [11:0] cb_kron_data4,
    input signed [11:0] cb_kron_data5,
    input signed [11:0] cb_kron_data6,
    input signed [11:0] cb_kron_data7,
    input signed [11:0] cb_kron_data8,    
    input cb_kron_valid,
    
    input signed [11:0] dct_data1,
    input signed [11:0] dct_data2,
    input signed [11:0] dct_data3,
    input signed [11:0] dct_data4,
    input signed [11:0] dct_data5,
    input signed [11:0] dct_data6,
    input signed [11:0] dct_data7,
    input signed [11:0] dct_data8, 
    
    input dct_o1, dct_o2, dct_o3, dct_o4, dct_o5, dct_o6, dct_o7,
    
    output reg m_axis_valid,
    output reg signed [31:0] m_axis_data
    
    );
    reg  flag;
    reg [5:0] rd_pt;
    reg [3:0] d0,d1,d2,d3,d4,d5,d6,d7;
    integer i;
    reg signed [31:0] buffer [63:0];
    
    // data write
    always@(posedge i_clk)begin
        if(!i_rst)begin
            for(i = 0; i<64; i = i+1)begin
                buffer[i] <= 0;
            end
            d0 <= 0; d1<=0; d2<=0; d3<=0;
            d4<=0;d5<=0; d6<=0; d7<=0;
        end
        else begin
            if(cr_kron_valid)begin
                buffer[0] <= { {20{cb_kron_data1[11]}}, cb_kron_data1};
                buffer[1] <= { {20{cb_kron_data2[11]}}, cb_kron_data2};
                buffer[2] <= { {20{cb_kron_data3[11]}}, cb_kron_data3};
                buffer[3] <= { {20{cb_kron_data4[11]}}, cb_kron_data4};
                buffer[4] <= { {20{cb_kron_data5[11]}}, cb_kron_data5};
                buffer[5] <= { {20{cb_kron_data6[11]}}, cb_kron_data6};
                buffer[6] <= { {20{cb_kron_data7[11]}}, cb_kron_data7};
                buffer[7] <= { {20{cb_kron_data8[11]}}, cb_kron_data8};
            end 
            if(cb_kron_valid)begin
                buffer[8] <= { {20{cr_kron_data1[11]}}, cr_kron_data1};
                buffer[9] <= { {20{cr_kron_data2[11]}}, cr_kron_data2};
                buffer[10] <= { {20{cr_kron_data3[11]}}, cr_kron_data3};
                buffer[11] <= {{20{cr_kron_data4[11]}}, cr_kron_data4};
                buffer[12] <= { {20{cr_kron_data5[11]}}, cr_kron_data5};
                buffer[13] <= {{20{cr_kron_data6[11]}}, cr_kron_data6};
                buffer[14] <= { {20{cr_kron_data7[11]}},cr_kron_data7};
                buffer[15] <= { {20{cr_kron_data8[11]}}, cr_kron_data8};
            end        
            if(dct_o1)begin
                buffer[16 + d0] <= {{20{dct_data1[11]}},dct_data1};
                d0 = d0 +1;
                if(d0==6)begin
                    d0 <= 0;
                end
            end
            if(dct_o2)begin
                buffer[23 + d1] <= {{20{dct_data2[11]}}, dct_data2};
                d1 <= d1 +1;
                if(d1 ==6)begin
                    d1 <= 0;
                end
            end
            
            if(dct_o3)begin
               buffer[30 + d2] <= {{20{dct_data3[11]}}, dct_data3};
               d2 <= d2+ 1;
               if(d2==6)begin
                d2 <= 0;
               end 
            end
           
           if(dct_o4)begin
            buffer[37+d3] <= { {20{dct_data4[11]}}, dct_data4};
            d3 <= d3 + 1;
            if(d3 == 6)begin
                d3 <= 0;
            end
           end
           if(dct_o5)begin
            buffer[44+d4] <= {{20{dct_data5[11]}}, dct_data5};
            d4 <= d4 +1;
            if(d4 == 6)begin
                d4 <= 0;
            end
           end
           if(dct_o6)begin
                buffer[ 51 + d5] <=  {{20{dct_data6[11]}}, dct_data6};
                d5 <= d5 +1;
                if(d5 ==6)begin
                    d5 <= 0;
                end
           end
           if(dct_o7)begin
                buffer[58 + d6] <= {{20{dct_data7[11]}}, dct_data7};
                d6 <= d6 +1;
                if(d6 == 6)begin
                    d6 <= 0;
                end
           end
        end
    end
    
    // data read 
    always@(posedge i_clk)begin
        if(!i_rst)begin
            flag <= 0;
            rd_pt <= 0;
        end
        else begin
            if(cr_kron_valid)begin
                flag <= 1;
            end
            else begin
                if(flag ==1)begin
                    m_axis_data <= buffer[rd_pt];
                    m_axis_valid <= 1;
                    rd_pt <= rd_pt +1;
                    if(rd_pt ==63)begin
                        flag <=0;
                        rd_pt <= 0;
                        m_axis_valid <= 0;
                    end
                end
            end
        end
    end
    
    
endmodule
