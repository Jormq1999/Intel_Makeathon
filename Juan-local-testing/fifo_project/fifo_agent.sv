```systemverilog
//
// UVM Agent: fifo_agent
//
`ifndef FIFO_AGENT_SV
`define FIFO_AGENT_SV

class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_driver   driver;
    fifo_monitor  monitor;
    uvm_sequencer #(fifo_item) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = fifo_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            driver = fifo_driver::type_id::create("driver", this);
            sequencer = uvm_sequencer#(fifo_item)::type_id::create("sequencer", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass

`endif // FIFO_AGENT_SV
```
