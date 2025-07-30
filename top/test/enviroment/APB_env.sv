`ifndef APB_ENV_SV
`define APB_ENV_SV

    class APB_env extends uvm_env;
        `uvm_component_utils(APB_env)

        APB_slave_agent apb_slave_agent;
        APB_master_agent apb_master_agent;

        APB_scoreboard apb_sb;
        APB_coverage apb_cov;
        
        // Default Constructor
        function new (string name = "APB_env", uvm_component parent);
            super.new(name,parent);
        endfunction : new

        // Build Phase
        function void build_phase(uvm_phase phase );
        super.build_phase (phase);
            apb_slave_agent = APB_slave_agent::type_id::create("apb_slave_agent",this);
            apb_master_agent = APB_master_agent::type_id::create("apb_master_agent",this);
            apb_sb= APB_scoreboard::type_id::create("apb_sb",this);
            apb_cov= APB_coverage::type_id::create("apb_cov",this);
        endfunction : build_phase

        // Connect Phase
        function void connect_phase (uvm_phase phase );
            apb_slave_agent.apb_slave_agent_ap.connect(apb_sb.slave_sb_export);
            apb_slave_agent.apb_slave_agent_ap.connect(apb_cov.slave_cov_export);
            apb_master_agent.apb_master_agent_ap.connect(apb_sb.master_sb_export);
            apb_master_agent.apb_master_agent_ap.connect(apb_cov.master_cov_export);
        endfunction : connect_phase

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask : run_phase
        
    endclass : APB_env
    
`endif // APB_ENV_SV