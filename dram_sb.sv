class dram_sb extends uvm_scoreboard;
`uvm_component_utils(dram_sb);

dram_seq_item pkt,pkt1;
bit [7:0] mem[0:63];
uvm_tlm_analysis_fifo #(dram_seq_item)ip_fifo;
uvm_tlm_analysis_fifo #(dram_seq_item)op_fifo;

function new(string name="dram_sb",uvm_component parent);
super.new(name,parent);
ip_fifo=new("ip_fifo",this);
op_fifo=new("op_fifo",this);

endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
pkt=dram_seq_item::type_id::create("pkt",this);
pkt1=dram_seq_item::type_id::create("pkt1",this);
endfunction


task run_phase(uvm_phase phase);
forever
begin

fork
ip_fifo.get(pkt);
`uvm_info("SB","TRANSACTIONS FROM MON1",UVM_NONE);
  $display("sb data0_in=%d,add=%d",pkt.data0_in,pkt.add0);
op_fifo.get(pkt1);
`uvm_info("SB","TRANSACTIONS FROM MON2",UVM_NONE);
  $display("sb data0_out=%d,add=%d",pkt1.data0_out,pkt1.add0);
  
  
  ip_fifo.get(pkt);
`uvm_info("SB","TRANSACTIONS FROM MON1",UVM_NONE);
  $display("sb data1_in=%d,add=%d",pkt.data1_in,pkt.add1);
op_fifo.get(pkt1);
`uvm_info("SB","TRANSACTIONS FROM MON2",UVM_NONE);
  $display("sb data1_out=%d,add=%d",pkt1.data1_out,pkt1.add1);
  
  

join

  if(pkt.wr0==0)
begin
  mem[pkt.add0]=pkt.data0_in;
end
  if(pkt1.data0_out==mem[pkt1.add0])
   begin
     `uvm_info("SB MATCHED",$sformatf("DATA pkt.data0_in=%d,pkt1.data0_out=%d",mem[pkt1.add0],pkt1.data0_out),UVM_NONE);
//$display("SB:::::data matched pkt1.en=%d,pkt1.count=%d,pkt.en=%d",pkt1.count);
   end
else
   begin
     `uvm_info("SB NOT MATCHED",$sformatf("DATA pkt.data0_in=%d,pkt1.data0_out=%d",mem[pkt1.add0],pkt1.data0_out),UVM_NONE);
 //$display("SB:::::data not matched pkt1.en=%d,pkt1.count=%d,pkt.en=%d",pkt1.count);
    end 
  
 
  if(pkt.wr1==0)
begin
  mem[pkt.add1]=pkt.data1_in;
end
  if(pkt1.data1_out==mem[pkt1.add1])
   begin
     `uvm_info("SB MATCHED",$sformatf("DATA pkt.data0_in=%d,pkt1.data1_out=%d",mem[pkt1.add1],pkt1.data1_out),UVM_NONE);
//$display("SB:::::data matched pkt1.en=%d,pkt1.count=%d,pkt.en=%d",pkt1.count);
   end
else
   begin
     `uvm_info("SB NOT MATCHED",$sformatf("DATA pkt.data0_in=%d,pkt1.data1_out=%d",mem[pkt1.add1],pkt1.data1_out),UVM_NONE);
 //$display("SB:::::data not matched pkt1.en=%d,pkt1.count=%d,pkt.en=%d",pkt1.count);
    end 
  
  

end
endtask

endclass
