//
// UVM Transaction Item: fifo_item
//
`ifndef FIFO_ITEM_SV
`define FIFO_ITEM_SV

class fifo_item extends uvm_sequence_item;
    // Data payload
    rand logic [31:0] data;

    // Type of transaction
    typedef enum { WRITE, READ } trans_type_e;
    rand trans_type_e trans_type;

    // UVM factory registration
    `uvm_object_utils_begin(fifo_item)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_enum(trans_type_e, trans_type, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor
    function new(string name = "fifo_item");
        super.new(name);
    endfunction

endclass

`endif // FIFO_ITEM_SV