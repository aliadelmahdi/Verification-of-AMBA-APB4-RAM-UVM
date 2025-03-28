// Define constants for signal widths and values
`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32
`define APB_STRB_WIDTH 4
`define APB_PROT_WIDTH 3

// Define for signal states
`define LOW 0
`define HIGH 1

interface APB_if(input bit PCLK);
  // External stimulus signals
  logic                       SWRITE;
  logic [`APB_ADDR_WIDTH-1:0] SADDR, SWDATA;  // Using the defined width
  logic [`APB_STRB_WIDTH-1:0] SSTRB;
  logic [`APB_PROT_WIDTH-1:0] SPROT;
  logic                       transfer;
  logic                       PRESETn;

  // Internal bus signals (from master to slave)
  logic                       PSEL, PENABLE, PWRITE;
  logic [`APB_ADDR_WIDTH-1:0] PADDR, PWDATA;  // Using the defined width
  logic [`APB_STRB_WIDTH-1:0] PSTRB;
  logic [`APB_PROT_WIDTH-1:0] PPROT;
  logic                       PREADY, PSLVERR;
  
  // Slave output signal
  logic [`APB_DATA_WIDTH-1:0] PRDATA;  // Using the defined width
endinterface
