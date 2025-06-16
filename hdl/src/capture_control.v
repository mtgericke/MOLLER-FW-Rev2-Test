// spare_reg1[0] enables test sequence

// control signal generation for testing ...
// 510us cycle-time = 63750 clks [xF906]  [7500 adc samples]
//     wait 10us = 1250 clks     [x04E2]
//     enable comes on 64 clks before start
//     start comes on to start integration

module capture_control (             input wire rst,
   input wire clk,                   input wire trig,
   input wire [15:0]  ena_delay,     input wire [15:0] start_delay,
   input wire [ 3:0] cap_regions,    input wire [15:0] cap_region_size,
   output wire cap_ena,              output wire cap_start,
   output wire end_cycle,            output wire [3:0] cap_region
);
assign cap_region = region_cnt;

/* for test only */assign end_cycle  = (tmp_cnt == 16'hF906); 
/* for test only */wire   tmp_trig   = (tmp_cnt == 16'h0000);  // use this in place of trig
/* for test only */reg [15:0] tmp_cnt ;  always @ (posedge clk) tmp_cnt  <= (end_cycle) ? 16'h0 : tmp_cnt  + 16'h1;

wire cycle_active = ( cycle_cnt != 16'h0 && cycle_cnt > ena_delay + start_delay);
wire region_end   = ( sample_cnt == cap_region_size);
wire all_end      = ( region_cnt == cap_regions - 16'h1 && region_end );
assign cap_ena   = cycle_cnt >= ena_delay;
assign cap_start = sample_cnt == 16'h0 && cycle_active && ~all_end;

reg [15:0] cycle_cnt;   reg [15:0] region_cnt;   reg [15:0] sample_cnt;
always @ (posedge clk) begin
   if( rst ) begin
      cycle_cnt  <= 16'h0;   
      region_cnt <= 16'h0;   sample_cnt <= 16'h0;
   end else begin
      sample_cnt <= sample_cnt;  cycle_cnt  <= (cycle_cnt != 16'h0) ? cycle_cnt + 16'h1 : 16'h0;    
      region_cnt <= region_cnt;
      if( cycle_active ) begin
	 if( all_end ) begin cycle_cnt <= 16'h0; end
	 sample_cnt <= region_end ? 16'h0 : sample_cnt + 16'h1;
         region_cnt <= region_end ? region_cnt + 16'h1 : region_cnt;
      end else if ( trig || tmp_trig ) begin // do not allow retrigger during cycle
         cycle_cnt <= 16'h1;   region_cnt <= 16'h0;  sample_cnt <= 16'h0;
      end
   end
end 

endmodule 
