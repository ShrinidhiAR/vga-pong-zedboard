module vga_timing (
    input  logic clk100mhz,
    input  logic reset,
    input  logic pixel_tick,

    output logic [9:0] hcount,
    output logic [9:0] vcount,
    output logic       hsync,
    output logic       vsync,
    output logic       video_on,
    output logic       frame_tick
);

    localparam int H_VISIBLE = 640;
    localparam int H_FRONT   = 16;
    localparam int H_SYNC    = 96;
    localparam int H_BACK    = 48;
    localparam int H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK; // 800

    localparam int V_VISIBLE = 480;
    localparam int V_FRONT   = 10;
    localparam int V_SYNC    = 2;
    localparam int V_BACK    = 33;
    localparam int V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK; // 525

    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset) begin
            hcount <= 10'd0;
        end else if (pixel_tick) begin
            if (hcount == H_TOTAL - 1)
                hcount <= 10'd0;
            else
                hcount <= hcount + 10'd1;
        end
    end

    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset) begin
            vcount <= 10'd0;
        end else if (pixel_tick && hcount == H_TOTAL - 1) begin
            if (vcount == V_TOTAL - 1)
                vcount <= 10'd0;
            else
                vcount <= vcount + 10'd1;
        end
    end

    assign hsync = ~((hcount >= (H_VISIBLE + H_FRONT)) &&
                      (hcount <  (H_VISIBLE + H_FRONT + H_SYNC)));

    assign vsync = ~((vcount >= (V_VISIBLE + V_FRONT)) &&
                      (vcount <  (V_VISIBLE + V_FRONT + V_SYNC)));

    assign video_on = (hcount < H_VISIBLE) && (vcount < V_VISIBLE);

    // One-cycle pulse at the very start of each frame
    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset)
            frame_tick <= 1'b0;
        else
            frame_tick <= pixel_tick && (hcount == 0) && (vcount == 0);
    end

endmodule
