/*** Examples of Synchronizer usage

// Positive Reset Sync
synchronizer #(
	.RST_STATE(1)		// When reset occurs go immediately into reset state
) ref_rst_sync (
	.clk	(clk),
	.rst	(rst),
	.d		(rst),
	.q		(registered_reset)
);

// Negative Reset Sync
synchronizer #(
	.RST_STATE(0)		// When reset occurs go immediately into reset_n state
) ref_rst_sync (
	.clk	(clk),
	.rst	(!reset_n),
	.d		(reset_n),
	.q		(registered_reset_n)
);

// Signal Sync - Warning: Extra steps need to be taken to ensure data bus integrity is kept across clock domains!
synchronizer #(
	.RST_STATE({SZ_SYNC{1'b0}}),	// When reset occurs, the entire sync bus goes to zero
	.SZ_DATA(SZ_SYNC),				// Width of signal bus
	.NUM_SYNC(2)						// Number of synchronizing registers
) ref_sig_sync (
	.clk	(clk),
	.rst	(rst),
	.d		(sig_to_clk),
	.q		(sig_from_clk)
);

*/
module synchronizer (
	clk,
	rst,
	d,
	q
);

parameter NUM_SYNC = 3;
parameter SZ_DATA = 1;
parameter RST_STATE = 0;

input wire rst;
input wire clk;
input wire [SZ_DATA-1:0] d;
output wire [SZ_DATA-1:0] q;

wire [SZ_DATA-1:0] sync [NUM_SYNC:0];

assign q = sync[NUM_SYNC];
assign sync[0] = d;

genvar n;
generate
for(n=0; n<NUM_SYNC; n=n+1) begin: data_sync
	register #(.SZ_DATA(SZ_DATA),.RST_STATE(RST_STATE)) sync_reg (
		.clk	(clk),
		.rst	(rst),
		.ena	(1'b1),
		.d		(sync[n]),
		.q		(sync[n+1])
	);
end // for
endgenerate

endmodule
