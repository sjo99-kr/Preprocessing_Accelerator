`timescale 1ns / 1ps



module LineBuffer#(parameter N = 240
)(
    input i_clk,
    input i_rst,
    input i_read,
    input i_write,
    input [23:0] i_data,
    output [23:0] o_data
    );
    //LineBuffer Setting (1920 x 1080)
    reg [23:0] LineBuffer [N / 8 - 1:0];
    reg [$clog2(N / 8) + 1: 0] wr_ptr;
    reg [$clog2(N / 8) +1 :0] rd_ptr;
    
    // rd_ptr setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            rd_ptr <=0;
        end
        else begin
            if(i_read)begin
                rd_ptr <= rd_ptr +1;
                if(rd_ptr == N / 8 - 1) begin
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
                if(wr_ptr == N / 8 - 1) begin
                    wr_ptr <= 0;
                end
            end
        end
    end
 
    
    // write process
    always@(posedge i_clk)begin
        if(i_write)begin
            LineBuffer[wr_ptr] <= i_data;
        end
    end
        
    // data setting
    assign o_data = LineBuffer[rd_ptr];
endmodule
