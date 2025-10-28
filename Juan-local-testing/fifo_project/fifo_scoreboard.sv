```systemverilog
//
// UVM Scoreboard: fifo_scoreboard
//
`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_imp #(fifo_item, fifo_scoreboard) item_collected_export;
    fifo_item expected_q[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction

    virtual function void write(fifo_item item);
        if (item.trans_type == fifo_item::WRITE) begin
            expected_q.push_back(item);
            `uvm_info("SCOREBOARD", $sformatf("Write transaction collected. Data: %h", item.data), UVM_HIGH)
        end else if (item.trans_type == fifo_item::READ) begin
            if (expected_q.size() > 0) begin
                fifo_item expected_item = expected_q.pop_front();
                if (expected_item.data != item.data) begin
                    `uvm_error("SCOREBOARD", $sformatf("Data mismatch! Expected: %h, Actual: %h", expected_item.data, item.data))
                end else begin
                    `uvm_info("SCOREBOARD", $sformatf("Data match. Data: %h", item.data), UVM_HIGH)
                end
            end else begin
                `uvm_warning("SCOREBOARD", "Read from empty FIFO detected by monitor.")
            end
        end
    endfunction

endclass

`endif // FIFO_SCOREBOARD_SV
```
