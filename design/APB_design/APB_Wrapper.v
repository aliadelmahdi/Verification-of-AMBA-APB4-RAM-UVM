`ifndef APB_WRAPPER_V
`define APB_WRAPPER_V

module APB_Wrapper (
    input PCLK, PRESETn,
    input SWRITE,
    input [`APB_ADDR_WIDTH-1:0] SADDR,
    input [`APB_DATA_WIDTH-1:0] SWDATA,
    input [`APB_STRB_WIDTH-1:0] SSTRB,
    input [`APB_PROT_WIDTH-1:0] SPROT,
    input transfer,
    output [`APB_DATA_WIDTH-1:0] PRDATA
    );

    wire PSEL, PENABLE, PWRITE;
    wire [`APB_ADDR_WIDTH-1:0] PADDR;
    wire [`APB_DATA_WIDTH-1:0] PWDATA;
    wire [`APB_STRB_WIDTH-1:0] PSTRB;
    wire [`APB_PROT_WIDTH-1:0] PPROT;
    wire PREADY, PSLVERR;

    // Instantiating our master
    APB_Master Master (
        .PCLK (PCLK),
        .PRESETn(PRESETn),
        .SWRITE(SWRITE),
        .SADDR(SADDR),
        .SWDATA(SWDATA),
        .SSTRB(SSTRB),
        .SPROT(SPROT),
        .transfer(transfer),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PPROT(PPROT),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );

    // Instantiating our slave
    APB_Slave Slave (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PPROT(PPROT),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR),
        .PRDATA(PRDATA)
    );

endmodule : APB_Wrapper

`endif // APB_WRAPPER_V