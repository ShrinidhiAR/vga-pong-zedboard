module game_logic (
    input  logic clk100mhz,
    input  logic reset,       // also used as "serve" - hold BTNC to reset ball/score
    input  logic frame_tick,

    input  logic btn_up1,
    input  logic btn_down1,
    input  logic btn_up2,
    input  logic btn_down2,

    output logic [9:0] paddle1_y,
    output logic [9:0] paddle2_y,
    output logic [9:0] ball_x,
    output logic [9:0] ball_y,
    output logic [3:0] score1,
    output logic [3:0] score2
);

    // ---------------------------------------------------------
    // Playfield constants
    // ---------------------------------------------------------
    localparam int SCREEN_W    = 640;
    localparam int SCREEN_H    = 480;

    localparam int PADDLE_W    = 10;
    localparam int PADDLE_H    = 60;
    localparam int PADDLE1_X   = 20;
    localparam int PADDLE2_X   = 610;
    localparam int PADDLE_SPEED= 4;
    localparam int PADDLE_MAX_Y= SCREEN_H - PADDLE_H;

    localparam int BALL_SIZE   = 8;
    localparam int BALL_SPEED  = 2;
    localparam int BALL_START_X= SCREEN_W/2 - BALL_SIZE/2;
    localparam int BALL_START_Y= SCREEN_H/2 - BALL_SIZE/2;

    // ball velocity, small signed values (+/- BALL_SPEED)
    logic signed [4:0] ball_dx, ball_dy;

    // ---------------------------------------------------------
    // Paddle 1 (left)
    // ---------------------------------------------------------
    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset) begin
            paddle1_y <= (SCREEN_H - PADDLE_H) / 2;
        end else if (frame_tick) begin
            if (btn_up1 && paddle1_y > PADDLE_SPEED)
                paddle1_y <= paddle1_y - PADDLE_SPEED;
            else if (btn_up1)
                paddle1_y <= 0;
            else if (btn_down1 && paddle1_y < PADDLE_MAX_Y - PADDLE_SPEED)
                paddle1_y <= paddle1_y + PADDLE_SPEED;
            else if (btn_down1)
                paddle1_y <= PADDLE_MAX_Y;
        end
    end

    // ---------------------------------------------------------
    // Paddle 2 (right)
    // ---------------------------------------------------------
    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset) begin
            paddle2_y <= (SCREEN_H - PADDLE_H) / 2;
        end else if (frame_tick) begin
            if (btn_up2 && paddle2_y > PADDLE_SPEED)
                paddle2_y <= paddle2_y - PADDLE_SPEED;
            else if (btn_up2)
                paddle2_y <= 0;
            else if (btn_down2 && paddle2_y < PADDLE_MAX_Y - PADDLE_SPEED)
                paddle2_y <= paddle2_y + PADDLE_SPEED;
            else if (btn_down2)
                paddle2_y <= PADDLE_MAX_Y;
        end
    end

    // ---------------------------------------------------------
    // Ball
    // ---------------------------------------------------------
    logic signed [10:0] next_x, next_y;
    logic left_hit, right_hit, top_hit, bottom_hit;
    logic scored_left, scored_right; // scored_left = point for player 2, ball exited left

    always_comb begin
        next_x = $signed({1'b0, ball_x}) + ball_dx;
        next_y = $signed({1'b0, ball_y}) + ball_dy;

        top_hit    = (next_y <= 0);
        bottom_hit = (next_y >= (SCREEN_H - BALL_SIZE));

        // paddle1 (left) collision zone: ball's left edge reaches paddle's right edge,
        // and ball vertically overlaps the paddle
        left_hit = (next_x <= (PADDLE1_X + PADDLE_W)) &&
                   (ball_x  >  PADDLE1_X) && // only trigger while approaching, not already past
                   ((ball_y + BALL_SIZE) >= paddle1_y) &&
                   (ball_y <= (paddle1_y + PADDLE_H)) &&
                   (ball_dx < 0);

        right_hit = (next_x >= (PADDLE2_X - BALL_SIZE)) &&
                    (ball_x  <  PADDLE2_X) &&
                    ((ball_y + BALL_SIZE) >= paddle2_y) &&
                    (ball_y <= (paddle2_y + PADDLE_H)) &&
                    (ball_dx > 0);

        scored_left  = (next_x < 0);                       // player 2 scores
        scored_right = (next_x > (SCREEN_W - BALL_SIZE));  // player 1 scores
    end

    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset) begin
            ball_x  <= BALL_START_X;
            ball_y  <= BALL_START_Y;
            ball_dx <= -BALL_SPEED;
            ball_dy <=  BALL_SPEED;
            score1  <= 4'd0;
            score2  <= 4'd0;
        end else if (frame_tick) begin
            if (scored_left) begin
                score2  <= (score2 == 4'd9) ? 4'd0 : score2 + 1'b1;
                ball_x  <= BALL_START_X;
                ball_y  <= BALL_START_Y;
                ball_dx <=  BALL_SPEED;   // serve toward the player who just conceded
                ball_dy <= (ball_dy[4]) ? -BALL_SPEED : BALL_SPEED;
            end else if (scored_right) begin
                score1  <= (score1 == 4'd9) ? 4'd0 : score1 + 1'b1;
                ball_x  <= BALL_START_X;
                ball_y  <= BALL_START_Y;
                ball_dx <= -BALL_SPEED;
                ball_dy <= (ball_dy[4]) ? -BALL_SPEED : BALL_SPEED;
            end else begin
                // normal movement, with reflections
                ball_x <= next_x[9:0];
                ball_y <= next_y[9:0];

                if (top_hit || bottom_hit)
                    ball_dy <= -ball_dy;

                if (left_hit || right_hit)
                    ball_dx <= -ball_dx;
            end
        end
    end

endmodule
