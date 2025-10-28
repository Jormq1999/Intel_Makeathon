// Edge cases testbench for FIFO
`timescale 1ns/1ps
module tb_edgecases;
    parameter DATA_WIDTH = 32;
    parameter DEPTH = 16;

    logic clk; logic rst_n;
    logic [DATA_WIDTH-1:0] w_data; logic w_en;
    logic [DATA_WIDTH-1:0] r_data; logic r_en;
    logic full; logic almost_full; logic empty; logic almost_empty;

    fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (
        .clk(clk), .rst_n(rst_n), .w_data(w_data), .w_en(w_en),
        .full(full), .almost_full(almost_full), .r_data(r_data), .r_en(r_en), .empty(empty), .almost_empty(almost_empty)
    );

    initial begin clk = 0; forever #5 clk = ~clk; end

    initial begin
        rst_n = 0; w_en = 0; r_en = 0; w_data = 0;
        repeat (4) @(posedge clk);
        rst_n = 1; @(posedge clk);

        // Attempt to read when empty
        $display("EDGE: attempt read when empty");
        r_en <= 1; @(posedge clk); r_en <= 0; @(posedge clk);

        // Fill FIFO
        $display("EDGE: fill FIFO fully");
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            @(posedge clk);
            if (!full) begin
                w_en <= 1; w_data <= i; @(posedge clk); w_en <= 0;
            end
        end

        // Try to write when full
        $display("EDGE: attempt write when full");
        @(posedge clk); w_en <= 1; w_data <= 12345; @(posedge clk); w_en <= 0;

        // Reset during operation
        $display("EDGE: reset during operation");
        @(posedge clk); rst_n <= 0; @(posedge clk); rst_n <= 1;

        // Check FIFO is empty after reset
        repeat (2) @(posedge clk);
        if (!empty) $error("EDGE: expected empty after reset"); else $display("EDGE: empty after reset OK");

        $display("EDGE TEST completed");
        $finish;
    end
endmodule
