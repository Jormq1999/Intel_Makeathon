```systemverilog
//
// Top-level Testbench: tb_top
//
// Description:
// This module instantiates the DUT (FIFO) and the verification interface.
// It also handles clock generation and reset sequencing.
//
`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;

    // Clock and Reset
    logic clk;
    
    // Instantiate the interface
    fifo_if #(.DATA_WIDTH(32), .DEPTH(16)) dut_if(clk);

    // Instantiate the DUT
    fifo #(
        .DATA_WIDTH(32),
        .DEPTH(16)
    ) dut (
        .clk(dut_if.clk),
        .rst_n(dut_if.rst_n),
        .w_data(dut_if.w_data),
        .w_en(dut_if.w_en),
        .full(dut_if.full),
        .almost_full(dut_if.almost_full),
        .r_data(dut_if.r_data),
        .r_en(dut_if.r_en),
        .empty(dut_if.empty),
        .almost_empty(dut_if.almost_empty)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Reset Generation
    initial begin
        dut_if.rst_n = 0;
        repeat (5) @(posedge clk);
        dut_if.rst_n = 1;
    end

    // UVM Test Execution
    initial begin
        // Place the interface into the UVM configuration database
        uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top", "vif", dut_if);
        
        // Run the UVM test
        run_test("fifo_base_test");
    end

endmodule
```
