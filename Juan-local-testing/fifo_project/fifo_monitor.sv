//
// UVM Monitor: fifo_monitor
//
`ifndef FIFO_MONITOR_SV
`define FIFO_MONITOR_SV

`include "uvm_macros.svh"

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_item) item_collected_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Could not get virtual interface")
    endfunction

  virtual task run_phase(uvm_phase phase);
      fifo_item item;

      forever begin
          @(posedge vif.clk);

          // Monitor write transactions
          if (vif.w_en && !vif.full) begin
              item = fifo_item::type_id::create("write_item");
              item.trans_type = fifo_item::WRITE;
              item.data = vif.w_data;
              item_collected_port.write(item);
          end

          // Monitor read transactions
          if (vif.r_en && !vif.empty) begin
              item = fifo_item::type_id::create("read_item");
              item.trans_type = fifo_item::READ;
              item.data = vif.r_data;
              item_collected_port.write(item);
          end
      end
  endtask
endclass

`endif // FIFO_MONITOR_SV