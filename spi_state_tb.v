`timescale 1ns / 1ps

module spi_state_tb;

reg         clk;
reg         rst;
reg  [15:0] data_in;

wire        spi_cs;
wire        spi_sclk;
wire        spi_data;
wire [04:0] counter;

SPI_state dut (
    .clk (clk),
    .rst (rst),
    .counter (counter),
    .data_in (data_in),
    .spi_cs (spi_cs),
    .spi_sclk (spi_sclk),
    .spi_data (spi_data)
);

initial begin
    clk     = 0;
    rst     = 0;
    data_in = 0;
end

always #5 clk = ~clk;

initial begin
    #10 rst=1;
    
         data_in = 16'hA569;
    #480 data_in = 16'h2563;
    #480 data_in = 16'h9B63;
    #480 data_in = 16'h6A61;
    #480 data_in = 16'hA265;
    #480 data_in = 16'h7564;
    
    $finish;
end

endmodule