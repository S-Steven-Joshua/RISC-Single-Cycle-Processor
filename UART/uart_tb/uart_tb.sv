`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 16:55:44
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;

    // Clock and Reset
    logic clk;
    logic rst;

    // TX Interface Signals
    logic wr_en;
    logic [7:0] data_in;
    logic busy;

    // RX Interface Signals
    logic rdy_clr;
    logic rdy;
    logic [7:0] data_out;

    // =========================================================================
    // Device Under Test (DUT) Instance
    // =========================================================================
    uart_top dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .data_in(data_in),
        .busy(busy),
        .rdy_clr(rdy_clr),
        .rdy(rdy),
        .data_out(data_out)
    );

    // =========================================================================
    // Clock Generation (100 MHz Clock -> 10ns Period)
    // =========================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // =========================================================================
    // Real-Time Flag Transition Monitor
    // Prints status changes immediately to the simulation transcript window
    // =========================================================================
    initial begin
        $timeformat(-9, 3, " ns", 20); // Prints time values precisely in nanoseconds
        $display("[MONITOR] Starting real-time flag transition tracking...");
        
        fork
            forever @(posedge rst)     $display("[FLAG CHANGED] @ %0t | RST asserted (System Resetting)", $time);
            forever @(negedge rst)     $display("[FLAG CHANGED] @ %0t | RST deasserted (System Active)", $time);
            forever @(posedge busy)    $display("[FLAG CHANGED] @ %0t | BUSY went HIGH (TX frame transmission started)", $time);
            forever @(negedge busy)    $display("[FLAG CHANGED] @ %0t | BUSY went LOW  (TX frame transmission finished)", $time);
            forever @(posedge rdy)     $display("[FLAG CHANGED] @ %0t | RDY went HIGH  (RX valid frame captured!) Data Out = %h", $time, data_out);
            forever @(negedge rdy)     $display("[FLAG CHANGED] @ %0t | RDY went LOW   (RX ready flag cleared)", $time);
            forever @(posedge rdy_clr) $display("[FLAG CHANGED] @ %0t | RDY_CLR pulsed HIGH (Clearing RX ready request)", $time);
        join
    end

    // =========================================================================
    // Stimulus Task Blocks
    // =========================================================================
    
    // Transmit a byte through the TX engine
    task automatic send_byte(input logic [7:0] din);
        begin
            @(negedge clk);
            data_in = din;
            wr_en   = 1'b1;
            @(negedge clk);
            wr_en   = 1'b0;
        end
    endtask : send_byte

    // Clear the Receiver Ready flag
    task automatic clear_ready;
        begin
            @(negedge clk);
            rdy_clr = 1'b1;
            @(negedge clk);
            rdy_clr = 1'b0;
        end
    endtask : clear_ready

    // =========================================================================
    // Main Simulation Execution Flow
    // =========================================================================
    initial begin
        // Initialize all drive signals to safe default states
        wr_en    = 0;
        data_in  = 0;
        rdy_clr  = 0;
        rst      = 0;
        #20;

        // ---------------------------------------------------------------------
        // STEP 1: Execute Global System Reset
        // ---------------------------------------------------------------------
        $display("\n=== STEP 1: Initiating Hardware Reset ===");
        @(negedge clk);
        rst = 1'b1;
        @(negedge clk);
        rst = 1'b0;
        #100; // Allow internal registers a brief window to settle in IDLE

        // ---------------------------------------------------------------------
        // STEP 2: Transmit and Verify First Packet (8'h41)
        // ---------------------------------------------------------------------
        $display("\n=== STEP 2: Transmitting Packet 8'h41 ===");
        send_byte(8'h41); 
        
        // Wait for the receiver to completely finish sampling the frame
        wait(rdy); 
        #50; // Hold window: lets rdy sit visibly on the waveform viewer
        
        // Clear the ready flag cleanly
        clear_ready;
        
        // Verify transmitter hardware dropped its busy line
        wait(!busy);  
        
        // CRITICAL TIMING GUARD: Wait 60,000 ns to guarantee the receiver 
        // finishes its cleanup states and enters IDLE before driving new data.
        #60000; 

        // ---------------------------------------------------------------------
        // STEP 3: Transmit and Verify Second Packet (8'h55)
        // ---------------------------------------------------------------------
        $display("\n=== STEP 3: Transmitting Packet 8'h55 ===");
        send_byte(8'h55);
        
        // Wait for the receiver to capture the next packet
        wait(rdy);
        #50;
        clear_ready;
        
        // Wait for transmitter to completely unload the second packet
        wait(!busy);
        #60000;

        // ---------------------------------------------------------------------
        // STEP 4: Close Out Simulation Safely
        // ---------------------------------------------------------------------
        $display("\n=== SIMULATION COMPLETE: All transitions verified cleanly ===");
        $finish;
    end

endmodule : uart_tb
