
import uvm_pkg::*;
import dram_pkg::*;

interface dram_if (input bit clk, input bit rst_n);
  logic [1:0] cmd;
  logic [5:0] row;
  logic [4:0] col;
  logic [7:0] wr_data;
  logic [7:0] rd_data;
  logic       valid;

  // For the DUT side
  modport dut (input  clk, rst_n, cmd, row, col, wr_data,
               output rd_data, valid);

  // For the Testbench side
  modport tb  (output cmd, row, col, wr_data,
               input  rd_data, valid);
endinterface
