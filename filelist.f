
# filelist.f example
# (the timescale or macros you might include up top)
+incdir+.

# UVM packages from your tool
# (the simulator typically does this automatically)

# Our local packages
dram_pkg.sv         # defines dram_seq_item
dram_seq_pkg.sv     # defines dram_base_seq

# The rest of our code
dram_drv.sv
dram_mon.sv
dram_cov.sv
dram_sb.sv
dram_agent.sv
dram_env.sv
dram_test.sv

design.sv
interface.sv
testbench.sv
