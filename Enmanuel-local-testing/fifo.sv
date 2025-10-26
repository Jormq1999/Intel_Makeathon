// Simple Synchronous FIFO
// Parameters: DATA_WIDTH, DEPTH
// Signals: clk, rst_n, wr_en, rd_en, data_in, data_out, full, empty
//Supports 16 entries of 8-bit width each

module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH) // Calculates the logarithm base-2 of DEPTH
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    wr_en,
    input  logic                    rd_en,
    input  logic [DATA_WIDTH-1:0]   data_in,
    output logic [DATA_WIDTH-1:0]   data_out,
    output logic                    full,
    output logic                    empty
);

    // Internal memory array
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    // Read and write pointers
    logic [ADDR_WIDTH:0] wr_ptr;
    logic [ADDR_WIDTH:0] rd_ptr;
    
    // Full and empty flag generation
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && 
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);
    assign empty = (wr_ptr == rd_ptr);
    
    // Write operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end
    
    // Read operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= '0;
            data_out <= '0;
        end else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

endmodule
