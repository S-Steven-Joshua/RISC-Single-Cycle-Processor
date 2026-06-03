`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 01:14:34
// Design Name: 
// Module Name: deserializer_tb
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


module deserializer_tb;
    logic        clk;
    logic        rst;
    logic        ready;
    logic [7:0]  data_in;
    logic        rdy_clear;
    logic [31:0] data_out;
    logic        master_ready;
    
    
    deserializer des1(
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .data_in(data_in),
        .rdy_clear(rdy_clear),
        .data_out(data_out),
        .master_ready(master_ready)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    task send_byte(input [7:0] byte_val);
        begin
            @(posedge clk);
            data_in = byte_val;
            ready   = 1'b1;
            @(posedge clk);
            ready   = 1'b0;
            
            @(posedge clk); 
        end
    endtask
    
    initial begin
        
        rst     = 1;
        ready   = 0;
        data_in = 8'h00;
        #20 rst = 0;
        
        @(posedge clk);
        send_byte(8'hDE);
        send_byte(8'hAF);
        send_byte(8'hBA);
        send_byte(8'hEF);
        
        
        #20;
        
        $display("Final data_out: %h", data_out);
        $finish;
    end
    initial begin
        $monitor("Time=%0t | ready=%b | data_in=%h | master_ready=%b | data_out=%h", 
                  $time, ready, data_in, master_ready, data_out);
    end
endmodule: deserializer_tb
