//
// Design: AXI-Style Synchronous FIFO
//
// Description:
// This module implements a synchronous First-In, First-Out (FIFO) buffer with
// parameterized data width and depth. It uses an AXI-stream-like interface
// with write and read enables, along with status flags for full, empty,
// almost full, and almost empty conditions.
//
// The depth of the FIFO must be a power of 2.
//

module fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 16,
    parameter AFULL_THRESH  = DEPTH - 2, // Almost Full Threshold
    parameter AEMPTY_THRESH = 2          // Almost Empty Threshold
) (
    // System Signals
    input  logic                  clk,
    input  logic                  rst_n,

    // Write Interface
    input  logic [DATA_WIDTH-1:0] w_data,
    input  logic                  w_en,
    output logic                  full,
    output logic                  almost_full,

    // Read Interface
    output logic [DATA_WIDTH-1:0] r_data,
    input  logic                  r_en,
    output logic                  empty,
    output logic                  almost_empty
);

    // Local parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Internal storage
    logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    logic [DATA_WIDTH-1:0] r_data_reg;

    // Pointers and counters
    logic [ADDR_WIDTH-1:0] w_ptr;
    logic [ADDR_WIDTH-1:0] r_ptr;
    logic [ADDR_WIDTH:0]   item_count; // One extra bit to differentiate full from empty

    //--------------------------------------------------------------------------
    // Pointer and Counter Logic
    //--------------------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_ptr <= '0;
            r_ptr <= '0;
            item_count <= '0;
        end else begin
            // Item counter logic
            case ({w_en && !full, r_en && !empty})
                2'b10: item_count <= item_count + 1; // Write, no read
                2'b01: item_count <= item_count - 1; // Read, no write
                // 2'b11 (Write and Read) and 2'b00 (No op): count remains the same
                default: item_count <= item_count;
            endcase

            // Write pointer logic
            if (w_en && !full) begin
                w_ptr <= w_ptr + 1;
            end

            // Read pointer logic
            if (r_en && !empty) begin
                r_ptr <= r_ptr + 1;
            end
        end
    end

    //--------------------------------------------------------------------------
    // Memory Write and Read
    //--------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (w_en && !full) begin
            mem[w_ptr] <= w_data;
        end
    end

    // Registered read data output
    always_ff @(posedge clk) begin
        if (r_en && !empty) begin
            r_data_reg <= mem[r_ptr];
        end
    end

    assign r_data = r_data_reg;

    //--------------------------------------------------------------------------
    // Status Flags
    //--------------------------------------------------------------------------
    assign full  = (item_count == DEPTH);
    assign empty = (item_count == 0);

    assign almost_full  = (item_count >= AFULL_THRESH);
    assign almost_empty = (item_count <= AEMPTY_THRESH);

endmodule