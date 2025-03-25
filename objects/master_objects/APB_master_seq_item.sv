package APB_master_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
 
    class APB_master_seq_item extends uvm_sequence_item;
        `uvm_object_utils(APB_master_seq_item)
        //inputs
        rand bit SWRITE;
        rand bit [31:0] SADDR, SWDATA; 
        rand bit [3:0] SSTRB;
        rand bit [2:0] SPROT;
        rand bit transfer;
        rand bit PRESETn;
        logic PREADY;
        logic PSLVERR;

        //outputs
        logic PSEL, PENABLE, PWRITE;
        logic [31:0] PADDR, PWDATA;
        logic [3:0] PSTRB;
        logic [2:0] PPROT;

        function new(string name = "APB_master_seq_item");
            super.new(name);
        endfunction

		constraint SADDR_const {
            SADDR inside {'h10,'h20,'h30,'h40,'h50};
                               }
                            

        
    endclass : APB_master_seq_item

endpackage : APB_master_seq_item_pkg