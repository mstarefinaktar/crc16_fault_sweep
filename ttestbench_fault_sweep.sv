`timescale 1ns / 1ps

module testbench_fault_sweep;
    reg clk = 0;
    reg reset = 1;
    reg enable = 0;
    reg [15:0] data_in;
    reg [15:0] fault_mask = 16'b0;
    reg [15:0] fault_value = 16'b0;
    wire [15:0] crc_out;

    integer i;
    integer csv;

    // Instantiate CRC module with fault injection
    crc16_parallel_fault uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .data_in(data_in),
        .fault_mask(fault_mask),
        .fault_value(fault_value),
        .crc_out(crc_out)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench_fault_sweep);

        csv = $fopen("crc_fault_sweep.csv", "w");
        $fwrite(csv, "Time_ns,Data_in,FaultBit,FaultType,FaultMask,FaultValue,CRC_out\n");

        #10 reset = 0;

        data_in = 16'hA5A5;  // test pattern

        for (i = 0; i < 16; i = i + 1) begin
            sweep_fault(i, 1'b0); // Stuck-at-0
            sweep_fault(i, 1'b1); // Stuck-at-1
        end

        #50 $fclose(csv);
        #10 $finish;
    end

    task sweep_fault(input integer bit_pos, input bit stuck_val);
        begin
            @(negedge clk);
            fault_mask = (16'b1 << bit_pos);
            fault_value = (stuck_val ? (16'b1 << bit_pos) : 16'b0);
            enable = 1;
            @(negedge clk);
            enable = 0;
            @(posedge clk);
            $fwrite(csv, "%0t,%h,%0d,%s,%h,%h,%h\n",
                $time,
                data_in,
                bit_pos,
                (stuck_val ? "stuck-at-1" : "stuck-at-0"),
                fault_mask,
                fault_value,
                crc_out
            );
        end
    endtask
endmodule
