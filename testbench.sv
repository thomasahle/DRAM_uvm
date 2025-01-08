
`timescale 1ns/1ps
import uvm_pkg::*;
import dram_pkg::*;
import dram_seq_pkg::*;

module dram_top();
  bit clk;
  bit rst_n;

  // Instantiate the interface
  dram_if dif(clk, rst_n);

  // Instantiate the DRAM model
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

  // Clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  // Run UVM
  initial begin
    // Provide the interface to the test via config_db
    uvm_config_db#(virtual dram_if)::set(uvm_root::get(), "*", "vif", dif);

    run_test("dram_test");
    #100 $finish;
  end
endmodule
