module DRAM_model (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [1:0]  cmd,      // 00=ACT, 01=READ, 10=WRITE, 11=PRE
  input  logic [5:0]  row,      // row address
  input  logic [4:0]  col,      // column address
  input  logic [7:0]  wr_data,
  output logic [7:0]  rd_data,
  output logic        valid
);

  // Very simple: single bank, 64 rows, each row has 32 columns of 8-bit data.
  // Active row stored in row_buffer, or 'none' if not open.
  logic [7:0] mem [0:63][0:31];
  logic [5:0] active_row;
  logic       row_open;

  // For read data handshake
  logic [7:0] read_pipe;
  logic       valid_pipe;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      active_row <= '0;
      row_open   <= 0;
      rd_data    <= '0;
      valid_pipe <= 0;
    end
    else begin
      // Default no valid read output this cycle
      valid_pipe <= 0;

      case(cmd)
        2'b00: begin // ACT (Activate)
          // open a new row
          active_row <= row;
          row_open   <= 1;
        end
        2'b01: begin // READ
          if(row_open && (active_row == row)) begin
            read_pipe <= mem[row][col];
            valid_pipe <= 1;
          end
          // else read invalid data
        end
        2'b10: begin // WRITE
          if(row_open && (active_row == row)) begin
            mem[row][col] <= wr_data;
          end
        end
        2'b11: begin // PRE (Precharge)
          // close the row
          row_open <= 0;
        end
        default: ;
      endcase
    end
  end

  // Pipeline read data out
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      rd_data <= '0;
    end else begin
      if(valid_pipe) begin
        rd_data <= read_pipe;
      end
    end
  end

  assign valid = valid_pipe;

endmodule
