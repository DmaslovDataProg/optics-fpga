module fir_filter (
    input wire clk,
    input wire rst_n,
    input wire signed [11:0] data_in,
    output reg signed [11:0] data_out
);

    // 1. Define Coefficients as individual constants
    // 29 coefficients from Python FIR computations
    localparam signed [15:0] C0  = -61,  C1  = -68,  C2  = -79,  C3  = -78,  C4  = -35;
    localparam signed [15:0] C5  = 79,   C6  = 293,  C7  = 621,  C8  = 1059, C9  = 1580;
    localparam signed [15:0] C10 = 2138, C11 = 2670, C12 = 3111, C13 = 3402, C14 = 3504;
    localparam signed [15:0] C15 = 3402, C16 = 3111, C17 = 2670, C18 = 2138, C19 = 1580;
    localparam signed [15:0] C20 = 1059, C21 = 621,  C22 = 293,  C23 = 79,   C24 = -35;
    localparam signed [15:0] C25 = -78,  C26 = -79,  C27 = -68,  C28 = -61;

    // 2. Internal Memory
    reg signed [11:0] delay_line [0:28];
    reg signed [12:0] centered_data;
    reg signed [32:0] accumulator;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            centered_data <= 0;
            accumulator <= 0;
            for (i=0; i<29; i=i+1) delay_line[i] <= 0;
        end else begin
            // --- STEP A: BIAS CORRECTION ---
            // Input is 0 to 4095. Subtract 2048 to center it at 0.
            centered_data <= $signed({1'b0, data_in}) - 13'sd2048;

            // --- STEP B: SHIFT REGISTER ---
            delay_line[0] <= centered_data[11:0];
            for (i=1; i<29; i=i+1) delay_line[i] <= delay_line[i-1];

            // --- STEP C: MULTIPLY AND ACCUMULATE (MAC) ---
            // We do the math manually to ensure Icarus understands it
            accumulator = (delay_line[0] * C0)   + (delay_line[1] * C1)   + (delay_line[2] * C2)   + 
                          (delay_line[3] * C3)   + (delay_line[4] * C4)   + (delay_line[5] * C5)   + 
                          (delay_line[6] * C6)   + (delay_line[7] * C7)   + (delay_line[8] * C8)   + 
                          (delay_line[9] * C9)   + (delay_line[10] * C10) + (delay_line[11] * C11) + 
                          (delay_line[12] * C12) + (delay_line[13] * C13) + (delay_line[14] * C14) + 
                          (delay_line[15] * C15) + (delay_line[16] * C16) + (delay_line[17] * C17) + 
                          (delay_line[18] * C18) + (delay_line[19] * C19) + (delay_line[20] * C20) + 
                          (delay_line[21] * C21) + (delay_line[22] * C22) + (delay_line[23] * C23) + 
                          (delay_line[24] * C24) + (delay_line[25] * C25) + (delay_line[26] * C26) + 
                          (delay_line[27] * C27) + (delay_line[28] * C28);

            // --- STEP D: OUTPUT SCALING ---
            // Shift down by 15 bits (coefficient scale) and add 2048 bias back
            data_out <= (accumulator[26:15]) + 12'sd2048;
        end
    end
endmodule