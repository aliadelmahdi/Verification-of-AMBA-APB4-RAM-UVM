package APB_master_monitor_pkg;

    import uvm_pkg::*,
           APB_master_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_master_monitor extends uvm_monitor;
        `uvm_component_utils (APB_master_monitor)
        virtual APB_if apb_if;
        APB_master_seq_item master_response_seq_item;
        uvm_analysis_port #(APB_master_seq_item) master_monitor_ap;

        function new(string name = "APB_master_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            master_monitor_ap = new ("master_monitor_ap",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                master_response_seq_item = APB_master_seq_item::type_id::create("master_response_seq_item");
                @(negedge apb_if.PCLK);
                master_response_seq_item.SWRITE = apb_if.SWRITE;
                master_response_seq_item.SADDR = apb_if.SADDR;
                master_response_seq_item.SWDATA = apb_if.SWDATA;
                master_response_seq_item.SSTRB = apb_if.SSTRB;
                master_response_seq_item.SPROT = apb_if.SPROT;
                master_response_seq_item.transfer = apb_if.transfer;
                master_response_seq_item.PENABLE = apb_if.PENABLE;
                master_response_seq_item.PSEL = apb_if.PSEL;
                master_response_seq_item.PWRITE = apb_if.PWRITE;
                master_response_seq_item.PADDR = apb_if.PADDR;
                master_response_seq_item.PWDATA = apb_if.PWDATA;
                master_response_seq_item.PSTRB = apb_if.PSTRB;
                master_response_seq_item.PPROT = apb_if.PPROT;
                master_response_seq_item.PRESETn = apb_if.PRESETn;
                master_response_seq_item.PREADY = apb_if.PREADY;
                master_response_seq_item.PSLVERR = apb_if.PSLVERR;
                master_response_seq_item.cs = apb_if.cs;
                //Golden model
                master_response_seq_item.PENABLE_ref = apb_if.PENABLE_ref;
                master_response_seq_item.PSEL_ref = apb_if.PSEL_ref;
                master_response_seq_item.PWRITE_ref = apb_if.PWRITE_ref;
                master_response_seq_item.PADDR_ref = apb_if.PADDR_ref;
                master_response_seq_item.PWDATA_ref = apb_if.PWDATA_ref;
                master_response_seq_item.PSTRB_ref = apb_if.PSTRB_ref;
                master_response_seq_item.PPROT_ref = apb_if.PPROT_ref;
                master_response_seq_item.PREADY_ref = apb_if.PREADY_ref;
                master_response_seq_item.PSLVERR_ref = apb_if.PSLVERR_ref;
                master_monitor_ap.write(master_response_seq_item);
                `uvm_info("run_phase", master_response_seq_item.sprint(), UVM_HIGH)
            end

        endtask
        
    endclass : APB_master_monitor

endpackage : APB_master_monitor_pkg