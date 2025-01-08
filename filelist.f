# Add the current directory to the include path
+incdir+.

# 1) Compile the packages first (they define classes & types):
dram_pkg.sv
dram_seq_pkg.sv

# 2) Then compile the UVM components that reference those packages
dram_drv.sv
dram_mon.sv
dram_cov.sv
dram_sb.sv
dram_agent.sv
dram_env.sv
dram_test.sv

# 3) Finally, compile your design and top testbench
design.sv
interface.sv
testbench.sv

