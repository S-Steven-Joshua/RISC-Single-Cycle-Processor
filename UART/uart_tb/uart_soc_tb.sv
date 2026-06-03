`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 11:44:20
// Design Name: 
// Module Name: uart_soc_tb
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


module uart_soc_tb;

    logic        clk;
    logic        rst;
    logic [31:0] data_in;
    logic        wr_en;
    logic        master_busy;
    logic [31:0] data_out;
    logic        master_ready;

    logic [7:0] tx_byte;
    logic [7:0] rx_byte;

    uart_soc dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .wr_en(wr_en),
        .master_busy(master_busy),
        .data_out(data_out),
        .master_ready(master_ready)
    );

    assign tx_byte = dut.data_tx;
    assign rx_byte = dut.data_rx;

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Main Test
    //--------------------------------------------------
    initial begin

        rst     = 1'b1;
        wr_en   = 1'b0;
        data_in = 32'h00000000;

        #20;
        rst = 1'b0;

        @(posedge clk);

        data_in = 32'h11223344;
        wr_en   = 1'b1;

        @(posedge clk);
        wr_en = 1'b0;

        // Wait until full 32-bit word is reconstructed
        wait(master_ready);

        #20;

        if(data_out == 32'h11223344)
            $display("SUCCESS: Data matches! got %h", data_out);
        else
            $display("ERROR: Expected 11223344, got %h", data_out);

        $finish;
    end

    //--------------------------------------------------
    // Monitor
    //--------------------------------------------------
    initial begin
        $monitor(
            "Time=%0t | TX_Byte=%h | RX_Byte=%h | RX_RDY=%b | CLR=%b | CNT=%0d | DATA_OUT=%h",
            $time,
            tx_byte,
            rx_byte,
            dut.uart_rx1.rdy,
            dut.deserializer1.rdy_clear,
            dut.deserializer1.counter,
            data_out
        );
    end

endmodule
