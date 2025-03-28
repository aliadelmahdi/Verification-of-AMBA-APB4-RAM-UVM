module APB_sva(input PCLK, PRESETn,
    input SWRITE,
    input [31:0] SADDR, SWDATA, 
    input [3:0] SSTRB,
    input [2:0] SPROT,
    input transfer,
    output [31:0] PRDATA 
    );

endmodule