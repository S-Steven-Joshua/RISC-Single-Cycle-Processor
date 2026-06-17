`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 03:39:22
// Design Name: 
// Module Name: auto_tb
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


module auto_tb;
    logic clk;
    logic rst;
    logic write;
    logic [3:0] data_in;
    logic busy;
    logic pready_p;
    
    auto #(.N(4)) auto1(
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(data_in),
        .busy(busy),
        .pready_p(pready_p)
    );
    
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d wave=%b busy=%b counter=%b  write=%b ",$time,wave,busy,
        auto.counter,write  
    );
    end
    
    initial begin
    rst=1;
    #10;
    rst=0;
    
    @(posedge clk);
    write=1'b1;
    data_in=4'b1100;
    //count=4'b0100;
    @(posedge clk);
    write=0;
    #500;
    
    @(posedge clk);
    write=1;
    data_in=4'b0000;
    @(posedge clk);
    write=0;
    #200;
    
//    @(posedge clk);
//    data_in=8'b1111;
//    count=8'b1111;
//    #300;
    
    $finish;
    end
endmodule
