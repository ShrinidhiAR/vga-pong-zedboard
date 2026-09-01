module top (
    input  logic clk100mhz,

    input  logic btnc,   // center button -> reset / serve
    input  logic btnu,   // player 1 up
    input  logic btnd,   // player 1 down
    input  logic sw0,    // player 2 up
    input  logic sw1,    // player 2 down

    output logic [3:0] vga_r,
    output logic [3:0] vga_g,
    output logic [3:0] vga_b,
    output logic       vga_hs,
    output logic       vga_vs
);

    logic reset;
    assign reset = btnc;

    // ---------------------------------------------------------
    // Pixel clock enable (100MHz / 4 -> ~25MHz tick)
    // ---------------------------------------------------------
    logic pixel_tick;
    clk_div u_clk_div (
        .clk100mhz  (clk100mhz),
        .reset      (reset),
        .pixel_tick (pixel_tick)
    );

    // ---------------------------------------------------------
    // VGA timing generator
    // ---------------------------------------------------------
    logic [9:0] hcount, vcount;
    logic       hsync, vsync, video_on, frame_tick;

    vga_timing u_vga_timing (
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

    // ---------------------------------------------------------
    // Debounced button/switch inputs
    // ---------------------------------------------------------
    logic btnu_db, btnd_db, sw0_db, sw1_db;

    debounce u_db_btnu (.clk100mhz(clk100mhz), .reset(reset), .noisy(btnu),
                           .clean(btnu_db));
    debounce u_db_btnd (.clk100mhz(clk100mhz), .reset(reset), .noisy(btnd),
                           .clean(btnd_db));
    debounce u_db_sw0  (.clk100mhz(clk100mhz), .reset(reset), .noisy(sw0),
                           .clean(sw0_db));
    debounce u_db_sw1  (.clk100mhz(clk100mhz), .reset(reset), .noisy(sw1),
                           .clean(sw1_db));

    // ---------------------------------------------------------
    // Game state
    // ---------------------------------------------------------
    logic [9:0] paddle1_y, paddle2_y;
    logic [9:0] ball_x, ball_y;
    logic [3:0] score1, score2;

    game_logic u_game_logic (
        .clk100mhz  (clk100mhz),
        .reset      (reset),
        .frame_tick (frame_tick),
        .btn_up1    (btnu_db),
        .btn_down1  (btnd_db),
        .btn_up2    (sw0_db),
        .btn_down2  (sw1_db),
        .paddle1_y  (paddle1_y),
        .paddle2_y  (paddle2_y),
        .ball_x     (ball_x),
        .ball_y     (ball_y),
        .score1     (score1),
        .score2     (score2)
    );

    // ---------------------------------------------------------
    // Pixel painter (combinational)
    // ---------------------------------------------------------
    logic [3:0] rgb_r, rgb_g, rgb_b;

    pixel_gen u_pixel_gen (
        .hcount    (hcount),
        .vcount    (vcount),
        .paddle1_y (paddle1_y),
        .paddle2_y (paddle2_y),
        .ball_x    (ball_x),
        .ball_y    (ball_y),
        .score1    (score1),
        .score2    (score2),
        .rgb_r     (rgb_r),
        .rgb_g     (rgb_g),
        .rgb_b     (rgb_b)
    );

    // ---------------------------------------------------------
    // Output register - blank RGB during retrace, else painted pixel
    // ---------------------------------------------------------
    always_ff @(posedge clk100mhz) begin
        if (pixel_tick) begin
            vga_hs <= hsync;
            vga_vs <= vsync;
            if (video_on) begin
                vga_r <= rgb_r;
                vga_g <= rgb_g;
                vga_b <= rgb_b;
            end else begin
                vga_r <= 4'h0;
                vga_g <= 4'h0;
                vga_b <= 4'h0;
            end
        end
    end

endmodule
