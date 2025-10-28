//
// UVM Sequence: fifo_base_sequence
//
`ifndef FIFO_BASE_SEQUENCE_SV
`define FIFO_BASE_SEQUENCE_SV

class fifo_base_sequence extends uvm_sequence #(fifo_item);
    `uvm_object_utils(fifo_base_sequence)

    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction

    // Base sequence task - to be extended by specific tests
    virtual task body();
        // Default behavior is to do nothing
    endtask
endclass

//
// Sequence: Write data to FIFO
//
class fifo_write_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_write_sequence)

    int num_writes = 1;

    function new(string name = "fifo_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat (num_writes) begin
            `uvm_do_with(req, {
                req.trans_type == fifo_item::WRITE;
            })
        end
    endtask
endclass

//
// Sequence: Read data from FIFO
//
class fifo_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_read_sequence)

    int num_reads = 1;

    function new(string name = "fifo_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        repeat (num_reads) begin
            `uvm_do_with(req, {
                req.trans_type == fifo_item::READ;
            })
        end
    endtask
endclass

`endif // FIFO_BASE_SEQUENCE_SV