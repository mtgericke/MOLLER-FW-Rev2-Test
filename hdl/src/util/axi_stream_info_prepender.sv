/*
	Packet Length Prepender

	Takes in a AXI Stream packet and prepends the length of the packet to the start, increasing the size of the packet by one word.

	There is a two cycle delay between packets (this could be reduced, but at an increase in corner cases to be handled)

	Conditions Handled:

	- length exceeded, if the packet exceeds the maximum length given by MAX_PKT_LEN before a TLAST is received, all words received are
	discarded, and the packet capture starts again

	- single word packets are allowed

*/

module axi_stream_packet_info_length_prepender (
	clk,
	rst,

  	info,
    enable,
  	force_end,

	in_tlast,
	in_tdata,
	in_tvalid,
	in_tready,

	out_tlast,
	out_tvalid,
	out_tdata,
	out_tready
);

parameter ID = 0;
parameter ENDIAN_SWAP = 0;
parameter MAX_PKT_LEN = 368; // defaults to correct size for 1500 MTU
parameter NUM_PACKETS = 2;

// Set memory to power of 2
localparam DEPTH = 2**$clog2((MAX_PKT_LEN+1)*NUM_PACKETS); // we need an extra word available per packet
localparam SZ_DATA = 32;
localparam SZ_AXI_WIDTH = SZ_DATA + 1; // tdata + tlast
localparam SZ_DEPTH = $clog2(DEPTH);
localparam SZ_PKTS = $clog2(NUM_PACKETS+1);

input wire clk;
input wire rst;
input wire enable;
input wire [1:0][31:0] info;
input wire force_end;
input wire in_tlast;
input wire [SZ_DATA-1:0] in_tdata;
input wire in_tvalid;
output reg in_tready = 1'b0;

output reg out_tvalid = 1'b0;
output reg out_tlast = 1'b0;
output reg [SZ_DATA-1:0] out_tdata = 32'h0;
input wire out_tready;

wire in_captured = in_tvalid && in_tready;
wire out_captured = out_tvalid && out_tready;

reg wr_ena;
reg [1:0][31:0] r_info;
reg [31:0] wr_cnt;
reg [SZ_AXI_WIDTH-1:0] wr_dat;
reg [SZ_DEPTH-1:0] wr_pos;
reg [SZ_DEPTH-1:0] rd_pos;
reg [SZ_DEPTH-1:0] wr_start;

reg [SZ_AXI_WIDTH-1:0] r_data [DEPTH-1:0];

reg [SZ_PKTS-1:0] in_pkts;
reg [SZ_PKTS-1:0] out_pkts;

  enum int unsigned { ST_IDLE = 0, ST_DATA = 2, ST_WR_LEN = 4, ST_WR_DATA1 = 8, ST_WR_DATA2 = 16 } in_state;

// inferred ram block with pass through logic to match read-during-write behaviour
always@(posedge clk) begin
	if(wr_ena)
		r_data[wr_pos] <= wr_dat;
end

// read side logic
always@(posedge rst, posedge clk) begin
	if(rst) begin
		out_pkts <= 0;
		rd_pos 	<= 0;
		out_tvalid <= 1'b0;
        out_tlast <= 1'b0;
        out_tdata <= 0;
	end else begin
		if(out_captured) begin
			out_tlast <= (out_tlast) ? 1'b0 : (wr_pos == rd_pos) ? wr_dat[32] : r_data[rd_pos][32];
			out_tdata <= (out_tlast) ? 32'h0 : (wr_pos == rd_pos) ? wr_dat[31:0] : r_data[rd_pos][31:0];
			rd_pos 	<= (out_tlast) ? rd_pos : rd_pos + 1'b1;
			out_pkts <= (out_tlast) ? out_pkts + 1'b1 : out_pkts;
			out_tvalid	<= (out_tlast) ? 1'b0 : 1'b1; // changed to go low for one clock cycle after EOP
		end else if(out_tvalid) begin
            out_tdata <= out_tdata;
			out_tlast <= out_tlast;
			rd_pos 	<= rd_pos;
			out_tvalid	<= out_tvalid;
			out_pkts <= out_pkts;
        end else begin
			rd_pos 	<= (in_pkts - out_pkts != 0) ? rd_pos + 1'b1 : rd_pos;
			out_tlast <= (in_pkts - out_pkts != 0) ? (wr_pos == rd_pos) ? wr_dat[32] : r_data[rd_pos][32] : 1'b0;
			out_tdata <= (in_pkts - out_pkts != 0) ? (wr_pos == rd_pos) ? wr_dat[31:0] : r_data[rd_pos][31:0] : 32'h0;
            out_tvalid <= (in_pkts - out_pkts != 0) ? 1'b1 : 1'b0;
			out_pkts <= out_pkts;
        end
	end
end

always@(posedge rst, posedge clk) begin
	if(rst) begin
		in_tready <= 1'b0;
		in_pkts <= 0;
		wr_ena <= 1'b0;
		wr_pos <= 0;
		wr_start <= 0;
		in_state <= ST_IDLE;
	end else begin
		case(in_state)

		ST_IDLE: begin
			wr_pos <= wr_start + 2'h3;
            wr_start <= wr_start;
			wr_cnt <= 1;
			wr_dat <= { in_tlast, in_tdata };
			// Did we capture data?
			if(in_captured & enable) begin
				in_tready <= (in_tlast) ? 1'b0 : 1'b1;
				in_state <= (in_tlast) ? ST_WR_LEN : ST_DATA;
				in_pkts <= in_pkts;
				wr_ena <= 1'b1;
                r_info <= info;
			end else begin
				in_tready <= (in_pkts - out_pkts) < NUM_PACKETS ? 1'b1 : 1'b0;
				in_state <= ST_IDLE;
				in_pkts <= in_pkts;
				wr_ena <= 1'b0;
                r_info <= r_info;
			end
		end

		ST_DATA: begin
			if(in_captured) begin
                // silently drop packet being created if it exceeds the maximum byte size allowed
              if(wr_cnt > MAX_PKT_LEN) begin
					in_tready <= 1'b0;
					in_state <= ST_IDLE;
                    wr_start <= wr_start;
					wr_pos <= wr_start;
					wr_ena <= 1'b0;
                    wr_cnt <= 0;
                	wr_dat <= {in_tlast, in_tdata};
                // Write this last word and then go to write the length at start
              end else if (in_tlast | force_end) begin
                    in_tready 	<= 1'b0;
                    in_state <= ST_WR_LEN;
                    wr_start <= wr_start;
                    wr_pos <= wr_pos + 1'b1;
                    wr_ena <= 1'b1;
                    wr_cnt <= wr_cnt + 1'b1;
                	wr_dat <= {in_tlast | force_end, in_tdata};
                end else begin
					in_tready 	<= 1'b1;
					in_state <= ST_DATA;
                    wr_start <= wr_start;
					wr_pos <= wr_pos + 1'b1;
					wr_ena <= 1'b1;
                    wr_cnt <= wr_cnt + 1'b1;
                  	wr_dat <= {in_tlast, in_tdata};
                end
			end else begin
			    // wait for data to continue or finish up
                in_tready <= (force_end) ? 1'b0 : 1'b1;
                in_state <= (force_end) ? ST_WR_LEN: ST_DATA;
				wr_start <= wr_start;
              	wr_pos <= wr_pos;
                wr_ena <= (force_end) ? 1'b1 : 1'b0;
				wr_cnt <= wr_cnt;
                wr_dat <= {force_end, wr_dat[31:0]};
			end
            r_info <= r_info;
            in_pkts <= in_pkts;
            wr_dat <= wr_dat;
		end

		ST_WR_LEN: begin
            r_info <= r_info;
          	in_pkts <= in_pkts;
			in_tready <= 1'b0;
			in_state <= ST_WR_DATA1;
			wr_start <= wr_pos + 1'b1;
			wr_pos	<= wr_start;
			wr_ena 	<= 1'b1;
			wr_cnt	<= wr_cnt;
			wr_dat	<= (ENDIAN_SWAP) ? {1'b0, {<<8{wr_cnt[23:0]}}, ID[7:0]} : {1'b0, ID[7:0], wr_cnt[23:0]};
		end

        ST_WR_DATA1: begin
            r_info <= r_info;
            in_pkts <= in_pkts;
            in_tready <= 1'b0;
            in_state <= ST_WR_DATA2;
            wr_start <= wr_start;
		    wr_pos	<= wr_pos + 1'b1;
		    wr_ena 	<= 1'b1;
		    wr_cnt	<= wr_cnt;
            wr_dat	<= (ENDIAN_SWAP) ? {1'b0, {<<8{r_info[0][31:0]}}} : {1'b0, r_info[0][31:0]};
        end

        ST_WR_DATA2: begin
            r_info <= r_info;
            in_pkts <= in_pkts + 1'b1; // do this here once we know we succeeded in making a packet!
            in_tready <= 1'b0;
            in_state <= ST_IDLE;
            wr_start <= wr_start;
			wr_pos	<= wr_pos + 1'b1;
			wr_ena 	<= 1'b1;
			wr_cnt	<= wr_cnt;
            wr_dat	<= (ENDIAN_SWAP) ? {1'b0, {<<8{r_info[1][31:0]}}} : {1'b0, r_info[1][31:0]};
        end

		endcase

	end
end

endmodule