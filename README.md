# ARM AMPA AP4 Verification

This repository contains the UVM-based verification environment for the ARM AMPA AP4 protocol. It focuses exclusively on the verification aspects, and with achieved 100% code and functional coverage through event driven simulation with constraints randomization according to a verification plan.

## Overview

- **Verification Scope:**  
  This repository focused solely on the verification part of the AMPA AP4 protocol. The design itself is not part of this repository.

- **Coverage:**  
  The verification process achieved 100% code and functional coverage.

- **UVM-Based Environment:**  
  The testbench is built using a UVM (Universal Verification Methodology) framework.

- **Design Acknowledgement:**  
  The design components are maintained in a another repository by Mohamed Hussein: [AMPA_APB4_Protocol](https://github.com/MohamedHussein27/AMPA_APB4_Protocol). Please refer to that repository for design details.

## UVM Structure

The UVM environment is organized into several directories and files, as detailed below:

### Interface Files
- `interface/apb_defines.svh`
- `interface/shared_pkg.sv`
- `interface/APB_if.sv`

### Design Files
- `design/APB_design/APB_Wrapper.v`
- `design/APB_design/golden_model.sv`
- `design/APB_design/APB_Slave.v`
- `design/APB_design/APB_Master.v`

### Assertions
- `design/APB_Assertions/APB_sva.sv`

### Testbench Objects
- `objects/APB_config.sv`

### Master Objects
- `objects/master_objects/APB_master_seq_item.sv`
- `objects/master_objects/APB_master_main_sequence.sv`
- `objects/master_objects/APB_master_reset_sequence.sv`

### Slave Objects
- `objects/slave_objects/APB_slave_seq_item.sv`
- `objects/slave_objects/APB_slave_main_sequence.sv`

### Environment Files
- `top/test/enviroment/APB_env.sv`

### Agents
- **Master Agent:**  
  - `top/test/enviroment/master_agent/APB_master_agent.sv`  
  - `top/test/enviroment/master_agent/sequencer/APB_master_sequencer.sv`  
  - `top/test/enviroment/master_agent/driver/APB_master_driver.sv`  
  - `top/test/enviroment/master_agent/monitor/APB_master_monitor.sv`

- **Slave Agent:**  
  - `top/test/enviroment/slave_agent/APB_slave_agent.sv`  
  - `top/test/enviroment/slave_agent/sequencer/APB_slave_sequencer.sv`  
  - `top/test/enviroment/slave_agent/driver/APB_slave_driver.sv`  
  - `top/test/enviroment/slave_agent/monitor/APB_slave_monitor.sv`

### Scoreboard and Coverage Collector
- `top/test/enviroment/scoreboard/APB_scoreboard.sv`
- `top/test/enviroment/coverage_collector/APB_coverage_collector.sv`

### Test and Top-Level Files
- **Test File:**  
  - `top/test/test.sv`
- **Top-Level File:**  
  - `top/top.sv`
