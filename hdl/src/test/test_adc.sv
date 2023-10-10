// Upon restart, tests X samples against the PATTERN, skipping the first N samples
//
// Note: The ADC this was designed to test (LTC2387), its first two conversions
// must be ignored according to the datasheet
module test_adc #(
    parameter ADC_BITS = 18,
  	parameter PATTERN = 18'b11_0011_0000_1111_1100
) (
	input wire clk,
	input wire rst,
    input wire start,
  	input wire adc_valid,
  	input wire [ADC_BITS-1:0] adc_data,
  	output reg [31:0] num_matches,
  	output reg [31:0] num_mismatches
);

reg started;

always@(posedge clk) begin
    if(rst) begin
        started <= 1'b0;
        num_matches <= 0;
        num_mismatches <= 0;
    end else begin
        started <= start;
        if(start & ~started) begin
            // on initial start, reset counters
            num_mismatches <= 0;
            num_matches <= 0;
        end else if(start) begin
            // if we have started, start increment counters
            num_matches <= (adc_data == PATTERN) && adc_valid ? num_matches + 1'b1 : num_matches;
            num_mismatches <= (adc_data != PATTERN) && adc_valid ? num_mismatches + 1'b1 : num_mismatches;
        end else begin
            // Hold values until next start, so they can be readback
            num_matches <= num_matches;
            num_mismatches <= num_mismatches;
        end
    end
end

endmodule
