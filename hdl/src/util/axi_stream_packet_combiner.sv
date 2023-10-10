/*
	Packet Length Prepender

	Takes in a AXI Stream packet and prepends the length of the packet to the start, increasing the size of the packet by one word.

	There is a two cycle delay between packets (this could be reduced, but at an increase in corner cases to be handled)

	Conditions Handled:

	- length exceeded, if the packet exceeds the maximum length given by MAX_PKT_LEN before a TLAST is received, all words received are
	discarded, and the packet capture starts again

	- single word packets are allowed

*/

module axi_stream_packet_combiner (
	clk,
	rst,

  	force_transmit,

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
parameter MAX_PKT_LEN = 64; // maximum size of an individual packet
parameter MAX_COMBINED_LEN = 368; // maximum size of a combined packet
parameter NUM_PACKETS = 8; // maximum packets to

localparam SZ_DATA = 32;

input wire clk;
input wire rst;
input wire force_transmit;

input wire in_tlast;
input wire [SZ_DATA-1:0] in_tdata;
input wire in_tvalid;
output wire in_tready;

output wire out_tvalid;
output wire out_tlast;
output wire [SZ_DATA-1:0] out_tdata;
input wire out_tready;

reg in_tlast_allowed = 1'b0;
reg [$clog2(MAX_COMBINED_LEN+1):0] cnt;

// count incoming packets and allow a tlast once we are within (MAX_COMBINED_PACKETS - MAX_PKT_LEN)
// OR we receive a 'force_transmit' (transmission cannot start until current incoming packet is received)

wire in_tlast_int = in_tvalid & in_tlast & in_tlast_allowed;

always@(posedge clk) begin
	if(rst) begin
		cnt <= 0;
		in_tlast_allowed <= 1'b0;
	end else begin
		if(in_tlast_int && in_tready) begin
			cnt <= 0;
			in_tlast_allowed <= 1'b0;
		end else begin
          	cnt <= (in_tvalid && in_tready) ? cnt + 1'b1 : cnt;
			if(cnt >= (MAX_COMBINED_LEN - MAX_PKT_LEN) || force_transmit) begin
				in_tlast_allowed <= 1'b1;
			end	else begin
				// latch, must maintain value
				in_tlast_allowed <= in_tlast_allowed;
			end
		end
	end
end

axi_stream_packet_length_prepender #(
	.ID(ID),
	.ENDIAN_SWAP(ENDIAN_SWAP),
	.MAX_PKT_LEN(MAX_COMBINED_LEN),
	.NUM_PACKETS(NUM_PACKETS)
) prepender (
	.clk(clk),
	.rst(rst),
	.in_tlast(in_tlast_int),
	.in_tdata(in_tdata),
	.in_tvalid(in_tvalid),
	.in_tready(in_tready),
	.out_tlast(out_tlast),
	.out_tvalid(out_tvalid),
	.out_tdata(out_tdata),
	.out_tready(out_tready)
);

endmodule