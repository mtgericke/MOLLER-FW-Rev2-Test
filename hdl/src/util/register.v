module register( 
	clk,
	rst,
	ena,
	d,
	q
); 

parameter SZ_DATA = 1;
parameter [SZ_DATA-1:0] RST_STATE = 0;
parameter RST_POS_EDGE = 1;

input wire clk;
input wire rst;
input wire ena;
input wire [SZ_DATA-1:0] d;
output wire [SZ_DATA-1:0] q;

reg [SZ_DATA-1:0] r_q = RST_STATE[SZ_DATA-1:0];

assign q = r_q;

generate
if(RST_POS_EDGE) begin
	always@(posedge rst, posedge clk) begin
		if(rst == 1'b1) 
			r_q <= RST_STATE[SZ_DATA-1:0];
		else 
			if(ena)
				r_q <= d;
			else
				r_q <= r_q;
	end
end else begin
	always@(negedge rst, posedge clk) begin
		if(rst == 1'b0) 
			r_q <= RST_STATE[SZ_DATA-1:0];
		else 
			if(ena)
				r_q <= d;
			else
				r_q <= r_q;
	end
end
endgenerate
		
endmodule

module register_no_rst( 
	clk,
	ena,
	d,
	q
); 

parameter SZ_DATA = 1;
parameter [SZ_DATA-1:0] RST_STATE = 0;

input wire clk;
input wire ena;
input wire [SZ_DATA-1:0] d;
output wire [SZ_DATA-1:0] q;

reg [SZ_DATA-1:0] r_q = RST_STATE[SZ_DATA-1:0];

assign q = r_q;

always@(posedge clk) begin
	if(ena)
		r_q <= d;
	else
		r_q <= r_q;
end
		
endmodule
