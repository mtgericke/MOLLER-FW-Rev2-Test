module rate_counter(
    input wire clk,
    input wire rst,
    input wire d,
    output reg valid,
    output reg [31:0] rate
);

parameter CLK_FREQ = 125000000;

reg [31:0] on_cnts;
reg [31:0] cnt;

reg prev_d;

wire toggled_hi;

assign toggled_hi = (rst) ? 1'b0 : d & ~prev_d;

always@(posedge clk) begin
    prev_d <= d;
end

always@(posedge clk) begin
    if(rst) begin
        on_cnts <= 0;
        cnt <= 0;
        rate <= 0;
        valid <= 1'b0;
    end else begin
        // reset 'on count' on zero, the last 'on count' is added
        // directly to the rate
        on_cnts <= (cnt == 0) ? 0 : on_cnts + toggled_hi;
        rate <= (cnt == 0) ? on_cnts + toggled_hi : rate;
        valid <= (cnt == 0) ? 1'b1 : 1'b0;
        cnt <= (cnt > 0) ? cnt - 1'b1 : CLK_FREQ - 1;
    end
end

endmodule