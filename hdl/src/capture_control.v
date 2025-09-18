// spare_reg1[0] enables test sequence

// control signal generation for testing ...
// 510us cycle-time = 63750 clks [xF906]  [7500 adc samples]
//     wait 10us = 1250 clks     [x04E2]
//     enable comes on 64 clks before start
//     start comes on to start integration

module capture_control (             input wire rst,
   input wire clk,                   input wire trig,
   input wire valid,                 input wire test_mode,
   input wire [15:0]  ena_delay,     input wire [15:0] start_delay,
   input wire [ 3:0] cap_regions,    input wire [15:0] cap_region_size,
   output wire cap_ena,              output wire cap_start,
   output wire end_cycle,            output wire [3:0] cap_region
   //output wire win_end
);
assign cap_region = region_cnt;
reg [15:0] cycle_cnt;   
reg [15:0] region_cnt;   
reg [15:0] sample_cnt;
reg [15:0] tmp_cnt ;
   
localparam CYCLE_LENGTH_CLOCKS  = 16'hF906; // 7500 * 8.5
localparam CYCLE_LENGTH_SAMPLES = 16'h1DC4; // 7500

   
   
//assign end_cycle  = test_mode ? (tmp_cnt == CYCLE_LENGTH_CLOCKS) : 1'b0; 
//wire   tmp_trig   = test_mode ? (tmp_cnt == 16'h0000) : 1'b0; 
//reg [15:0] tmp_cnt ;  always @ (posedge clk) tmp_cnt  <= test_mode ? ((end_cycle) ? 16'h0 : tmp_cnt  + 16'h1) : 16'h0;
   
assign end_cycle  = test_mode ? (tmp_cnt == CYCLE_LENGTH_SAMPLES) : 1'b0; 
wire   tmp_trig   = test_mode ? (tmp_cnt == 16'h0000) : 1'b0; 
always @ (posedge clk) tmp_cnt  <= test_mode ? ( (end_cycle) ? 16'h0 : ((valid) ? tmp_cnt  + 16'h1 : tmp_cnt) ) : 16'h0;

wire cycle_active = ( cycle_cnt != 16'h0 && cycle_cnt > ena_delay + start_delay);
//wire region_end   = ( sample_cnt == cap_region_size);
//wire all_end      = ( region_cnt == cap_regions - 16'h1 && region_end );
wire region_end   = valid && ( sample_cnt == cap_region_size);
wire all_end      = valid && ( region_cnt == cap_regions - 16'h1 && region_end );
assign cap_ena   = cycle_cnt >= ena_delay;
assign cap_start = sample_cnt == 16'h0 && cycle_active && ~all_end;
//assign win_end = all_end;
   

always @ (posedge clk) begin
   if( rst ) begin
      cycle_cnt  <= 16'h0;   
      region_cnt <= 16'h0;   
      sample_cnt <= 16'h0;
   end else begin
      //sample_cnt <= sample_cnt;  cycle_cnt  <= (cycle_cnt != 16'h0) ? cycle_cnt + 16'h1 : 16'h0;    
      sample_cnt <= sample_cnt;  cycle_cnt  <= (cycle_cnt != 16'h0) ? ( (valid) ? cycle_cnt + 16'h1 : cycle_cnt) : 16'h0;    
      region_cnt <= region_cnt;
      if( cycle_active ) begin
	 if( all_end ) begin cycle_cnt <= 16'h0; end
	 sample_cnt <= region_end ? 16'h0 : valid ? sample_cnt + 16'h1 : sample_cnt; 
	 //sample_cnt <= region_end ? 16'h0 : sample_cnt + 16'h1;
         region_cnt <= region_end ? region_cnt + 16'h1 : region_cnt;
      end else if ( trig || tmp_trig ) begin // do not allow retrigger during cycle
         cycle_cnt <= 16'h1;   region_cnt <= 16'h0;  sample_cnt <= 16'h0;
      end
   end
end 

endmodule 
