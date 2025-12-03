
module SPI_state (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] data_in,
    
    output wire        spi_cs,
    output wire        spi_sclk,
    output wire        spi_data, // MISO
    output wire [04:0] counter
);

localparam [1:0] IDLE     = 0;
localparam [1:0] TRANSFER = 1;
localparam [1:0] DONE     = 2;

reg        MOSI;
reg [04:0] count;
reg        cs;
reg        sclk;
reg [01:0] state;

always @ (posedge clk or negedge rst) begin
    if (~rst) begin
        MOSI  <= 1'b0;
        count <= 05'd16;
        cs    <= 01'b1;
        sclk  <= 01'b0;
        state <= IDLE;
    end
    
    else begin
        case (state)
            IDLE: begin
                sclk  <= 1'b0;
                cs    <= (count == 16);
                state <= TRANSFER;
            end
            
            TRANSFER: begin
                sclk  <= 1'b0;
                cs    <= 1'b0;
                MOSI  <= data_in [count - 1];
                count <= count - 1;
                state <= DONE;
            end
            
            DONE: begin
                sclk <= 1'b1;
                if (count > 0) state <= IDLE;
                else begin
                    count <= 16;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

assign spi_cs   = cs;
assign spi_sclk = sclk;
assign spi_data = MOSI;
assign counter = count;

endmodule
