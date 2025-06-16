module axi_stream_ts_data #(
  	parameter ID = 0,
  	parameter MAX_PKT_LEN = 64,
  	parameter DEPTH_BITS = 8
)(
	input wire clk,
	input wire rst,

  	input wire ena,
  	input wire [63:0] in_timestamp,
	input wire [15:0] in_num_samples,

  	input wire [63:0] in_tdata,
	input wire in_tvalid,
  	input wire in_tlast,
	output reg in_tready,

  	output reg [63:0] out_tdata,
	output reg out_tfirst,
	output reg out_tlast,
	output reg out_tvalid,
	input wire out_tready,

        output wire [63:0] strm_dbg_out
);
assign strm_dbg_out = {
   1'b0, in_pkts,
   word_cnt,
   out_tfirst, out_tlast, out_tvalid, out_tready,                last_word, in_tvalid, in_tlast, in_tready,
         out_tlast,buf_not_empty,in_captured,wr_ena,             in_state[3:0], 
   wr_pos[3:0], rd_pos[3:0], in_pkts[3:0],in_pkts[3:0]
};
// Usual pattern 0011 0101 0111 0010
//   out_tfirst, out_tlast             always zero
//   out_valid                         always high
//   out_tready                        high, low every 11 clks
//
//                                     0
//   in_tvalid                         always high
//   in_tlast                          always low
//   in_tready                         always high
//   
//   out_tlast                         always low
//   buf_not_empty                     always high     
//   in_captured                       always high
//   wr_ena                            always high except 1 clk on state idle
//
//   state[4] - idle or data
   
localparam INT_MAX_PKT_LEN = (MAX_PKT_LEN < 3) ? 3 : (MAX_PKT_LEN > 65536) ? 65536 : MAX_PKT_LEN;
localparam INT_MAX_SAMPLES = INT_MAX_PKT_LEN - 2;
// Set memory to power of 2
localparam DEPTH = 2**DEPTH_BITS; // we need two extra words available per packet
localparam SZ_AXI_WIDTH = 64 + 1; // tdata + tlast
localparam SZ_DEPTH = $clog2(DEPTH);

wire in_captured = in_tvalid && in_tready;
wire out_captured = out_tvalid && out_tready;

reg [31:0] num_pkts_in;
reg wr_ena;
reg [SZ_AXI_WIDTH-1:0] wr_dat;
reg [15:0] wr_cnt;
reg [SZ_DEPTH:0] wr_pos;
reg [SZ_DEPTH:0] wr_start;
reg [SZ_DEPTH:0] rd_pos;
reg [SZ_AXI_WIDTH-1:0] r_data [DEPTH-1:0];
reg [SZ_DEPTH-1:0] in_pkts;
reg [SZ_DEPTH-1:0] out_pkts;
reg [63:0] r_timestamp;
reg [15:0] max_samples;
reg [16:0] max_pkt_len;

enum int unsigned { ST_IDLE = 1, ST_DATA = 2, ST_WR_LEN = 4, ST_WR_TS = 8, ST_WR_UPDATE = 16 } in_state;

// inferred ram block with pass through logic to match read-during-write behaviour
always@(posedge clk) begin
	if(wr_ena)
		r_data[wr_pos[SZ_DEPTH-1:0]] <= wr_dat;
end

reg [15:0] word_cnt;
wire buf_not_empty = (in_pkts - out_pkts != 0);
wire last_word     = (word_cnt == 16'h0);
// read side logic
always@(posedge clk) begin
   if(rst) begin
      word_cnt <= 16'h0;
      out_pkts   <= 0;
      rd_pos 	 <= 0;
      out_tvalid <= 1'b0;
      out_tlast  <= 1'b0;
      out_tfirst <= 1'b0;
      out_tdata  <= 0;
   end else begin
      if(out_tvalid) begin
         if(out_tready) begin
            word_cnt <= word_cnt - 16'h1;
            rd_pos      <= (out_tlast) ? rd_pos : rd_pos + 1'b1;
	    //out_tlast   <= last_word;
	    out_tlast   <= (out_tlast) ? 1'b0 : r_data[rd_pos[SZ_DEPTH-1:0]][SZ_AXI_WIDTH-1];
	    out_tdata   <= (out_tlast) ? 0 : r_data[rd_pos[SZ_DEPTH-1:0]][63:0];
	    out_pkts    <= (out_tlast) ? out_pkts + 1'b1 : out_pkts;
	    out_tvalid	<= (out_tlast) ? 1'b0 : 1'b1;
	    out_tfirst  <= 1'b0;
	 end else begin
            word_cnt <= word_cnt;
	    rd_pos 	<= rd_pos;
	    out_tdata <= out_tdata;
	    out_tlast <= out_tlast;
	    out_tvalid	<= out_tvalid;
	    out_pkts <= out_pkts;
	    out_tfirst <= out_tfirst;
	 end
      end else begin // if (out_tvalid)
         word_cnt   <= buf_not_empty ? r_data[rd_pos[SZ_DEPTH-1:0]][15:0] : 16'h0;
         rd_pos     <= buf_not_empty ? rd_pos + 1'b1 : rd_pos;
         out_tlast  <= buf_not_empty ? r_data[rd_pos[SZ_DEPTH-1:0]][SZ_AXI_WIDTH-1] : 1'b0;
         out_tdata  <= buf_not_empty ? r_data[rd_pos[SZ_DEPTH-1:0]][63:0] : {64{1'b0}};
         out_tvalid <= buf_not_empty ? 1'b1 : 1'b0;
         out_tfirst <= buf_not_empty ? 1'b1 : 1'b0;
         out_pkts   <= out_pkts;
      end
   end
end

reg space_check;
reg [SZ_DEPTH:0] used;

always@(posedge clk) begin
	if(rst) begin
    	space_check <= 0;
		used <= 0;
	end else begin
		used <= (wr_start - rd_pos);
      space_check <= (DEPTH - used) > MAX_PKT_LEN ? 1'b1 : 1'b0;
	end
end

always@(posedge clk) begin
	if(rst) begin
		num_pkts_in <= 0;
		in_tready <= 1'b0;
		in_pkts <= 0;
		wr_ena <= 1'b0;
		wr_pos <= 0;
		wr_cnt <= 0;
		wr_start <= 0;
		in_state <= ST_IDLE;
		max_samples <= 0;
	end else begin
		case(in_state)

		ST_IDLE: begin
			wr_pos <= wr_start + 2;
                        wr_start <= wr_start;
                  	in_pkts <= in_pkts;
			r_timestamp <= in_timestamp;
			max_samples <= (in_num_samples > INT_MAX_SAMPLES) ? INT_MAX_SAMPLES - 1'b1 : in_num_samples - 1'b1;
			// Did we capture data?
			if(in_captured && ena) begin
			   num_pkts_in <= num_pkts_in + 1'b1;
             		   wr_cnt <= 2;
            		   if(max_pkt_len == 3)  begin
              		      wr_dat <= { 1'b1, in_tdata };
              		      in_tready <= 1'b0;
    	       		      in_state <= ST_WR_LEN;
			      wr_ena <= 1'b1;
             		   end else begin
             		      wr_dat <= { 1'b0, in_tdata };
              		      in_tready <= 1'b1;
    	     		      in_state <= ST_DATA;
            		      wr_ena <= 1'b1;
           		   end
			end else begin
              		   wr_cnt <= 0;
			   num_pkts_in <= num_pkts_in;
		      	   in_tready <= (space_check) ? 1'b1 : 1'b0;
			   in_state <= ST_IDLE;
			   wr_ena <= 1'b0;
			end
		end

		ST_DATA: begin
			max_samples <= max_samples;
			if(in_captured) begin
            		   // If enable goes low, finish up packet and send it
           		   // can't drop packet, otherwise space_avail will no longer
           		   // be valid
           		   if (in_tlast || !ena || (wr_cnt > max_samples)) begin
            		      in_tready 	<= 1'b0;
            		      in_state <= ST_WR_LEN;
             		      wr_start <= wr_start;
             		      wr_pos <= wr_pos + 1'b1;
             		      wr_ena <= 1'b1;
             		      wr_cnt <= wr_cnt + 1'b1;
             		      wr_dat <= {1'b1, in_tdata};
            	    	   end else begin
			      in_tready 	<= 1'b1;
			      in_state <= ST_DATA;
                              wr_start <= wr_start;
		              wr_pos <= wr_pos + 1'b1;
			      wr_ena <= 1'b1;
               	  	      wr_cnt <= wr_cnt + 1'b1;
               	  	      wr_dat <= {1'b0, in_tdata};
                           end
			end else if (!ena) begin
			   // Enable went low outside of a valid in word
		           // finish up and re-write last data pos with tlast high
			   in_tready 	<= 1'b0;
                  	   in_state <= ST_WR_LEN;
                 	   wr_start <= wr_start;
                	   wr_pos <= wr_pos;
                	   wr_ena <= 1'b1;
                 	   wr_cnt <= wr_cnt + 1;
                 	   wr_dat <= {1'b1, wr_dat[63:0]};
			end else begin
		       	   // wait for data to continue
			   // we store last word in case we have to go back and add
			   // tlast to it
              	           wr_dat <= wr_dat;
			   in_tready <= 1'b1;
		           in_state <= ST_DATA;
			   wr_start <= wr_start;
			   wr_pos <= wr_pos;
			   wr_ena <= 1'b0;
			   wr_cnt <= wr_cnt;
			end
			num_pkts_in <= num_pkts_in;
                        in_pkts <= in_pkts;
               	        r_timestamp <= r_timestamp;
		end

		ST_WR_LEN: begin
			max_samples <= max_samples;
                        in_pkts <= in_pkts;
			in_tready <= 1'b0;
			in_state <= ST_WR_TS;
			wr_start <= wr_pos + 1'b1;
			wr_pos	<= wr_start;
			wr_ena 	<= 1'b1;
			wr_cnt	<= 0;
          		wr_dat	<= {1'b0, ID[7:0], 8'h0, num_pkts_in, wr_cnt[15:0]};
          		r_timestamp <= r_timestamp;
		       	num_pkts_in <= num_pkts_in;
		end

		ST_WR_TS: begin
			max_samples <= max_samples;
            		in_pkts <= in_pkts;
			in_tready <= 1'b0;
			in_state <= ST_WR_UPDATE;
			wr_start <= wr_start;
			wr_pos	<= wr_pos + 1;
			wr_ena 	<= 1'b1;
			wr_cnt	<= 0;
          	wr_dat	<= {1'b0, r_timestamp[63:0]};
            r_timestamp <= r_timestamp;
			num_pkts_in <= num_pkts_in;
		end

        ST_WR_UPDATE: begin
			max_samples <= max_samples;
            in_pkts <= in_pkts + 1'b1;
			in_tready <= 1'b0;
			in_state <= ST_IDLE;
			wr_start <= wr_start;
			wr_pos	<= wr_start;
			wr_ena 	<= 1'b0;
			wr_cnt	<= 0;
          	wr_dat	<= 0;
            r_timestamp <= r_timestamp;
			num_pkts_in <= num_pkts_in;
		end

		default: begin
			num_pkts_in <= 0;
			in_tready <= 1'b0;
			in_pkts <= 0;
			wr_ena <= 1'b0;
			wr_pos <= 0;
			wr_cnt <= 0;
			wr_start <= 0;
			in_state <= ST_IDLE;
			max_samples <= 0;
		end

		endcase

	end
end

endmodule
