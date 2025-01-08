package dram_pkg; // Package to hold sequence items, etc.

import uvm_pkg::*;

typedef enum bit [1:0] {
  ACT   = 2'b00,
  READ  = 2'b01,
  WRITE = 2'b10,
  PRE   = 2'b11
} dram_cmd_e;

class dram_seq_item extends uvm_sequence_item;
  `uvm_object_utils(dram_seq_item)

  rand dram_cmd_e cmd;
  rand bit [5:0]  row;
  rand bit [4:0]  col;
  rand bit [7:0]  wr_data;
  
  // For scoreboard checking
  bit [7:0] rd_data;
  bit       valid;

  function new(string name="dram_seq_item");
    super.new(name);
  endfunction

  // For random constraints, you might do something like:
  constraint c_row { row inside {[0:63]}; }
  constraint c_col { col inside {[0:31]}; }
endclass

endpackage
