`timescale 1 ns / 1 ps

module pos_finder #(
	parameter WIDTH = 56
)(
   input wire clk,
   input wire rst,

   input wire [WIDTH-1:0] d,
   output reg [6:0] q,
   output reg done
);

reg [$clog2(WIDTH+1)-1:0] pos;
reg [$clog2(WIDTH+1)-1:0] one_cnt;
reg [$clog2(WIDTH+1)-1:0] max_cnt;
reg [$clog2(WIDTH+1)-1:0] max_pos;

always@(posedge clk) begin
    if(rst) begin
      	q <= 0;
        done <= 0;
        pos <= 0;
        one_cnt <= 0;
        max_cnt <= 0;
        max_pos <= 0;
    end else begin
      if(!done && (pos < WIDTH)) begin
        	done <= (pos == (WIDTH-1)) ? 1'b1 : 1'b0;
            pos <= pos + 1'b1;
          	one_cnt <= (d[pos] == 1'b1) ? one_cnt + 1'b1 : 0;
            max_cnt <= (one_cnt > max_cnt) ? one_cnt : max_cnt;
        	max_pos <= (one_cnt > max_cnt) ? pos - 1'b1 : max_pos;
          	q <= max_pos - (max_cnt[6:1]);
        end else begin
             done <= done;
             pos <= pos;
             one_cnt <= 0;
             max_cnt <= 0;
             max_pos <= max_pos;
         	 q <= q;
        end
    end
end

endmodule