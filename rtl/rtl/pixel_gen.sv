module pixel_gen (
    input  logic [9:0] hcount,
    input  logic [9:0] vcount,

    input  logic [9:0] paddle1_y,
    input  logic [9:0] paddle2_y,
    input  logic [9:0] ball_x,
    input  logic [9:0] ball_y,
    input  logic [3:0] score1,
    input  logic [3:0] score2,

    output logic [3:0] rgb_r,
    output logic [3:0] rgb_g,
    output logic [3:0] rgb_b
);

    localparam int PADDLE_W  = 10;
    localparam int PADDLE_H  = 60;
    localparam int PADDLE1_X = 20;
    localparam int PADDLE2_X = 610;
    localparam int BALL_SIZE = 8;

    // ---------------------------------------------------------
    // Shape hit-tests
    // ---------------------------------------------------------
    logic in_paddle1, in_paddle2, in_ball, in_net;

    assign in_paddle1 = (hcount >= PADDLE1_X) && (hcount < PADDLE1_X + PADDLE_W) &&
                         (vcount >= paddle1_y) && (vcount < paddle1_y + PADDLE_H);

    assign in_paddle2 = (hcount >= PADDLE2_X) && (hcount < PADDLE2_X + PADDLE_W) &&
                         (vcount >= paddle2_y) && (vcount < paddle2_y + PADDLE_H);

    assign in_ball = (hcount >= ball_x) && (hcount < ball_x + BALL_SIZE) &&
                      (vcount >= ball_y) && (vcount < ball_y + BALL_SIZE);

    // dashed center net: thin vertical strip, on for 16px / off for 16px
    assign in_net = (hcount >= 318) && (hcount < 322) && (vcount[4] == 1'b0);

    // ---------------------------------------------------------
    // Scoreboard - two single digits, 5x7 glyph scaled up 4x
    // ---------------------------------------------------------
    localparam int DIGIT_SCALE = 4;
    localparam int DIGIT_W     = 5 * DIGIT_SCALE; // 20
    localparam int DIGIT_H     = 7 * DIGIT_SCALE; // 28

    localparam int SCORE1_X = 260;
    localparam int SCORE2_X = 360;
    localparam int SCORE_Y  = 20;

    logic in_score1_box, in_score2_box;
    logic [2:0] score1_row, score1_col, score2_row, score2_col;
    logic       score1_pixel, score2_pixel;

    assign in_score1_box = (hcount >= SCORE1_X) && (hcount < SCORE1_X + DIGIT_W) &&
                            (vcount >= SCORE_Y)  && (vcount < SCORE_Y + DIGIT_H);

    assign in_score2_box = (hcount >= SCORE2_X) && (hcount < SCORE2_X + DIGIT_W) &&
                            (vcount >= SCORE_Y)  && (vcount < SCORE_Y + DIGIT_H);

    assign score1_col = (hcount - SCORE1_X) >> 2;
    assign score1_row = (vcount - SCORE_Y)  >> 2;
    assign score2_col = (hcount - SCORE2_X) >> 2;
    assign score2_row = (vcount - SCORE_Y)  >> 2;

    digit_rom u_digit1 (
        .digit (score1),
        .row   (score1_row),
        .col   (score1_col),
        .pixel (score1_pixel)
    );

    digit_rom u_digit2 (
        .digit (score2),
        .row   (score2_row),
        .col   (score2_col),
        .pixel (score2_pixel)
    );

    // ---------------------------------------------------------
    // Color mux - priority: paddles/ball > score > net > background
    // ---------------------------------------------------------
    always_comb begin
        if (in_paddle1 || in_paddle2 || in_ball) begin
            {rgb_r, rgb_g, rgb_b} = {4'hF, 4'hF, 4'hF}; // white
        end else if ((in_score1_box && score1_pixel) || (in_score2_box && score2_pixel)) begin
            {rgb_r, rgb_g, rgb_b} = {4'hF, 4'hF, 4'hF}; // white
        end else if (in_net) begin
            {rgb_r, rgb_g, rgb_b} = {4'h6, 4'h6, 4'h6}; // dim gray dashes
        end else begin
            {rgb_r, rgb_g, rgb_b} = {4'h0, 4'h0, 4'h0}; // black background
        end
    end

endmodule
