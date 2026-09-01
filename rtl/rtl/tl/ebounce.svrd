module debounce (
    input  logic clk100mhz,
    input  logic reset,
    input  logic noisy,
    output logic clean
);

    localparam int DEBOUNCE_CYCLES = 100_000; // ~1ms at 100MHz
    localparam int CNT_WIDTH = $clog2(DEBOUNCE_CYCLES);

    // 2-FF synchronizer to avoid metastability
    logic sync0, sync1;
    always_ff @(posedge clk100mhz) begin
        sync0 <= noisy;
        sync1 <= sync0;
    end

    logic [CNT_WIDTH-1:0] count;

    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset) begin
            count <= '0;
            clean <= 1'b0;
        end else if (sync1 == clean) begin
            count <= '0; // input agrees with current output, no change pending
        end else begin
            count <= count + 1'b1;
            if (count == DEBOUNCE_CYCLES - 1)
                clean <= sync1;
        end
    end

endmodule
