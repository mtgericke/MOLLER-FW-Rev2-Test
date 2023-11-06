`timescale 1 ns / 1 ps

module data_delayer
#(
	parameter DEPTH = 1,
  	parameter WIDTH = 1
)(
  input wire rst,
  input wire clk,
  input wire [$clog2(DEPTH):0] delay,
  input wire [WIDTH-1:0] d,
  output wire [WIDTH-1:0] q,
  output reg valid
);

reg [$clog2(DEPTH):0] int_delay;
reg [$clog2(DEPTH+1):0] cnt;
reg [$clog2(DEPTH)-1:0] wr_pos;
reg [$clog2(DEPTH)-1:0] rd_pos;
reg [WIDTH-1:0] last_d;

wire [WIDTH-1:0] int_q;

always@(posedge clk) begin
    if(rst) begin
      wr_pos <= 0;
      rd_pos <= 1;
      cnt <= 1;
      valid <= 1'b0;
      int_delay <= delay;
    end else begin
      int_delay <= (delay > DEPTH) ? DEPTH : delay;
      wr_pos <= wr_pos + 1'b1;
      rd_pos <= rd_pos + 1'b1;
      cnt <= (cnt < DEPTH) ? cnt + 1'b1 : cnt;
      valid <= (cnt >= int_delay) ? 1'b1 : 1'b0;
      last_d <= d;
    end
end

assign q = (int_delay == 0) ? d : (int_delay == 1) ? last_d : int_q;

dual_one_clock_wr_first #(
  .WIDTH( WIDTH ),
  .DEPTH( DEPTH )
) delay_ram (
  .clk(clk),
  .wr_ena(1'b1),
  .wr_addr(wr_pos),
  .rd_addr(rd_pos - int_delay),
  .d(d),
  .q(int_q)
);

endmodule
