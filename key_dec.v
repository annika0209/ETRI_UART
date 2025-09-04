module key_dec(
    input clk, rst,
    input [3:0] rx_data, // 4비트 UART 데이터
    input rx_busy,

    output reg is_digit, is_operator, is_enter, is_clear,
    output reg rx_valid
);

reg prev_busy;
always @(posedge clk or posedge rst) begin
    if (rst) prev_busy <= 1'b0;
    else     prev_busy <= rx_busy;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        is_digit    <= 0;
        is_operator <= 0;
        is_enter    <= 0;
        is_clear    <= 0;
        rx_valid    <= 0;
    end else begin
        rx_valid    <= (~rx_busy & prev_busy); // 1-clk pulse
        if (~rx_busy & prev_busy) begin
            is_digit    <= (rx_data <= 4'h9);
            is_operator <= (rx_data >= 4'hA && rx_data <= 4'hD);
            is_enter    <= (rx_data == 4'hE);
            is_clear    <= (rx_data == 4'hF);
        end else begin
            is_digit    <= 0;
            is_operator <= 0;
            is_enter    <= 0;
            is_clear    <= 0;
        end
    end
end

endmodule