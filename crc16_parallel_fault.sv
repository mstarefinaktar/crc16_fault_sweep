`timescale 1ns / 1ps

module crc16_parallel_fault (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [15:0] data_in,
    input wire [15:0] fault_mask,   // 1 = affected bit
    input wire [15:0] fault_value,  // 1 = stuck-at-1, 0 = stuck-at-0
    output reg [15:0] crc_out
);

    reg [15:0] crc_reg;
    wire [15:0] data_faulted;

    // Inject faults: apply mask and force stuck-at value
    assign data_faulted = (data_in & ~fault_mask) | (fault_value & fault_mask);

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_reg <= 16'hFFFF;
        end else if (enable) begin
            crc_reg <= crc_reg;  // default hold value
            for (i = 0; i < 16; i = i + 1) begin
                if ((data_faulted[i] ^ crc_reg[15]) == 1'b1) begin
                    crc_reg <= {crc_reg[14:0], 1'b0} ^ 16'h1021;
                end else begin
                    crc_reg <= {crc_reg[14:0], 1'b0};
                end
            end
        end
    end

    always @(*) begin
        crc_out = crc_reg;
    end

endmodule
