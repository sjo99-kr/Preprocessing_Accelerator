`timescale 1ns / 1ps

module Buffer_8x8(

    input i_clk,
    input i_rst,
    // slave
    input [31:0] s_axis_data,
    input s_axis_valid,
    
    output reg s_axis_ready,
    
    // master
    output reg [23:0] output_data1,
    output reg [23:0] output_data2,
    output reg [23:0] output_data3,
    output reg [23:0] output_data4,
    output reg [23:0] output_data5, 
    output reg [23:0] output_data6,
    output reg [23:0] output_data7,
    output reg [23:0] output_data8,
    output reg output_valid,
    output reg o_intr
    );
    
    reg [23:0] buffer [63:0];
    integer i;
    reg flag;
    reg [5:0] wr_pt;
    reg [2:0] rd_pt;
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            for(i =0; i < 63; i = i+1)begin
                buffer[i] <= 0;
            end
            output_valid <= 0;
            wr_pt <= 0;
            flag <= 0;
            o_intr <= 0;
            s_axis_ready <= 0;
        end        
                   
        else begin
            if(s_axis_valid)begin
                buffer[wr_pt] <= s_axis_data[23:0];
                wr_pt <= wr_pt + 1; 
            end     
            if(wr_pt== 63 && (flag ==0))begin
                wr_pt <= 0;
                flag <= 1;
                s_axis_ready <= 0;
            end
            
            if(rd_pt == 7 && flag == 1)begin
                flag <= 0;
                o_intr <= 1;
                s_axis_ready <= 1;
            end
            else begin
                o_intr <= 0;
            end
        end
    end
    always@(posedge i_clk)begin
        if(!i_rst)begin
            output_data1 <= 0;
            output_data2 <= 0;
            output_data3 <= 0;
            output_data4 <= 0;
            output_data5 <= 0;
            output_data6 <= 0;
            output_data7 <= 0;
            output_data8 <= 0;
            output_valid <= 0;
            rd_pt <= 0;
        end
        else begin
            if(flag ==1) begin
                
                output_data1 <= buffer[rd_pt*8];
                output_data2 <= buffer[rd_pt*8 + 1];
                output_data3 <= buffer[rd_pt*8 + 2];
                output_data4 <= buffer[rd_pt*8 + 3];
                output_data5 <= buffer[rd_pt*8 + 4];
                output_data6 <= buffer[rd_pt*8 + 5];
                output_data7 <= buffer[rd_pt*8 + 6];
                output_data8 <= buffer[rd_pt*8 + 7];
                rd_pt <= rd_pt + 1;
                output_valid <= 1;
            end 
        end
    end
endmodule
