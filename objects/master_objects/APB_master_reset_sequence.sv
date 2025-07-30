`ifndef APB_MASTER_RESET_SEQUENCE_SV
`define APB_MASTER_RESET_SEQUENCE_SV

    class APB_master_reset_sequence extends uvm_sequence #(APB_master_seq_item);

        `uvm_object_utils (APB_master_reset_sequence)
        APB_master_seq_item master_seq_item;

        function new (string name = "APB_master_reset_sequence");
            super.new(name);
        endfunction

        task body;
            master_seq_item = APB_master_seq_item::type_id::create("master_seq_item");
            start_item(master_seq_item);
                master_seq_item.SWRITE = `LOW;
                master_seq_item.SADDR = `LOW;
                master_seq_item.SWDATA = `LOW;
                master_seq_item.SSTRB = `LOW;
                master_seq_item.SPROT = `LOW;
                master_seq_item.transfer = `LOW;
                master_seq_item.PRESETn = `LOW;
                master_seq_item.cs = IDLE;
            finish_item(master_seq_item);
        endtask
        
    endclass : APB_master_reset_sequence

`endif // APB_MASTER_RESET_SEQUENCE_SV