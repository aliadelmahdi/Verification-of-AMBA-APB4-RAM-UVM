package APB_slave_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
 
    class APB_slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(APB_slave_seq_item)
        logic PSEL, PENABLE, PWRITE;  
        logic [31:0] PADDR, PWDATA;
        logic [3:0] PSTRB;
        logic [2:0] PPROT;
        logic PCLK, PRESETn;

        logic [31:0] PRDATA;
        logic PREADY;
        logic PSLVERR;

        function new(string name = "APB_slave_seq_item");
            super.new(name);
        endfunction
        
    endclass : APB_slave_seq_item

endpackage : APB_slave_seq_item_pkg