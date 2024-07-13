`timescale 1ns / 1ps

module row_dct(
    input  i_clk,
    input i_rst,
    input i_valid,
    input signed [11:0] i_data0,
    input signed [11:0] i_data1,
    input signed [11:0] i_data2,
    input signed [11:0] i_data3,
    input signed [11:0] i_data4,
    input signed [11:0] i_data5,
    input signed [11:0] i_data6,
    input signed [11:0] i_data7,
    
    output  o_valid1,
    output  o_valid2,
    output  o_valid3,
    output  o_valid4,
    output  o_valid5,
    output  o_valid6,
    output  o_valid7,
    output  o_valid8,
    
    // reflects 1d-dct result 
    output signed [11:0] o_data0,
    output signed [11:0] o_data1,
    output signed [11:0] o_data2,
    output signed [11:0] o_data3,
    output signed [11:0] o_data4,
    output signed [11:0] o_data5,
    output signed [11:0] o_data6,
    output signed [11:0] o_data7
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

    
    
    
    // Pipeline stage valid
    reg s1_valid,s2_valid, s3_valid, s4_valid;
    
    reg c1_valid, c2_valid, c3_valid, c4_valid, c5_valid, c6_valid, c7_valid, c8_valid;
    
    // stage 1 
    always@(posedge i_clk)begin
        if(!i_rst)begin
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
        if(!i_rst)begin
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
                temp2_data0 <= (temp1_data3 << 4) + (temp1_data0 << 4) ;
                temp2_data1 <= (temp1_data2 << 4)  + (temp1_data1 << 4);
                temp2_data2 <= (temp1_data1 << 4)  -  (temp1_data2 << 4);
                temp2_data3 <= (temp1_data0 << 4)  - (temp1_data3 << 4);
                temp2_data4 <= (temp1_data4 << 4);
                temp2_data5 <= ((((temp1_data5 * 6)) + (temp1_data6 << 4)) * 5 / 8) - (temp1_data5 << 4);
                temp2_data6 <= ((temp1_data5 * 6))  + (temp1_data6 << 4);
                temp2_data7 <= (temp1_data7 << 4);
            end
        end
    end
    
    //stage 3
    always@(posedge i_clk)begin
        if(!i_rst)begin
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
                temp3_data4 <= temp2_data4 + temp2_data5;
                temp3_data5 <= temp2_data4 - temp2_data5;
                temp3_data6 <= temp2_data7 - temp2_data6;
                temp3_data7 <= temp2_data6 + temp2_data7;
            end
        end
    end
    
    // stage 4
    always@(posedge i_clk)begin
        if(!i_rst)begin
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
                temp4_data4 <= temp3_data4 - (temp3_data7 / 8);
                temp4_data5 <= temp3_data5 + (temp3_data6 * 7 / 8);
                temp4_data6 <= temp3_data6 - ((temp3_data5 + (temp3_data6 * 7 / 8)) / 2);
                temp4_data7 <= temp3_data7;
            end
        end
    end
    
    // output signal setting
    always@(posedge i_clk)begin
        if(!i_rst)begin
            s1_valid <=0;
            s2_valid <= 0;
            s3_valid <= 0;
            s4_valid <= 0;
        end
        else begin
            s1_valid <= i_valid;
            s2_valid <= s1_valid;
            s3_valid <= s2_valid;
            s4_valid <= s3_valid;
        end
    end
    reg [4:0] count;
    always@(posedge i_clk)begin
        if(!i_rst)begin
            count <= 0;
        end
        else begin
            if(s4_valid)begin
                count <= count +1;
                if(count ==7)begin
                    count <= 0;
                end
            end
        end
    end
    always@(posedge i_clk)begin
        if(!i_rst)begin
            c1_valid <= 0; c2_valid <= 0; c3_valid <= 0; c4_valid <= 0; c5_valid <= 0;
            c6_valid <=0 ;c7_valid <=0; c8_valid <=0;
        end
        else begin
            if(s3_valid)begin
                case (count) 
                    0: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 1; c8_valid <= 0;
                        end
                    1: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 1; c8_valid <= 0;
                       end
                    2: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 1; c8_valid <= 0;                        
                        end
                    3: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 1; c8_valid <= 0;                     
                    end
                    4: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 1; c8_valid <= 0; 
                    end
                    5: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 1; c8_valid <= 0; 
                    end
                    6: begin
                            c1_valid <= 1; c2_valid <=1; c3_valid <= 1; c4_valid <= 1;
                            c5_valid <= 1; c6_valid <=1; c7_valid <= 0; c8_valid <= 0; 
                    end
                    7: begin
                            c1_valid <= 0; c2_valid <=0; c3_valid <= 0; c4_valid <= 0 ;
                            c5_valid <= 0; c6_valid <=0; c7_valid <= 0; c8_valid <= 0; 
                    end              
                endcase
            end
        end
    end
    
    assign o_valid1 = c1_valid;
    assign o_valid2 = c2_valid;
    assign o_valid3 = c3_valid;
    assign o_valid4 = c4_valid;
    assign o_valid5 = c5_valid;
    assign o_valid6 = c6_valid;
    assign o_valid7 = c7_valid;
    assign o_valid8 = c8_valid;

    assign o_data0 = (temp4_data0[6:0] > 63) ? temp4_data0[18:7] + 1 : temp4_data0[18:7];
    assign o_data1 = (temp4_data7[6:0] > 63) ? temp4_data7[18:7] + 1 : temp4_data7[18:7];
    assign o_data2 = (temp4_data3[6:0] > 63) ? temp4_data3[18:7] + 1:  temp4_data3[18:7];
    assign o_data3 = (temp4_data6[6:0] > 63) ? temp4_data6[18:7] + 1 : temp4_data6[18:7];
    assign o_data4 = (temp4_data1[6:0] > 63) ? temp4_data1[18:7] + 1 : temp4_data1[18:7];
    assign o_data5 = (temp4_data5[6:0] > 63) ? temp4_data5[18:7] + 1 : temp4_data5[18:7];
    assign o_data6 = (temp4_data2[6:0] > 63) ? temp4_data2[18:7] + 1 : temp4_data2[18:7];
    assign o_data7 = (temp4_data4[6:0] > 63) ? temp4_data4[18:7] + 1 : temp4_data4[18:7];
endmodule
