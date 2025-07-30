`ifndef APB_SLAVE_MAIN_SEQUENCE_SV
`define APB_SLAVE_MAIN_SEQUENCE_SV

    class APB_slave_main_sequence extends uvm_sequence #(APB_slave_seq_item);

        `uvm_object_utils (APB_slave_main_sequence);
        APB_slave_seq_item slave_seq_item;

        function new(string name = "APB_slave_main_sequence");
            super.new(name);            
        endfunction
        
        task body;

            repeat(`TEST_ITER_MEDIUM) begin
                slave_seq_item = APB_slave_seq_item::type_id::create("slave_seq_item");
                start_item(slave_seq_item);
                assert(slave_seq_item.randomize()) else $error("Randomization Failed");
                finish_item(slave_seq_item);
            end

        endtask
        
    endclass : APB_slave_main_sequence

`endif // APB_SLAVE_MAIN_SEQUENCE_SV