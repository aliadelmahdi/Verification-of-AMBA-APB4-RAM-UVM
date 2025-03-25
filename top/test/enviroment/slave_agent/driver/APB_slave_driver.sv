package APB_slave_driver_pkg;

    import  uvm_pkg::*,
            APB_config_pkg::*,
            APB_slave_main_sequence_pkg::*,
            APB_slave_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class APB_slave_driver extends uvm_driver #(APB_slave_seq_item);
        `uvm_component_utils(APB_slave_driver)
        virtual APB_if apb_if;
        APB_slave_seq_item stimulus_seq_item;

        function new(string name = "APB_slave_driver", uvm_component parent);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stimulus_seq_item = APB_slave_seq_item::type_id::create("slave_stimulus_seq_item");
                seq_item_port.get_next_item(stimulus_seq_item);

                apb_if.PSEL = stimulus_seq_item.PSEL;
                apb_if.PENABLE = stimulus_seq_item.PENABLE;
                apb_if.PWRITE = stimulus_seq_item.PWRITE;
                apb_if.PADDR = stimulus_seq_item.PADDR;
                apb_if.PWDATA = stimulus_seq_item.PWDATA;
                apb_if.PSTRB = stimulus_seq_item.PSTRB;
                apb_if.PPROT = stimulus_seq_item.PPROT;

                apb_if.PRDATA = stimulus_seq_item.PRDATA;
                apb_if.PREADY = stimulus_seq_item.PREADY;
                apb_if.PSLVERR = stimulus_seq_item.PSLVERR;

                apb_if.PRESETn = stimulus_seq_item.PRESETn;

                @(negedge apb_if.PCLK)
                seq_item_port.item_done();
                `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
            end
        endtask
        
    endclass : APB_slave_driver

endpackage : APB_slave_driver_pkg