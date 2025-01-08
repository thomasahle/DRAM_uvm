class dram_monitor extends uvm_monitor;
  `uvm_component_utils(dram_monitor)

  uvm_analysis_port #(dram_seq_item) item_collected_port;
  virtual dram_if tb_if;

  function new(string name="dram_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dram_if)::get(this, "", "vif", tb_if))
      `uvm_fatal("MON", "No virtual interface provided to monitor")
  endfunction

  task run_phase(uvm_phase phase);
    dram_seq_item trans;
    trans = new("mon_trans");

    forever begin
      @(posedge tb_if.clk);

      // Whenever cmd != idle, let's capture a transaction
      if(tb_if.cmd != 2'bxx) begin
        // Copy signals
        trans.cmd     = tb_if.cmd;
        trans.row     = tb_if.row;
        trans.col     = tb_if.col;
        trans.wr_data = tb_if.wr_data;
        trans.valid   = tb_if.valid;
        trans.rd_data = tb_if.rd_data;
        
        // Send to scoreboard / coverage
        item_collected_port.write(trans);
        
        `uvm_info(get_type_name(),
          $sformatf("MON: Observed cmd=%0b row=%0d col=%0d wr_data=0x%0h valid=%0b rd_data=0x%0h",
                    trans.cmd, trans.row, trans.col, trans.wr_data, 
                    trans.valid, trans.rd_data),
          UVM_LOW
        );
      end
    end
  endtask
endclass
