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


module dct_linebuffer(
    input i_clk,
    input i_rst,
    input i_read,
    input i_write,
    input [11:0] i_data0,
    input [11:0] i_data1,
    input [11:0] i_data2,
    input [11:0] i_data3,
    input [11:0] i_data4,
    input [11:0] i_data5,
    input [11:0] i_data6,
    input [11:0] i_data7,
    
    output [11:0] o_data0,
    output [11:0] o_data1,
    output [11:0] o_data2,
    output [11:0] o_data3,
    output [11:0] o_data4,
    output [11:0] o_data5,
    output [11:0] o_data6,
    output [11:0] o_data7,
    output  o_valid
    );
    //LineBuffer Setting (1920 x 1080)
    reg signed [11: 0] LineBuffer0 [7:0];
    reg signed [11: 0] LineBuffer1 [7:0];
    reg signed [11: 0] LineBuffer2 [7:0];
    reg signed [11: 0] LineBuffer3 [7:0];
    reg signed [11: 0] LineBuffer4 [7:0];
    reg signed [11: 0] LineBuffer5 [7:0];
    reg signed [11: 0] LineBuffer6 [7:0];
    reg signed [11: 0] LineBuffer7 [7:0];
    
    wire empty;
    reg [2: 0] wr_ptr;
    reg [2 :0] rd_ptr;
    reg [2:0] buf_num;
    
    
    // rd_ptr setting 
    always@(posedge i_clk)begin
        if(i_rst)begin
            rd_ptr <=0;
        end
        else begin
            if(i_read)begin
                rd_ptr <= rd_ptr +1;
                if(rd_ptr == 7) begin
                    rd_ptr <= 0;
                end
            end
        end
    end    
    
    // wr_ptr setting && buf_num setting
    always@(posedge i_clk)begin
        if(i_rst)begin
            wr_ptr<=0;
            buf_num <=0;
        end
        else begin
            if(i_write)begin
                buf_num <= buf_num +1;
                if(buf_num==7)begin
                    buf_num <= 0;
                end
            end
        end
    end
 
    
    // write process
    always@(posedge i_clk)begin
        if(i_write)begin
            case(buf_num) 
                0: begin
                    LineBuffer0[0] <= i_data0;
                    LineBuffer0[1] <= i_data1;
                    LineBuffer0[2] <= i_data2;
                    LineBuffer0[3] <= i_data3;
                    LineBuffer0[4] <= i_data4;
                    LineBuffer0[5] <= i_data5;
                    LineBuffer0[6] <= i_data6;
                    LineBuffer0[7] <= i_data7;
                end    
                1:  begin
                        LineBuffer1[0] <= i_data0;
                        LineBuffer1[1] <= i_data1;
                        LineBuffer1[2] <= i_data2;
                        LineBuffer1[3] <= i_data3;
                        LineBuffer1[4] <= i_data4;
                        LineBuffer1[5] <= i_data5;
                        LineBuffer1[6] <= i_data6;
                        LineBuffer1[7] <= i_data7;
                    end
                2:  begin
                        LineBuffer2[0] <= i_data0;
                        LineBuffer2[1] <= i_data1;
                        LineBuffer2[2] <= i_data2;
                        LineBuffer2[3] <= i_data3;
                        LineBuffer2[4] <= i_data4;
                        LineBuffer2[5] <= i_data5;
                        LineBuffer2[6] <= i_data6;
                        LineBuffer2[7] <= i_data7;
                    end
                3:  begin
                        LineBuffer3[0] <= i_data0;
                        LineBuffer3[1] <= i_data1;
                        LineBuffer3[2] <= i_data2;
                        LineBuffer3[3] <= i_data3;
                        LineBuffer3[4] <= i_data4;
                        LineBuffer3[5] <= i_data5;
                        LineBuffer3[6] <= i_data6;
                        LineBuffer3[7] <= i_data7;
                    end
                4:  begin
                        LineBuffer4[0] <= i_data0;
                        LineBuffer4[1] <= i_data1;
                        LineBuffer4[2] <= i_data2;
                        LineBuffer4[3] <= i_data3;
                        LineBuffer4[4] <= i_data4;
                        LineBuffer4[5] <= i_data5;
                        LineBuffer4[6] <= i_data6;
                        LineBuffer4[7] <= i_data7;
                    end
                5:  begin
                        LineBuffer5[0] <= i_data0;
                        LineBuffer5[1] <= i_data1;
                        LineBuffer5[2] <= i_data2;
                        LineBuffer5[3] <= i_data3;
                        LineBuffer5[4] <= i_data4;
                        LineBuffer5[5] <= i_data5;
                        LineBuffer5[6] <= i_data6;
                        LineBuffer5[7] <= i_data7;
                    end
                6:  begin
                        LineBuffer6[0] <= i_data0;
                        LineBuffer6[1] <= i_data1;
                        LineBuffer6[2] <= i_data2;
                        LineBuffer6[3] <= i_data3;
                        LineBuffer6[4] <= i_data4;
                        LineBuffer6[5] <= i_data5;
                        LineBuffer6[6] <= i_data6;
                        LineBuffer6[7] <= i_data7;
                    end
                7:  begin
                        LineBuffer7[0] <= i_data0;
                        LineBuffer7[1] <= i_data1;
                        LineBuffer7[2] <= i_data2;
                        LineBuffer7[3] <= i_data3;
                        LineBuffer7[4] <= i_data4;
                        LineBuffer7[5] <= i_data5;
                        LineBuffer7[6] <= i_data6;
                        LineBuffer7[7] <= i_data7;
                    end
            endcase
        end
    end
    

    

        
    // data setting
    assign o_valid = i_read;
    assign o_data0 = LineBuffer0[rd_ptr];
    assign o_data1 = LineBuffer1[rd_ptr];
    assign o_data2 = LineBuffer2[rd_ptr];
    assign o_data3 = LineBuffer3[rd_ptr];
    assign o_data4 = LineBuffer4[rd_ptr];
    assign o_data5 = LineBuffer5[rd_ptr];
    assign o_data6 = LineBuffer6[rd_ptr];
    assign o_data7 = LineBuffer7[rd_ptr];
    
endmodule
