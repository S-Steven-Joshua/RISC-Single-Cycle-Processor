`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 10:51:23
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input logic clk,
    input logic rst,
    input logic rdy_clr,
    input logic en, // 16x oversampling clock tick
    input logic rx, 
    output logic rdy,
    output logic [7:0] data_out
    );
    typedef enum logic [1:0] {S0, S1, S2} state_t;
    state_t state;
    logic [2:0] index;
    logic [7:0] temp;
    logic [3:0] sample; // Counts 0 to 15 (16 total ticks per bit)
    
    // Combined all assignments to rdy, state, and outputs into ONE block
    always_ff @(posedge clk) begin
        if(rst) begin
            rdy      <= 1'b0;
            data_out <= '0;
            sample   <= '0;
            state    <= S0;
            temp     <= '0;
            index    <= '0;
        end else begin
            if (rdy_clr) begin
                rdy <= 1'b0;
            end

            if(en) begin
                case(state)
                    S0: begin // Look for falling edge of Start Bit
                        if(rx == 1'b0) begin
                            if(sample == 4'd7) begin // Center of start bit (tick 8)
                                state  <= S1;
                                sample <= '0;
                                temp   <= '0;
                                index  <= '0;
                            end else begin
                                sample <= sample + 1'b1;
                            end
                        end else begin
                            sample <= '0; // Reset if it was a noise glitch
                        end
                    end                     
                    S1: begin // Data Bits Sampling
                        if(sample == 4'd15) begin // Full bit period reached (16 ticks)
                            sample      <= '0;
                            temp[index] <= rx; // Sample at the end of the 16-tick interval
                            if(index == 3'b111) begin
                                state <= S2;
                                index <= '0;
                            end else begin
                                index <= index + 1'b1;
                            end
                        end else begin
                            sample <= sample + 1'b1;
                        end
                    end
                    S2: begin // Stop Bit Verification
                        if(sample == 4'd15) begin // Wait full bit duration
                            sample <= '0;
                            if(rx == 1'b1) begin // Valid high stop bit
                                data_out <= temp;
                                rdy      <= 1'b1;
                            end
                            state <= S0;
                        end else begin
                            sample <= sample + 1'b1;
                        end
                    end
                    default: state <= S0;
                endcase
            end
        end
    end
endmodule:uart_rx