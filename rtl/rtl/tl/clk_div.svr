module clk_div (
    input  logic clk100mhz,
    input  logic reset,
    output logic pixel_tick
);

    logic [1:0] count;

    always_ff @(posedge clk100mhz or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else
            count <= count + 2'b01;
    end

    assign pixel_tick = (count == 2'b00); // one pulse every 4 cycles

endmodule
