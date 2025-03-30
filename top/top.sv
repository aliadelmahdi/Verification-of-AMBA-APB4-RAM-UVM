import uvm_pkg::*;
import APB_env_pkg::*;
import APB_test_pkg::*;
import shared_pkg::*; // For enums and parameters
`include "apb_defines.svh" // For macros
`timescale `TIME_UNIT / `TIME_PRECISION

module tb_top;
    bit clk;
    // Clock Generation
    initial begin
        clk = `LOW;
        forever #(`CLK_PERIOD/2) clk = ~ clk;
    end

    
    APB_env env_instance; // Instantiate the APB4 enviroment
    APB_test test; // Instantiate the APB4 test

    // Instantiate the interface
    APB_if apb_if (clk);
    // Instantiating the APB_Wrapper module and connecting it to the APB interface signals
    APB_Wrapper DUT (
        .PCLK(apb_if.PCLK),
        .PRESETn(apb_if.PRESETn),
        .SWRITE(apb_if.SWRITE),
        .SADDR(apb_if.SADDR),
        .SWDATA(apb_if.SWDATA),
        .SSTRB(apb_if.SSTRB),
        .SPROT(apb_if.SPROT),
        .transfer(apb_if.transfer),
        .PRDATA(apb_if.PRDATA)
        );

        // Hierarchical Referencing to access internal signals in the DUT
        assign apb_if.PREADY  = DUT.Slave.PREADY;  
        assign apb_if.PSLVERR = DUT.Slave.PSLVERR;
        assign apb_if.PENABLE = DUT.Slave.PENABLE;
        assign apb_if.PSEL = DUT.Slave.PSEL;
        assign apb_if.cs = shared_pkg::state_e'(DUT.Master.cs);

        assign apb_if.PWRITE  = DUT.PWRITE;  
        assign apb_if.PADDR = DUT.PADDR;
        assign apb_if.PWDATA = DUT.PWDATA;
        assign apb_if.PSTRB = DUT.PSTRB;
        assign apb_if.PPROT = DUT.PPROT;


    golden_model GLD (
        .PCLK(apb_if.PCLK),
        .PRESETn(apb_if.PRESETn),
        .SWRITE(apb_if.SWRITE),
        .SADDR(apb_if.SADDR),
        .SWDATA(apb_if.SWDATA),
        .SSTRB(apb_if.SSTRB),
        .SPROT(apb_if.SPROT),
        .transfer(apb_if.transfer),
        .PRDATA(apb_if.PRDATA_ref)
        );

        // Access internal signals in the golden model
        assign apb_if.PREADY_ref  = GLD.PREADY;  
        assign apb_if.PSLVERR_ref = GLD.PSLVERR;
        assign apb_if.PENABLE_ref = GLD.PENABLE;
        assign apb_if.PSEL_ref = GLD.PSEL;
        assign apb_if.PWRITE_ref  = GLD.PWRITE;  
        assign apb_if.PADDR_ref = GLD.PADDR;
        assign apb_if.PWDATA_ref = GLD.PWDATA;
        assign apb_if.PSTRB_ref = GLD.PSTRB;
        assign apb_if.PPROT_ref = GLD.PPROT;

    // Binding the APB_sva module (SystemVerilog Assertions) to the APB_Wrapper instance
    bind APB_Wrapper APB_sva APB_sva_inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .SWRITE(SWRITE),
        .SADDR(SADDR),
        .SWDATA(SWDATA),
        .SSTRB(SSTRB),
        .SPROT(SPROT),
        .transfer(transfer),
        .PRDATA(PRDATA),
        .PREADY(DUT.Slave.PREADY),
        .PSLVERR(DUT.Slave.PSLVERR),
        .PENABLE(DUT.Slave.PENABLE),
        .PSEL(DUT.Slave.PSEL),
        .PWRITE(DUT.PWRITE),
        .PADDR(DUT.PADDR),
        .PWDATA(DUT.PWDATA),
        .PSTRB(DUT.PSTRB),
        .PPROT(DUT.PPROT),
        .cs(DUT.Master.cs),
        .ns(DUT.Master.ns)
        );    

    initial begin
        uvm_top.set_report_verbosity_level(UVM_MEDIUM); // Set verbosity level
        uvm_top.finish_on_completion = `DISABLE_FINISH; // Prevent UVM from calling $finish
        uvm_config_db#(virtual APB_if)::set(null, "*", "apb_if", apb_if); // Set APB interface globally
        run_test("APB_test"); // Start the UVM test
        $stop; // Stop simulation after test execution
    end
endmodule : tb_top