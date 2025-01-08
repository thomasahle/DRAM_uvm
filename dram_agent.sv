class dram_agent extends uvm_agent;
  `uvm_component_utils(dram_agent)

  dram_driver   drv;
  dram_monitor  mon;
  uvm_analysis_port #(dram_seq_item) analysis_port;
  dram_seqr     seqr; // we'll define this next

  function new(string name, uvm_component parent);
    super.new(name,parent);
    analysis_port = new("analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = dram_driver::type_id::create("drv", this);
    mon  = dram_monitor::type_id::create("mon", this);
    seqr = dram_seqr::type_id::create("seqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    mon.item_collected_port.connect(analysis_port);
  endfunction
endclass

class dram_seqr extends uvm_sequencer #(dram_seq_item);
  `uvm_component_utils(dram_seqr)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
