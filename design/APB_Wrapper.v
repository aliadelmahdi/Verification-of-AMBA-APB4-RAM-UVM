module APB_Wrapper (APB_if apb_if);

  //instantiating our master
  APB_Master Master (
      .PCLK (apb_if.PCLK),
      .PRESETn(apb_if.PRESETn),
      .SWRITE(apb_if.SWRITE),
      .SADDR(apb_if.SADDR),
      .SWDATA(apb_if.SWDATA),
      .SSTRB(apb_if.SSTRB),
      .SPROT(apb_if.SPROT),
      .transfer(apb_if.transfer),
      .PSEL(apb_if.PSEL),
      .PENABLE(apb_if.PENABLE),
      .PWRITE(apb_if.PWRITE),
      .PADDR(apb_if.PADDR),
      .PWDATA(apb_if.PWDATA),
      .PSTRB(apb_if.PSTRB),
      .PPROT(apb_if.PPROT),
      .PREADY(apb_if.PREADY),
      .PSLVERR(apb_if.PSLVERR)
  );

  //instantiating our slave
  APB_Slave Slave (
      .PCLK(apb_if.PCLK),
      .PRESETn(apb_if.PRESETn),
      .PSEL(apb_if.PSEL),
      .PENABLE(apb_if.PENABLE),
      .PWRITE(apb_if.PWRITE),
      .PADDR(apb_if.PADDR),
      .PWDATA(apb_if.PWDATA),
      .PSTRB(apb_if.PSTRB),
      .PPROT(apb_if.PPROT),
      .PREADY(apb_if.PREADY),
      .PSLVERR(apb_if.PSLVERR),
      .PRDATA(apb_if.PRDATA)
  );
endmodule