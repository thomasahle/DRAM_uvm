
import uvm_pkg::*;
import dram_pkg::*;
`include "uvm_macros.svh"

class dram_monitor extends uvm_monitor;
  `uvm_component_utils(dram_monitor)

  virtual dram_if vif;
  uvm_analysis_port #(dram_seq_item) item_collected_port;

  function new(string name="dram_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dram_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "No virtual interface provided to monitor");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);

      // We'll consider a "transaction" whenever cmd != 2'bxx
      if (vif.cmd != 2'bxx) begin
        dram_seq_item trans = new("mon_trans");
        trans.cmd     = vif.cmd;
        trans.row     = vif.row;
        trans.col     = vif.col;
        trans.wr_data = vif.wr_data;
        trans.rd_data = vif.rd_data;
        trans.valid   = vif.valid;

        item_collected_port.write(trans);

        `uvm_info("MON", $sformatf(
          "OBSERVED cmd=%0d row=%0d col=%0d wr_data=0x%0h valid=%0b rd_data=0x%0h",
           trans.cmd, trans.row, trans.col, trans.wr_data, trans.valid, trans.rd_data
        ), UVM_LOW)
      end
    end
  endtask
endclass
