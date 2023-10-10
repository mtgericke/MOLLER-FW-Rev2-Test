module adc_mux #(
    parameter NUM_CH = 8,
    parameter WIDTH = 18
)(
    input wire clk,
    input wire rst,
    input wire [$clog2(NUM_CH)-1:0] ch,
    input wire [NUM_CH-1:0][WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always@(posedge clk) begin
    if(rst) begin
        q <= {WIDTH{1'b0}};
    end begin
        q <= d[ch];
    end
end

endmodule