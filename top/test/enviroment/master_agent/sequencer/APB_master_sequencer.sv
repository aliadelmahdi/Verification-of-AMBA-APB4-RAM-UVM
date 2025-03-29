package APB_master_sequencer_pkg;

    import uvm_pkg::*,
           APB_master_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_master_sequencer extends uvm_sequencer #(APB_master_seq_item);

        `uvm_component_utils(APB_master_sequencer);

        function new(string name = "APB_master_sequence", uvm_component parent);
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
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : APB_master_sequencer

endpackage : APB_master_sequencer_pkg