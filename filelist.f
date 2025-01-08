# Add the current directory to the include path
+incdir+.

# 1) Compile the packages first (they define classes & types):
1_dram_pkg.sv
2_dram_seq_pkg.sv

# 2) Then compile the UVM components that reference those packages
3_dram_drv.sv
4_dram_mon.sv
5_dram_cov.sv
6_dram_sb.sv
7_dram_agent.sv
8_dram_env.sv
9_dram_test.sv

# 3) Finally, compile your design and top testbench
design.sv
interface.sv
testbench.sv

