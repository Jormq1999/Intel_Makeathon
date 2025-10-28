// Simple non-UVM testbench for the FIFO
`timescale 1ns/1ps
module tb_simple;

    parameter DATA_WIDTH = 32;
    parameter DEPTH = 16;
    parameter NUM_TRANS = 32; // number of writes to attempt

    // Clock and reset
    logic clk;
    logic rst_n;

    // DUT interface signals
    logic [DATA_WIDTH-1:0] w_data;
    logic                  w_en;
    logic [DATA_WIDTH-1:0] r_data;
    logic                  r_en;
    logic                  full;
    logic                  almost_full;
    logic                  empty;
    logic                  almost_empty;

    // Instantiate DUT
    fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .w_data(w_data),
        .w_en(w_en),
        .full(full),
        .almost_full(almost_full),
        .r_data(r_data),
        .r_en(r_en),
        .empty(empty),
        .almost_empty(almost_empty)
    );

    // Clock gen
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    // Test vectors storage
    reg [DATA_WIDTH-1:0] expected[$];
    integer i;

    // Test sequence
    initial begin
        // reset
        rst_n = 0;
        w_en = 0;
        r_en = 0;
        w_data = 0;
        repeat (4) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // Fill attempts (write until full or NUM_TRANS tries)
        $display("Starting write phase");
        for (i = 0; i < NUM_TRANS; i = i + 1) begin
            @(posedge clk);
            if (!full) begin
                w_en <= 1;
                w_data <= $urandom;
                expected.push_back(w_data);
                $display("WRITE: %0d data=%h count=%0d", i, w_data, expected.size());
            end else begin
                w_en <= 0;
                $display("FIFO full at write attempt %0d", i);
            end
        end
        // Deassert write
        @(posedge clk);
        w_en <= 0;

        // Small gap
        repeat (4) @(posedge clk);

        // Read back until expected is empty
        $display("Starting read phase");
        i = 0;
        while (expected.size() > 0) begin
            @(posedge clk);
            if (!empty) begin
                r_en <= 1;
                @(posedge clk);
                r_en <= 0;
                // r_data is combinational read of mem[r_ptr] in our design
                // sample at the same cycle after r_en
                reg [DATA_WIDTH-1:0] actual;
                actual = r_data;
                reg [DATA_WIDTH-1:0] exp = expected.pop_front();
                if (actual !== exp) begin
                    $error("Data mismatch at read %0d: expected=%h actual=%h", i, exp, actual);
                end else begin
                    $display("READ %0d OK: %h", i, actual);
                end
                i = i + 1;
            end else begin
                @(posedge clk);
            end
        end

        $display("Test completed. %0d items read and verified.", i);
        $finish;
    end

endmodule
