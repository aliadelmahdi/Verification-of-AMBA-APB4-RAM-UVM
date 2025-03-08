interface APB_if(input logic PCLK);
  // External stimulus signals
  logic         SWRITE;
  logic [31:0]  SADDR, SWDATA;
  logic [3:0]   SSTRB;
  logic [2:0]   SPROT;
  logic         transfer;
  logic PRESETn;
  // Internal bus signals (from master to slave)
  logic         PSEL, PENABLE, PWRITE;
  logic [31:0]  PADDR, PWDATA;
  logic [3:0]   PSTRB;
  logic [2:0]   PPROT;
  logic         PREADY, PSLVERR;
  
  // Slave output signal
  logic [31:0]  PRDATA;
  
  // Define modport for the slave agent (driving the bus)
  modport slave_mp (
    input  PSEL, PENABLE, PWRITE, PADDR, PWDATA, PSTRB, PPROT, PCLK, PRESETn,
    output PRDATA, PREADY, PSLVERR
  );
  
  // Define modport for the master agent (observing responses)
  modport master_mp(
    input SWRITE, SADDR, SWDATA, SSTRB, SPROT, transfer, PREADY, PSLVERR, PRESETn, PCLK,
    output PSEL, PENABLE, PWRITE, PADDR, PWDATA, PSTRB, PPROT
  );
endinterface