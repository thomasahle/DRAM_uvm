package dram_seq_pkg;
import uvm_pkg::*;
import dram_pkg::*; // Our dram_seq_item

class dram_base_seq extends uvm_sequence #(dram_seq_item);
  `uvm_object_utils(dram_base_seq)

  function new(string name="dram_base_seq");
    super.new(name);
  endfunction

  virtual task body();
    dram_seq_item req;
    foreach (i in [0:9]) begin
      req = dram_seq_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);

      // Randomize with an approach that ensures we do a valid DRAM flow
      // e.g. 1) random ACT, 2) random READ/WRITE multiple times, 3) random PRE, etc.
      // For demonstration, let's do: ACT -> 2 random WRITEs -> 2 random READs -> PRE
      if(i % 5 == 0) begin
        req.cmd = ACT; // occasionally do an ACT
      end
      else if(i % 5 == 1 || i % 5 == 2) begin
        req.cmd = WRITE;
      end
      else if(i % 5 == 3 || i % 5 == 4) begin
        req.cmd = READ;
      end

      // randomize row/col/wr_data
      assert(req.randomize());
      
      finish_item(req);
    end

    // Finally send a PRE to close row
    req = dram_seq_item::type_id::create("final_pre");
    start_item(req);
    req.cmd = PRE;
    assert(req.randomize());
    finish_item(req);
  endtask

endclass
endpackage
