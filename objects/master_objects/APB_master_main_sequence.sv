package APB_master_main_sequence_pkg;

    import uvm_pkg::*;
    import APB_master_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_master_main_sequence extends uvm_sequence #(APB_master_seq_item);

        `uvm_object_utils (APB_master_main_sequence);
        APB_master_seq_item seq_item;

        function new(string name = "APB_master_main_sequence");
            super.new(name);            
        endfunction
        
        task body;

            repeat(1000) begin
                seq_item = APB_master_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Randomization Failed");
                finish_item(seq_item);
            end

        endtask
        
    endclass : APB_master_main_sequence

endpackage : APB_master_main_sequence_pkg