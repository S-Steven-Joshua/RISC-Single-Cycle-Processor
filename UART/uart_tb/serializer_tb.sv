`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 18:17:39
// Design Name: 
// Module Name: serializer_tb
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


module serializer_tb;
    logic        clk;
    logic        rst;
    logic [31:0] data_in; // 32-bit input
    logic        wr_en;
    logic        busy;    // Mock UART signal
    logic        tx;      // Mock UART signal
    logic [7:0]  data_out;
    logic        master_busy;
    logic        master_write;
    
    // Instantiate Serializer
    serializer s1 (
    .clk          (clk),
    .rst          (rst),
    .data_in      (data_in),
    .wr_en        (wr_en),
    .busy         (busy),
    .tx           (tx),
    .data_out     (data_out),
    .master_busy  (master_busy),
    .master_write (master_write)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize
        rst = 1; wr_en = 0; data_in = 0; busy = 0; tx = 1;
        #20 rst = 0;

        // --- Test 1: Send a 32-bit word ---
        @(posedge clk);
        data_in = 32'hAABBCCDD;
        wr_en   = 1;
        @(posedge clk);
        wr_en   = 0;

        // --- Mock UART behavior ---
        // The serializer will wait for tx=1 and !busy
        // Simulate UART busy cycle for 4 bytes
        repeat (4) begin
            wait(master_write); // Wait for serializer to trigger
            busy = 1;           // UART starts working
            tx   = 0;           // UART pulls line low (Start bit)
            #50;                // Mock transmission time
            busy = 0;           // UART finishes
            tx   = 1;           // UART line idle/stop bit
            #10;
        end

        #100 $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | master_busy=%b | master_write=%b | data_out=%h", 
                  $time, master_busy, master_write, data_out);
    end
endmodule:serializer_tb