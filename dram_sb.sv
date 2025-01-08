class dram_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dram_scoreboard)

  // We'll store a mirror of the memory
  bit [7:0] mem [0:63][0:31];
  // We have an analysis fifo from the monitor
  uvm_tlm_analysis_fifo #(dram_seq_item) analysis_fifo;

  function new(string name="dram_scoreboard", uvm_component parent);
    super.new(name,parent);
    analysis_fifo = new("analysis_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    dram_seq_item trans;
    forever begin
      analysis_fifo.get(trans);

      case(trans.cmd)
        ACT: ; // do nothing in scoreboard, just conceptually "open" a row
        READ: begin
          // If valid was asserted, check if scoreboard memory matches
          if(trans.valid) begin
            if(mem[trans.row][trans.col] == trans.rd_data) begin
              `uvm_info("SB", $sformatf("READ MATCH row=%0d col=%0d data=0x%0h", 
                         trans.row, trans.col, trans.rd_data), UVM_LOW)
            end else begin
              `uvm_error("SB", $sformatf("READ MISMATCH row=%0d col=%0d scoreboard=0x%0h dut=0x%0h",
                         trans.row, trans.col, mem[trans.row][trans.col], trans.rd_data))
            end
          end
        end
        WRITE: begin
          mem[trans.row][trans.col] = trans.wr_data;
        end
        PRE: ; // do nothing
      endcase
    end
  endtask
endclass
