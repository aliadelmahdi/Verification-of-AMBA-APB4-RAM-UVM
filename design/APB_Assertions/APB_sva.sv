/*  
    This assertion file follows the **Verification Plan** numbering  
    Each section corresponds to a specific verification requirement:  

    Example:
    1- Reset Behavior Verification  
       - Ensures correct reset values for master and slave. 

    2- FSM design vs ARM AMBA APB4 FSM  
       - 2.2: Transition from IDLE to SETUP  
         (Ensures proper state transition behavior)  

    The numbers (e.g., 1, 2.2) match the corresponding test items  
    from the **Verification Plan** for traceability and clarity
*/
`include "apb_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters
`timescale `TIME_UNIT / `TIME_PRECISION

module APB_sva(
    input PCLK, PRESETn,
    input SWRITE,
    input [`APB_DATA_WIDTH-1:0] SWDATA, [`APB_DATA_WIDTH-1:0] PWDATA,
    input [`APB_ADDR_WIDTH-1:0] SADDR,  [`APB_ADDR_WIDTH-1:0] PADDR,
    input [`APB_STRB_WIDTH-1:0] SSTRB,  [`APB_STRB_WIDTH-1:0] PSTRB,
    input [`APB_PROT_WIDTH-1:0] SPROT,  [`APB_PROT_WIDTH-1:0] PPROT,
    input [`APB_DATA_WIDTH-1:0] PRDATA,
    input PREADY,PSLVERR, PENABLE, PSEL, PWRITE, transfer,
    input [1:0] cs,ns
    );
    
    //** 1: Reset Behavior Verification **\\
    property reset_master_check;
        (!PRESETn) |=> 
                (!PSEL
                && !PENABLE
                && !PWRITE
                && !PADDR
                && !PWDATA
                && !PSTRB 
                && !PPROT);
    endproperty
    
    property reset_slave_check;
        (!PRESETn) |=> (!PSLVERR && !PRDATA);
    endproperty

    property reset_fsm_check;
        (!PRESETn) |=> (cs == IDLE);
    endproperty

    reset_master_assert: assert property (@(posedge PCLK , negedge PRESETn) reset_master_check) 
        else $fatel("Reset values for master did not match expected LOW");
    
    reset_slave_assert: assert property (@(posedge PCLK) reset_slave_check) 
        else $fatel("Reset values for slave did not match expected LOW");

    reset_fsm_assert: assert property (@(posedge PCLK , negedge PRESETn) reset_fsm_check) 
        else $fatel("Reset value for FSM design did not match expected value IDLE");
    
    //** 2: FSM design vs ARM AMPBA APB4 FSM **\\
    
    // 2.2: Transition from IDLE to SETUP
    property idle_to_setup_check;
        @(posedge PCLK) disable iff (!PRESETn)
            (cs == IDLE && transfer) |=> (cs == SETUP);
    endproperty
    
    property idle_hold_check;
        @(posedge PCLK) disable iff (!PRESETn)
            (cs == IDLE && !transfer) |=> (cs == IDLE);
    endproperty
    
    idle_to_setup_assert: assert property (idle_to_setup_check) 
        else $fatal("FSM did not transition from IDLE to SETUP correctly when transfer was asserted");
    
    idle_hold_assert: assert property (idle_hold_check) 
        else $fatal("FSM incorrectly left IDLE when transfer was not asserted");
    
    // 2.3: Transition from SETUP to ACCESS
    property setup_to_access_check;
        @(posedge PCLK) disable iff (!PRESETn)
            (cs == SETUP) |=> (cs == ACCESS);
    endproperty

    setup_to_access_assert: assert property (setup_to_access_check)
        else $fatal("FSM did not transition from SETUP to ACCESS correctly after one clock cycle");

    // 2.4: Transition from ACESS to SETUP
    property access_to_setup_check;
        @(posedge PCLK) disable iff (!PRESETn)
            (cs == ACCESS && PREADY && transfer) |=> (cs == SETUP);
    endproperty

    property illegal_access_to_setup_check;
        @(posedge PCLK) disable iff (!PRESETn)
            ((cs == ACCESS) && !(PREADY && transfer))|=> (cs != SETUP);
    endproperty

    access_to_setup_assert: assert property (access_to_setup_check)
        else $fatal("FSM did not correctly transition from ACCESS to SETUP when PREADY and transfer were asserted");

    illegal_access_to_setup_assert: assert property (illegal_access_to_setup_check)
        else $fatal("FSM incorrectly left ACCESS when either PREADY or transfer was deasserted");

    // 2.5: Transition from ACCESS to IDLE
    property access_to_idle_check;
        @(posedge PCLK) disable iff (!PRESETn)
            (cs == ACCESS && PREADY && !transfer) |=> (cs == IDLE);
    endproperty

    property illegal_access_to_idle_check;
        @(posedge PCLK) disable iff (!PRESETn)
            ((cs == ACCESS) && !(PREADY && !transfer))|=> (cs != IDLE);
    endproperty

    access_to_idle_assert: assert property (access_to_idle_check)
        else $fatal("FSM did not correctly transition from ACCESS to IDLE when PREADY and transfer were asserted");

    illegal_access_to_idle_assert: assert property (illegal_access_to_idle_check)
        else $fatal("FSM incorrectly left ACCESS and went to IDLE when the condition PREADY && !transfer was not HIGH");
    
    // 2.6: Peripheral signals at IDLE state
    property peripheral_signals_idle_check;
        @(posedge PCLK) disable iff (!PRESETn)
         (cs == IDLE) |-> (!PSEL && !PENABLE);
    endproperty

    peripheral_signals_idle_assert: assert property (peripheral_signals_idle_check)
        else $error("Failed to deassert PSEL & PENABLE");
    
    // 2.7: Peripheral signals at SETUP state
    property peripheral_signals_setup_check;
        @(posedge PCLK) disable iff (!PRESETn)
         (cs == SETUP) |-> (PSEL
                            && !PENABLE
                            && PWRITE == SWRITE
                            && PADDR  == SADDR
                            && PWDATA == SWDATA
                            && PSTRB  == SSTRB
                            && PPROT  == SPROT);
    endproperty

    peripheral_signals_setup_assert: assert property (peripheral_signals_setup_check)
        else $error("Failed to verify peripheral signals at SETUP state");
    
    // 2.8: Peripheral signals at ACCESS state
    property peripheral_signals_access_check;
        @(posedge PCLK) disable iff (!PRESETn)
            (cs == ACCESS) |-> (PSEL && PENABLE);
    endproperty

    peripheral_signals_access_assert: assert property (peripheral_signals_access_check)
        else $error("Failed to assert PSEL & PENABLE");
        
endmodule
