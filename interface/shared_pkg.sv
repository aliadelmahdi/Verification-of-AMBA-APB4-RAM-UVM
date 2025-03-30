package shared_pkg;

    // Include macros inside the package
    `include "apb_defines.svh"
    
    // FSM ARM AMPA APB4 States
    typedef enum {IDLE, SETUP, ACCESS} state_e;
    
    // Privilieged bit indicator
    typedef enum bit {
        NORMAL_ACCESS   = `LOW,
        PRIVILEGED_ACCESS = `HIGH
    } pprot_privilege_t;

    // Security bit indicator
    typedef enum bit {
        SECURE_ACCESS   = `LOW,
        NONSECURE_ACCESS = `HIGH
    } pprot_security_t;

    // Instruction bit indicator
    typedef enum bit {
        DATA_ACCESS      = `LOW,
        INSTRUCTION_ACCESS = `HIGH
    } pprot_access_type_t;

    // Peripheral protection struct
    typedef struct packed {
        pprot_access_type_t access;
        pprot_security_t security;
        pprot_privilege_t privilege;
    } pprot_t;
    
    // Define different strobe PSTRB conditions for write operations
    typedef enum logic [3:0] {
        PSTRB_SB_LSB      = 4'b0001,
        PSTRB_SB_2ND      = 4'b0010,
        PSTRB_SH_LSB      = 4'b0011,
        PSTRB_SB_3RD      = 4'b0100,
        PSTRB_SB_3RD_LSB  = 4'b0101,
        PSTRB_SB_2ND_3RD  = 4'b0110,
        PSTRB_SH_LSB_3B   = 4'b0111,
        PSTRB_SB_MSB      = 4'b1000,
        PSTRB_SB_MSB_LSB  = 4'b1001,
        PSTRB_SH_MSB      = 4'b1010,
        PSTRB_SH_MSB_LSB  = 4'b1011,
        PSTRB_SB_MSB_2ND  = 4'b1100,
        PSTRB_SB_MSB_3B   = 4'b1101,
        PSTRB_SH_MSB_3B   = 4'b1110,
        PSTRB_FULL_WORD   = 4'b1111
    } pstrb_t;
    
endpackage
    