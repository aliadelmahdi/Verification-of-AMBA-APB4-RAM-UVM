package APB_master_reset_sequence_pkg;

    import uvm_pkg::*,
           APB_master_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class APB_master_reset_sequence extends uvm_sequence #(APB_master_seq_item);

        `uvm_object_utils (APB_master_reset_sequence)
        APB_master_seq_item master_seq_item;

        function new (string name = "APB_master_reset_sequence");
            super.new(name);
        endfunction

        task body;
            master_seq_item = APB_master_seq_item::type_id::create("master_seq_item");

            start_item(master_seq_item);
                master_seq_item.SWRITE = 0;
                master_seq_item.SADDR = 0;
                master_seq_item.SWDATA = 0;
                master_seq_item.SSTRB = 0;
                master_seq_item.SPROT = 0;
                master_seq_item.transfer = 0;
                master_seq_item.PRESETn = 0;
            finish_item(master_seq_item);
        endtask
        
    endclass : APB_master_reset_sequence

endpackage : APB_master_reset_sequence_pkg