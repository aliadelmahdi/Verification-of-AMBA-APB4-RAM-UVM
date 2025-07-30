`ifndef APB_MASTER_MAIN_SEQUENCE_SV
`define APB_MASTER_MAIN_SEQUENCE_SV

    class APB_master_main_sequence extends uvm_sequence #(APB_master_seq_item);

        `uvm_object_utils (APB_master_main_sequence);
        APB_master_seq_item seq_item;

        function new(string name = "APB_master_main_sequence");
            super.new(name);            
        endfunction
        
        task body;

            repeat(`TEST_ITER_SMALL) begin
                seq_item = APB_master_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Master Randomization Failed");
                finish_item(seq_item);
            end

        endtask
        
    endclass : APB_master_main_sequence

`endif // APB_MASTER_MAIN_SEQUENCE_SV