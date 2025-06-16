module subsystem_stream_all #(
    parameter NUM_CH = 16
)(
    input wire clk,
    input wire rst,

    input wire [NUM_CH-1:0][17:0] data,
    input wire valid,
    input wire [63:0] timestamp,
    input wire [2:0] block,
    input wire ena,
    input wire all_chan,

    input wire [3:0] ch0_sel,
    input wire [3:0] ch1_sel,
    input wire [15:0] num_samples,
    input wire [6:0] rate_div,

    output wire [63:0] fifo_tdata,
    output wire fifo_tfirst,
    output wire fifo_tlast,
    output wire fifo_tvalid,
    input wire fifo_tready
);

reg in_tvalid;
reg [63:0] in_ts;
reg [19:0] div;
wire [19:0] scaled_div = ( rate_div[6:4] == 3'h0 ) ? {16'h0,rate_div[3:0]      } :
                         ( rate_div[6:4] == 3'h1 ) ? {14'h0,rate_div[3:0], 2'h0} :
                         ( rate_div[6:4] == 3'h2 ) ? {12'h0,rate_div[3:0], 4'h0} :
                         ( rate_div[6:4] == 3'h3 ) ? {10'h0,rate_div[3:0], 6'h0} :
                         ( rate_div[6:4] == 3'h4 ) ? { 8'h0,rate_div[3:0], 8'h0} :
                         ( rate_div[6:4] == 3'h5 ) ? { 6'h0,rate_div[3:0],10'h0} :
                         ( rate_div[6:4] == 3'h6 ) ? { 4'h0,rate_div[3:0],12'h0} :
                                                     { 2'h0,rate_div[3:0],14'h0};

reg [63:0] stream_in_ts;
reg stream_in_tvalid;
reg [63:0] stream_in_tdata;
reg [3:0] stream_in_beat;

wire [17:0] mux_ch0;
wire [17:0] mux_ch1;
wire in_tready; // TODO: use this to count any missing data?

// ADC Data muxes, we stream two channels at a time, split between even and odd channels
adc_mux #(
    .NUM_CH( NUM_CH )
) ch0_mux (
    .clk(clk),
    .rst(rst),
    .ch(ch0_sel),
    .d(data),
    .q(mux_ch0)
);

adc_mux #(
    .NUM_CH( NUM_CH )
) ch1_mux (
    .clk(clk),
    .rst(rst),
    .ch(ch1_sel),
    .d(data),
    .q(mux_ch1)
);

// The mux pipeline the data, so in_tvalid goes high when the data from the original valid arrives on
// the output of the mux
always@(posedge clk) begin
    in_ts <= timestamp; // pipeline delayed due to mux delay
    if(rst || (~ena)) begin
        in_tvalid <= 1'b0;
        div <= 20'h0;
    end else begin
        if(valid) begin
            in_tvalid <= (div == 0) ? 1'b1 : 1'b0;
            div <= (div > 0) ? div - 1'b1 : scaled_div; // TODO: make it load from regmap rate_div
        end else begin
            in_tvalid <= 1'b0;
            div <= div;
        end
    end
end

reg [NUM_CH-1:0][17:0] data_reg; always @(posedge clk) data_reg <= valid ? data : data_reg;

always@(posedge clk) begin
    stream_in_ts <= in_ts;
    if(rst) begin
        stream_in_beat <= 4'h0;
        stream_in_tvalid <= 1'b0;
        stream_in_tdata <= 0;
        stream_in_beat <= 0;
    end else begin
        if( all_chan ) begin
            if(in_tvalid) begin
                stream_in_beat <= 4'h1;
                if( stream_in_beat != 4'h5 ) stream_in_tdata <= 64'hffffffffffffffff; // mark error (will occur just after mode change)
                else stream_in_tdata <= {2'h0,data_reg[15][7:0],data_reg[2][17:0],data_reg[1][17:0],data_reg[0][17:0]};
                stream_in_tvalid <= 1'b1;
	    end else begin
                stream_in_beat  <= (stream_in_beat == 4'h5) ? 4'h5 : stream_in_beat + 4'h1;
                stream_in_tdata <= (stream_in_beat == 4'h1) ? {2'h0,data_reg[15][15: 8],data_reg[ 5][17:0],data_reg[ 4][17:0],data_reg[ 3][17:0]} :
                                   (stream_in_beat == 4'h2) ? {8'h0,data_reg[15][17:16],data_reg[ 8][17:0],data_reg[ 7][17:0],data_reg[ 6][17:0]} :
                                   (stream_in_beat == 4'h3) ? {10'h0,                   data_reg[11][17:0],data_reg[10][17:0],data_reg[ 9][17:0]} :
                                                              {10'h0,                   data_reg[14][17:0],data_reg[13][17:0],data_reg[12][17:0]};
                stream_in_tvalid <= stream_in_beat != 4'h5;
	    end
        end else if(ch0_sel == ch1_sel) begin
            if(in_tvalid) begin
                stream_in_beat <= stream_in_beat + 1'b1;
                if(stream_in_beat[0]) begin
                    stream_in_tvalid <= 1'b1;
                    stream_in_tdata <= { stream_in_tdata[31:0], {mux_ch0, block, rate_div, ch0_sel}};
                end else begin
                    stream_in_tvalid <= 1'b0;
                    stream_in_tdata <= { 32'h0, {mux_ch0, block, rate_div, ch0_sel}};
                end
            end else begin
                stream_in_tvalid <= 0;
                stream_in_tdata <= stream_in_tdata;
            end
        end else begin
            stream_in_tvalid <= in_tvalid;
            stream_in_tdata <= {{ mux_ch0, block, rate_div, ch0_sel},{ mux_ch1, block, rate_div, ch1_sel}};
        end
    end
end

axi_stream_ts_data #(
    .ID(8'hDD),
    .MAX_PKT_LEN(8192),
    .DEPTH_BITS(15)
) adc_data_streamer (
	.clk(clk),
	.rst(rst),

  	.ena(ena),
  	.in_timestamp(stream_in_ts),
  	.in_num_samples(num_samples),

  	.in_tdata(stream_in_tdata),
	.in_tvalid(stream_in_tvalid),
  	.in_tlast(1'b0),
	.in_tready(in_tready),

  	.out_tdata(fifo_tdata),
    .out_tfirst(fifo_tfirst),
	.out_tlast(fifo_tlast),
	.out_tvalid(fifo_tvalid),
	.out_tready(fifo_tready)
);

endmodule
