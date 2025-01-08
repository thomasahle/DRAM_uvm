class dram_env extends uvm_env;
  `uvm_component_utils(dram_env)

  dram_agent        agent;
  dram_scoreboard   sb;
  dram_cov          cov;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = dram_agent::type_id::create("agent", this);
    sb    = dram_scoreboard::type_id::create("sb", this);
    cov   = dram_cov::type_id::create("cov", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // scoreboard analysis fifo
    agent.analysis_port.connect(sb.analysis_fifo.analysis_export);
    // coverage
    agent.analysis_port.connect(cov.analysis_export);
  endfunction
endclass
