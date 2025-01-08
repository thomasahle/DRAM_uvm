
import uvm_pkg::*;
import dram_pkg::*;
import dram_seq_pkg::*;
`include "uvm_macros.svh"

class dram_test extends uvm_test;
  `uvm_component_utils(dram_test)

  dram_env env;

  function new(string name="dram_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = dram_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    dram_base_seq seq;
    seq = new("base_seq");
    seq.start(env.agent.seqr);

    #100;
    phase.drop_objection(this);
  endtask
endclass
