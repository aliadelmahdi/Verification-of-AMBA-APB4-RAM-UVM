package APB_slave_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "apb_defines.svh" // For macros
 
    class APB_slave_seq_item extends uvm_sequence_item;
        logic PSEL, PENABLE, PWRITE;  
        logic [`APB_ADDR_WIDTH-1:0]  PADDR;
        logic [`APB_DATA_WIDTH-1:0] PWDATA;

        logic [`APB_STRB_WIDTH-1:0] PSTRB;
        logic [`APB_PROT_WIDTH-1:0] PPROT;
        logic PRESETn;

        logic [`APB_DATA_WIDTH-1:0] PRDATA;
        logic PREADY;
        logic PSLVERR;

        // Golden Model
        logic PREADY_ref;
        logic PSLVERR_ref;
        logic [`APB_DATA_WIDTH-1:0] PRDATA_ref;

        `uvm_object_utils_begin(APB_slave_seq_item)
            `uvm_field_int(PRESETn, UVM_DEFAULT)
            `uvm_field_int(PRDATA, UVM_DEFAULT)
            `uvm_field_int(PREADY, UVM_DEFAULT)
            `uvm_field_int(PSLVERR, UVM_DEFAULT)
            `uvm_field_int(PENABLE, UVM_DEFAULT)
            // Golden Model
            `uvm_field_int(PREADY_ref, UVM_DEFAULT)
            `uvm_field_int(PSLVERR_ref, UVM_DEFAULT)
            `uvm_field_int(PRDATA_ref, UVM_DEFAULT)
        `uvm_object_utils_end
        function new(string name = "APB_slave_seq_item");
            super.new(name);
        endfunction
        
    endclass : APB_slave_seq_item

endpackage : APB_slave_seq_item_pkg