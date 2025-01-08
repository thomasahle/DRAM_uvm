
import uvm_pkg::*;
import dram_pkg::*;
`include "uvm_macros.svh"

class dram_driver extends uvm_driver #(dram_seq_item);
  `uvm_component_utils(dram_driver)

  // Reference to the interface
  virtual dram_if vif;

  function new(string name="dram_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dram_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "No virtual interface provided to driver");
  endfunction

  virtual task run_phase(uvm_phase phase);
    dram_seq_item req;

    forever begin
      seq_item_port.get_next_item(req);

      @(posedge vif.clk);
      vif.cmd     = req.cmd;
      vif.row     = req.row;
      vif.col     = req.col;
      vif.wr_data = req.wr_data;

      `uvm_info("DRV", $sformatf("SENT cmd=%0d row=%0d col=%0d wr_data=0x%0h",
                                 req.cmd, req.row, req.col, req.wr_data),
                UVM_LOW)

      @(posedge vif.clk);
      seq_item_port.item_done();
    end
  endtask
endclass
