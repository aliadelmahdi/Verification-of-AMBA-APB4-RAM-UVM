`include "apb_defines.svh" // For macros
import shared_pkg::*; // For enums and parameters

module golden_model (
    input PCLK, PRESETn,
    input SWRITE,
    input [`APB_ADDR_WIDTH-1:0] SADDR,
    input [`APB_DATA_WIDTH-1:0] SWDATA,
    input [`APB_STRB_WIDTH-1:0] SSTRB,
    input [`APB_PROT_WIDTH-1:0] SPROT,
    input transfer,
    output logic [`APB_DATA_WIDTH-1:0] PRDATA
    );

    logic PSEL, PENABLE, PWRITE;
    logic [`APB_ADDR_WIDTH-1:0] PADDR;
    logic [`APB_DATA_WIDTH-1:0] PWDATA;
    logic [`APB_STRB_WIDTH-1:0] PSTRB;
    logic [`APB_PROT_WIDTH-1:0] PPROT;
    logic PREADY, PSLVERR;

    // Define memory using the MEM_WIDTH and MEM_DEPTH from `defines`
    logic [`MEM_WIDTH-1:0] Cache [`MEM_DEPTH-1:0];
    logic [`APB_DATA_WIDTH-1:0] data_write;

    always @ (posedge PCLK) begin
        if (~PRESETn) begin
            PSLVERR <= 0;
            PRDATA <= 0;
        end
        else if (PSEL) begin
            // Writing stage
            if (PWRITE) begin    
                data_write = compute_data(PWDATA, PSTRB);
                Cache[PADDR] <= data_write;
                PSLVERR <= 0;
            end
            // Reading stage
            else begin
                if (PSTRB != 0)
                    PSLVERR <= 1;
                else begin
                    PRDATA <= Cache[PADDR];
                    PSLVERR <= 0;
                end
            end
        end
    end

    assign PREADY = (PSEL && PENABLE) ? 1 : 0; 

    state_e ns, cs;
    always @(posedge PCLK, negedge PRESETn)
    begin
        cs <= (~PRESETn) ? IDLE : ns;
    end

    //next state logic
    always_comb begin
        case(cs)
            IDLE : ns = (transfer) ? SETUP:IDLE;
            SETUP : ns = ACCESS;
            ACCESS : begin
                case({PREADY,transfer}) 
                2'b10: ns = IDLE;
                2'b11: ns = SETUP;
                default: ns = ACCESS;
                endcase
            end
            default : ns = IDLE;
        endcase
    end

    //output logic
    always_comb begin
        if(~PRESETn)
            begin
                PSEL = 0;
                PENABLE = 0;
                PWRITE = 0;
                PADDR = 0;
                PWDATA = 0;
                PSTRB = 0;
                PPROT = 0;
            end
        else begin
            case(cs)
                IDLE : begin
                    PSEL = 0;
                    PENABLE = 0;
                end
                SETUP : begin
                    PSEL = 1;
                    PENABLE = 0;
                    PWRITE = SWRITE;
                    PADDR = SADDR;
                    PWDATA = SWDATA;
                    PSTRB = SSTRB;
                    PPROT = SPROT;
                end
                ACCESS : begin
                    PSEL = 1;
                    PENABLE = 1;
                end
            endcase
        end
    end

    function logic [`APB_DATA_WIDTH-1:0] compute_data(
        input logic [`APB_DATA_WIDTH-1:0] PWDATA,
        input logic [`APB_STRB_WIDTH-1:0] PSTRB
    );
        case (PSTRB)
            PSTRB_SB_LSB:      return {{24{PWDATA[7]}},  PWDATA[7:0]};
            PSTRB_SB_2ND:      return {{24{PWDATA[15]}}, PWDATA[15:8], 8'h00};
            PSTRB_SH_LSB:      return {{16{PWDATA[15]}}, PWDATA[15:0]};
            PSTRB_SB_3RD:      return {{24{PWDATA[23]}}, PWDATA[23:16], 8'h00};
            PSTRB_SB_3RD_LSB:  return {{16{PWDATA[23]}}, PWDATA[23:16], 8'h00, PWDATA[7:0]};
            PSTRB_SB_2ND_3RD:  return {{8{PWDATA[23]}},  PWDATA[23:8], 8'h00};
            PSTRB_SH_LSB_3B:   return {{8{PWDATA[23]}},  PWDATA[23:0]};
            PSTRB_SB_MSB:      return {PWDATA[31:24], 24'h000000};
            PSTRB_SB_MSB_LSB:  return {PWDATA[31:24], 16'h0000, PWDATA[7:0]};
            PSTRB_SH_MSB:      return {PWDATA[31:23], 8'h00, PWDATA[15:8], 8'h00};
            PSTRB_SH_MSB_LSB:  return {PWDATA[31:23], 8'h00, PWDATA[15:0]};
            PSTRB_SB_MSB_2ND:  return {PWDATA[31:16], 16'h0000};
            PSTRB_SB_MSB_3B:   return {PWDATA[31:16], 8'h00, PWDATA[7:0]};
            PSTRB_SH_MSB_3B:   return {PWDATA[31:8], 8'h00};
            PSTRB_FULL_WORD:   return PWDATA[31:0];
            default:           return 32'h00000000;
        endcase
    endfunction
 
endmodule
