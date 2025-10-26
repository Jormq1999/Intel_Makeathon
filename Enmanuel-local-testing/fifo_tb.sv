// FIFO Testbench
// Tests basic functionality, full/empty conditions, and data integrity

`timescale 1ns/1ps

module fifo_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;
    parameter CLK_PERIOD = 10; // 10ns = 100MHz

    // Testbench signals
    logic                    clk;
    logic                    rst_n;
    logic                    wr_en;
    logic                    rd_en;
    logic [DATA_WIDTH-1:0]   data_in;
    logic [DATA_WIDTH-1:0]   data_out;
    logic                    full;
    logic                    empty;

    // Test tracking
    int error_count = 0;
    int test_count = 0;

    // Instantiate DUT
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        $display("========================================");
        $display("FIFO Testbench Started");
        $display("========================================");
        
        // Initialize signals
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        
        // Test Case 1: Reset
        test_reset();
        
        // Test Case 2: Single Write
        test_single_write();
        
        // Test Case 3: Single Read
        test_single_read();
        
        // Test Case 4: Fill FIFO
        test_fill_fifo();

        // Test Case 5: Read after Fill
        test_single_read_after_fill();

        // Test Case 6: Drain FIFO
        test_drain_fifo();
        
        // Test Case 7: Data Integrity
        test_data_integrity();
        
        // Test Case 8: Simultaneous Read/Write
        test_simultaneous_rw();
        
        // Test Case 9: Write to Full FIFO
        test_write_when_full();
        
        // Test Case 10: Read from Empty FIFO
        test_read_when_empty();
        
        // Test Case 11: Back-to-Back Operations
        test_back_to_back();
        
        // Summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Errors: %0d", error_count);
        if (error_count == 0)
            $display("STATUS: ALL TESTS PASSED!");
        else
            $display("STATUS: TESTS FAILED!");
        $display("========================================\n");
        
        $finish;
    end

    //===========================================
    // Test Case Tasks
    //===========================================

    // Test Case 1: Reset Functionality
    task test_reset();
        begin
            test_count++;
            $display("\n[TEST %0d] Reset Functionality", test_count);
            
            rst_n = 0;
            #(CLK_PERIOD*5);
            rst_n = 1;
            #(CLK_PERIOD);
            
            if (empty !== 1'b1) begin
                $display("  ERROR: Empty flag not set after reset");
                error_count++;
            end
            if (full !== 1'b0) begin
                $display("  ERROR: Full flag set after reset");
                error_count++;
            end
            $display("  PASS: Reset successful - empty=%b, full=%b", empty, full);
        end
    endtask

    // Test Case 2: Single Write Operation
    task test_single_write();
        begin
            test_count++;
            $display("\n[TEST %0d] Single Write Operation", test_count);
            
            @(posedge clk);
            wr_en = 1;
            data_in = 170;
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);
            
            if (empty !== 1'b0) begin
                $display("  ERROR: FIFO still empty after write");
                error_count++;
            end else begin
                $display("  PASS: Write successful - empty=%b, full=%b", empty, full);
            end
        end
    endtask

    // Test Case 3: Single Read Operation
    task test_single_read();
        begin
            test_count++;
            $display("\n[TEST %0d] Single Read Operation", test_count);
            
            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            
            if (data_out !== 170) begin
                $display("  ERROR: Read data mismatch - expected=170, got=%0d", data_out);
                error_count++;
            end
            if (empty !== 1'b1) begin
                $display("  ERROR: FIFO not empty after reading last entry");
                error_count++;
            end else begin
                $display("  PASS: Read successful - data=%0d, empty=%b", data_out, empty);
            end
        end
    endtask

    // Test Case 4: Fill FIFO to Full
    task test_fill_fifo();
        begin
            test_count++;
            $display("\n[TEST %0d] Fill FIFO to Full", test_count);
            
            // Write DEPTH entries
            for (int i = 0; i < DEPTH; i++) begin
                @(posedge clk);
                wr_en = 1;
                data_in = i;
            end
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);
            
            if (full !== 1'b1) begin
                $display("  ERROR: Full flag not set after %0d writes", DEPTH);
                error_count++;
            end else begin
                $display("  PASS: FIFO full after %0d writes - full=%b", DEPTH, full);
            end
        end
    endtask


    // Test Case 5: Read after Fill

    task test_single_read_after_fill();
        begin
            test_count++;
            $display("\n[TEST %0d] Single Read Operation", test_count);
            
            rd_en = 1;
            @(posedge clk);  // Data becomes valid here
            rd_en = 0;
            
            if (data_out !== 0) begin
                $display("  ERROR: Read data mismatch - expected=0, got=%0d", data_out);
                error_count++;
            end
            else begin
                $display("  PASS: Read successful - data=%0d, empty=%b", data_out, empty);
            end
            
            @(posedge clk);  // Extra cycle before next test
        end
    endtask

    // Test Case 6: Drain FIFO to Empty
    task test_drain_fifo();
        logic [DATA_WIDTH-1:0] expected_data;
        int errors = 0;
        
        begin
            test_count++;
            $display("\n[TEST %0d] Drain FIFO to Empty", test_count);
            
            // Read remaining entries (DEPTH-1 because Test 5 already read one)
            for (int i = 1; i < DEPTH; i++) begin
                rd_en = 1;
                @(posedge clk);  // Clock edge - data becomes valid
                expected_data = i;
                if (data_out !== expected_data) begin
                    $display("  ERROR: Data mismatch at position %0d - expected=%0d, got=%0d", 
                             i, expected_data, data_out);
                    errors++;
                end
            end
            rd_en = 0;
            @(posedge clk);
            
            if (empty !== 1'b1) begin
                $display("  ERROR: Empty flag not set after %0d reads", DEPTH-1);
                error_count++;
            end else if (errors > 0) begin
                $display("  FAIL: %0d data mismatches detected", errors);
                error_count++;
            end else begin
                $display("  PASS: FIFO drained successfully - all data matched");
            end
        end
    endtask

    // Test Case 7: Data Integrity with Random Pattern
    task test_data_integrity();
        logic [DATA_WIDTH-1:0] test_data[0:DEPTH-1];
        logic [DATA_WIDTH-1:0] read_data;
        int errors = 0;
        
        begin
            test_count++;
            $display("\n[TEST %0d] Data Integrity - Random Pattern", test_count);
            
            // Generate and write random data
            for (int i = 0; i < DEPTH; i++) begin
                test_data[i] = $random;
                @(posedge clk);
                wr_en = 1;
                data_in = test_data[i];
            end
            @(posedge clk);
            wr_en = 0;
            
            // Read and verify
            for (int i = 0; i < DEPTH; i++) begin
                //@(posedge clk);
                rd_en = 1;
                @(posedge clk);
                if (data_out !== test_data[i]) begin
                    $display("  ERROR: Data mismatch at position %0d - expected=%0d, got=%0d", 
                             i, test_data[i], data_out);
                    errors++;
                end
            end
            rd_en = 0;
            @(posedge clk);
            
            if (errors > 0) begin
                $display("  FAIL: %0d data mismatches detected", errors);
                error_count++;
            end else begin
                $display("  PASS: All random data matched perfectly");
            end
        end
    endtask

    // Test Case 8: Simultaneous Read and Write
    task test_simultaneous_rw();
        logic [DATA_WIDTH-1:0] write_val, expected_val;
        
        begin
            test_count++;
            $display("\n[TEST %0d] Simultaneous Read and Write", test_count);
            
            // Fill half the FIFO first
            for (int i = 0; i < DEPTH/2; i++) begin
                @(posedge clk);
                wr_en = 1;
                rd_en = 0;
                data_in = 80 + i;
            end
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            
            // Simultaneous operations
            for (int i = 0; i < 8; i++) begin
                write_val = 160 + i;
                @(posedge clk);
                wr_en = 1;
                rd_en = 1;
                data_in = write_val;
            end
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            
            $display("  PASS: Simultaneous operations completed without errors");
        end
    endtask

    // Test Case 9: Write to Full FIFO (Overflow Protection)
    task test_write_when_full();
        begin
            test_count++;
            $display("\n[TEST %0d] Write to Full FIFO", test_count);
            
            // Fill FIFO with 255 for 16 times
            for (int i = 0; i < DEPTH; i++) begin
                @(posedge clk);
                wr_en = 1;
                data_in = 255;
            end
            @(posedge clk);
            
            // Try to write when full
            wr_en = 1;
            data_in = 238;
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);
            
            if (full !== 1'b1) begin
                $display("  ERROR: Full flag not maintained");
                error_count++;
            end else begin
                $display("  PASS: Overflow protection working - full flag maintained");
            end
            
            // Clean up - empty FIFO before test 10
            for (int i = 0; i < DEPTH; i++) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);
        end
    endtask

    // Test Case 10: Read from Empty FIFO (Underflow Protection)
    task test_read_when_empty();
        begin
            test_count++;
            $display("\n[TEST %0d] Read from Empty FIFO", test_count);
            
            // Ensure FIFO is empty
            if (empty !== 1'b1) begin
                $display("  ERROR: FIFO not empty at start of test");
                error_count++;
            end
            
            // Try to read when empty
            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);
            
            if (empty !== 1'b1) begin
                $display("  ERROR: Empty flag not maintained");
                error_count++;
            end else begin
                $display("  PASS: Underflow protection working - empty flag maintained");
            end
        end
    endtask

    // Test Case 11: Back-to-Back Operations
    task test_back_to_back();
        logic [DATA_WIDTH-1:0] test_pattern[0:7];
        int errors = 0;
        
        begin
            test_count++;
            $display("\n[TEST %0d] Back-to-Back Operations", test_count);
            
            // Generate test pattern
            for (int i = 0; i < 8; i++) begin
                test_pattern[i] = 176 + i;
            end
            
            // Back-to-back writes
            for (int i = 0; i < 8; i++) begin
                @(posedge clk);
                wr_en = 1;
                data_in = test_pattern[i];
            end
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);
            
            // Back-to-back reads
            for (int i = 0; i < 8; i++) begin
                //@(posedge clk);
                rd_en = 1;
                @(posedge clk);
                if (data_out !== test_pattern[i]) begin
                    $display("  ERROR: Data mismatch - expected=%0d, got=%0d", 
                             test_pattern[i], data_out);
                    errors++;
                end
            end
            rd_en = 0;
            @(posedge clk);
            
            if (errors > 0) begin
                $display("  FAIL: %0d errors in back-to-back operations", errors);
                error_count++;
            end else begin
                $display("  PASS: Back-to-back operations successful");
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #(CLK_PERIOD * 10000);
        $display("\n*** TIMEOUT: Simulation exceeded time limit ***");
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);
    end

endmodule
