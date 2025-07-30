`ifndef APB_SLAVE_DRIVER_SV
`define APB_SLAVE_DRIVER_SV

    class APB_slave_driver extends uvm_driver #(APB_slave_seq_item);
        `uvm_component_utils(APB_slave_driver)
        virtual APB_if.slave_driver apb_if;
        APB_slave_seq_item stimulus_seq_item;

        // Default Constructor
        function new(string name = "APB_slave_driver", uvm_component parent);
            super.new(name,parent);
        endfunction : new

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction : build_phase

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction : connect_phase

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stimulus_seq_item = APB_slave_seq_item::type_id::create("slave_stimulus_seq_item");
                seq_item_port.get_next_item(stimulus_seq_item);
                apb_if.PWRITE = stimulus_seq_item.PWRITE;
                apb_if.PADDR = stimulus_seq_item.PADDR;
                apb_if.PWDATA = stimulus_seq_item.PWDATA;
                apb_if.PSTRB = stimulus_seq_item.PSTRB;
                apb_if.PPROT = stimulus_seq_item.PPROT;
                apb_if.PSEL = stimulus_seq_item.PSEL;
                apb_if.PENABLE = stimulus_seq_item.PENABLE;
                apb_if.PRESETn = stimulus_seq_item.PRESETn;
                @(negedge apb_if.PCLK)
                seq_item_port.item_done();
                `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
            end
        endtask : run_phase
        
    endclass : APB_slave_driver

`endif // APB_SLAVE_DRIVER_SV