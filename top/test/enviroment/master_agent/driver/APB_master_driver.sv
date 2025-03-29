package APB_master_driver_pkg;

    import  uvm_pkg::*,
            APB_config_pkg::*,
            APB_master_main_sequence_pkg::*,
            APB_master_reset_sequence_pkg::*,
            APB_master_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_master_driver extends uvm_driver #(APB_master_seq_item);
        `uvm_component_utils(APB_master_driver)
        virtual APB_if apb_if;
        APB_master_seq_item stimulus_seq_item;

        function new(string name = "APB_master_driver", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction
        
        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stimulus_seq_item = APB_master_seq_item::type_id::create("master_stimulus_seq_item");
                seq_item_port.get_next_item(stimulus_seq_item);
                apb_if.SWRITE = stimulus_seq_item.SWRITE;
                apb_if.SADDR = stimulus_seq_item.SADDR;
                apb_if.SWDATA = stimulus_seq_item.SWDATA;
                apb_if.SSTRB = stimulus_seq_item.SSTRB;
                apb_if.SPROT = stimulus_seq_item.SPROT;
                apb_if.transfer = stimulus_seq_item.transfer;
                apb_if.PRESETn = stimulus_seq_item.PRESETn;
                @(negedge apb_if.PCLK)
                seq_item_port.item_done();
                `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
            end
        endtask
        
    endclass : APB_master_driver

endpackage : APB_master_driver_pkg