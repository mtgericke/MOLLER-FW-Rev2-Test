
module uwire_lmk04816 #(
    parameter CLK_PERIOD = 1
) (
	input wire clk,
	input wire rst,
  	input wire start,
    input wire [31:0] d,

  	output reg DATAuWire,
  	output reg CLKuWire,
  	output reg LEuWire,
    output reg ready
);

  localparam LAST_BIT_CNT = 66;
  localparam MIN_TIMING = 50; // Actual minimum is 25ns, but lets give a healthy lee-way

  // Timing minimums are all 25ns, so we must wait that long between transitions
  localparam CYCLES_PER_STATE = (CLK_PERIOD >= MIN_TIMING) ? 1 : (MIN_TIMING / CLK_PERIOD);

  reg started;
  reg [$clog2(CYCLES_PER_STATE+1):0] st_cnt;
  reg [$clog2(72):0] bit_cnt;

  reg [31:0] d_shift;

  always@(posedge clk) begin
    if(rst) begin
      started <= 1'b0;
      ready <= 1'b0;
      CLKuWire <= 1'b0;
      LEuWire <= 1'b0;
      DATAuWire <= 1'b0;
      d_shift <= d;
      st_cnt <= 0;
      bit_cnt <= 0;
    end else begin
      if(!started && start) begin
        started <= 1'b1;
        ready <= 1'b0;
  		st_cnt <= 1;
        bit_cnt <= 0;
        d_shift <= {d[30:0],1'b0};
        CLKuWire <= 1'b0;
        DATAuWire <= d[31];
      end else if (started) begin

        st_cnt <= (st_cnt < CYCLES_PER_STATE-1) ? st_cnt + 1'b1 : 0;
        bit_cnt <= (st_cnt < CYCLES_PER_STATE-1) ? bit_cnt : bit_cnt + 1'b1;

        LEuWire <= (bit_cnt == LAST_BIT_CNT-1) ? 1'b1 : 1'b0;

        if(bit_cnt == LAST_BIT_CNT+1) begin
          ready <= 1'b1;
          started <= 1'b0;
        end else begin
          ready <= 1'b0;
          started <= 1'b1;
        end


        if(st_cnt == 0) begin
          CLKuWire <= (bit_cnt < LAST_BIT_CNT-1) ? ~CLKuWire : 1'b0;
          if(bit_cnt[0] == 1'b0) begin
          	DATAuWire <= d_shift[31];
          	d_shift <= {d_shift[30:0], 1'b0};
          end else begin
            DATAuWire <= DATAuWire;
            d_shift <= d_shift;
          end
        end else begin
          DATAuWire <= DATAuWire;
          d_shift <= d_shift;
        end
      end else begin
        started <= 1'b0;
        ready <= 1'b1;
        CLKuWire <= 1'b0;
        LEuWire <= 1'b0;
        DATAuWire <= 1'b0;
        d_shift <= 0;
        st_cnt <= 0;
        bit_cnt <= 0;
      end
    end
  end

endmodule
