// Simultaneous write/read stress test
`timescale 1ns/1ps
module tb_simul;
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
        integer i;
        reg [DATA_WIDTH-1:0] expected[$];

        rst_n = 0; w_en = 0; r_en = 0; w_data = 0;
        repeat (4) @(posedge clk);
        rst_n = 1; @(posedge clk);

        // Stress: for many cycles randomly enable write/read
        for (i = 0; i < 200; i = i + 1) begin
            @(posedge clk);
            // random chance to write
            if ($urandom_range(0,1)) begin
                if (!full) begin
                    w_en <= 1;
                    w_data <= $urandom;
                    expected.push_back(w_data);
                end else begin
                    w_en <= 0;
                end
            end else begin
                w_en <= 0;
            end

            // random chance to read
            if ($urandom_range(0,1)) begin
                if (!empty) begin
                    r_en <= 1;
                    @(posedge clk);
                    r_en <= 0;
                    reg [DATA_WIDTH-1:0] actual = r_data;
                    reg [DATA_WIDTH-1:0] expect = expected.pop_front();
                    if (actual !== expect) begin
                        $error("SIMUL TEST: mismatch: expected=%0h actual=%0h", expect, actual);
                    end
                end else begin
                    r_en <= 0;
                end
            end else begin
                r_en <= 0;
            end
        end

        $display("SIMUL TEST completed");
        $finish;
    end
endmodule
