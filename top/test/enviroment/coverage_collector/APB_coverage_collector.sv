package APB_coverage_pkg;
 import     uvm_pkg::*,
            APB_slave_driver_pkg::*,
            APB_master_driver_pkg::*,
            APB_scoreboard_pkg::*,
            APB_master_main_sequence_pkg::*,
            APB_slave_main_sequence_pkg::*,
            APB_master_reset_sequence_pkg::*,
            APB_master_seq_item_pkg::*,
            APB_slave_seq_item_pkg::*,
            APB_slave_sequencer_pkg::*,
            APB_master_sequencer_pkg::*,
            APB_slave_monitor_pkg::*,
            APB_master_monitor_pkg::*,
            APB_config_pkg::*,
            APB_slave_agent_pkg::*,
            APB_master_agent_pkg::*;
    `include "uvm_macros.svh"


    class APB_coverage extends uvm_component;
        `uvm_component_utils(APB_coverage)

        // Analysis Export for receiving transactions from monitors
        uvm_analysis_export #(APB_master_seq_item) master_cov_export;
        uvm_tlm_analysis_fifo #(APB_master_seq_item) master_cov_apb;
        APB_master_seq_item master_seq_item_cov;

        uvm_analysis_export #(APB_slave_seq_item) slave_cov_export;
        uvm_tlm_analysis_fifo #(APB_slave_seq_item) slave_cov_apb;
        APB_slave_seq_item slave_seq_item_cov;

        // Covergroup definitions
        covergroup apb_cov_grp;

        endgroup

        // Constructor
        function new (string name = "APB_coverage", uvm_component parent);
            super.new(name, parent);
            apb_cov_grp = new();
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            master_cov_export = new("master_cov_export", this);
            master_cov_apb = new("master_cov_apb", this);
            slave_cov_export = new("slave_cov_export", this);
            slave_cov_apb = new("slave_cov_apb", this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            master_cov_export.connect(master_cov_apb.analysis_export);
            slave_cov_export.connect(slave_cov_apb.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Get the next transaction from the analysis FIFO.
                master_cov_apb.get(master_seq_item_cov);
                slave_cov_apb.get(slave_seq_item_cov);
                apb_cov_grp.sample();
            end
        endtask

    endclass : APB_coverage

endpackage : APB_coverage_pkg