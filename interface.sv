interface dram_if (input bit clk, input bit rst_n);
  // DRAM signals
  logic [1:0] cmd;       // 00=ACT, 01=READ, 10=WRITE, 11=PRE
  logic [5:0] row;
  logic [4:0] col;
  logic [7:0] wr_data;
  logic [7:0] rd_data;
  logic       valid;

  // For DUT connect
  modport dut(
    input  clk, rst_n, cmd, row, col, wr_data,
    output rd_data, valid
  );

  // For TB driving
  modport tb(
    output cmd, row, col, wr_data,
    input  rd_data, valid
  );
endinterface
