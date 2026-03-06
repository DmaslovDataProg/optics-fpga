module moving_avg (
    input wire clk,                // System Clock
    input wire rst_n,              // Active-low Reset
    input wire signed [11:0] data_in,   // 12-bit ADC Input
    output reg signed [11:0] data_out   // 12-bit Filtered Output
);

    // 1. Internal Storage (The "Pipe")
    reg signed [11:0] shift_reg [0:3]; // 0 to 3 is the 4 tap filter, created previously
    
    // 2. Intermediate Sum (14-bit to prevent overflow)
    reg signed [13:0] sum;

    // 3. The Synchronous Logic Block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state: Clear everything
            data_out <= 12'd0;
            sum <= 14'd0;
            shift_reg[0] <= 12'd0;
            shift_reg[1] <= 12'd0;
            shift_reg[2] <= 12'd0;
            shift_reg[3] <= 12'd0;
        end else begin
            // A. Shifting Logic: Move old data down the line
            shift_reg[0] <= data_in;      // Newest sample enters
            shift_reg[1] <= shift_reg[0]; // Sample 0 moves to 1
            shift_reg[2] <= shift_reg[1]; // Sample 1 moves to 2
            shift_reg[3] <= shift_reg[2]; // Sample 2 moves to 3

            // B. Summation Logic
            sum <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];

            // C. Division Logic (Right shift by 2 = Divide by 4)
            data_out <= sum[13:2]; 
        end
    end

endmodule