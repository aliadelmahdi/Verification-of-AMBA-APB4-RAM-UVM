package APB_slave_sequencer_pkg;

    import uvm_pkg::*;
    import APB_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_slave_sequencer extends uvm_sequencer #(apb_slave_seq_item);

        `uvm_component_utils(apb_slave_sequencer);

        function new(string name = "APB_slave_sequence", uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass : APB_slave_sequencer

endpackage : APB_slave_sequencer_pkg