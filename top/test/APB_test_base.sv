`ifndef APB_TEST_BASE_SV
`define APB_TEST_BASE_SV

class APB_test_base extends uvm_test;
        `uvm_component_utils(APB_test_base)
        APB_env apb_env; // Enviroment handle to the APB4
        // Configuration objects for master and slave configurations
        APB_config apb_master_cnfg; // Master configuration
        APB_config apb_slave_cnfg; // Slave configuration
        virtual APB_if apb_if; // Virtual interface handle
        APB_master_main_sequence apb_master_main_seq; // Master main test sequence
        APB_slave_main_sequence apb_slave_main_seq; // Slave main test sequence
        APB_master_reset_sequence apb_master_reset_seq; // Master reset test sequence

        // Default constructor
        function new(string name = "APB_test_base", uvm_component parent);
            super.new(name,parent);
        endfunction : new

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase); // Call parent class's build_phase
            // Create instances from the UVM factory
            apb_env = APB_env::type_id::create("env",this);
            apb_master_cnfg = APB_config::type_id::create("APB_master_config",this);
            apb_slave_cnfg = APB_config::type_id::create("APB_slave_config",this);
            apb_master_main_seq = APB_master_main_sequence::type_id::create("master_main_seq",this);
            apb_slave_main_seq = APB_slave_main_sequence::type_id::create("slave_main_seq",this);
            apb_master_reset_seq = APB_master_reset_sequence::type_id::create("reset_seq",this);

            // Retrieve the virtual interface for APB master from the UVM configuration database
            if(!uvm_config_db #(virtual APB_if)::get(this,"","apb_if",apb_master_cnfg.apb_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the master virtual interface of the APB form the configuration database");
            // Retrieve the virtual interface for APB slave from the UVM configuration database
            if(!uvm_config_db #(virtual APB_if)::get(this,"","apb_if",apb_slave_cnfg.apb_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the slave virtual interface of the APB form the configuration database");
        
            // Set the master as an active agent (drives transactions)
            apb_master_cnfg.is_active =UVM_ACTIVE;
            // Set the slave as a passive agent (only monitors transactions)
            apb_slave_cnfg.is_active =UVM_PASSIVE;

            // Store the APB master and slave configuration objects in the UVM configuration database
            uvm_config_db # (APB_config)::set(this , "*" , "CFG",apb_master_cnfg);
            uvm_config_db # (APB_config)::set(this , "*" , "CFG",apb_slave_cnfg);
        endfunction : build_phase

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase); // Call parent class's run phase
            phase.raise_objection(this); // Raise an objection to prevent the test from ending
            // Reset sequence
            `uvm_info("run_phase","stimulus Generation started",UVM_LOW)
            apb_master_reset_seq.start(apb_env.apb_master_agent.apb_master_seqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
            // Main Sequence
            `uvm_info("run_phase", "Stimulus Generation Started",UVM_LOW)
            // apb_slave_main_seq.start(apb_env.apb_slave_agent.apb_slave_seqr);
            apb_master_main_seq.start(apb_env.apb_master_agent.apb_master_seqr);
            `uvm_info("run_phase", "Stimulus Generation Ended",UVM_LOW) 

            phase.drop_objection(this); // Drop the objection to allow the test to complete
        endtask : run_phase

endclass : APB_test_base

`endif // APB_TEST_BASE_SV