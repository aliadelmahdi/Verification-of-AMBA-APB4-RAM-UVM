package APB_master_sequencer_pkg;

    import uvm_pkg::*;
    import APB_master_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_master_sequencer extends uvm_sequencer #(APB_master_seq_item);

        `uvm_component_utils(APB_master_seq_item);

        function new(string name = "APB_master_sequence", uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass : APB_master_sequencer

endpackage : APB_master_sequencer_pkg