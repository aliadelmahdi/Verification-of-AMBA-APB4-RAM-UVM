import uvm_pkg::*;
import APB_env_pkg::*;
import APB_test_pkg::*;
`define DISABLE_FINISH 0
`define ENABLE_FINISH 1
`define CLK_PERIOD 10 
`define LOW 0
module tb_top;
    bit clk;
    // Clock Generation
    initial begin
        clk = `LOW;
        forever #(`CLK_PERIOD/2) clk = ~ clk;
    end

    APB_env env_instance;
    APB_test test;

    // Instantiate the interface
    APB_if apb_if (clk);
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
    bind APB_Wrapper APB_sva APB_sva_inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .SWRITE(SWRITE),
        .SADDR(SADDR),
        .SWDATA(SWDATA),
        .SSTRB(SSTRB),
        .SPROT(SPROT),
        .transfer(transfer),
        .PRDATA(PRDATA)
        );    

    initial begin
        uvm_top.finish_on_completion = `DISABLE_FINISH; // Prevents UVM_root from calling $finish
        uvm_config_db #(virtual APB_if)::set (null,"*","apb_if",apb_if);
        run_test("APB_test");
        $stop;
    end
endmodule : tb_top