`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/16 16:50:06
// Design Name: 
// Module Name: LineBuffer
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


module LineBuffer#(parameter N =1920
)(
    input i_clk,
    input i_rst,
    input i_read,
    input i_write,
    input [23:0] i_data,
    output reg o_valid,
    output [23:0] o_data
    );
    //LineBuffer Setting (1920 x 1080)
    reg [23:0] LineBuffer [N / 8 - 1:0];
    reg [$clog2(N / 8) + 1: 0] wr_ptr;
    reg [$clog2(N / 8) +1 :0] rd_ptr;
    reg out_signal;
    
    // rd_ptr setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            rd_ptr <=0;
        end
        else begin
            if(i_read)begin
                rd_ptr <= rd_ptr +1;
                if(rd_ptr == N / 8) begin
                    rd_ptr <= 0;
                end
            end
        end
    end    
    
    // wr_ptr setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            wr_ptr<=0;
        end
        else begin
            if(i_write)begin
                wr_ptr <= wr_ptr +1;
                if(wr_ptr == N / 8) begin
                    wr_ptr <= 0;
                end
            end
        end
    end
    
    // out signal
    always@(posedge i_clk)begin
        if(i_rst)begin
            o_valid <=0;
        end
        else o_valid <=i_read; 
    end
    
    // write process
    always@(posedge i_clk)begin
        if(i_write)begin
            LineBuffer[wr_ptr] <= i_data;
        end
    end
    
    assign o_data = LineBuffer[rd_ptr];
    
endmodule
