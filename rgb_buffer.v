`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/21 20:36:36
// Design Name: 
// Module Name: rgb_buffer
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


module rgb_buffer(
    input i_clk,
    input i_rst,
    input [23:0] rgb_input,
    input i_read,
    
    output [23:0] rgb_output0,
    output [23:0] rgb_output1,
    output [23:0] rgb_output2,
    output [23:0] rgb_output3,
    output [23:0] rgb_output4,
    output [23:0] rgb_output5,
    output [23:0] rgb_output6,
    output [23:0] rgb_output7,
    output o_valid
    );
    reg [23:0] buffer [7:0];
    reg [2:0] counter;
    reg out_sig;
    always@(posedge i_clk) begin
        if(i_rst) begin
            counter <= 0;
            buffer[0] <= 0;
            buffer[1] <= 0;
            buffer[2] <= 0;
            buffer[3] <= 0;
            buffer[4] <= 0;
            buffer[5] <= 0;
            buffer[6] <= 0;
            buffer[7] <= 0;
        end
        if(i_read) begin
            case(counter) 
                0 : begin
                    buffer[0] <= rgb_input;
                    counter <= counter +1;
                end
                1: begin
                    buffer[1] <= rgb_input;
                    counter <= counter +1;
                end
                2: begin
                    buffer[2] <= rgb_input;
                    counter <= counter +1;
                end
                3: begin
                    buffer[3] <= rgb_input;
                    counter <= counter +1;
                end
                4: begin
                    buffer[4] <= rgb_input;
                    counter <= counter +1;
                end
                5: begin
                    buffer[5] <= rgb_input;
                    counter <= counter +1;
                end
                6: begin
                    buffer[6] <= rgb_input;
                    counter <= counter +1;
                end
                7: begin
                    buffer[7] <= rgb_input;
                    counter <= counter +1;
                end
            endcase
        end
    end

    always@(posedge i_clk)begin
        if(i_rst)begin
            out_sig <= 0;
        end
        else begin
            if(counter == 7)begin
                out_sig <= 1;
            end
            else begin
                out_sig <= 0;
            end
        end
    end

    assign o_valid = out_sig;

    assign rgb_output0 = (out_sig) ? buffer[0] : 0;
    assign rgb_output1 = (out_sig) ? buffer[1] : 0;
    assign rgb_output2 = (out_sig) ? buffer[2] : 0;
    assign rgb_output3 = (out_sig) ? buffer[3] : 0;
    assign rgb_output4 = (out_sig) ? buffer[4] : 0;
    assign rgb_output5 = (out_sig) ? buffer[5] : 0;
    assign rgb_output6 = (out_sig) ? buffer[6] : 0;
    assign rgb_output7 = (out_sig) ? buffer[7] : 0;

endmodule
