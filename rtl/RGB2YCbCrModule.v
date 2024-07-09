`timescale 1ns / 1ps

module RGB2YCbCrModule (
    input i_clk,
    input i_rst,
    input [23:0] i_data, // [23:16] B, [15:8] G [7:0] R
    input i_valid,
    
    output [7:0] o_LUMA_data,
    output [7:0] o_CB_data,
    output [7:0] o_CR_data,
    output o_valid
    );
    // scaling -> 64 * 256 
    reg [13:0] Y1 = 14'd4899; //0.299
    reg [13:0] Y2 = 14'd9617; // 0.587
    reg [13:0] Y3 = 14'd1868; // 0.114
    reg [13:0] CB1 = 14'd2764;  // 0.168
    reg [13:0] CB2 = 14'd5428; //0.331
    reg [13:0] CB3 = 14'd8192; // 0.5
    reg [13:0] CR1 = 14'd8192; // 0.5
    reg [13:0] CR2 = 14'd6860; //  0.4187
    reg [13:0] CR3 = 14'd1332; // 0.081
        
    // first clock cycle
    reg [21:0] Y1_product, Y2_product, Y3_product;
    reg [21:0] CB1_product, CB2_product, CB3_product;
    reg [21:0] CR1_product, CR2_product, CR3_product;
    
    //second clock cycle
    reg [21:0] Y_temp, CB_temp, CR_temp; 

    //third clock cycle
    reg [7:0] Y, CB, CR;
    reg	cal_valid1, cal_valid2, out_valid;
    
    //first clcok cycle
    always @(posedge i_clk) begin
        if (i_rst) begin
            Y1_product <= 0;	
            Y2_product <= 0;
            Y3_product <= 0;   
            CB1_product <= 0;	
            CB2_product <= 0;
            CB3_product <= 0;
            CR1_product <= 0;	
            CR2_product <= 0;
            CR3_product <= 0;
        end
        else if (i_valid) begin
            Y1_product <= Y1 * i_data[7:0];	
            Y2_product <= Y2 * i_data[15:8];
            Y3_product <= Y3 * i_data[23:16];   
            CB1_product <= CB1 * i_data[7:0];	
            CB2_product <= CB2 * i_data[15:8];
            CB3_product <= CB3 * i_data[23:16];
            CR1_product <= CR1 * i_data[7:0];	
            CR2_product <= CR2 * i_data[15:8];
            CR3_product <= CR3 * i_data[23:16];
            end
    end 
    
    // second clock cycle
    always@(posedge i_clk)begin
            if(i_rst)begin 
                Y_temp <= 0;
                CB_temp <= 0;
                CR_temp <= 0;
            end
            
            else if(cal_valid1) begin
                Y_temp <= Y1_product + Y2_product + Y3_product;
                CB_temp <= 22'd2097152 - CB1_product - CB2_product + CB3_product;
                CR_temp <= 22'd2097152 + CR1_product - CR2_product - CR3_product;  
            end
    end
 
    // third clock cycle
    always @(posedge i_clk)
    begin
        if (i_rst) begin
            Y <= 0;
            CB <= 0;
            CR <= 0;   
            end
        
        else if (cal_valid2) begin
             // rounding process
            Y <= Y_temp[13] ? Y_temp[21:14] + 1: Y_temp[21:14];
            CB <= CB_temp[13] & (CB_temp[21:14] != 8'd255) ? CB_temp[21:14] + 1: CB_temp[21:14];
            CR <= CR_temp[13] & (CR_temp[21:14] != 8'd255) ? CR_temp[21:14] + 1: CR_temp[21:14]; 
            // Need to avoid rounding if the value in the top 8 bits is 255, otherwise
            // the value would rollover from 255 to 0
            end
    end
    
    assign o_LUMA_data = Y;
    assign o_CB_data = CB;
    assign o_CR_data = CR;
    
    assign o_valid = out_valid;

    // signal Control
    always @(posedge i_clk)
    begin
        if (i_rst) begin
            cal_valid1 <= 0;
            cal_valid2 <= 0;
            out_valid <= 0;   
            end
        else begin
            cal_valid1 <= i_valid; //for seocnd clock cycle
            cal_valid2 <= cal_valid1; // for third clcok cycle
            out_valid <= cal_valid2; // for output valid signal
            end
    end

endmodule 
