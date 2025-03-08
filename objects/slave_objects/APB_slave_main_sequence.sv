package APB_slave_main_sequence_pkg;

    import uvm_pkg::*;
    import APB_slave_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class APB_slave_main_sequence extends uvm_sequence #(APB_slave_seq_item);

        `uvm_object_utils (APB_slave_main_sequence);
        APB_slave_seq_item slave_seq_item;

        function new(string name = "APB_slave_main_sequence");
            super.new(name);            
        endfunction
        
        task body;

            repeat(2) begin
                slave_seq_item = APB_slave_seq_item::type_id::create("slave_seq_item");
                start_item(slave_seq_item);
                assert(slave_seq_item.randomize()) else $error("Randomization Failed");
                finish_item(slave_seq_item);
            end

        endtask
        
    endclass : APB_slave_main_sequence

endpackage : APB_slave_main_sequence_pkg