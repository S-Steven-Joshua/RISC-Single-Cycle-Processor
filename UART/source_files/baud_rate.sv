`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 18:07:07
// Design Name: 
// Module Name: baud_rate
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


module baud_rate(
    input logic clk,
    input logic rst,
    output logic tx_en,
    output logic rx_en
    );
    logic [12:0] transmitter;
    logic [8:0]  reciever;
    

    always_ff @(posedge clk) begin
        if (rst) begin
            transmitter <= '0;
        end else if(transmitter == 13'd5208) begin
            transmitter <= '0;
        end else begin
            transmitter <= transmitter + 1'b1;
        end
    end
    
    always_ff @(posedge clk) begin
        if (rst) begin
            reciever <= '0;
        end else if(reciever == 9'd326) begin
            reciever <= '0;
        end else begin
            reciever <= reciever + 1'b1;
        end
    end
    
    assign tx_en = (transmitter == 13'b0);
    assign rx_en = (reciever == 9'b0);
endmodule:baud_rate