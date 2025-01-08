import uvm_pkg::*;
import dram_pkg::*;
interface dram_if (input bit clk, input bit rst_n); // forward declaration needed
endinterface

class dram_driver extends uvm_driver #(dram_seq_item);
  `uvm_component_utils(dram_driver)

  virtual dram_if tb_if;

  function new(string name="dram_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dram_if)::get(this, "", "vif", tb_if))
      `uvm_fatal("DRV", "No virtual interface provided to driver")
  endfunction

  virtual task run_phase(uvm_phase phase);
    dram_seq_item req;
    forever begin
      seq_item_port.get_next_item(req);

      // Drive the interface
      @(posedge tb_if.clk);
      tb_if.cmd     = req.cmd;
      tb_if.row     = req.row;
      tb_if.col     = req.col;
      tb_if.wr_data = req.wr_data;

      // We can wait a cycle if needed
      @(posedge tb_if.clk);
      seq_item_port.item_done();
      
      `uvm_info(get_type_name(), 
        $sformatf("DRV: Sent cmd=%0b row=%0d col=%0d wr_data=0x%0h", 
                  req.cmd, req.row, req.col, req.wr_data), 
        UVM_LOW
      );
    end
  endtask
endclass
