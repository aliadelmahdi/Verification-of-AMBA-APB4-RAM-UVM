// The following `define` values represent bit widths and sizes used in the design. 
// are only for convenience and to make the code more readable. 
`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32
`define APB_STRB_WIDTH 4
`define APB_PROT_WIDTH 3
`define MEM_WIDTH 32
`define MEM_DEPTH 1024
module APB_Slave #(
        parameter MEM_WIDTH = `MEM_WIDTH, 
        parameter MEM_DEPTH = `MEM_DEPTH
    ) (
        input PSEL, PENABLE, PWRITE,  
        input [`APB_ADDR_WIDTH-1:0] PADDR, 
        input [`APB_DATA_WIDTH-1:0] PWDATA,
        input [`APB_STRB_WIDTH-1:0] PSTRB,
        input [`APB_PROT_WIDTH-1:0] PPROT,
        input PCLK, PRESETn,
        output reg [`APB_DATA_WIDTH-1:0] PRDATA,
        output PREADY,
        output reg PSLVERR
    );

    // Define memory using the MEM_WIDTH and MEM_DEPTH from `defines`
    reg [MEM_WIDTH-1:0] Cache [MEM_DEPTH-1:0];

    always @ (posedge PCLK) begin
        if (~PRESETn) begin
            PSLVERR <= 0;
            PRDATA <= 0;
        end
        else if (PSEL) begin  // Access state when PSEL is high
            // Writing stage
            if (PWRITE) begin     
                case (PSTRB)
                    4'b0001: Cache[PADDR] <= {{24{PWDATA[7]}}, PWDATA[7:0]}; // Store the least significant byte (sb)
                    4'b0010: Cache[PADDR] <= {{24{PWDATA[15]}}, PWDATA[15:8], 8'h00}; // Store the second byte with zeroes
                    4'b0011: Cache[PADDR] <= {{16{PWDATA[15]}}, PWDATA[15:0]}; // Store the least significant half-word (sh)
                    4'b0100: Cache[PADDR] <= {{24{PWDATA[23]}}, PWDATA[23:16], 8'h00}; // Store the third byte with zeroes
                    4'b0101: Cache[PADDR] <= {{16{PWDATA[23]}}, PWDATA[23:16], 8'h00, PWDATA[7:0]}; // Store the third and least significant bytes with zeroes
                    4'b0110: Cache[PADDR] <= {{8{PWDATA[23]}}, PWDATA[23:8], 8'h00}; // Store the second and third bytes with zeroes
                    4'b0111: Cache[PADDR] <= {{8{PWDATA[23]}}, PWDATA[23:0]}; // Store the least significant three bytes (sh)
                    4'b1000: Cache[PADDR] <= {PWDATA[31:24], 24'h000000}; // Store the most significant byte without sign extension
                    4'b1001: Cache[PADDR] <= {PWDATA[31:24], 16'h0000, PWDATA[7:0]}; // Store most and least significant bytes without sign extension
                    4'b1010: Cache[PADDR] <= {PWDATA[31:23], 8'h00, PWDATA[15:8], 8'h00}; // Store the most significant half-word with zeroes
                    4'b1011: Cache[PADDR] <= {PWDATA[31:23], 8'h00, PWDATA[15:0]}; // Store the most significant half-word and the least significant byte
                    4'b1100: Cache[PADDR] <= {PWDATA[31:16], 16'h0000}; // Store the most significant and second bytes without sign extension
                    4'b1101: Cache[PADDR] <= {PWDATA[31:16], 8'h00, PWDATA[7:0]}; // Store the most significant three bytes with zeroes
                    4'b1110: Cache[PADDR] <= {PWDATA[31:8], 8'h00}; // Store the most significant three bytes with zeroes
                    4'b1111: Cache[PADDR] <= PWDATA[31:0]; // Store the full word
                    default: Cache[PADDR] <= 32'h00000000; // Default case for invalid PSTRB values
                endcase
                PSLVERR <= 0;
            end
            // Reading stage
            else begin
                if (PSTRB != 0)
                    PSLVERR <= 1;  // PSTRB must remain low when reading
                else begin
                    PRDATA <= Cache[PADDR];
                    PSLVERR <= 0;
                end
            end
        end
    end
    assign PREADY = (PSEL && PENABLE) ? 1 : 0; 

endmodule
