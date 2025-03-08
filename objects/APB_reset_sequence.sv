package APB_reset_sequence_pkg;

    import uvm_pkg::*,
           APB_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class APB_reset_sequence extends uvm_sequence #(APB_seq_item);

        `uvm_object_utils (APB_reset_sequence)
        APB_seq_item seq_item;

        function new (string name = "APB_reset_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = APB_seq_item::type_id::create("seq_item");

            start_item(seq_item);
                // seq_item. = 0;
                // seq_item. = 0;
               
            finish_item(seq_item);
        endtask
        
    endclass : APB_reset_sequence

endpackage : APB_reset_sequence_pkg