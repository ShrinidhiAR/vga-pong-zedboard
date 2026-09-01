module vga_timing_tb;

    logic clk100mhz = 0;
    logic reset = 1;
    logic pixel_tick;
    logic [9:0] hcount, vcount;
    logic hsync, vsync, video_on, frame_tick;

    int frame_tick_count = 0;
    int errors = 0;

    // 100MHz clock
    always #5 clk100mhz = ~clk100mhz;

    // Simple free-running pixel_tick generator (mirrors clk_div behavior)
    logic [1:0] div_count = 0;
    always_ff @(posedge clk100mhz) div_count <= div_count + 1;
    assign pixel_tick = (div_count == 2'b00);

    vga_timing dut (
        .clk100mhz  (clk100mhz),
        .reset      (reset),
        .pixel_tick (pixel_tick),
        .hcount     (hcount),
        .vcount     (vcount),
        .hsync      (hsync),
        .vsync      (vsync),
        .video_on   (video_on),
        .frame_tick (frame_tick)
    );

    always_ff @(posedge clk100mhz) begin
        if (frame_tick) frame_tick_count++;
    end

    initial begin
        repeat (4) @(posedge clk100mhz);
        reset = 0;

        // Check hcount never exceeds 799
        fork
            begin
                forever begin
                    @(posedge clk100mhz);
                    if (hcount > 10'd799) begin
                        $error("hcount exceeded max: %0d", hcount);
                        errors++;
                    end
                    if (vcount > 10'd524) begin
                        $error("vcount exceeded max: %0d", vcount);
                        errors++;
                    end
                end
            end
        join_none

        // Run for slightly more than 2 full frames
        // 1 frame = 800*525 = 420000 pixel clocks = 1,680,000 clk100mhz cycles
        repeat (3_400_000) @(posedge clk100mhz);

        if (frame_tick_count < 2) begin
            $error("Expected at least 2 frame_tick pulses, got %0d", frame_tick_count);
            errors++;
        end else begin
            $display("frame_tick fired %0d times as expected", frame_tick_count);
        end

        if (errors == 0)
            $display("*** TEST PASSED ***");
        else
            $display("*** TEST FAILED with %0d errors ***", errors);

        $finish;
    end

endmodule
