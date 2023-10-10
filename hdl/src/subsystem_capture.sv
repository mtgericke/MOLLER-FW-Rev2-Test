/*
    Captures ADC data and sums + sum_of_squares it
    Relies on the fact sample_valid can only occur every
    68 / 8ns = ~8 clock cycles (not 9!) from the deserializer which runs at 250Mhz
    This means we have 7 'empty' clock cycles after each sample_valid
*/

module subsystem_capture #(
    parameter NUM_CH = 16,
    parameter WIDTH = 18
)(
    input wire rst,
    input wire clk,

    input wire ena,
    input wire start,

    input wire [63:0] in_timestamp,
    input wire sample_valid,
    input wire [NUM_CH-1:0][WIDTH-1:0] sample_ch_data,
    input wire [NUM_CH-1:0] sample_ch_valid,

    // streaming output
    output wire [63:0] fifo_tdata,
    output wire fifo_tvalid,
    output wire fifo_tlast,
    input wire fifo_tready
);

reg started;
reg [63:0] cap_ts;
reg [63:0] samples_captured;
reg [63:0] pkt_counter;

reg [NUM_CH-1:0][63:0] ch_sample_count;
reg signed [NUM_CH-1:0][63:0] ch_sum;
reg signed [NUM_CH-1:0][63:0] ch_sum_of_squares;
wire captured;

// capture on start signal after we've been already started
// or if we were started and we get turned off (ena goes low)
// assign captured = (!start && started);
assign captured = 1'b0;

genvar n;
generate

for(n=0; n<NUM_CH; n = n+1) begin

reg result_valid;
reg signed [63:0] result;

always@(posedge clk) begin

    if(rst) begin
        ch_sample_count[n] <= 0;
        ch_sum[n] <= 0;
        ch_sum_of_squares[n] <= 0;
        result <= 0;
        result_valid <= 1'b0;
    end else begin

        result_valid <= sample_valid;
        result <= $signed(sample_ch_data[n]) * $signed(sample_ch_data[n]);

        // on capture reset the counters,
        if(captured) begin
            if(ena && result_valid && sample_ch_valid[n]) begin
                ch_sum[n] <= $signed(sample_ch_data[n]);
                ch_sum_of_squares[n] <= result;
                ch_sample_count[n] <= 1'b1;
            end else begin
                ch_sum[n] <= 0;
                ch_sum_of_squares[n] <= 0;
                ch_sample_count[n] <= 0;
            end
        end else begin
            if(((ena & start) || (started)) && result_valid && sample_ch_valid[n]) begin
                ch_sum[n] <= ch_sum[n] + $signed(sample_ch_data[n]);
                ch_sum_of_squares[n] <= ch_sum_of_squares[n] + result;
                ch_sample_count[n] <= ch_sample_count[n] + 1'b1;
            end else begin
                ch_sum[n] <= ch_sum[n];
                ch_sum_of_squares[n] <= ch_sum_of_squares[n];
                ch_sample_count[n] <= ch_sample_count[n];
            end
        end
    end
end
end

always@(posedge clk) begin
    if(rst) begin
        samples_captured <= 0;
        pkt_counter <= 0;
        started <= 0;
        cap_ts <= 0;
    end else begin
        pkt_counter <= (captured) ? pkt_counter + 1'b1 : pkt_counter;
        started <= (ena && start) ? 1'b1 : (!ena) ? 1'b0 : started;

        // on capture reset the counters,
        if(captured) begin
            if(ena && sample_valid) begin
                samples_captured <= 1;
                cap_ts <= in_timestamp;
            end else begin
                samples_captured <= 0;
                cap_ts <= 0;
            end
        end else begin
            if(((ena & start) || (started)) && sample_valid) begin
                samples_captured <= samples_captured + 1'b1;
                cap_ts <= (cap_ts == 0) ? in_timestamp : cap_ts;
            end else begin
                samples_captured <= samples_captured;
                cap_ts <= cap_ts;
            end
        end
    end
end

endgenerate

simple_packetizer #(
    .ID(8'hAA),
	.ENDIAN_SWAP(1'b0),
	.PREPEND_LEN(1),
    .NUM_INPUTS(16+16+16+3),
    .WIDTH(64)
) integration_packetizer (
    .clk(clk),
    .rst(rst),
    .capture(captured),
    .d({
        ch_sum_of_squares,
		ch_sum,
		ch_sample_count,
        samples_captured,
        pkt_counter,
		cap_ts}),
    .tready	(fifo_tready),
    .tdata	(fifo_tdata),
    .tvalid	(fifo_tvalid),
    .tlast	(fifo_tlast)
);

endmodule