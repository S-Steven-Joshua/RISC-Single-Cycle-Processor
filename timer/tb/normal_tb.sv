`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 00:02:20
// Design Name: 
// Module Name: normal_tb
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

 
module normal_tb;
    logic clk;
    logic rst;
    logic enable;
    logic [7:0] data_in;
    logic [3:0] count;
    logic wave;
    logic busy;
    
    normal #(.N(8)) normal1(
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data_in(data_in),
        .count(count),
        .wave(wave),
        .busy(busy)
    );
    initial begin
    clk=0;
    forever #5 clk= ~clk;
    end
    
    initial begin
    $monitor("Time=%d wave=%b busy=%b counter=%b counter_1=%b",$time,wave,busy,
        normal.counter,normal.counter_1    
    );
    end
    
    initial begin
    rst=1;
    #10;
    rst=0;
    enable=1;
    @(posedge clk);
    data_in=8'b0010_0100;
    count=4'b0100;
    #500;
    
//    @(posedge clk);
//    data_in=8'b1111;
//    count=8'b1111;
//    #300;
    
    $finish;
    end
endmodule:normal_tb
