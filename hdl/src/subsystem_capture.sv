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
    input wire 			       rst,
    input wire 			       clk,

    input wire 			       ena,
    input wire 			       start,
    input wire [3:0] 		       cap_region,
    //input wire                         win_end,
    input wire [1:0] 		       trigger,
    input wire [63:0] 		       in_timestamp,
    input wire 			       sample_valid,
    input wire [NUM_CH-1:0][WIDTH-1:0] sample_ch_data,
    input wire [NUM_CH-1:0] 	       sample_ch_valid,

    // streaming output
    output wire [63:0] 		       fifo_tdata,
    output wire 		       fifo_tvalid,
    output wire 		       fifo_tlast,
    input wire 			       fifo_tready
);

   reg 				       started;
   reg [63:0] 			       cap_ts;
   reg [63:0] 			       samples_captured;
   reg [63:0] 			       pkt_counter;   

   reg [NUM_CH-1:0][63:0] 	       ch_sample_count;
   reg [NUM_CH-1:0][63:0] 	       ch_sample_count_win;  //total count over the entire window (all regions) for a given channel
   reg signed [NUM_CH-1:0][63:0]       ch_sum;
   reg signed [NUM_CH-1:0][63:0]       ch_sum_win;
   reg signed [NUM_CH-1:0][63:0]       ch_sum_of_squares;
   reg signed [NUM_CH-1:0][63:0]       ch_sum_of_squares_win;
   reg [NUM_CH-1:0][63:0] 	       ch_misc;	       
   reg signed [NUM_CH-1:0][19:0]       ch_min;
   reg signed [NUM_CH-1:0][19:0]       ch_max;
   wire 			       captured;
   
   // capture on start signal after we've been already started
   // or if we were started and we get turned off (ena goes low)
   // assign captured = (!start && started);
   reg 				       start_reg;  always@(posedge clk) start_reg <= start;
   assign captured = (start && !start_reg && started) || (!ena && started);
   reg 				       cap_reg;  always @(posedge clk) cap_reg <= captured;
   reg [15:0] 			       cap_cnt; always @(posedge clk) cap_cnt <= captured ? cap_cnt + 16'h1 : cap_cnt;
   wire 			       init_mm;
   assign init_mm = start && !start_reg;
/* -----\/----- EXCLUDED -----\/-----
   wire 			       init_win_sums;
   assign init_win_sums = start && !started;
 -----/\----- EXCLUDED -----/\----- */
   

   genvar 			       n;
   generate

      for(n=0; n<NUM_CH; n = n+1) begin
	 
	 reg result_valid;
	 reg signed [19:0] result_sum;
	 reg [63:0] result_sq;
	 
	 always@(posedge clk) begin
	    if(rst) begin
	       ch_sample_count[n] <= 0;
	       ch_sum[n] <= 0;
	       ch_sum_of_squares[n] <= 0;
	       ch_sample_count_win[n] <= 0;
	       ch_sum_win[n] <= 0;
	       ch_sum_of_squares_win[n] <= 0;
	       ch_min[n] <= 20'h7FFFF;
	       ch_max[n] <= 20'h80000;
	       result_sum <= 0;
	       result_sq <= 0;
	       result_valid <= 1'b0;
	    end else begin
	       
	       result_valid <= sample_valid && sample_ch_valid[n];
	       result_sq <= $signed(sample_ch_data[n]) * $signed(sample_ch_data[n]);
	       result_sum <= sample_ch_data[n][17] ? {2'h3,sample_ch_data[n]} : {2'h0,sample_ch_data[n]}; //$signed(sample_ch_data[n]);

	       if(init_mm) begin
		  ch_min[n] <= 20'h7FFFF;
		  ch_max[n] <= 20'h80000;
		  if(!started) begin
		     ch_sum_win[n] <= 0;
		     ch_sum_of_squares_win[n] <= 0;
		     ch_sample_count_win[n] <= 0;
		  end
	       end else if( cap_reg ) begin
	       // on capture reset the counters,
		  if(ena && result_valid) begin
		     ch_sum[n] <= result_sum[19] ? $signed({44'hFFFFFFFFFFF,result_sum}) :  $signed({44'h0,result_sum});
		     ch_sum_of_squares[n] <= result_sq;
		     ch_sample_count[n] <= 1'b1;
		     ch_min[n] <= 20'h7FFFF;
		     ch_max[n] <= 20'h80000;
		     //ch_min[n] <= result_sum;
		     //ch_max[n] <= result_sum;
		  end else begin
		     ch_sum[n] <= 0;
		     ch_sum_of_squares[n] <= 0;
		     ch_sample_count[n] <= 0;
		     ch_min[n] <= 20'h7FFFF;
		     ch_max[n] <= 20'h80000;
		  end
	       end else begin
		  if(((ena & start) || (started)) && result_valid ) begin
		     ch_sum[n]            <= $signed(ch_sum[n]) + (result_sum[19] ? $signed({44'hFFFFFFFFFFF,result_sum}) :  $signed({44'h0,result_sum}));//result_sum;
		     ch_sum_of_squares[n] <= ch_sum_of_squares[n] + result_sq;
		     ch_sample_count[n]   <= ch_sample_count[n] + 1'b1;
		     
		     ch_sum_win[n]        <= $signed(ch_sum_win[n]) + (result_sum[19] ? $signed({44'hFFFFFFFFFFF,result_sum}) :  $signed({44'h0,result_sum}));//result_sum;
		     ch_sum_of_squares_win[n] <= ch_sum_of_squares_win[n] + result_sq;
		     ch_sample_count_win[n] <= ch_sample_count_win[n] + 1'b1;
		     
		     ch_min[n] <= ($signed(result_sum) < $signed(ch_min[n])) ? result_sum : ch_min[n];
		     ch_max[n] <= ($signed(result_sum) > $signed(ch_max[n])) ? result_sum : ch_max[n];
		     ch_misc[n] <= {22'h0,trigger,ch_min[n],ch_max[n]};

 		  end else begin
		     ch_sum[n] <= ch_sum[n];
		     ch_sum_of_squares[n] <= ch_sum_of_squares[n];
		     ch_sample_count[n] <= ch_sample_count[n];
		     
		     ch_sum_win[n] <= ch_sum_win[n];
		     ch_sum_of_squares_win[n] <= ch_sum_of_squares_win[n];
		     ch_sample_count_win[n] <= ch_sample_count_win[n];
		     
		     ch_min[n] <= ch_min[n];
		     ch_max[n] <= ch_max[n];
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
            if(cap_reg) begin
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
    .NUM_INPUTS(16+16+16+16+16+16+16+3),
    .WIDTH(64)
) integration_packetizer (
    .clk(clk),
    .rst(rst),
    .capture(cap_reg),
    .d({
        ch_sum_of_squares,
	ch_sum,
	ch_sample_count,
        ch_sum_of_squares_win,
	ch_sum_win,
	ch_sample_count_win,
	ch_misc,
        samples_captured,
        cap_region, pkt_counter[59:0],
	cap_ts}),
    .tready	(fifo_tready),
    .tdata	(fifo_tdata),
    .tvalid	(fifo_tvalid),
    .tlast	(fifo_tlast)
);

endmodule
