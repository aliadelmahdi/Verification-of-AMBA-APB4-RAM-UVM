`ifndef APB_SLAVE_SEQUENCER_SV
`define APB_SLAVE_SEQUENCER_SV

    class APB_slave_sequencer extends uvm_sequencer #(APB_slave_seq_item);

        `uvm_component_utils(APB_slave_sequencer);

        function new(string name = "APB_slave_sequence", uvm_component parent);
            super.new(name,parent);
        endfunction
        
        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask

    endclass : APB_slave_sequencer

`endif // APB_SLAVE_SEQUENCER_SV