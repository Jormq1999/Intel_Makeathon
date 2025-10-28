// Pointer wrap testbench for FIFO
`timescale 1ns/1ps
module tb_wrap;
    parameter DATA_WIDTH = 32;
    parameter DEPTH = 8; // small depth to force wrapping quickly

    logic clk;
    logic rst_n;

    logic [DATA_WIDTH-1:0] w_data;
    logic w_en;
    logic [DATA_WIDTH-1:0] r_data;
    logic r_en;
    logic full;
    logic almost_full;
    logic empty;
    logic almost_empty;

    fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (
        .clk(clk), .rst_n(rst_n), .w_data(w_data), .w_en(w_en),
        .full(full), .almost_full(almost_full), .r_data(r_data), .r_en(r_en), .empty(empty), .almost_empty(almost_empty)
    );

    // Clock
    initial begin clk = 0; forever #5 clk = ~clk; end

    // Test
    initial begin
        integer i;
        reg [DATA_WIDTH-1:0] exp[$];

        // reset
        rst_n = 0; w_en = 0; r_en = 0; w_data = 0;
        repeat (4) @(posedge clk);
        rst_n = 1; @(posedge clk);

        // Write DEPTH*3 values to force pointer wrap multiple times
        for (i = 0; i < DEPTH*3; i = i + 1) begin
            @(posedge clk);
            if (!full) begin
                w_en <= 1;
                w_data <= i;
                exp.push_back(i);
            end else begin
                w_en <= 0;
            end
        end
        @(posedge clk); w_en <= 0;

        // Read back until we've read all expected values
        i = 0;
        while (exp.size() > 0) begin
            @(posedge clk);
            if (!empty) begin
                r_en <= 1;
                @(posedge clk);
                r_en <= 0;
                reg [DATA_WIDTH-1:0] actual = r_data;
                reg [DATA_WIDTH-1:0] expect = exp.pop_front();
                if (actual !== expect) begin
                    $error("WRAP TEST: mismatch at read %0d: exp=%0d actual=%0d", i, expect, actual);
                end else begin
                    $display("WRAP TEST: read %0d OK: %0d", i, actual);
                end
                i = i + 1;
            end
        end

        $display("WRAP TEST completed: %0d items verified", i);
        $finish;
    end
endmodule
