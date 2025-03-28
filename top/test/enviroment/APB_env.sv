package APB_env_pkg; 
    import  uvm_pkg::*,
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
            APB_master_agent_pkg::*,
            APB_coverage_pkg::*;
    `include "uvm_macros.svh"
    // For single scoreboard uncomment
    class APB_env extends uvm_env;
        `uvm_component_utils(APB_env)

        APB_slave_agent apb_slave_agent;
        APB_master_agent apb_master_agent;

        APB_scoreboard apb_master_sb;
        APB_coverage apb_master_cov;

        APB_scoreboard apb_slave_sb;
        APB_coverage apb_slave_cov;

        function new (string name = "APB_env", uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase );
        super.build_phase (phase);
            apb_slave_agent = APB_slave_agent::type_id::create("apb_slave_agent",this);
            apb_master_agent = APB_master_agent::type_id::create("apb_master_agent",this);

            apb_master_sb= APB_scoreboard::type_id::create("apb_master_sb",this);
            apb_master_cov= APB_coverage::type_id::create("apb_master_cov",this);

            apb_slave_sb= APB_scoreboard::type_id::create("apb_slave_sb",this);
            apb_slave_cov= APB_coverage::type_id::create("apb_slave_cov",this);
        endfunction

        function void connect_phase (uvm_phase phase );
            apb_slave_agent.apb_slave_agent_ap.connect(apb_slave_sb.slave_sb_export);
            apb_slave_agent.apb_slave_agent_ap.connect(apb_slave_cov.slave_cov_export);
            apb_master_agent.apb_master_agent_ap.connect(apb_master_sb.master_sb_export);
            apb_master_agent.apb_master_agent_ap.connect(apb_master_cov.master_cov_export);
          endfunction
    endclass : APB_env
endpackage : APB_env_pkg