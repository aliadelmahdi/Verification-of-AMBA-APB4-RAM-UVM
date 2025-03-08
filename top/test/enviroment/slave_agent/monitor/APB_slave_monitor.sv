package APB_slave_monitor_pkg;

    import uvm_pkg::*,
           APB_slave_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class APB_slave_monitor extends uvm_monitor;

        `uvm_component_utils (APB_slave_monitor)
        virtual APB_if apb_if;
        APB_slave_seq_item slave_response_seq_item;
        uvm_analysis_port #(APB_slave_seq_item) slave_monitor_ap;

        function new(string name = "APB_slave_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            slave_monitor_ap = new ("slave_monitor_ap",this);
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                slave_response_seq_item = APB_slave_seq_item::type_id::create("slave_response_seq_item");
                @(negedge apb_if.PCLK);
                slave_response_seq_item.PSEL = apb_if.PSEL;
                slave_response_seq_item.PENABLE = apb_if.PENABLE;
                slave_response_seq_item.PWRITE = apb_if.PWRITE;
                slave_response_seq_item.PADDR = apb_if.PADDR;

                slave_response_seq_item.PWDATA = apb_if.PWDATA;
                slave_response_seq_item.PSTRB = apb_if.PSTRB;

                slave_response_seq_item.PPROT = apb_if.PPROT;
                slave_response_seq_item.PRDATA = apb_if.PRDATA;

                slave_response_seq_item.PREADY = apb_if.PREADY;
                slave_response_seq_item.PSLVERR = apb_if.PSLVERR;
                slave_response_seq_item.PRESETn = apb_if.PRESETn;

                slave_monitor_ap.write(slave_response_seq_item);
                `uvm_info("run_phase", slave_response_seq_item.sprint(), UVM_HIGH)
            end

        endtask
        
    endclass : APB_slave_monitor

endpackage : APB_slave_monitor_pkg