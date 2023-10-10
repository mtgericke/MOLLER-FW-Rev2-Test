module freq_counter (
	clk,
	rst,
	clk_freq,
	q
);

parameter REF_FREQ 	= 100000000; // 100 MHz default frequency for the reference clock
parameter NUM_SYNC 	= 3;		 // Number of synchronizers in graycode sync counter
parameter WIDTH 	= 32;		 // WIDTH must be large enough to contain the expected frequency, otherwise overflow will occur
localparam SZ_COUNT = $clog2(REF_FREQ+1);

input wire 				clk;
input wire 				rst;
input wire 				clk_freq;
output reg [WIDTH-1:0] 	q;

wire [WIDTH-1:0] 	synced_cnt; // the clock-domain crossed value of the current freq_cnt, synchronized
reg  [WIDTH-1:0] 	last_cnt; // the last value stored of the free running freq_cnt, in the ref_clk domain
reg  [WIDTH-1:0] 	freq_cnt; // a free-running count of the clock to get the frequency of
reg  [SZ_COUNT-1:0] ref_cnt; // used to keep track of the reference clock period

// Every loop of the ref clock take the latest synced clock counter, and minus it from the last loops synced count value
// This turns out to be very accurate, and is much simplier than stopping and starting a counter across the clock domains
always@(posedge rst, posedge clk) begin 
	if(rst) begin 
		ref_cnt  <= {SZ_COUNT{1'b0}};
		last_cnt <= {WIDTH{1'b0}};
		q 		 <= {WIDTH{1'b0}};
	end else begin 	
		if(ref_cnt == (REF_FREQ-1'b1)) begin
			ref_cnt  <= {SZ_COUNT{1'b0}};
			last_cnt <= synced_cnt;
			q <= synced_cnt - last_cnt;
		end else begin
			ref_cnt  <= ref_cnt + 1'b1;
            last_cnt <= last_cnt;
		    q 		 <= q;
		end 
	end 
end 

// a very fast clock compared to the reference clock, it could in theory overflow.
// We can just let it free run
always@(posedge clk_freq) begin 
	freq_cnt <= freq_cnt + 1'b1;
end

// Send captured count back to clk domain via graycode synchronizer 
synchronizer_counter #( 
	.SZ_WIDTH(WIDTH), 
	.NUM_SYNC(NUM_SYNC)
) sync_count (
	.clk	( clk ),
	.rst	( rst ),
	.d_clk	( clk_freq ),
	.d 		( freq_cnt ),
	.q 		( synced_cnt )
);

endmodule
