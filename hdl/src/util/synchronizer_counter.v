// Instantiates a counter that crosses a clock domain
module synchronizer_counter (
	clk,
	rst,
	d_clk,	
	d,
	q
);

parameter NUM_SYNC = 2;
parameter SZ_WIDTH = 32;

input wire clk;
input wire d_clk;
input wire rst;
input wire [SZ_WIDTH-1:0] d;
output wire [SZ_WIDTH-1:0] q;

wire [SZ_WIDTH-1:0] synced_gray;
wire [SZ_WIDTH-1:0] gray;

/*
wire d_rst;

// Sync reset to data clock
synchronizer #( 
	.SZ_DATA(1),
	.RST_STATE(1),
	.NUM_SYNC(NUM_SYNC)
) sync_rst (
	.clk	( d_clk ),
	.rst  ( rst ),
	.d    ( rst ),
	.q 	( d_rst )
);
*/

// Convert binary count to gray code for clock domain transfer 
bin2gray #(
	.SZ_DATA(SZ_WIDTH)
) count_to_gray (
	.clk	( d_clk ),
	.rst	( rst ), // was d_rst 
	.bin	( d ),
	.gray	( gray )
);

// Cross clock domain, we may be a couple counts behind at times
synchronizer #(
	.SZ_DATA(SZ_WIDTH),
	.NUM_SYNC(NUM_SYNC)
) sync_gray ( 
	.clk 	( clk ),
	.rst 	( rst ),
	.d 	( gray ),
	.q 	( synced_gray )
);

// Convert from gray code to binary for final output
gray2bin #( 
	.SZ_DATA(SZ_WIDTH)
) gray_to_count (
	.clk	( clk ),
	.rst	( rst ),
	.gray	( synced_gray ),
	.bin	( q )
);

endmodule
