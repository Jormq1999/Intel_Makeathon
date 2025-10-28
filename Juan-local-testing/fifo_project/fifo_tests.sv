//
// UVM Base Test: fifo_base_test
//
`ifndef FIFO_BASE_TEST_SV
`define FIFO_BASE_TEST_SV

class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)

    fifo_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        // Base test does nothing, to be extended
        #100ns;
        phase.drop_objection(this);
    endtask

endclass

//
// Test: Write to Full
//
class test_write_to_full extends fifo_base_test;
    `uvm_component_utils(test_write_to_full)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_write_sequence seq;
        phase.raise_objection(this);
        seq = fifo_write_sequence::type_id::create("seq");
        seq.num_writes = 20; // More than DEPTH to test full condition
        seq.start(env.agent.sequencer);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass

//
// Test: Read from Empty
//
class test_read_from_empty extends fifo_base_test;
    `uvm_component_utils(test_read_from_empty)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_read_sequence read_seq;
        fifo_write_sequence write_seq;
        phase.raise_objection(this);
        // First, fill the FIFO
        write_seq = fifo_write_sequence::type_id::create("write_seq");
        write_seq.num_writes = 16;
        write_seq.start(env.agent.sequencer);
        
        // Then, read until empty
        read_seq = fifo_read_sequence::type_id::create("read_seq");
        read_seq.num_reads = 20; // More than DEPTH
        read_seq.start(env.agent.sequencer);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass

`endif // FIFO_BASE_TEST_SV
