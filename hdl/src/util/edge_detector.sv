module rising_edge_detector(
    input wire clk,
    input wire rst,
    input wire d,
    output wire q
);

reg prev_d;

assign q = (rst) ? 1'b0 : d & ~prev_d;

always@(posedge clk) begin
    prev_d <= d;
end

endmodule

module falling_edge_detector(
    input wire clk,
    input wire rst,
    input wire d,
    output wire q
);

reg prev_d;

assign q = (rst) ? 1'b0 : ~d & prev_d;

always@(posedge clk) begin
    prev_d <= d;
end

endmodule

module either_edge_detector(
    input wire clk,
    input wire rst,
    input wire d,
    output wire q
);

reg prev_d;

assign q = (rst) ? 1'b0 : d ^ prev_d;

always@(posedge clk) begin
    prev_d <= d;
end

endmodule