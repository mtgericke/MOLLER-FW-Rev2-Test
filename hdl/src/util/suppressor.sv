module suppressor (
  input wire clk,
  input wire rst,
  input wire start,
  input wire [31:0] delay_cnt,
  input wire [31:0] total_cnt,

  output reg active,
  output reg valid,
  output reg first,
  output reg last
);

reg [31:0] counter;

always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        active <= 1'b0;
        valid <= 1'b0;
        last <= 1'b0;
      	first <= 1'b0;
    end else begin
        if(!active) begin
          	first <= (start) ? 1'b1 : 1'b0;
          	active <= (1'b0 < total_cnt) ? start : 1'b0;
            counter <= 32'h1;
          	valid <= (start) ? ((1'b0 >= delay_cnt) && (1'b0 < total_cnt)) ? 1'b1 : 1'b0 : 1'b0;
          	last <= (start) ? (1'b1 == total_cnt) ? 1'b1 : 1'b0 : 1'b0;
        end else begin
          	first <= (counter < total_cnt) ? 1'b0 : start;
          	active <= (counter < total_cnt) ? 1'b1 : start;
          	counter <= (counter < total_cnt) ? counter + 1'b1 : (start) ? 32'h1 : total_cnt;
            valid <= ((counter >= delay_cnt) && (counter < total_cnt)) ? 1'b1 : (start) ? ((1'b0 >= delay_cnt) && (1'b0 < total_cnt)) ? 1'b1 : 1'b0 : 1'b0;
            last <= (counter == (total_cnt - 1'b1)) ? 1'b1 : (start) ? (1'b1 == total_cnt) ? 1'b1 : 1'b0 : 1'b0;
        end
    end
end

endmodule