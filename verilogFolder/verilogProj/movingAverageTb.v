`timescale 1ns/1ps

module tb_moving_avg;

    reg clk;
    reg rst_n;
    reg signed [11:0] tb_data_in;
    wire signed [11:0] tb_data_out;

    // 1. Create a "Memory Array" to hold the file data
    // Depth is 2400 (matches your 0.05s @ 48kHz signal)
    reg [11:0] test_memory [0:2399];
    integer i;

    moving_avg uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(tb_data_in),
        .data_out(tb_data_out)
    );

    always #10 clk = ~clk; // 50MHz Clock

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        tb_data_in = 0;

        // 2. LOAD THE FILE into test_memory
        $readmemh("input_signal.hex", test_memory);
        $display("Loaded %d samples from hex file", 2400);

        #100 rst_n = 1; // Release reset

        // 3. FEED DATA: Loop through the memory
        for (i = 0; i < 2400; i = i + 1) begin
            @(posedge clk);
            tb_data_in = test_memory[i];
        end

        $display("Processing Complete.");
        $finish;
    end

    initial begin
        $dumpfile("moving_avg_sim.vcd");
        $dumpvars(0, tb_moving_avg);
    end

endmodule