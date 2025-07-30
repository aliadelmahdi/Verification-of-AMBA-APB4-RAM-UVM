`ifndef APB_SLAVE_AGENT_SV
`define APB_SLAVE_AGENT_SV

    class APB_slave_agent extends uvm_agent;

        `uvm_component_utils(APB_slave_agent)
        APB_slave_sequencer apb_slave_seqr;
        APB_slave_driver apb_slave_drv;
        APB_slave_monitor apb_slave_mon;
        APB_config apb_slave_cnfg;
        uvm_analysis_port #(APB_slave_seq_item) apb_slave_agent_ap;
        uvm_active_passive_enum is_active;

        function new(string name = "APB_slave_agent", uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(APB_config)::get(this,"","CFG",apb_slave_cnfg)) 
                `uvm_fatal ("build_phase","Unable to get the slave configuration object from the database")
            is_active = apb_slave_cnfg.is_active;
            if(is_active==UVM_ACTIVE)begin
                apb_slave_drv = APB_slave_driver::type_id::create("apb_slave_drv",this);
                apb_slave_seqr = APB_slave_sequencer::type_id::create("apb_slave_seqr",this);
            end
            apb_slave_mon = APB_slave_monitor::type_id::create("apb_slave_mon",this);
            apb_slave_agent_ap = new("apb_slave_agent_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            if(is_active==UVM_ACTIVE)begin
              apb_slave_drv.seq_item_port.connect(apb_slave_seqr.seq_item_export);
              apb_slave_drv.apb_if = apb_slave_cnfg.apb_if;
            end
            apb_slave_mon.slave_monitor_ap.connect(apb_slave_agent_ap);
            apb_slave_mon.apb_if = apb_slave_cnfg.apb_if;
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : APB_slave_agent

`endif // APB_SLAVE_AGENT_SV