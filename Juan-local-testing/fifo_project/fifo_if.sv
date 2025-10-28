//
// Interface: fifo_if
//
// Description:
// This interface encapsulates all signals for the synchronous FIFO design.
// It is used to connect the DUT to the testbench.
//
interface fifo_if (
    input logic clk
);
    // Parameters
    parameter DATA_WIDTH = 32;
    parameter DEPTH      = 16;

    // System Signals
    logic                  rst_n;

    // Write Interface
    logic [DATA_WIDTH-1:0] w_data;
    logic                  w_en;
    logic                  full;
    logic                  almost_full;

    // Read Interface
    logic [DATA_WIDTH-1:0] r_data;
    logic                  r_en;
    logic                  empty;
    logic                  almost_empty;

    // Modport for the Testbench (driving and monitoring)
    modport tb (
        output rst_n,
        output w_data,
        output w_en,
        input  full,
        input  almost_full,
        input  r_data,
        output r_en,
        input  empty,
        input  almost_empty,
        input  clk
    );

    // Modport for the DUT
    modport dut (
        input  rst_n,
        input  w_data,
        input  w_en,
        output full,
        output almost_full,
        output r_data,
        input  r_en,
        output empty,
        output almost_empty,
        input  clk
    );

endinterface