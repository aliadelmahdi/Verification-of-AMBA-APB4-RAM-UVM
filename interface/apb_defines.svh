`ifndef APB_DEFINES_SVH
`define APB_DEFINES_SVH

    // Basic logic levels
    `define LOW 0
    `define HIGH 1

    // APB bus parameters
    `define APB_ADDR_WIDTH 10  // Address bus width
    `define APB_DATA_WIDTH 32  // Data bus width
    `define APB_STRB_WIDTH 4   // Strobe signal width
    `define APB_PROT_WIDTH 3   // Protection signal width

    // Read/Write control
    `define WRITE 1
    `define READ  0

    // Common test data patterns
    `define WDATA_ALL_ZERO   32'h0000_0000  // All zeros
    `define WDATA_ALL_ONE    32'hFFFF_FFFF  // All ones
    `define WDATA_ALT_1010   32'hAAAA_AAAA  // Alternating 1010 pattern
    `define WDATA_ALT_0101   32'h5555_5555  // Alternating 0101 pattern

    // Probability values for test scenarios
    `define WRITE_PROB 70  // 70% chance of write operation
    `define READ_PROB  30  // 30% chance of read operation

    // Memory settings
    `define MEM_DEPTH 1024  // Number of memory locations
    `define MEM_WIDTH 32    // Width of each memory location in bits

    // Simulation control
    `define DISABLE_FINISH 0  // Keep Questa simulation running
    `define ENABLE_FINISH 1   // Close Questa simulation when done

    // Clock period definition
    `define CLK_PERIOD 10  // Clock period in time units

    // Test iterations
    `define TEST_ITER_SMALL   100    // Small number of iterations for quick debugging
    `define TEST_ITER_MEDIUM  1000   // Medium-sized test
    `define TEST_ITER_LARGE   10000  // Large-scale test
    `define TEST_ITER_STRESS  100000 // Stress test

    // Timescale control
    `define TIME_UNIT 1ps
    `define TIME_PRECISION 1ps

`endif
