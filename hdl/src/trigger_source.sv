`timescale 1 ns / 1 ps

// Fire trigger depending on edge_trigger
// MSB = rising edge
// LSB = falling edge
// Allow triggering on rise,fall,both, or none (pass-thru)
module trigger_source #(
    parameter CLOCK_FREQ = 0
)(
    input wire clk,
    input wire rst,
    input wire d,

    // control options
    input wire invert,
    input wire [1:0] edge_trigger, // which edge to trigger on (MSB = rise, LSB = fall)

    output reg [31:0] toggle_count, // number of edge changes since reset
    output reg [31:0] toggle_rate, // rate of edge changing per clock freq period
    output reg toggle_rate_strobe, // strobe when toggle_rate updates
    output reg q
);

reg d_prev;
reg [31:0] clock_period;
reg [31:0] toggle_rate_count;

always@(posedge clk) begin
    d_prev <= d;
    if(rst) begin
        toggle_count <= 0;
        toggle_rate <= 0;
        toggle_rate_count <= 0;
        toggle_rate_strobe <= 0;
        clock_period <= 0;
        q <= 0;
    end else begin
        toggle_count <= (d != d_prev) ? toggle_count + 1'b1 : toggle_count;
        if(clock_period < CLOCK_FREQ) begin
            toggle_rate <= toggle_rate;
            toggle_rate_count <= toggle_rate_count;
            toggle_rate_strobe <= 0;
            clock_period <= clock_period + 1'b1;
        end else begin
            toggle_rate <= toggle_count - toggle_rate_count;
            toggle_rate_count <= toggle_count;
            toggle_rate_strobe <= 1'b1;
            clock_period <= 0;
        end

        // Invert d and d_prev instead of storing an inverted d
        // prevents toggles happening when invert is toggled
        case(edge_trigger)
        2'b00: q <= (d ^ invert);
        2'b01: q <= (~(d ^ invert) & (d_prev ^ invert));
        2'b10: q <= ((d ^ invert) & ~(d_prev ^ invert));
        2'b11: q <= ((d ^ invert) ^ (d_prev ^ invert));
        endcase
    end
end

endmodule