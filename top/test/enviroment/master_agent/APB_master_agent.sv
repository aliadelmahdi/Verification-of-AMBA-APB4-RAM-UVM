package APB_master_agent_pkg;
    import uvm_pkg::*,
        APB_seq_item_pkg::*,
        APB_master_driver_pkg::*,
        APB_main_sequence_pkg::*,
        APB_reset_sequence_pkg::*,
        APB_master_sequencer_pkg::*,
        APB_master_monitor_pkg::*,
        APB_config_pkg::*;
    `include "uvm_macros.svh"
 
    class APB_master_agent extends uvm_agent;

        `uvm_component_utils(apb_master_agent)
        APB_master_sequencer apb_master_seqr;
        APB_master_driver apb_master_drv;
        APB_master_monitor apb_master_mon;
        APB_config apb_master_cnfg;
        uvm_analysis_port #(APB_seq_item) apb_master_agent_ap;

        function new(string name = "APB_master_agent", uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(APB_config)::get(this,"","CFG",apb_master_cnfg)) 
                `uvm_fatal ("build_phase","Unable to get the master configuration object from the database")
            
            apb_master_drv = APB_master_driver::type_id::create("apb_master_drv",this);
            apb_master_seqr = APB_master_sequencer::type_id::create("apb_master_seqr",this);
            apb_master_mon = APB_master_monitor::type_id::create("apb_master_mon",this);
            apb_master_agent_ap = new("apb_master_agent_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);

            apb_master_drv.apb_if = apb_master_cnfg.apb_if;
            apb_master_mon.apb_if = apb_master_cnfg.apb_if;

            apb_master_drv.seq_item_port.connect(apb_master_seqr.seq_item_export);
            apb_master_mon.master_monitor_ap.connect(apb_master_agent_ap);
        endfunction

    endclass : APB_master_agent

endpackage : APB_master_agent_pkg