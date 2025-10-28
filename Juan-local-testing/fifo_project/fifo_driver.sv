//
// UVM Driver: fifo_driver
//
`ifndef FIFO_DRIVER_SV
`define FIFO_DRIVER_SV

class fifo_driver extends uvm_driver #(fifo_item);
    `uvm_component_utils(fifo_driver)

    virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_item(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_item(fifo_item item);
        if (item.trans_type == fifo_item::WRITE) begin
            @(posedge vif.clk);
            vif.w_en <= 1;
            vif.w_data <= item.data;
            @(posedge vif.clk);
            vif.w_en <= 0;
        end else if (item.trans_type == fifo_item::READ) begin
            @(posedge vif.clk);
            vif.r_en <= 1;
            @(posedge vif.clk);
            vif.r_en <= 0;
        end
    endtask

endclass

`endif // FIFO_DRIVER_SV