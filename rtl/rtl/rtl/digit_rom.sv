module digit_rom (
    input  logic [3:0] digit,
    input  logic [2:0] row,
    input  logic [2:0] col,
    output logic       pixel
);

    logic [4:0] row_pattern;

    always_comb begin
        case (digit)
            4'd0: case (row)
                0: row_pattern = 5'b01110;
                1: row_pattern = 5'b10001;
                2: row_pattern = 5'b10011;
                3: row_pattern = 5'b10101;
                4: row_pattern = 5'b11001;
                5: row_pattern = 5'b10001;
                6: row_pattern = 5'b01110;
                default: row_pattern = 5'b00000;
            endcase
            4'd1: case (row)
                0: row_pattern = 5'b00100;
                1: row_pattern = 5'b01100;
                2: row_pattern = 5'b00100;
                3: row_pattern = 5'b00100;
                4: row_pattern = 5'b00100;
                5: row_pattern = 5'b00100;
                6: row_pattern = 5'b01110;
                default: row_pattern = 5'b00000;
            endcase
            4'd2: case (row)
                0: row_pattern = 5'b01110;
                1: row_pattern = 5'b10001;
                2: row_pattern = 5'b00001;
                3: row_pattern = 5'b00010;
                4: row_pattern = 5'b00100;
                5: row_pattern = 5'b01000;
                6: row_pattern = 5'b11111;
                default: row_pattern = 5'b00000;
            endcase
            4'd3: case (row)
                0: row_pattern = 5'b11111;
                1: row_pattern = 5'b00010;
                2: row_pattern = 5'b00100;
                3: row_pattern = 5'b00010;
                4: row_pattern = 5'b00001;
                5: row_pattern = 5'b10001;
                6: row_pattern = 5'b01110;
                default: row_pattern = 5'b00000;
            endcase
            4'd4: case (row)
                0: row_pattern = 5'b00010;
                1: row_pattern = 5'b00110;
                2: row_pattern = 5'b01010;
                3: row_pattern = 5'b10010;
                4: row_pattern = 5'b11111;
                5: row_pattern = 5'b00010;
                6: row_pattern = 5'b00010;
                default: row_pattern = 5'b00000;
            endcase
            4'd5: case (row)
                0: row_pattern = 5'b11111;
                1: row_pattern = 5'b10000;
                2: row_pattern = 5'b11110;
                3: row_pattern = 5'b00001;
                4: row_pattern = 5'b00001;
                5: row_pattern = 5'b10001;
                6: row_pattern = 5'b01110;
                default: row_pattern = 5'b00000;
            endcase
            4'd6: case (row)
                0: row_pattern = 5'b00110;
                1: row_pattern = 5'b01000;
                2: row_pattern = 5'b10000;
                3: row_pattern = 5'b11110;
                4: row_pattern = 5'b10001;
                5: row_pattern = 5'b10001;
                6: row_pattern = 5'b01110;
                default: row_pattern = 5'b00000;
            endcase
            4'd7: case (row)
                0: row_pattern = 5'b11111;
                1: row_pattern = 5'b00001;
                2: row_pattern = 5'b00010;
                3: row_pattern = 5'b00100;
                4: row_pattern = 5'b01000;
                5: row_pattern = 5'b01000;
                6: row_pattern = 5'b01000;
                default: row_pattern = 5'b00000;
            endcase
            4'd8: case (row)
                0: row_pattern = 5'b01110;
                1: row_pattern = 5'b10001;
                2: row_pattern = 5'b10001;
                3: row_pattern = 5'b01110;
                4: row_pattern = 5'b10001;
                5: row_pattern = 5'b10001;
                6: row_pattern = 5'b01110;
                default: row_pattern = 5'b00000;
            endcase
            4'd9: case (row)
                0: row_pattern = 5'b01110;
                1: row_pattern = 5'b10001;
                2: row_pattern = 5'b10001;
                3: row_pattern = 5'b01111;
                4: row_pattern = 5'b00001;
                5: row_pattern = 5'b00010;
                6: row_pattern = 5'b01100;
                default: row_pattern = 5'b00000;
            endcase
            default: row_pattern = 5'b00000;
        endcase
    end

    assign pixel = row_pattern[4 - col];

endmodule
