`timescale 1ns/1ps  // Define time units

module tb_moving_avg;

    // 1. Signals for the "Virtual FPGA"
    reg clk;
    reg rst_n;
    reg signed [11:0] tb_data_in;
    wire signed [11:0] tb_data_out;

    // 2. Instantiate your Filter (Connect the "Box")
    moving_avg uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(tb_data_in),
        .data_out(tb_data_out)
    );

    // 3. Clock Generation (100MHz = 10ns period) 
    // since it flips every 5ns, a full cycle (up and down) takes 10ns, our 100MHz heartbeat
    always #5 clk = ~clk;

    // 4. THE MAIN PROCESS
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        tb_data_in = 0;

        // Release Reset after 20ns
        #20 rst_n = 1;

        // Load your Python data!
        // We will simulate 500 samples
        repeat (500) begin
            @(posedge clk);
            // In a real test, we'd read from the file here
            // For now, let's just send a test value
            tb_data_in = $random % 2048; 
        end

        $display("Simulation Finished");
        $finish;
    end

    // 5. Generate a waveform file for GTKWave
    initial begin
        $dumpfile("simulation_result.vcd");
        $dumpvars(0, tb_moving_avg);
    end

endmodule