`timescale 1 ns / 1 ps

module ltc2387_deserializer_twolane
#(
  parameter NUM_ADC = 1,
  parameter CLOCK_PERIOD = 4
)(
  input wire rst,
  input wire clk,  // must be clk_cnv divided by 2
  input wire clk_cnv, // clk_cnv domain signals (expected 250MHz)
  input wire start, // start conversion, can be left high to convert at fastest possible rate
  input wire [63:0] in_ts, // input timestamp, captured on convert signal
  input wire [7:0] sample_rate, // number of clock cycles to wait, only used if above CONV_WAIT time
  output reg ready, // ready for another conversion start
  output reg adc_cnv, // conversion start request
  output reg adc_clk, // clock send to ADC

  input wire [NUM_ADC-1:0][8:0] adc_ch_load, // delay in time (ps), on DCO/DA/DB lines
  output wire [NUM_ADC-1:0][8:0] adc_ch_delay, // delay in time (ps), on DCO/DA/DB lines

  // read clock domain (expected 125MHz)
  input wire [NUM_ADC-1:0] adc_dco, // DCO from ADC
  input wire [NUM_ADC-1:0] adc_da,  // DA from ADC
  input wire [NUM_ADC-1:0] adc_db,  // DB from ADC

  output reg q_valid,
  output reg [63:0] q_ts,
  output reg [NUM_ADC-1:0] q_ch_valid, // q valid
  output reg [NUM_ADC-1:0][17:0] q_data // deserialized adc data
);

localparam READ_CLOCK_PERIOD = CLOCK_PERIOD * 2;

localparam integer DCO_CLOCK_COUNT = (5*2); // twice to account for rise+fall edges

// How many clock cycles do we need to hold convert high, required time is 5ns
localparam integer CNV_HIGH_CLOCK = (CLOCK_PERIOD < 5) ? $ceil(5 / CLOCK_PERIOD) : 1;

// Wait after conversion high to start reading back
localparam integer READ_START = $ceil(65 / CLOCK_PERIOD);
localparam integer READ_TIME = (5 * READ_CLOCK_PERIOD);
localparam integer READ_DELAY = $ceil((5 * READ_CLOCK_PERIOD) - 49);
localparam integer READ_DELAY_CORRECTION = (READ_DELAY > 0) ? $ceil(READ_DELAY / CLOCK_PERIOD) : 0;

// Wait after conversion high to start reading back, typically should match (or be very close)
// to the READ_START, but can be longer if our expected readback rate is quite low
localparam integer CONV_WAIT = $ceil(66.67 / CLOCK_PERIOD) + READ_DELAY_CORRECTION;

// counter to hold place in conversion cycle
reg [7:0] cnv_count;
reg [$clog2(DCO_CLOCK_COUNT+1)-1:0] dco_count;
reg [READ_START-1:0] read_shift;
reg [NUM_ADC-1:0][19:0] data;
reg [NUM_ADC-1:0][9:0] dco;

reg [63:0] in_ts_captured; // hold on to timestamp

reg [7:0] conv_wait_time;

wire [NUM_ADC-1:0] da_r;
wire [NUM_ADC-1:0] da_f;
wire [NUM_ADC-1:0] db_r;
wire [NUM_ADC-1:0] db_f;
wire [NUM_ADC-1:0] dco_r;
wire [NUM_ADC-1:0] dco_f;

wire ready_to_convert = (cnv_count == 0) ? 1'b1 : 1'b0;
wire converting = (ready_to_convert && start) ? 1'b1 : 1'b0;

wire wr_ena = read_shift[0];
wire [63:0] ts_d;
wire ts_valid;
wire full;
wire empty;
wire rd_busy;
wire wr_busy;

// Conversion handling, we use a shift register to let read side know when to clock out DCO
always@(posedge clk_cnv) begin
  if(rst || wr_busy) begin
    ready <= 1'b0;
    cnv_count <= 0;
    read_shift <= 0;
    adc_cnv <= 1'b0;
    in_ts_captured <= 0;
    conv_wait_time <= 0;
  end else begin

    conv_wait_time <= (sample_rate < CONV_WAIT) ? CONV_WAIT : sample_rate;
    ready <= ready_to_convert;
    cnv_count <= (ready_to_convert) ? (start) ? conv_wait_time - 1 : 0 : cnv_count - 1'b1;
    read_shift <= {{ ready_to_convert && start }, read_shift[READ_START-1:1] };
    adc_cnv <= converting;

    // Due to nature of ADC conversion rate, at 'worst' DCO clock out happens on same beat as
    // new conversion, this means the correct timestamp should still be in the register
    in_ts_captured <= (converting) ? in_ts : in_ts_captured;
  end
end

// ADC Output Clock Logic
always@(posedge clk_cnv) begin
  if(rst) begin
      dco_count <= 0;
      adc_clk <= 0;
  end else begin
      adc_clk <= dco_count[0];
      dco_count <= (read_shift[0]) ? DCO_CLOCK_COUNT - 1 : (dco_count > 0) ? dco_count - 1'b1 : 0;
  end
end

// Capture timestamp on convert signal, but send the timestamp on start of DCO
// If no proper DCO bit pattern is seen before next timestamp, alignment was invalid
adc_ts_fifo ts_fifo (
    .srst( rst ),
    .wr_clk( clk_cnv ),
    .wr_rst_busy(wr_busy), // can't start conversions until this is low
    .rd_clk( clk ),
    .din( in_ts_captured ),
    .wr_en( wr_ena ),
    .rd_en( 1'b1 ),
    .dout( ts_d ),
    .valid( ts_valid ),

    // Just ignore these
    .full(full),
    .empty(empty),
    .rd_rst_busy(rd_busy)
);

reg [3:0] q_count;
reg [63:0] ts;

// We have two possibilities, as the read clock is half the speed of the 'write' clock
always@(posedge clk) begin
  if(rst) begin
    q_count <= 0;
    q_ts <= 0;
    q_valid <= 0;
    ts <= 0;
  end else begin
    if(ts_valid) begin
      q_count <= 3;
      q_valid <= 0;
      q_ts <= 0;
      ts <= ts_d;
    end else begin
      q_count <= (q_count > 0) ? q_count - 1'b1 : 0;
      if(q_count == 1) begin
        q_valid <= 1'b1;
        q_ts <= ts;
      end else begin
        q_valid <= 1'b0;
        q_ts <= 0;
      end
      ts <= ts;
    end
  end
end

wire delay_rdy;

IDELAYCTRL #(
  .SIM_DEVICE("ULTRASCALE")
) delay_ctrl (
  .RST(rst),
  .REFCLK(clk_cnv),
  .RDY(delay_rdy)
);


genvar n;
generate
for ( n = 0; n < NUM_ADC; n = n + 1) begin

  // Capture logic
  always@(posedge clk) begin
    data[n] <= { data[n][15:0], da_r[n], db_r[n], da_f[n], db_f[n] };
    dco[n] <= { dco[n][7:0], dco_r[n], dco_f[n]};
  end

  // We have two possibilities, as the read clock is half the speed of the 'write' clock
  always@(posedge clk) begin
    if(rst || q_valid) begin
        q_ch_valid[n] <= 1'b0;
        q_data[n] <= 0;
    end else begin
      if(dco[n] == 10'h0AA) begin
        q_ch_valid[n] <= 1'b1;
        q_data[n] <= data[n][17:0];
      end else if(dco[n] == 10'h155) begin
        q_ch_valid[n] <= 1'b1;
        q_data[n] <= data[n][19:2];
      end else begin
        q_ch_valid[n] <= q_ch_valid[n];
        q_data[n] <= q_data[n];
      end
    end
  end

  wire lane_dco;
  wire lane_db;
  wire lane_da;

  delay_reset_seq #(
    .CLOCK_FREQ(250.0)
  ) dco_delay (
    .rst(rst),
    .clk(clk_cnv),
    .rdy(delay_rdy),
    .d(adc_dco[n]),
    .q(lane_dco),

    .load_value(adc_ch_load[n]),
    .delay_value(adc_ch_delay[n]),
    .done()
  );

  delay_reset_seq #(
    .CLOCK_FREQ(250.0)
  ) da_delay (
    .rst(rst),
    .clk(clk_cnv),
    .rdy(delay_rdy),
    .d(adc_da[n]),
    .q(lane_da),

    .load_value(adc_ch_load[n]),
    .delay_value(),
    .done()
  );

  delay_reset_seq #(
    .CLOCK_FREQ(250.0)
  ) db_delay (
    .rst(rst),
    .clk(clk_cnv),
    .rdy(delay_rdy),
    .d(adc_db[n]),
    .q(lane_db),

    .load_value(adc_ch_load[n]),
    .delay_value(),
    .done()
  );

  IDDRE1 #(
  .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
  .IS_CB_INVERTED(1)
  ) ddr_dco (
    .R(rst),   // 1-bit reset
    .C(clk),   // 1-bit clock input
    .CB(clk),
    .D(lane_dco),   // 1-bit DDR data input
    .Q1(dco_r[n]), // 1-bit output for positive edge of clock
    .Q2(dco_f[n]) // 1-bit output for negative edge of clock
  );

  IDDRE1 #(
    .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
    .IS_CB_INVERTED(1)
  ) ddr_da (
    .R(rst),   // 1-bit reset
    .C(clk),   // 1-bit clock input
    .CB(clk),
    .D(lane_da),   // 1-bit DDR data input
    .Q1(da_r[n]), // 1-bit output for positive edge of clock
    .Q2(da_f[n]) // 1-bit output for negative edge of clock
  );

  IDDRE1 #(
    .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
    .IS_CB_INVERTED(1)
  ) ddr_db (
    .R(rst),   // 1-bit reset
    .C(clk),   // 1-bit clock input
    .CB(clk),
    .D(lane_db),   // 1-bit DDR data input
    .Q1(db_r[n]), // 1-bit output for positive edge of clock
    .Q2(db_f[n]) // 1-bit output for negative edge of clock
  );

end
endgenerate

endmodule
