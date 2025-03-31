package APB_coverage_pkg;
    import  uvm_pkg::*,
            APB_slave_driver_pkg::*,
            APB_master_driver_pkg::*,
            APB_scoreboard_pkg::*,
            APB_master_main_sequence_pkg::*,
            APB_slave_main_sequence_pkg::*,
            APB_master_reset_sequence_pkg::*,
            APB_master_seq_item_pkg::*,
            APB_slave_seq_item_pkg::*,
            APB_slave_sequencer_pkg::*,
            APB_master_sequencer_pkg::*,
            APB_slave_monitor_pkg::*,
            APB_master_monitor_pkg::*,
            APB_config_pkg::*,
            APB_slave_agent_pkg::*,
            APB_master_agent_pkg::*,
            shared_pkg::*;
    `include "uvm_macros.svh"


    class APB_coverage extends uvm_component;
        `uvm_component_utils(APB_coverage)

        // Analysis Export for receiving transactions from monitors
        uvm_analysis_export #(APB_master_seq_item) master_cov_export;
        uvm_tlm_analysis_fifo #(APB_master_seq_item) master_cov_apb;
        APB_master_seq_item master_seq_item_cov;
        uvm_analysis_export #(APB_slave_seq_item) slave_cov_export;
        uvm_tlm_analysis_fifo #(APB_slave_seq_item) slave_cov_apb;
        APB_slave_seq_item slave_seq_item_cov;

        // Covergroup definitions
        covergroup apb_cov_grp;
            rst_n_cp: coverpoint master_seq_item_cov.PRESETn{
                bins active = {`LOW};
                bins inactive = {`HIGH};
                bins inactive_to_active = (`HIGH=>`LOW);
                bins active_to_inactive = (`LOW=>`HIGH);
            }
            transfer_cp: coverpoint master_seq_item_cov.transfer{
                bins active = {`HIGH};
                bins inactive = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
           
            fsm_transitions_cp: coverpoint master_seq_item_cov.cs{
                // Cover States
                bins IDLE   = {IDLE};
                bins SETUP  = {SETUP};
                bins ACCESS = {ACCESS};
                // Cover Transitions
                bins IDLE_to_IDLE     = (IDLE=>IDLE);
                bins IDLE_to_SETUP    = (IDLE=>SETUP);
                bins SETUP_to_ACCESS  = (SETUP=>ACCESS);
                bins ACCESS_to_SETUP  = (ACCESS=>SETUP);
                bins ACCESS_to_IDLE   = (ACCESS=>IDLE);
            }
           
            address_cp: coverpoint slave_seq_item_cov.PADDR {
                bins lower_half  = { [0 : (`MEM_DEPTH/2 - 1)] }; 
                bins upper_half  = { [`MEM_DEPTH/2 : `MEM_DEPTH-1] };
                bins full_range  = { [0 : `MEM_DEPTH-1] };
            
                // Explicit boundary bins
                bins first_addr  = {0};
                bins middle_addr = {`MEM_DEPTH/2};
                bins last_addr   = {`MEM_DEPTH-1};
            }
            
            
            pslverr_cp: coverpoint master_seq_item_cov.PSLVERR{
                bins SUCCESS = {`LOW};
                bins ERROR = {`HIGH};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
        endgroup

        covergroup apb_write_cov_grp;
            pstrb_cp: coverpoint slave_seq_item_cov.PSTRB{
                bins PSTRB_SB_LSB     = {PSTRB_SB_LSB};
                bins PSTRB_SB_2ND     = {PSTRB_SB_2ND};
                bins PSTRB_SH_LSB     = {PSTRB_SH_LSB};
                bins PSTRB_SB_3RD     = {PSTRB_SB_3RD};
                bins PSTRB_SB_3RD_LSB = {PSTRB_SB_3RD_LSB};
                bins PSTRB_SB_2ND_3RD = {PSTRB_SB_2ND_3RD};
                bins PSTRB_SH_LSB_3B  = {PSTRB_SH_LSB_3B};
                bins PSTRB_SB_MSB     = {PSTRB_SB_MSB};
                bins PSTRB_SB_MSB_LSB = {PSTRB_SB_MSB_LSB};
                bins PSTRB_SH_MSB     = {PSTRB_SH_MSB};
                bins PSTRB_SH_MSB_LSB = {PSTRB_SH_MSB_LSB};
                bins PSTRB_SB_MSB_2ND = {PSTRB_SB_MSB_2ND};
                bins PSTRB_SB_MSB_3B  = {PSTRB_SB_MSB_3B};
                bins PSTRB_SH_MSB_3B  = {PSTRB_SH_MSB_3B};
                bins PSTRB_FULL_WORD  = {PSTRB_FULL_WORD};
            }
            pslverr_cp: coverpoint master_seq_item_cov.PSLVERR{
                bins SUCCESS = {`LOW};
            }

            write_data_cp: coverpoint slave_seq_item_cov.PWDATA {
                bins all_zero   = {`WDATA_ALL_ZERO};
                bins all_one    = {`WDATA_ALL_ONE};
                bins alt_1010   = {`WDATA_ALT_1010};
                bins alt_0101   = {`WDATA_ALT_0101};
                // fixed number of automatic bins
                bins low_range [20]= {[32'h0000_0001 : 32'h7FFF_FFFF]};
                // fixed number of automatic bins
                bins high_range [20] = {[32'h80000000 : 32'hFFFF_FFFE]};
            }
        
            write_op_cr: cross write_data_cp, pslverr_cp {
                bins no_error = binsof(write_data_cp) intersect {`WDATA_ALL_ZERO, `WDATA_ALL_ONE, `WDATA_ALT_1010, `WDATA_ALT_0101} &&
                                binsof(pslverr_cp.SUCCESS);
                bins low_range_no_error  = binsof(write_data_cp.low_range)  && binsof(pslverr_cp.SUCCESS);
                bins high_range_no_error = binsof(write_data_cp.high_range) && binsof(pslverr_cp.SUCCESS);
        
                option.cross_auto_bin_max = 0;
            }
            sprot_cp: coverpoint slave_seq_item_cov.PPROT {
                // Cover different protection levels
                bins normal_secure_data   = { NORMAL_ACCESS, SECURE_ACCESS, DATA_ACCESS };
                bins normal_nonsecure_data = { NORMAL_ACCESS, NONSECURE_ACCESS, DATA_ACCESS };
                bins privileged_secure_data = { PRIVILEGED_ACCESS, SECURE_ACCESS, DATA_ACCESS };
                bins privileged_nonsecure_data = { PRIVILEGED_ACCESS, NONSECURE_ACCESS, DATA_ACCESS };
                bins normal_secure_instr  = { NORMAL_ACCESS, SECURE_ACCESS, INSTRUCTION_ACCESS };
                bins normal_nonsecure_instr = { NORMAL_ACCESS, NONSECURE_ACCESS, INSTRUCTION_ACCESS };
                bins privileged_secure_instr = { PRIVILEGED_ACCESS, SECURE_ACCESS, INSTRUCTION_ACCESS };
                bins privileged_nonsecure_instr = { PRIVILEGED_ACCESS, NONSECURE_ACCESS, INSTRUCTION_ACCESS };    
            }
        endgroup

        covergroup apb_read_cov_grp;
            pslverr_cp: coverpoint master_seq_item_cov.PSLVERR{
                bins SUCCESS = {`LOW};
                bins ERROR = {`HIGH};
            }

            read_data_cp: coverpoint slave_seq_item_cov.PRDATA {
                bins all_zero   = {`WDATA_ALL_ZERO};
                bins all_one    = {`WDATA_ALL_ONE};
                bins alt_1010   = {`WDATA_ALT_1010};
                bins alt_0101   = {`WDATA_ALT_0101};
                // fixed number of automatic bins
                bins low_range [20]= {[32'h0000_0001 : 32'h7FFF_FFFF]};
                // fixed number of automatic bins
                bins high_range [20] = {[32'h80000000 : 32'hFFFF_FFFE]};
            }
        
            read_op_cr: cross read_data_cp, pslverr_cp {
                bins no_error = binsof(read_data_cp) intersect {`WDATA_ALL_ZERO, `WDATA_ALL_ONE, `WDATA_ALT_1010, `WDATA_ALT_0101} &&
                                binsof(pslverr_cp.SUCCESS);
                bins low_range_no_error  = binsof(read_data_cp.low_range)  && binsof(pslverr_cp.SUCCESS);
                bins high_range_no_error = binsof(read_data_cp.high_range) && binsof(pslverr_cp.SUCCESS);
        
                option.cross_auto_bin_max = 0;
            }
        endgroup

        covergroup apb_write_read_cov_grp;
            addr_cp: coverpoint slave_seq_item_cov.PADDR {
                bins per_address[] = {[32'h0000_0001 : 32'hFFFF_FFFE]};
            }
        
            write_data_cp: coverpoint slave_seq_item_cov.PWDATA {
                bins all_one    = {`WDATA_ALL_ONE};
                bins alt_1010   = {`WDATA_ALT_1010};
                bins alt_0101   = {`WDATA_ALT_0101};
            }
        
            read_data_cp: coverpoint slave_seq_item_cov.PRDATA {
                bins all_one    = {`WDATA_ALL_ONE};
                bins alt_1010   = {`WDATA_ALT_1010};
                bins alt_0101   = {`WDATA_ALT_0101};
            }
        
            write_read_cr: cross addr_cp, write_data_cp, read_data_cp {
                bins matched_write_read = binsof(addr_cp) && binsof(write_data_cp) && binsof(read_data_cp);
                option.cross_auto_bin_max = 0;
            }
        
        endgroup


        // Constructor
        function new (string name = "APB_coverage", uvm_component parent);
            super.new(name, parent);
            apb_cov_grp = new();
            apb_write_cov_grp = new();
            apb_read_cov_grp = new();
            apb_write_read_cov_grp = new();

        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            master_cov_export = new("master_cov_export", this);
            master_cov_apb = new("master_cov_apb", this);
            slave_cov_export = new("slave_cov_export", this);
            slave_cov_apb = new("slave_cov_apb", this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            master_cov_export.connect(master_cov_apb.analysis_export);
            slave_cov_export.connect(slave_cov_apb.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Get the next transaction from the analysis FIFO.
                master_cov_apb.get(master_seq_item_cov);
                slave_cov_apb.get(slave_seq_item_cov);
                apb_cov_grp.sample();
                if (slave_seq_item_cov.PWRITE && master_seq_item_cov.cs == ACCESS) begin
                    apb_write_cov_grp.sample();
                end
                if (!slave_seq_item_cov.PWRITE && master_seq_item_cov.cs == ACCESS) begin
                    apb_read_cov_grp.sample();
                end
                if (master_seq_item_cov.cs == ACCESS) begin
                    apb_write_read_cov_grp.sample();
                end
            end
        endtask

    endclass : APB_coverage

endpackage : APB_coverage_pkg