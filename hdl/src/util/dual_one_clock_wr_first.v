`timescale 1 ns / 1 ps

module dual_one_clock_wr_first #(
    parameter WIDTH = 1,
    parameter DEPTH = 1
)(
    input wire clk,
    input wire wr_ena,
    input wire [$clog2(DEPTH)-1:0] wr_addr,
    input wire [$clog2(DEPTH)-1:0] rd_addr,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

reg [WIDTH-1:0] ram [DEPTH-1:0];

always @(posedge clk) begin
    if (wr_ena) begin
        ram[wr_addr] <= d;
    end
end

always @(posedge clk) begin
    q <= ram[rd_addr];
end

endmodule