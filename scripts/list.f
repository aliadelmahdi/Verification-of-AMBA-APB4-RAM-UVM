+incdir+./design
+incdir+./design/APB_Assertions
+incdir+./design/APB_design
+incdir+./interface
+incdir+./objects
+incdir+./objects/master_objects
+incdir+./objects/slave_objects
+incdir+./top
+incdir+./top/test
+incdir+./top/test/enviroment
+incdir+./top/test/enviroment/coverage_collector
+incdir+./top/test/enviroment/master_agent
+incdir+./top/test/enviroment/master_agent/driver
+incdir+./top/test/enviroment/master_agent/monitor
+incdir+./top/test/enviroment/master_agent/sequencer
+incdir+./top/test/enviroment/scoreboard
+incdir+./top/test/enviroment/slave_agent
+incdir+./top/test/enviroment/slave_agent/driver
+incdir+./top/test/enviroment/slave_agent/monitor
+incdir+./top/test/enviroment/slave_agent/sequencer

# List of files for the APB testbench

# Interface files
interface/shared_pkg.sv
interface/APB_if.sv

# Design file
design/APB_design/design.v

# Assertions
design/APB_Assertions/APB_sva.sv

top/test/enviroment/APB_env_pkg.sv

# Test file
top/test/test.sv

# Top-level file
top/top.sv