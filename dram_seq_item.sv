class dram_seq_item extends uvm_sequence_item;
`uvm_object_utils(dram_seq_item)

// rand bit[7:0] data_in;
// rand bit[5:0] add;
// bit wr;
// bit en;
// bit[7:0] data_out;
  
  rand bit[7:0] data0_in,data0_out,data1_in,data1_out;
rand bit[5:0] add0,add1;
bit en,wr0,wr1;


function new(string name="dram_seq_item");
super.new(name);
endfunction

endclass

