class dram_mon1 extends uvm_monitor;
`uvm_component_utils(dram_mon1)
dram_seq_item pkt;
virtual intif inf;

uvm_analysis_port #(dram_seq_item) item_collected_port;
uvm_analysis_port #(dram_seq_item) custom_ap;

function new(string name="dram_mon1",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
uvm_config_db #(virtual intif) ::get(this,"","inf",inf);
item_collected_port=new("item_collected_port",this);
custom_ap = new("analysis_port",this);
endfunction

task run_phase(uvm_phase phase);
pkt=dram_seq_item::type_id::create("pkt");
forever
begin
#5;

  @(posedge inf.clk)
  if(inf.en==1) begin

pkt.en=inf.en;
pkt.wr0=inf.wr0;
pkt.data0_in=inf.data0_in;
pkt.add0=inf.add0;	
  
  pkt.wr1=inf.wr1;
pkt.data1_in=inf.data1_in;
pkt.add1=inf.add1;
  
  
`uvm_info("MON1","MON1 TRANSACTIONS" ,UVM_NONE);
end
`uvm_info("MON","MON TRANSACTIONS",UVM_NONE);
@(posedge inf.clk)
item_collected_port.write(pkt);
custom_ap.write (pkt);
	end
endtask
endclass
