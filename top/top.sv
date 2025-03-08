module tb_top;

    import uvm_pkg::*;
    import APB_env_pkg::*;
    import APB_test_pkg::*;

    bit clk;

    // Clock Generation
    initial begin
        clk = 0;
        forever #1 clk = ~ clk;
    end

    APB_env env_instance;
    APB_test test;
    // Instantiate the interface
    APB_if apb_if (clk);
    APB_Wrapper DUT (apb_if);
    // Configure the UVM database and the test
    initial begin
        uvm_config_db #(virtual APB_if)::set (null,"*","apb_if",apb_if);
        run_test("APB_test");
    end
endmodule : tb_top