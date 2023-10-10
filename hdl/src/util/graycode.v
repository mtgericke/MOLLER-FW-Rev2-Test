module bin2gray(
	clk,
	rst,
	bin,
	gray
);

parameter SZ_DATA = 2;	// Can never be less than 2, but of course, gray code less than 2 is actually binary so...

input wire clk;
input wire rst;
input wire 	[SZ_DATA-1:0] 	bin;
output wire [SZ_DATA-1:0] 	gray;

reg [SZ_DATA-1:0] r_gray;

assign gray = r_gray;

always@(posedge rst, posedge clk) begin
	if(rst)
		r_gray <= {SZ_DATA{1'b0}};
	else
		r_gray[SZ_DATA-1:0] <= bin[SZ_DATA-1:0] ^ {1'b0, bin[SZ_DATA-1:1]};
end

endmodule

module gray2bin(
	clk,
	rst,
	bin,
	gray
);

parameter SZ_DATA = 2; // Can never be less than 2, but of course, gray code less than 2 is actually binary so...

input wire clk;
input wire rst;
input wire 	[SZ_DATA-1:0] 	gray;
output wire [SZ_DATA-1:0] 	bin;

wire [SZ_DATA-1:0] w_bin;
reg [SZ_DATA-1:0] r_bin;

assign bin = r_bin;

always@(posedge rst, posedge clk) begin
	if(rst)
		r_bin <= {SZ_DATA{1'b0}};
	else
		r_bin <= w_bin;
end

assign w_bin[SZ_DATA-1] = gray[SZ_DATA-1];

genvar n;
generate
	for(n=SZ_DATA-2; n>=0; n=n-1) begin: gen_gray2bin
		assign w_bin[n] = gray[n] ^ w_bin[n+1];
	end
endgenerate

endmodule
