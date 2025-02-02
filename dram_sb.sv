
// dram_sb.sv

import uvm_pkg::*;
import dram_pkg::*;
`include "uvm_macros.svh"

class dram_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dram_scoreboard)

  // Memory mirror
  bit [7:0] mem [0:63][0:31];

  // TLM FIFO for receiving items from the agent
  uvm_tlm_analysis_fifo #(dram_seq_item) analysis_fifo;

  function new(string name="dram_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_fifo = new("analysis_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    dram_seq_item trans;

    forever begin
      analysis_fifo.get(trans);

      case (trans.cmd)
        ACT: ; // not checking anything special
        READ: begin
          if (trans.valid) begin
            if (mem[trans.row][trans.col] == trans.rd_data) begin
              `uvm_info("SB", $sformatf(
                "READ MATCH row=%0d col=%0d data=0x%0h",
                trans.row, trans.col, trans.rd_data),
                UVM_LOW)
            end else begin
              `uvm_error("SB", $sformatf(
                "READ MISMATCH row=%0d col=%0d expected=0x%0h got=0x%0h",
                trans.row, trans.col, mem[trans.row][trans.col], trans.rd_data))
            end
          end
        end
        WRITE: mem[trans.row][trans.col] = trans.wr_data;
        PRE:   ; // do nothing special
      endcase
    end
  endtask

endclass : dram_scoreboard
