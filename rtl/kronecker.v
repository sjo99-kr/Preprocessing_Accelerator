`timescale 1ns / 1ps

module kronecker(
    input i_clk,
    input i_rst,
    input i_valid,
    input signed [7:0] i_data0,
    input signed [7:0] i_data1,
    input signed [7:0] i_data2,
    input signed [7:0] i_data3,
    input signed [7:0] i_data4,
    input signed [7:0] i_data5,
    input signed [7:0] i_data6,
    input signed [7:0] i_data7,
    
    output  o_valid,
    // reflects 1d-dct result 
    output  signed [11:0] o_data0,
    output  signed [11:0] o_data1,
    output  signed [11:0] o_data2,
    output  signed [11:0] o_data3,
    output  signed [11:0] o_data4,
    output  signed [11:0] o_data5,
    output  signed [11:0] o_data6,
    output  signed [11:0] o_data7
    );
    
    //reg valid -------------------------stage 1-----------------------------------

    reg signed [10:0] a_half1;
    reg signed [10:0] b_half1;
    reg signed [14:0] c_half1;
    
    reg signed [10:0] a_half2;
    reg signed [10:0] b_half2;
    reg signed [14:0] c_half2;
    
    reg signed [10:0] a_half3;
    reg signed [12:0] b_half3;
    reg signed [16:0] c_half3;
    
    reg signed [10:0] a_half4;
    reg signed [16:0] c_half4;
    
    //---------------------------------stage 2--------------------------------------
    reg signed [16:0] a_ha1;
    reg signed [16:0] a_ha2;
    
    reg signed [16:0] b_ha1;
    reg signed [16:0] b_ha2;
    
    reg signed [16:0] c_ha1;
    reg signed [16:0] c_ha2;
    reg signed [16:0] c_ha3;
    reg signed [16:0] c_ha4;
        
    //--------------------------stage 3------------------------------------------
    reg signed [16:0] a_h1;
    reg signed [16:0] a_h2;
    
    reg signed [16:0] b_h1;
    reg signed [16:0] b_h2;
    reg signed [16:0] b_h3;
    
    reg signed [16:0] c_h1;
    reg signed [16:0] c_h2;
    //-------------------------stage 4----------------------------------------
    reg signed [16:0] a_s1;
    reg signed [16:0] a_s2;
    reg signed [16:0] a_s3;
    
    reg signed [16:0] b_s1;
    reg signed [16:0] b_s2;
    reg signed [16:0] b_s3;
    
    reg signed [16:0] c_s1;
    reg signed [16:0] c_s3;
    //----------------------------------------------------------//
    
    //valid signal
    reg stage2_valid, stage3_valid, stage4_valid, stage5_valid;
    reg stage6_valid, stage7_valid, stage8_valid, stage9_valid, stage10_valid;
    reg stage11_valid, stage12_valid, stage13_valid;

    // We have only one register data for each frequency output
    reg signed [12:0] frequency_data0 [6:0]; //freq 1
    reg signed [12:0] frequency_data1 [6:0]; // freq 2
    reg signed [12:0] frequency_data2 [6:0];// freq 3
    reg signed [12:0] frequency_data3 [6:0]; // freq 4
    reg signed [12:0] frequency_data4 [6:0];// freq 5
    reg signed [12:0] frequency_data5 [6:0];// freq 6
    reg signed [12:0] frequency_data6 [6:0]; // freq 7
    reg signed [12:0] frequency_data7 [6:0]; // freq 8
    
    reg signed [12:0] out_freq0;
    reg signed [12:0] out_freq1;
    reg signed [12:0] out_freq2;
    reg signed [12:0] out_freq3;
    reg signed [12:0] out_freq4;
    reg signed [12:0] out_freq5;
    reg signed [12:0] out_freq6;
    reg signed [12:0] out_freq7;
    
    // We have to control input sequence at buffer line
    always@(posedge i_clk)begin
        if(!i_rst)begin
            stage2_valid <= 0;
            stage3_valid <= 0;
            stage4_valid <= 0; stage5_valid <=0; stage6_valid <=0; stage7_valid <= 0;
            stage8_valid <= 0; stage9_valid <= 0; stage10_valid <= 0; stage11_valid <= 0;
            stage12_valid <=0; stage13_valid <= 0;
        end
        else begin
            stage2_valid <= i_valid;
            stage3_valid <= stage2_valid;
            stage4_valid <= stage3_valid;
            stage5_valid <= stage4_valid;
            stage6_valid <= stage5_valid;
            stage7_valid <= stage6_valid;
            stage8_valid <= stage7_valid;
            stage9_valid <= stage8_valid;
            stage10_valid <= stage9_valid;
            stage11_valid <= stage10_valid;
            stage12_valid <= stage11_valid;
            stage13_valid <= stage12_valid;
        end
    end

    //-------------------------------stage 1-----------------------------------------------//
    always@(posedge i_clk)begin
        if(!i_rst)begin 
            a_half1 <= 0;
            a_half2 <= 0;
            a_half3 <= 0;
            a_half4 <= 0;
            
            b_half1 <= 0;
            b_half2 <= 0;
            b_half3 <= 0;
            
            c_half1 <= 0;
            c_half2 <= 0;
            c_half3 <= 0;
            c_half4 <= 0;
        end
        else begin
            if(i_valid)begin
                a_half1 <= (i_data0 + i_data1);  
                a_half2 <= (i_data2 + i_data3);
                a_half3 <= (i_data4 + i_data5);
                a_half4 <= (i_data6 + i_data7);
                
                b_half1 <= (i_data0 -i_data7) >>> 1; 
                b_half2 <= (i_data1 - i_data6) >>> 1;
                b_half3 <= ((i_data2 - i_data5) * 3);
                
                c_half1 <= ((i_data1 - i_data2) *3);  
                c_half2 <= ((i_data6 - i_data5) * 3);
                c_half3 <= ((i_data0 - i_data3) * 55); 
                c_half4 <= ((i_data7 - i_data4) * 55);
                //// half valid
            end
        end
    end
    
    //-----------------------------------------------------stage 2---------------------------------------------//
    always@(posedge i_clk)begin
        if(!i_rst)begin
            a_ha1 <= 0;
            a_ha2 <= 0;
            
            b_ha1 <= 0;
            b_ha2 <= 0;
            
            c_ha1 <= 0;
            c_ha2 <= 0;
            c_ha3 <= 0;
            c_ha4 <= 0;
        end
        else begin
            if(stage2_valid)begin
                a_ha1 <= a_half1 + a_half2;
                a_ha2 <= a_half3 + a_half4;
                
                b_ha1 <= b_half1 + b_half2;
                b_ha2 <= b_half3 >>> 4;
                
                c_ha1 <= (c_half1 + c_half2);
                c_ha2<= (c_half3 + c_half4);
            end
        end
    end
    
    //------------------------------------------stage 3 -----------------------------------------------------//
    always@(posedge i_clk)begin
        if(!i_rst)begin
            a_h1 <= 0;
            b_h1 <= 0;
            c_h1 <= 0;
            c_h2 <= 0;
        end
        else begin
            if(stage3_valid)begin
               a_h1<= a_ha1 + a_ha2;
               
               b_h1 <= b_ha1 + b_ha2;
               
               c_h1 <= c_ha1 >>> 4;
               c_h2 <= c_ha2 >>> 7; 
            end
        end
    end
    //---------------------------------------stage 4---------------------------------------------------//
    always@(posedge i_clk)begin
        if(!i_rst)begin
            a_s1 <= 0;
            a_s2 <= 0;
            a_s3 <= 0;
            
            b_s1 <= 0;
            b_s2 <= 0;
            b_s3 <= 0;
            
            c_s1 <= 0;
            c_s3 <= 0;
        end
        else begin
            if(stage4_valid)begin
               a_s1 <= (a_h1 >>> 2);
               a_s2 <= (a_h1 * 55) >>> 8;    
               a_s3 <= (a_h1 * 3) >>> 5;       
                  
               b_s1 <= b_h1 >>> 1;
               b_s2 <= (b_h1 * 55) >>> 7;
               b_s3 <= (b_h1 * 3) >>> 4;
               
               c_s1 <= (c_h1 + c_h2) >>> 1;
               c_s3 <=  ((c_h1 + c_h2) * 3) >>> 4;
            end
        end
    end
    
    //-----------------------------------------------freqeuncy calculation-----------------------------------------------------------------//
    integer j;
    always@(posedge i_clk)begin
        if(!i_rst)begin
            for(j = 0; j<7; j= j+1)begin
                frequency_data0[j] <= 0;
                frequency_data1[j] <= 0;
                frequency_data2[j] <= 0;
                frequency_data3[j] <= 0;
                frequency_data4[j] <= 0;
                frequency_data5[j] <= 0;
                frequency_data6[j] <= 0;
                frequency_data7[j] <= 0;
            end
            out_freq0 <= 0;
            out_freq1 <= 0;
            out_freq2 <= 0;
            out_freq3 <= 0;
            out_freq4 <= 0;
            out_freq5 <= 0;
            out_freq6 <= 0;
            out_freq7 <= 0;
        end
        else begin
                if(stage5_valid) begin
                    frequency_data0[0] <=  a_s1;
                    frequency_data1[0] <=  b_s1;
                    frequency_data2[0] <=  c_s1;
                    frequency_data3[0] <=  a_s1;
                    frequency_data4[0] <=  b_s1;
                    frequency_data5[0] <=  c_s1;
                    frequency_data6[0] <=  a_s2;
                    frequency_data7[0] <=  b_s2;
                end
                if(stage6_valid)begin
                    frequency_data0[1] <= frequency_data0[0] + a_s1;
                    frequency_data1[1] <= frequency_data1[0] + b_s1;
                    frequency_data2[1] <= frequency_data2[0] + c_s1;
                    frequency_data3[1] <= frequency_data3[0] + a_s1;
                    frequency_data4[1] <= frequency_data4[0] + b_s1;
                    frequency_data5[1] <= frequency_data5[0] + c_s1;
                    frequency_data6[1] <= frequency_data6[0] + a_s3;
                    frequency_data7[1] <= frequency_data7[0] + b_s3;
                end
                if(stage7_valid) begin
                    frequency_data0[2] <= frequency_data0[1] + a_s1;
                    frequency_data1[2] <= frequency_data1[1] + b_s1;
                    frequency_data2[2] <= frequency_data2[1] + c_s1;
                    frequency_data3[2] <= frequency_data3[1] + a_s3;
                    frequency_data4[2] <= frequency_data4[1] + b_s3;
                    frequency_data5[2] <= frequency_data5[1] + c_s3;
                    frequency_data6[2] <= frequency_data6[1] - a_s3;
                    frequency_data7[2] <= frequency_data7[1] - b_s3;
                end
                
                if(stage8_valid) begin
                    frequency_data0[3] <= frequency_data0[2] + a_s1;
                    frequency_data1[3] <= frequency_data1[2] + b_s1;
                    frequency_data2[3] <= frequency_data2[2] + c_s1;
                    frequency_data3[3] <= frequency_data3[2];
                    frequency_data4[3] <= frequency_data4[2];
                    frequency_data5[3] <= frequency_data5[2];
                    frequency_data6[3] <= frequency_data6[2] - a_s2;
                    frequency_data7[3] <= frequency_data7[2] - b_s2;
                end
                
                if(stage9_valid)begin
                    frequency_data0[4] <= frequency_data0[3] + a_s1;
                    frequency_data1[4] <= frequency_data1[3] + b_s1;
                    frequency_data2[4] <= frequency_data2[3] + c_s1;
                    frequency_data3[4] <= frequency_data3[3];
                    frequency_data4[4] <= frequency_data4[3];
                    frequency_data5[4] <= frequency_data5[3];
                    frequency_data6[4] <= frequency_data6[3]  - a_s2;
                    frequency_data7[4] <= frequency_data7[3]  - b_s2;           
                end
                if(stage10_valid)begin
                    frequency_data0[5] <= frequency_data0[4] + a_s1;
                    frequency_data1[5] <= frequency_data1[4] + b_s1;
                    frequency_data2[5] <= frequency_data2[4] + c_s1;
                    frequency_data3[5] <= frequency_data3[4] - a_s3;
                    frequency_data4[5] <= frequency_data4[4] - b_s3;
                    frequency_data5[5] <= frequency_data5[4] - c_s3;
                    frequency_data6[5] <= frequency_data6[4] - a_s3;
                    frequency_data7[5] <= frequency_data7[4] - b_s3;
                end
                if(stage11_valid)begin
                    frequency_data0[6] <= frequency_data0[5] + a_s1;
                    frequency_data1[6] <= frequency_data1[5] + b_s1;
                    frequency_data2[6] <= frequency_data2[5] + c_s1;
                    frequency_data3[6] <= frequency_data3[5] - a_s1;
                    frequency_data4[6] <= frequency_data4[5] - b_s1;
                    frequency_data5[6] <= frequency_data5[5] - c_s1;
                    frequency_data6[6] <= frequency_data6[5] + a_s3;
                    frequency_data7[6] <= frequency_data7[5] + b_s3;
                end
                if(stage12_valid) begin
                    out_freq0 <= frequency_data0[6] + a_s1;
                    out_freq1 <= frequency_data1[6] + b_s1;
                    out_freq2 <= frequency_data2[6] + c_s1;
                    out_freq3 <= frequency_data3[6] - a_s1;
                    out_freq4 <= frequency_data4[6] - b_s1;
                    out_freq5 <= frequency_data5[6] - c_s1;
                    out_freq6 <= frequency_data6[6] + a_s2;
                    out_freq7 <= frequency_data7[6] + b_s2;
                end
            end
        end
        
    assign o_valid = stage13_valid && stage5_valid;
    
    assign o_data0 = (out_freq0[0] > 0) ? out_freq0[12:1] + 1 : out_freq0[12:1];
    assign o_data1 = (out_freq1[0] > 0) ? out_freq1[12:1] + 1 : out_freq1[12:1];
    assign o_data2 = (out_freq2[0] > 0) ? out_freq2[12:1] + 1 : out_freq2[12:1];
    assign o_data3 = (out_freq3[0] > 0) ? out_freq3[12:1] + 1 : out_freq3[12:1];
    assign o_data4 = (out_freq4[0] > 0) ? out_freq4[12:1] + 1 : out_freq4[12:1];
    assign o_data5 = (out_freq5[0] > 0) ? out_freq5[12:1] + 1 : out_freq5[12:1];
    assign o_data6 = (out_freq6[0] > 0) ? out_freq6[12:1] + 1 : out_freq6[12:1];
    assign o_data7 = (out_freq7[0] > 0) ? out_freq7[12:1] + 1 : out_freq7[12:1];
    
    //// calculation stage 

 endmodule
