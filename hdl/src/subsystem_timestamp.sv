module subsystem_timestamp #(
    parameter WIDTH = 64
)(
    input wire clk,
    input wire rst,

    input wire load,
    input wire [WIDTH-1:0] load_ts,

    output reg [WIDTH-1:0] ts
);

// Timestamp logic
always@(posedge clk) begin
	ts <= (rst) ? 0 : (load) ? load_ts : ts + 1'b1;
end

endmodule