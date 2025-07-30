# APB Verification Project

This project implements the **functional verification** of a fully integrated APB (Advanced Peripheral Bus) system, specifically targeting the ARM AMPA AP4 protocol. The verification environment includes:

  * **APB Master**
  * **APB Slave**
  * **Golden Reference Model**
  * **UVM-Based Testbench**
  * **SystemVerilog Assertions**
  * **Functional & Code Coverage Reports**

The original RTL design was developed by [Mohamed Hussein](https://github.com/MohamedHussein27/AMPA_APB4_Protocol) — full credit for the design goes to him. This repository extends that project by thoroughly verifying its behavior using modern verification methodologies.

This verification effort has achieved **100% code and functional coverage** through event-driven simulation with constrained randomization, adhering to a comprehensive verification plan.

-----

## Verification Methodology

This project follows the **UVM (Universal Verification Methodology)** and includes:

  * **Agents** for both APB Master and Slave
  * **UVM sequences** and configuration objects
  * **Scoreboard** and **coverage collectors**
  * **Golden Model** comparison for data integrity checks
  * **Assertion-Based Verification (ABV)** for protocol checks

The UVM Testbench Architecture:

<p align="center">
  <img width="565" height="644" alt="UVM Testbench Architecture" src="https://github.com/user-attachments/assets/9adec0a5-9c05-4890-8d21-821738e7a432" />
</p>

-----

## Assertions

Assertions follow a **structured and traceable format**, each designed to verify critical aspects of the APB protocol and component behavior.

Assertions cover:

  * **APB protocol compliance**
  * **FSM transitions** within master/slave logic
  * **Signal values at different states**
  * **Master and Slave behavior** during various transactions (reads, writes)

-----

## Coverage Reports

  * **Functional Coverage** is monitored through custom coverage collectors, capturing key transaction scenarios and corner cases.
  * **Code Coverage** is automatically captured by QuestaSim, providing metrics on line, toggle, FSM, and branch coverage.

Reports are automatically generated in HTML format for easy navigation and visualization. After simulation, open the `coverage_report/index.html` in your browser to view results.

-----

## Repository Structure

Overview of the file structure for design and verification components:

```
├── design/
│   ├── APB_Assertions/
│   │   └── APB_sva.sv
│   └── APB_design/
│       ├── APB_Master.v
│       ├── APB_Slave.v
│       ├── APB_Wrapper.v
│       ├── design.v
│       └── golden_model.sv
├── interface/
│   ├── APB_if.sv
│   ├── apb_defines.svh
│   └── shared_pkg.sv
├── top/
│   ├── objects/
│   │   ├── master_objects/
│   │   │   ├── APB_master_main_sequence.sv
│   │   │   ├── APB_master_reset_sequence.sv
│   │   │   ├── APB_master_seq_item.sv
│   │   │   └── APB_master_sequences.sv
│   │   ├── slave_objects/
│   │   │   ├── APB_slave_main_sequence.sv
│   │   │   ├── APB_slave_sequences.sv
│   │   │   └── APB_slave_seq_item.sv
│   │   └── APB_config.sv
│   ├── test/
│   │   ├── enviroment/
│   │   │   ├── APB_env.sv
│   │   │   ├── APB_env_pkg.sv
│   │   │   ├── coverage_collector/
│   │   │   │   └── APB_coverage_collector.sv
│   │   │   ├── master_agent/
│   │   │   │   ├── APB_master_agent.sv
│   │   │   │   ├── APB_master_pkg.sv
│   │   │   │   ├── driver/
│   │   │   │   │   └── APB_master_driver.sv
│   │   │   │   ├── monitor/
│   │   │   │   │   └── APB_master_monitor.sv
│   │   │   │   └── sequencer/
│   │   │   │       └── APB_master_sequencer.sv
│   │   │   ├── scoreboard/
│   │   │   │   └── APB_scoreboard.sv
│   │   │   └── slave_agent/
│   │   │       ├── APB_slave_agent.sv
│   │   │       ├── APB_slave_pkg.sv
│   │   │       ├── driver/
│   │   │       │   └── APB_slave_driver.sv
│   │   │       ├── monitor/
│   │   │       │   └── APB_slave_monitor.sv
│   │   │       └── sequencer/
│   │   │           └── APB_slave_sequencer.sv
│   │   └── test.sv
│   └── top.sv
```

-----

## Getting Started

### 1\. Clone the Repository

```bash
git clone https://github.com/aliadelmahdi/APB-Verification-Project.git # Placeholder URL
cd APB-Verification-Project
```

> **Note:** Ensure you also check out the original design repository:
> [https://github.com/MohamedHussein27/AMPA\_APB4\_Protocol](https://github.com/MohamedHussein27/AMPA_APB4_Protocol)

-----

### 2\. Prerequisites

You must have **QuestaSim** installed and properly configured in your environment path. This project has been tested using **QuestaSim 2021+**.

-----

## Running the Simulation

This project assumes the presence of `run.sh` (for Linux) and `run.bat` (for Windows) scripts, which would typically compile the design and run the UVM testbench.

### On **Linux**:

```bash
./run.sh
```

### On **Windows**:

```bash
run.bat
```

### To Enable GUI Mode:

Both the Linux and Windows run files execute in command-line mode by default. To enable GUI (graphical interface):

  * Edit `run.sh` or `run.bat`
  * **Remove** the `-c` option from the `vsim -do run.tcl -c` line (assuming a `run.tcl` script is used for simulation control).

```sh
# Change this:
vsim -c -do "scripts/run.tcl" # Example path for run.tcl

# To this:
vsim -do "scripts/run.tcl" # Example path for run.tcl
```

-----

## About the Author

This verification effort was developed by **Ali Adel**, who designed, built, and integrated the full testbench environment.

Key contributions include:

  * Designing the entire **UVM-based environment**
  * Creating the **assertion suite**
  * Building the **Golden Reference Model**
  * Defining and implementing **functional coverage points**
  * Generating comprehensive **coverage reports**

-----

## Contact

For questions, feedback, or collaboration:

  * Email: [aliadelmahdi77@gmail.com](mailto:aliadelmahdi77@gmail.com)
  * Linkedin: [linkedin.com/in/aliadelmahdi](https://www.linkedin.com/in/aliadelmahdi)
