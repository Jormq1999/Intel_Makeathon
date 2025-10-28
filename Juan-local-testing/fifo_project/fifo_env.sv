//
// UVM Environment: fifo_env
//
`ifndef FIFO_ENV_SV
`define FIFO_ENV_SV

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_agent    agent;
    fifo_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
    endfunction

endclass

`endif // FIFO_ENV_SV
