module uwire_loader #(
	parameter NUM_WORDS = 1
)(
	input wire clk,
  	input wire rst,
  	input wire [NUM_WORDS-1:0][31:0] d,
  	input wire ready,
  	output reg [31:0] q,
  	output reg start,
  	output reg done
);

  reg [$clog2(NUM_WORDS+1):0] words_left;

  always@(posedge clk) begin
    if(rst) begin
     	start <= 1'b0;
      	done <= 1'b0;
      	words_left <= NUM_WORDS;
    end else begin
      if(ready && !start) begin
        if(words_left > 0) begin
          q <= d[words_left-1];
          words_left <= words_left - 1'b1;
          start <= 1'b1;
          done <= 1'b0;
        end else begin
          q <= 32'h0;
          words_left <= 0;
          start <= 1'b0;
          done <= ready;
        end
      end else begin
        q <= q;
        start <= 1'b0;
        words_left <= words_left;
        done <= 1'b0;
      end
    end
  end

endmodule
