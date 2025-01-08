class dram_cov extends uvm_subscriber #(dram_seq_item);
  `uvm_component_utils(dram_cov)

  covergroup cg @(posedge vif.clk); // we’ll define vif below
    coverpoint item.cmd {
      bins act   = {ACT};
      bins read  = {READ};
      bins write = {WRITE};
      bins pre   = {PRE};
    }
    coverpoint item.row {
      bins row_low  = { [0:15] };
      bins row_mid  = { [16:31] };
      bins row_high = { [32:63] };
    }
    coverpoint item.col {
      bins col_low  = { [0:10] };
      bins col_mid  = { [11:20] };
      bins col_high = { [21:31] };
    }
    coverpoint item.wr_data {
      bins small = { [0:63] };
      bins big   = { [64:255] };
    }
    // Cross
    cross cmd, row;
  endgroup

  virtual dram_if vif;

  function new(string name="dram_cov", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dram_if)::get(this, "", "vif", vif))
      `uvm_fatal("COV", "No vif set for coverage");
    cg = new();
  endfunction

  virtual function void write(dram_seq_item t);
    item = t;
    cg.sample();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV", $sformatf("Overall coverage = %3.2f%%", cg.get_inst_coverage()), UVM_LOW);
  endfunction
endclass
