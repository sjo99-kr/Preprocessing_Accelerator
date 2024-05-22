`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/22 23:30:03
// Design Name: 
// Module Name: row_dct
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


module row_dct(
    input i_clk,
    input i_rst,
    input i_valid,
    input [10:0] i_data0,
    input [10:0] i_data1,
    input [10:0] i_data2,
    input [10:0] i_data3,
    input [10:0] i_data4,
    input [10:0] i_data5,
    input [10:0] i_data6,
    input [10:0] i_data7,
    
    output reg o_valid,
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
    // 
    
    //stage 1 data  , (OUTPUT : 13BIT + 4BIT) 14bit for calculation
    reg signed [18:0] temp1_data0;
    reg signed [18:0] temp1_data1;
    reg signed [18:0] temp1_data2;
    reg signed [18:0] temp1_data3;
    reg signed [18:0] temp1_data4;
    reg signed [18:0] temp1_data5;
    reg signed [18:0] temp1_data6;
    reg signed [18:0] temp1_data7;
    
    // connect s1-s2 data    
    //stage 2 data
    reg signed [18:0] temp2_data0;
    reg signed [18:0] temp2_data1;
    reg signed [18:0] temp2_data2;
    reg signed [18:0] temp2_data3;
    reg signed [18:0] temp2_data4;
    reg signed [18:0] temp2_data5;
    reg signed [18:0] temp2_data6;
    reg signed [18:0] temp2_data7;

    //stage 3 data
    reg signed [18:0] temp3_data0;
    reg signed [18:0] temp3_data1;
    reg signed [18:0] temp3_data2;
    reg signed [18:0] temp3_data3;
    reg signed [18:0] temp3_data4;
    reg signed [18:0] temp3_data5;
    reg signed [18:0] temp3_data6;
    reg signed [18:0] temp3_data7;

    //stage 4 data
    reg signed [18:0] temp4_data0;
    reg signed [18:0] temp4_data1;
    reg signed [18:0] temp4_data2;
    reg signed [18:0] temp4_data3;
    reg signed [18:0] temp4_data4;
    reg signed [18:0] temp4_data5;
    reg signed [18:0] temp4_data6;
    reg signed [18:0] temp4_data7;
   
    //stage 5 data
    reg signed [18:0] temp5_data0;
    reg signed [18:0] temp5_data1;
    reg signed [18:0] temp5_data2;
    reg signed [18:0] temp5_data3;
    reg signed [18:0] temp5_data4;
    reg signed [18:0] temp5_data5;
    reg signed [18:0] temp5_data6;
    reg signed [18:0] temp5_data7;
    
    
    
    // Pipeline stage valid
    reg s1_valid,s2_valid, s3_valid, s4_valid, s5_valid, s6_valid;
    
    // stage 1 
    always@(posedge i_clk)begin
        if(i_rst)begin
            temp1_data0 <= 0;
            temp1_data1 <= 0;
            temp1_data2 <= 0;
            temp1_data3 <= 0;
            temp1_data4 <= 0;
            temp1_data5 <= 0;
            temp1_data6 <= 0 ;
            temp1_data7 <= 0; 
        end
        else begin
            if(i_valid) begin
                temp1_data0 <= i_data0  + i_data7;
                temp1_data1 <= i_data1 + i_data6;
                temp1_data2 <= i_data2  + i_data5;
                temp1_data3 <= i_data3  + i_data4;
                temp1_data4 <= i_data3 - i_data4;
                temp1_data5 <= i_data2  - i_data5;
                temp1_data6 <= i_data1  - i_data6;
                temp1_data7  <= i_data0 - i_data7;
           end
        end
    end
    
    // stage 2
    always@(posedge i_clk) begin
        if(i_rst)begin
            temp2_data0 <= 0;
            temp2_data1 <= 0;
            temp2_data2 <= 0;
            temp2_data3 <= 0;
            temp2_data4 <= 0;
            temp2_data5 <= 0;
            temp2_data6 <= 0;
            temp2_data7 <= 0;
        end
        else begin
            if(s1_valid)begin
                temp2_data0 <= (temp1_data3 << 4) + (temp1_data1 << 4) ;
                temp2_data1 <= (temp1_data2 << 4)  + (temp1_data1 << 4);
                temp2_data2 <= (temp1_data1 << 4)  -  (temp1_data2 << 4);
                temp2_data3 <= (temp1_data0 << 4)  - (temp1_data3 << 4);
                temp2_data4 <= (temp1_data4 << 4);
                temp2_data5 <= (temp1_data5 << 4);
                temp2_data6 <= ((temp1_data5 * 6))  + (temp1_data6 << 4);
                temp2_data7 <= (temp1_data7 << 4);
            end
        end
    end
    
    //stage 3
    always@(posedge i_clk)begin
        if(i_rst)begin
            temp3_data0 <= 0;
            temp3_data1 <= 0;
            temp3_data2 <= 0;
            temp3_data3 <= 0;
            temp3_data4 <= 0;
            temp3_data5 <= 0;
            temp3_data6 <= 0;
            temp3_data7 <= 0;    
        end
        else begin
            if(s2_valid)begin
                temp3_data0 <= temp2_data0 + temp2_data1;
                temp3_data1 <= temp2_data1;
                temp3_data2 <= temp2_data2 - ((temp2_data3 * 3 ) / 8);
                temp3_data3 <= temp2_data3;
                temp3_data4 <= temp2_data4;
                temp3_data5 <= ((temp2_data6 * 5) / 8) - temp2_data5;
                temp3_data6 <= temp2_data7 - temp2_data6;
                temp3_data7 <= temp2_data6 + temp2_data7;
            end
        end
    end
    
    // stage 4
    always@(posedge i_clk)begin
        if(i_rst)begin
            temp4_data0 <= 0;
            temp4_data1 <= 0;
            temp4_data2 <= 0;
            temp4_data3 <= 0;
            temp4_data4 <= 0;
            temp4_data5 <= 0;
            temp4_data6 <= 0;
            temp4_data7 <= 0;        
        end
        else begin
            if(s3_valid) begin
                temp4_data0 <= temp3_data0;
                temp4_data1 <= (temp3_data0  / 2 ) - temp3_data1;
                temp4_data2 <= temp3_data2;
                temp4_data3 <= temp3_data3 + ((temp3_data2 * 3) / 8);
                temp4_data4 <= temp3_data4 + temp3_data5 - (temp3_data7 / 8);
                temp4_data5 <= temp3_data4 - temp3_data5 + (temp3_data6 * 7 / 8);
                temp4_data6 <= temp3_data6;
                temp4_data7 <= temp3_data7;
            end
        end
    end
    
        // stage 5
    always@(posedge i_clk)begin
        if(i_rst)begin
            temp5_data0 <= 0;
            temp5_data1 <= 0;
            temp5_data2 <= 0;
            temp5_data3 <= 0;
            temp5_data4 <= 0;
            temp5_data5 <= 0;
            temp5_data6 <= 0;
            temp5_data7 <= 0;        
        end
        else begin
            if(s4_valid) begin
                temp5_data0 <= temp4_data0;
                temp5_data1 <= temp4_data1;
                temp5_data2 <= temp4_data2;
                temp5_data3 <= temp4_data3;
                temp5_data4 <= temp4_data4; 
                temp5_data5 <= temp4_data5;
                temp5_data6 <= temp4_data6 - (temp4_data5 /2 );
                temp5_data7 <= temp4_data7;
            end
        end
    end

    
    // output signal setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            s1_valid <=0;
            s2_valid <= 0;
            s3_valid <= 0;
            s4_valid <= 0;
            o_valid<=0;
        end
        else begin
            s1_valid <= i_valid;
            s2_valid <= s1_valid;
            s3_valid <= s2_valid;
            s4_valid <= s3_valid;
            o_valid <= s4_valid;
        end
    end
    
    assign o_data0 = (temp5_data0[3:0] > 7) ? temp5_data0[17:4] + 1 :  temp5_data0[17:4];
    assign o_data1 = (temp5_data7[3:0] > 7) ? temp5_data7[17:4] + 1 : temp5_data7[17:4];
    assign o_data2 = (temp5_data3[3:0] > 7) ? temp5_data3[17:4] + 1: temp5_data3[17:4];
    assign o_data3 = (temp5_data6[3:0] > 7) ? temp5_data6[17:4] + 1 : temp5_data6[17:4];
    assign o_data4 = (temp5_data1[3:0] > 7) ? temp5_data1[17:4] + 1 : temp5_data1[17:4];
    assign o_data5 = (temp5_data5[3:0] > 7) ? temp5_data5[17:4] + 1 : temp5_data5[17:4];
    assign o_data6 = (temp5_data2[3:0] > 7) ? temp5_data2[17:4] + 1 : temp5_data2[17:4];
    assign o_data7 = (temp5_data4[3:0] > 7) ? temp5_data4[17:4] + 1 : temp5_data4[17:4];
endmodule
