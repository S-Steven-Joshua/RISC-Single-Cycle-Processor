`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 12:59:05
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input logic clk,
    input logic rst,
    // for tx
    input logic wr_en,
    input logic [7:0] data_in,
    output logic busy,
    //for rx
    input logic rdy_clr,
    output logic rdy,
    output logic [7:0] data_out
    );
    logic tx_en;
    logic rx_en;
    logic serial_data; // This acts as the loopback line line
    
    baud_rate br(.clk(clk), .rst(rst), .tx_en(tx_en), .rx_en(rx_en));
    
    uart_tx   ut(.clk(clk), .wr_en(wr_en), .en(tx_en), .rst(rst),
                 .data_in(data_in), .tx(serial_data), .busy(busy));
                 
    uart_rx   rt(.clk(clk), .rst(rst), .rdy_clr(rdy_clr), .en(rx_en),
                 .rx(serial_data), .rdy(rdy), .data_out(data_out));
endmodule:uart_top

