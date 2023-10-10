module subsystem_adc #(
    parameter NUM_ADC = 16,
    parameter CLK_CONVERT_PERIOD = 4
)(
    input wire rst,
    input wire clk,
    input wire clk_convert, // 2x clk, used for ADC CLK and ADC CONVERT signals
    input wire convert,

    input wire reset_counters,
    input wire [7:0] sample_rate,
    output wire [NUM_ADC-1:0][8:0] adc_ch_delay,
    input wire [NUM_ADC-1:0][8:0] adc_ch_load,

    input wire [63:0] in_ts,    // timestamp from global clock
    output wire convert_ready, // indicates ready to convert

    output wire adc_valid, // indicates we can check q_ch_valid, *NOT* that all data is valid
    output wire [63:0] adc_ts, // timestamp at time of conversion
    output wire [NUM_ADC-1:0] adc_ch_valid,
    output wire [NUM_ADC-1:0][17:0] adc_data,

    output reg [NUM_ADC-1:0][15:0] bad_dco_counter,
    output reg [NUM_ADC-1:0][15:0] bad_data_counter,

    input wire adc_testpat,

    // Signals to LTC2387 ADCs
    output wire adc_convert,
    output wire adc_clock,
    input wire [NUM_ADC-1:0] adc_dco,
    input wire [NUM_ADC-1:0] adc_da,
    input wire [NUM_ADC-1:0] adc_db
);

genvar n;
generate

for(n=0; n<NUM_ADC; n++) begin: adc_counters

always@(posedge clk) begin
    if(rst | reset_counters) begin
        bad_dco_counter[n] <= 0;
        bad_data_counter[n] <= 0;
    end else begin
        if(adc_valid) begin
            bad_dco_counter[n] <= (!adc_ch_valid[n] && (bad_dco_counter[n] < 65535)) ? bad_dco_counter[n] + 1'b1 : bad_dco_counter[n];
            bad_data_counter[n] <= (adc_ch_valid[n] && adc_testpat && (bad_data_counter[n] < 65535) && (adc_data[n] != 18'b110011000011111100)) ? bad_data_counter[n] + 1'b1 : bad_data_counter[n];
        end else begin
            bad_dco_counter[n] <= bad_dco_counter[n];
            bad_data_counter[n] <= bad_data_counter[n];
        end
    end
end

end
endgenerate

ltc2387_deserializer_twolane #(
    .NUM_ADC( NUM_ADC ),
    .CLOCK_PERIOD( CLK_CONVERT_PERIOD )
) adc (
    .rst( rst ),
    .clk( clk ),
    .clk_cnv( clk_convert ),

    .start( convert ),
    .in_ts( in_ts ),
    .ready( convert_ready ),

    .sample_rate( sample_rate ),
    .adc_ch_delay( adc_ch_delay ),
    .adc_ch_load( adc_ch_load ),

    .q_valid( adc_valid ),
    .q_ts( adc_ts ),
    .q_ch_valid( adc_ch_valid ),
    .q_data( adc_data ),

    // These go to the ADC pins
    .adc_cnv( adc_convert ), // conversion sent
    .adc_clk( adc_clock ), // clock send to ADC
    .adc_dco( adc_dco ),
    .adc_da( adc_da ),
    .adc_db( adc_db )
);

endmodule
