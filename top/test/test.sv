
package APB_test_pkg;
    import  uvm_pkg::*,
            APB_env_pkg::*,
            APB_config_pkg::*,
            APB_slave_driver_pkg::*,
            APB_master_driver_pkg::*,
            APB_master_main_sequence_pkg::*,
            APB_slave_main_sequence_pkg::*,
            APB_master_reset_sequence_pkg::*,
            APB_master_seq_item_pkg::*,
            APB_slave_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class APB_test extends uvm_test;
        `uvm_component_utils(APB_test)
        APB_env apb_env;
        APB_config apb_master_cnfg;
        APB_config apb_slave_cnfg;
        virtual APB_if apb_if;
        APB_master_main_sequence apb_master_main_seq;
        APB_slave_main_sequence apb_slave_main_seq;
        APB_master_reset_sequence apb_master_reset_seq;

        function new(string name = "APB_test", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            apb_env = APB_env::type_id::create("env",this);
            apb_master_cnfg = APB_config::type_id::create("APB_master_config",this);
            apb_slave_cnfg = APB_config::type_id::create("APB_slave_config",this);
            apb_master_main_seq = APB_master_main_sequence::type_id::create("master_main_seq",this);
            apb_slave_main_seq = APB_slave_main_sequence::type_id::create("slave_main_seq",this);
            apb_master_reset_seq = APB_master_reset_sequence::type_id::create("reset_seq",this);

            if(!uvm_config_db #(virtual APB_if)::get(this,"","apb_if",apb_master_cnfg.apb_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the virtual interface of the APB form the configuration database");
            
            if(!uvm_config_db #(virtual APB_if)::get(this,"","apb_if",apb_slave_cnfg.apb_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the virtual interface of the APB form the configuration database");
        
            apb_master_cnfg.is_active =UVM_ACTIVE;
            apb_slave_cnfg.is_active =UVM_PASSIVE;

            uvm_config_db # (APB_config)::set(this , "*" , "CFG",apb_master_cnfg);
            uvm_config_db # (APB_config)::set(this , "*" , "CFG",apb_slave_cnfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            // Reset sequence
            `uvm_info("run_phase","stimulus Generation started",UVM_LOW)
            apb_master_reset_seq.start(apb_env.apb_master_agent.apb_master_seqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
            // Main Sequence
            `uvm_info("run_phase", "Stimulus Generation Started",UVM_LOW)
            // apb_slave_main_seq.start(apb_env.apb_slave_agent.apb_slave_seqr);
            apb_master_main_seq.start(apb_env.apb_master_agent.apb_master_seqr);
            `uvm_info("run_phase", "Stimulus Generation Ended",UVM_LOW) 

            phase.drop_objection(this);
        endtask

    endclass : APB_test
    
endpackage : APB_test_pkg