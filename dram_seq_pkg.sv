
package dram_seq_pkg;
  import uvm_pkg::*;
  import dram_pkg::*;
  `include "uvm_macros.svh"

  class dram_base_seq extends uvm_sequence #(dram_seq_item);
    `uvm_object_utils(dram_base_seq)

    function new(string name="dram_base_seq");
      super.new(name);
    endfunction

    virtual task body();
      dram_seq_item req;

      // Example: 10 transactions + a final PRE
      for (int i=0; i<10; i++) begin
        req = dram_seq_item::type_id::create($sformatf("req_%0d", i));
        start_item(req);

        // Just a simplistic pattern:
        // 0 => ACT, 1 => WRITE, 2 => WRITE, 3 => READ, 4 => READ, repeat...
        if (i % 5 == 0)       req.cmd = ACT;
        else if (i % 5 < 3)   req.cmd = WRITE;
        else                  req.cmd = READ;

        // Randomize row/col/wr_data
        assert(req.randomize());

        finish_item(req);
      end

      // Finally do a PRE
      req = dram_seq_item::type_id::create("final_pre");
      start_item(req);
      req.cmd = PRE;
      assert(req.randomize());
      finish_item(req);
    endtask

  endclass
endpackage
