`ifndef APB_MASTER_SEQ_ITEM_SV
`define APB_MASTER_SEQ_ITEM_SV

    class APB_master_seq_item extends uvm_sequence_item;
        // RTL Design Signals
        //inputs
        rand bit SWRITE;
        rand bit [`APB_ADDR_WIDTH-1:0] SADDR; 
        rand bit [`APB_DATA_WIDTH-1:0] SWDATA; 
        rand bit [`APB_STRB_WIDTH-1:0] SSTRB;
        rand bit [`APB_PROT_WIDTH-1:0] SPROT;
        rand bit transfer;
        rand bit PRESETn;
        logic PREADY;
        logic PSLVERR;
        
        //outputs
        logic PSEL, PENABLE, PWRITE;
        logic [`APB_ADDR_WIDTH-1:0] PADDR;
        logic [`APB_DATA_WIDTH-1:0] PWDATA;
        logic [`APB_STRB_WIDTH-1:0] PSTRB;
        logic [`APB_PROT_WIDTH-1:0] PPROT;

        // For debugging 
        state_e cs;
        // Golden Model Signals
        logic PREADY_ref;
        logic PSLVERR_ref;
        logic PSEL_ref, PENABLE_ref, PWRITE_ref;
        logic [`APB_ADDR_WIDTH-1:0] PADDR_ref;
        logic [`APB_DATA_WIDTH-1:0] PWDATA_ref;
        logic [`APB_STRB_WIDTH-1:0] PSTRB_ref;
        logic [`APB_PROT_WIDTH-1:0] PPROT_ref;


        // Protection field variable using enums (randomized distribution)
        rand pprot_t pprot_field;

        // Default Constructor
        function new(string name = "APB_master_seq_item");
            super.new(name);
        endfunction : new

        `uvm_object_utils_begin(APB_master_seq_item)
            `uvm_field_int(SWRITE, UVM_DEFAULT)
            `uvm_field_int(SADDR, UVM_DEFAULT)
            `uvm_field_int(SWDATA, UVM_DEFAULT)
            `uvm_field_int(SSTRB, UVM_DEFAULT)
            `uvm_field_int(SPROT, UVM_DEFAULT)
            `uvm_field_int(transfer, UVM_DEFAULT)
            `uvm_field_int(PENABLE, UVM_DEFAULT)
            `uvm_field_int(PRESETn, UVM_DEFAULT)
            // Golden Model
            `uvm_field_int(PREADY_ref, UVM_DEFAULT)
            `uvm_field_int(PSLVERR_ref, UVM_DEFAULT)
            `uvm_field_int(PSEL_ref, UVM_DEFAULT)
            `uvm_field_int(PENABLE_ref, UVM_DEFAULT)
            `uvm_field_int(PWRITE_ref, UVM_DEFAULT)
            `uvm_field_int(PADDR_ref, UVM_DEFAULT)
            `uvm_field_int(PWDATA_ref, UVM_DEFAULT)
            `uvm_field_int(PSTRB_ref, UVM_DEFAULT)
            `uvm_field_int(PPROT_ref, UVM_DEFAULT)
        `uvm_object_utils_end

        constraint c_preset_distribution {
            PRESETn dist { `HIGH := 97, `LOW := 3 };
        }
        
        constraint c_transfer_active {
            transfer dist { `HIGH := 60,`LOW := 40 };
        }

        constraint sstrb_c {
            if (!SWRITE) {
                SSTRB dist {
                    `LOW             := 80,
                    PSTRB_FULL_WORD  :/ 20,  
                    PSTRB_SH_MSB_3B  :/ 20,  
                    PSTRB_SB_MSB_3B  :/ 20,  
                    PSTRB_SB_LSB     :/ 20,
                    PSTRB_SB_2ND     :/ 20,
                    PSTRB_SB_3RD     :/ 20,
                    PSTRB_SB_3RD_LSB :/ 20,
                    PSTRB_SB_2ND_3RD :/ 20,
                    PSTRB_SH_LSB_3B  :/ 20,
                    PSTRB_SB_MSB     :/ 20,
                    PSTRB_SB_MSB_LSB :/ 20,
                    PSTRB_SH_MSB_LSB :/ 20,
                    PSTRB_SB_MSB_2ND :/ 20,
                    PSTRB_SH_MSB     :/ 20,
                    PSTRB_SH_LSB     :/ 20
                };
            } else {
                SSTRB dist {
                    PSTRB_FULL_WORD  := 50,  
                    PSTRB_SH_MSB_3B  := 25,  
                    PSTRB_SB_MSB_3B  := 25,  
                    PSTRB_SB_LSB     :/ 5,
                    PSTRB_SB_2ND     :/ 5,
                    PSTRB_SB_3RD     :/ 5,
                    PSTRB_SB_3RD_LSB :/ 5,
                    PSTRB_SB_2ND_3RD :/ 5,
                    PSTRB_SH_LSB_3B  :/ 5,
                    PSTRB_SB_MSB     :/ 5,
                    PSTRB_SB_MSB_LSB :/ 5,
                    PSTRB_SH_MSB_LSB :/ 5,
                    PSTRB_SB_MSB_2ND :/ 5,
                    PSTRB_SH_MSB     :/ 5,
                    PSTRB_SH_LSB     :/ 5,
                    `LOW             :/ 5
                };
            }
        }
        
        constraint c_protection {
            // Privilege: 70% normal, 30% privileged
            pprot_field.privilege dist { NORMAL_ACCESS := 70, PRIVILEGED_ACCESS := 30 };
        
            // Access type: 75% data access, 25% instruction access
            pprot_field.access dist { DATA_ACCESS := 75, INSTRUCTION_ACCESS := 25 };
        
            // Correlate privilege and security levels
            if (pprot_field.privilege == PRIVILEGED_ACCESS) 
                pprot_field.security dist { SECURE_ACCESS := 80, NONSECURE_ACCESS := 20 };
            else 
                pprot_field.security dist { SECURE_ACCESS := 40, NONSECURE_ACCESS := 60 };
        
            // Tie the protection field to the SPROT signal
            // The bit ordering in pprot_t is {access, security, privilege}
            SPROT == {pprot_field.access, pprot_field.security, pprot_field.privilege};
        }
        
        
        constraint c_wdata_biased {
            SWDATA dist {
                `WDATA_ALL_ZERO := 5,   
                `WDATA_ALL_ONE  := 20,   
                `WDATA_ALT_1010 := 20,    
                `WDATA_ALT_0101 := 20,    
                [32'h0000_0001 : 32'h7FFF_FFFF] :/ 35, 
                [32'h8000_0000 : 32'hFFFF_FFFE] :/ 35  
            };
        }
    
        constraint c_swrite_biased {
            SWRITE dist {
                `WRITE := `WRITE_PROB,  
                `READ  := `READ_PROB   
            };
        }
        
        constraint c_address_biased {
            SADDR dist { [`MEM_DEPTH/2 : `MEM_DEPTH-1] := 50, [0 : `MEM_DEPTH/2-1] := 50 };
        }
    endclass : APB_master_seq_item

`endif // APB_MASTER_SEQ_ITEM_SV