//
// UVM Scoreboard: fifo_scoreboard
//
`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV

`include "uvm_macros.svh"

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_imp #(fifo_item, fifo_scoreboard) item_collected_export;
    fifo_item expected_q[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(fifo_item item);
        fifo_item expected_item;

        if (item.trans_type == fifo_item::WRITE) begin
            expected_q.push_back(item);
        end else if (item.trans_type == fifo_item::READ) begin
            if (expected_q.size() > 0) begin
                expected_item = expected_q.pop_front();
                if (expected_item.data != item.data) begin
                    `uvm_error("SCOREBOARD", $sformatf("Data mismatch! Expected: %h, Actual: %h", expected_item.data, item.data))
                end
            end
        end
    endfunction
endclass
`endif // FIFO_SCOREBOARD_SV