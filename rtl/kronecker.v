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
    reg  [3:0] cnt;

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
    reg [3:0] cnt;
    
    //valid signal
    reg stage2_valid, stage3_valid, stage4_valid, stage5_valid, out_signal;
    
    // We have only one register data for each frequency output
    reg signed [12:0] frequency_data0; //freq 1
    reg signed [12:0] frequency_data1; // freq 2
    reg signed [12:0] frequency_data2;// freq 3
    reg signed [12:0] frequency_data3; // freq 4
    reg signed [12:0] frequency_data4;// freq 5
    reg signed [12:0] frequency_data5;// freq 6
    reg signed [12:0] frequency_data6; // freq 7
    reg signed [12:0] frequency_data7; // freq 8
    
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
        if(i_rst)begin
            stage2_valid <= 0;
            stage3_valid <= 0;
            stage4_valid <= 0;
        end
        else begin
            stage2_valid <= i_valid;
            stage3_valid <= stage2_valid;
            stage4_valid <= stage3_valid;
            stage5_valid <= stage4_valid;
        end
    end
    //-------------------------------stage 1-----------------------------------------------//
    always@(posedge i_clk)begin
        if(i_rst)begin 
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
        if(i_rst)begin
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
        if(i_rst)begin
            a_ha1 <= 0;
            b_ha1 <= 0;
            c_ha1 <= 0;
        end
        else begin
            if(stage3_valid)begin
               a_h1 <= a_ha1 + a_ha2;
               
               b_h1 <= b_ha1 + b_ha2;
               
               c_h1 <= c_ha1 >>> 4;
               c_h2 <= c_ha2 >>> 7; 
            end
        end
    end
    //---------------------------------------stage 4---------------------------------------------------//
    always@(posedge i_clk)begin
        if(i_rst)begin
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
    //---------------------------------count setting--------------------------------------------/
    
    always@(posedge i_clk)begin
        if(i_rst)begin
            cnt <= 0;
        end
        else begin
            if(stage5_valid) begin
                if(cnt ==7) begin
                    cnt <= 0;
                end
                else begin
                    cnt <= cnt +1;
                end
            end
        end
    end
    always@(posedge i_clk)begin
        if(i_rst)begin
            out_signal <= 0;
        end
        else begin
            if(cnt==7) begin
                out_signal <= 1;
            end
            else out_signal <= 0;
        end
    end
    
    //-----------------------------------------------freqeuncy calculation-----------------------------------------------------------------//
    always@(posedge i_clk)begin
        if(i_rst)begin
            frequency_data0 <= 0;
            frequency_data1 <= 0;
            frequency_data2 <= 0;
            frequency_data3 <= 0;
            frequency_data4 <= 0;
            frequency_data5 <= 0;
            frequency_data6 <= 0;
            frequency_data7 <= 0;
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
            if(stage5_valid)begin
                if(cnt==0) begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3 + a_s1;
                    frequency_data4 <= frequency_data4 + b_s1;
                    frequency_data5 <= frequency_data5 + c_s1;
                    frequency_data6 <= frequency_data6 + a_s2;
                    frequency_data7 <= frequency_data7 + b_s2;
                end
                if(cnt==1)begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3 + a_s1;
                    frequency_data4 <= frequency_data4 + b_s1;
                    frequency_data5 <= frequency_data5 + c_s1;
                    frequency_data6 <= frequency_data6 + a_s3;
                    frequency_data7 <= frequency_data7 + b_s3;
                end
                if(cnt == 2)begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3 + a_s3;
                    frequency_data4 <= frequency_data4 + b_s3;
                    frequency_data5 <= frequency_data5 + c_s3;
                    frequency_data6 <= frequency_data6 - a_s3;
                    frequency_data7 <= frequency_data7 - b_s3;
                end
                if(cnt == 3) begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3;
                    frequency_data4 <= frequency_data4;
                    frequency_data5 <= frequency_data5;
                    frequency_data6 <= frequency_data6 - a_s2;
                    frequency_data7 <= frequency_data7 - b_s2;
                end
                if(cnt == 4)begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3;
                    frequency_data4 <= frequency_data4;
                    frequency_data5 <= frequency_data5;
                    frequency_data6 <= frequency_data6 - a_s2;
                    frequency_data7 <= frequency_data7 - b_s2;           
                end
                if(cnt == 5)begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3 - a_s3;
                    frequency_data4 <= frequency_data4 - b_s3;
                    frequency_data5 <= frequency_data5 - c_s3;
                    frequency_data6 <= frequency_data6 - a_s3;
                    frequency_data7 <= frequency_data7 - b_s3;
                end
                if(cnt == 6)begin
                    frequency_data0 <= frequency_data0 + a_s1;
                    frequency_data1 <= frequency_data1 + b_s1;
                    frequency_data2 <= frequency_data2 + c_s1;
                    frequency_data3 <= frequency_data3 - a_s1;
                    frequency_data4 <= frequency_data4 - b_s1;
                    frequency_data5 <= frequency_data5 - c_s1;
                    frequency_data6 <= frequency_data6 + a_s3;
                    frequency_data7 <= frequency_data7 + b_s3;
                end
                if(cnt == 7) begin
                    out_freq0 <= frequency_data0 + a_s1;
                    out_freq1 <= frequency_data1 + b_s1;
                    out_freq2 <= frequency_data2 + c_s1;
                    out_freq3 <= frequency_data3 - a_s1;
                    out_freq4 <= frequency_data4 - b_s1;
                    out_freq5 <= frequency_data5 - c_s1;
                    out_freq6 <= frequency_data6 + a_s2;
                    out_freq7 <= frequency_data7 + b_s2;
                    frequency_data0 <= 0;
                    frequency_data1 <= 0;
                    frequency_data2 <= 0;
                    frequency_data3 <= 0;
                    frequency_data4 <= 0;
                    frequency_data5 <= 0;
                    frequency_data6 <= 0;
                    frequency_data7 <= 0;
                end
            
            end
        end
    end
    
    assign o_valid = out_signal;
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
