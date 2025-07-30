
`ifndef APB_SLAVE_PKG_SV
`define APB_SLAVE_PKG_SV

    import shared_pkg::*;

    `include "APB_slave_seq_item.sv"
    `include "APB_slave_sequences.sv"
    `include "APB_slave_driver.sv"
    `include "APB_slave_monitor.sv"
    `include "APB_slave_sequencer.sv"
    `include "APB_slave_agent.sv"

`endif // APB_SLAVE_PKG_SV