// Comments referenced I used are from the ARM AMBA APB4 specifications  
// For detailed information on the AMBA APB4 interface, refer to the official ARM specification:
// https://www.eecs.umich.edu/courses/eecs373/readings/IHI0024C_amba_apb_protocol_spec.pdf
import shared_pkg::*; // For enums and parameters

interface APB_if(input bit PCLK); // Clock. The rising edge of PCLK times all transfers on the APB.
  // External stimulus signals
  logic SWRITE;
  logic [`APB_ADDR_WIDTH-1:0] SADDR;
  logic [`APB_DATA_WIDTH-1:0] SWDATA;
  logic [`APB_STRB_WIDTH-1:0] SSTRB;
  logic [`APB_PROT_WIDTH-1:0] SPROT;
  logic transfer; // To indicate the beginning of the transfer
  logic PRESETn; // Reset. The APB reset signal is active LOW. This signal is normally connected directly to the system bus reset signal.

  // Internal bus signals (from master to slave)
  logic PSEL; // Select. The APB bridge unit generates this signal to each peripheral bus slave. It indicates that the slave device is selected and that a data transfer is required. There is a PSELx signal for each slave.
  logic PENABLE; // Enable. This signal indicates the second and subsequent cycles of an APB transfer.
  logic PWRITE; // Direction. This signal indicates an APB write access when HIGH and an APB read access when LOW.
  logic [`APB_ADDR_WIDTH-1:0] PADDR; // Address. This is the APB address bus. It can be up to 32 bits wide and is driven by the peripheral bus bridge unit.
  logic [`APB_DATA_WIDTH-1:0] PWDATA; // Write data. This bus is driven by the peripheral bus bridge unit during write cycles when PWRITE is HIGH. This bus can be up to 32 bits wide.
  logic [`APB_STRB_WIDTH-1:0] PSTRB; // Write strobes. This signal indicates which byte lanes to update during a write transfer. There is one write strobe for each eight bits of the write data bus.
  logic [`APB_PROT_WIDTH-1:0] PPROT; // Protection type. This signal indicates the normal, privileged, or secure protection level of the transaction and whether the transaction is a data access or an instruction access
  logic PREADY; // Ready. The slave uses this signal to extend an APB transfer.
  logic PSLVERR; // This signal indicates a transfer failure.

  // Slave output signal
  logic [`APB_DATA_WIDTH-1:0] PRDATA; // Read Data. The selected slave drives this bus during read cycles when PWRITE is LOW. This bus can be up to 32-bits wide.

  // For Debugging 
  state_e cs; // current state
  
  // Golden Model Reference signals
  logic PSEL_ref;
  logic PENABLE_ref;
  logic PWRITE_ref;
  logic [`APB_ADDR_WIDTH-1:0] PADDR_ref;
  logic [`APB_DATA_WIDTH-1:0] PWDATA_ref;
  logic [`APB_STRB_WIDTH-1:0] PSTRB_ref;
  logic [`APB_PROT_WIDTH-1:0] PPROT_ref;
  logic PREADY_ref;
  logic PSLVERR_ref;
  logic [`APB_DATA_WIDTH-1:0] PRDATA_ref;

  modport master_driver (
    output SWRITE, SADDR, SWDATA, SSTRB, SPROT, transfer, PRESETn,
    input  PCLK
  );

  modport master_monitor (
    input SWRITE, SADDR, SWDATA, SSTRB, SPROT, transfer,
          PENABLE, PSEL, PWRITE, PADDR, PWDATA, PSTRB, PPROT,
          PRESETn, PREADY, PSLVERR, cs,
          PENABLE_ref, PSEL_ref, PWRITE_ref, PADDR_ref,
          PWDATA_ref, PSTRB_ref, PPROT_ref, PREADY_ref, PSLVERR_ref,
          PCLK
  );

  modport slave_driver (
    output PWRITE, PADDR, PWDATA, PSTRB, PPROT, PSEL, PENABLE, PRESETn,
    input  PCLK
  );

  modport slave_monitor (
    input PCLK, PSEL, PENABLE, PWRITE, PADDR, PWDATA,
          PSTRB, PPROT, PRDATA, PREADY, PSLVERR, PRESETn,
          PREADY_ref, PSLVERR_ref, PRDATA_ref
  );

endinterface : APB_if
