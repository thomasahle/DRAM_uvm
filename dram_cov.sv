class dram_cov #(type T=dram_seq_item) extends uvm_subscriber #(T);
`uvm_component_utils(dram_cov)
//dram_seq_item pkt;
T pkt;

covergroup CovPort;	//@(posedge intf.clk);
  address0 : coverpoint pkt.add0 {
    bins low    = {[0:42]};
   // bins med    = {[21:42]};
    bins high   = {[43:63]};
  }
  address1 : coverpoint pkt.add1 {
    bins low   = {[0:42]};
   // bins med    = {[21:42]};
    bins high   = {[43:63]};
  }
  data0 : coverpoint  pkt.data0_in {
    bins low    = {[0:150]};
   // bins med    = {[51:150]};
    bins high   = {[151:255]};
  }
  data1 : coverpoint  pkt.data1_in {
    bins low    = {[0:150]};
   // bins med    = {[51:150]};
    bins high   = {[151:255]};
  }
  enable : coverpoint pkt.en;
  write0 : coverpoint pkt.wr0;
  write1 : coverpoint pkt.wr1;
  crosss : cross write0,write1 { bins write = binsof(write0) intersect {0} && binsof(write1) intersect {0};
                                bins read = binsof(write0) && binsof(write1);}
endgroup

function new (string name = "dram_cov", uvm_component parent);
      super.new (name, parent);
	  CovPort = new;
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	//pkt=dram_seq_item::type_id::create("pkt");
    //CovPort = new("CovPort",this);
endfunction
	  
virtual function void write (T t);
	`uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);
	pkt = t;
	CovPort.sample();
endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("coverage = %.2f %%",CovPort.get_inst_coverage());
  endfunction

endclass