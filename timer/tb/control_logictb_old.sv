`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 20:15:33
// Design Name: 
// Module Name: control_logictb
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


module control_logictb;
    logic clk;
    logic rst;
    logic [31:0] data_word;
    logic write;
    logic master_busy;
    logic [3:0] bit_4;
    logic [7:0] bit_8;
    logic [11:0] bit_12;
    logic [15:0] bit_16;
    logic [7:0] counter_value;
    logic [5:0] control_word;
    logic [1:0] size_sel;
    
    control_logic control_logic1(
        .clk(clk),
        .rst(rst),
        .data_word(data_word),
        .write(write),
        .master_busy(master_busy),
        .bit_4(bit_4),
        .bit_8(bit_8),
        .bit_12(bit_12),
        .bit_16(bit_16),
        .counter_value(counter_value),
        .control_word(control_word),
        .size_sel(size_sel)
    );
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    initial begin
    $monitor("Time=%d write=%b data_in=%h bit_4=%b bit_8=%b bit_12=%b bit_16=%b counter_value=%b control_word=%b size_sel=%b",
        $time,write,data_word,bit_4,bit_8,bit_12,bit_16,counter_value,control_word,size_sel);
    end
    
    initial begin
    rst=1;
    data_word='0;
    write=0;
    #20;
    rst=0;
    @(posedge clk)
    write=1;
    data_word=32'h04640007;//4-bit normal mode
    @(posedge clk);
    write=0;
    
    @(posedge clk)
    write=1;
    data_word=32'h082F002F;//8 bit normal back mode
    @(posedge clk);
    write=0;
    
    @(posedge clk)
    write=1;
    data_word=32'h15000200;//12 bit auto  mode
    @(posedge clk);
    write=0;
    
    @(posedge clk)
    write=1;
    data_word=32'h1900C350;//16 bit auto back  mode
    @(posedge clk);
    write=0;    

    @(posedge clk)
    write=1;
    data_word=32'h0600000A;//4 bit square   mode
    @(posedge clk);
    write=0;   
     
    @(posedge clk)
    write=1;
    data_word=32'h0A000080;//4 bit square   mode
    @(posedge clk);
    write=0; 
    
    #500;
    $finish;
    end
endmodule:control_logictb
