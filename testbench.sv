`timescale 1ns/1ps
import uvm_pkg::*;
import dram_pkg::*;
import dram_seq_pkg::*;

`include "design.sv"
`include "interface.sv"
`include "dram_seq_item.sv"
`include "dram_seq.sv"
`include "dram_drv.sv"
`include "dram_mon.sv"
`include "dram_cov.sv"
`include "dram_sb.sv"
`include "dram_agent.sv"
`include "dram_env.sv"
`include "dram_test.sv"

module dram_top();
  bit clk;
  bit rst_n;

  // Instantiate the interface
  dram_if dif(clk, rst_n);

  // Instantiate the DRAM design
  DRAM_model dut (
    .clk(dif.dut.clk),
    .rst_n(dif.dut.rst_n),
    .cmd(dif.dut.cmd),
    .row(dif.dut.row),
    .col(dif.dut.col),
    .wr_data(dif.dut.wr_data),
    .rd_data(dif.dut.rd_data),
    .valid(dif.dut.valid)
  );

  // Clock & reset generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  initial begin
    // Set up the virtual interface for UVM
    uvm_config_db#(virtual dram_if)::set(uvm_root::get(), "*", "vif", dif);

    // Run the test
    run_test("dram_test");
    #100 $finish;
  end
endmodule
