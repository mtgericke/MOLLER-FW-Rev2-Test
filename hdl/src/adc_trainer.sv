`timescale 1 ns / 1 ps

module adc_trainer #(
    parameter NUM_ADC = 16,
    parameter WAIT_COUNT = 256,
    parameter CHECK_COUNT = 1000000,
    parameter PHASE_POS = 56,
    parameter PHASE_ADJUST_DELAY = 24,
    parameter START_DELAY = 125000
)(
    input wire clk,
    input wire rst,
    input wire ena,
    input wire valid,
    input wire [NUM_ADC-1:0][17:0] ch_data,
    input wire [NUM_ADC-1:0] ch_valid,

    // streaming output of training data
    output wire [63:0] fifo_tdata,
    output wire fifo_tvalid,
    output wire fifo_tlast,
    input wire fifo_tready,

    output reg [PHASE_POS-1:0] phase_error,
    output reg convert,
    output reg adjust_phase,
    output reg testpat,
    output reg done
);

localparam [17:0] TEST_PATTERN = 18'b110011000011111100; // 18-bit analog data value to expect
localparam ST_TRAIN_START = 1, ST_TRAIN_WAIT = 2, ST_TRAIN_CHECK = 3, ST_TRAIN_MOVE = 4, ST_TRAIN_SEARCH = 5, ST_TRAIN_RELOCATE = 6, ST_TRAIN_DONE = 7;

integer state;

reg [6:0] ph_count;
reg [31:0] count;
reg all_pattern_match;
reg all_pattern_valid;
reg ch_pattern_valid;
reg [NUM_ADC-1:0] ch_pattern_match;
reg rst_counter;
reg captured;

reg [NUM_ADC-1:0][23:0] ch_match_count;

wire [NUM_ADC-1:0][31:0] ch_match_counters;
wire [6:0] one_counter_pos;
wire one_counter_done;
wire [(PHASE_POS*2)-1:0] phase_bits_unrolled = { phase_error, phase_error };

always@(posedge clk) begin
   ch_pattern_valid <= valid;
   all_pattern_valid <= ch_pattern_valid;
   all_pattern_match <= &ch_pattern_match;
end

genvar n;
generate
for(n=0; n<NUM_ADC; n = n + 1) begin

assign ch_match_counters[n] = { n[7:0], ch_match_count[n] };

always@(posedge clk) begin
    ch_pattern_match[n] <= (valid && (ch_data[n] == TEST_PATTERN) && (ch_valid[n] == 1'b1)) ? 1'b1 : 1'b0;

    // Clear counter between
    if(state == ST_TRAIN_CHECK) begin
        ch_match_count[n] <= (valid && ((ch_data[n] != TEST_PATTERN) || (ch_valid[n] != 1'b1))) ? ch_match_count[n] + 1'b1: ch_match_count[n];
    end else begin
        ch_match_count[n] <= 0;
    end
end

end
endgenerate

// go through all 56 phase positions, and check for errors
// then relocate to the best position (one in the middle of the longest stretch of no errors)
always@(posedge clk) begin
    if(rst) begin
        adjust_phase <= 1'b0;
        phase_error <= 0;
        testpat <= 1'b0;
        done <= 0;
        count <= 0;
        ph_count <= 0;
        state <= ST_TRAIN_START;
        rst_counter <= 1;
        convert <= 0;
        captured <= 0;
    end else begin
        case(state)
            ST_TRAIN_START: begin
                adjust_phase <= 1'b0;
                phase_error <= 0;
                testpat <= 1'b0;
                done <= 1'b0;
                count <= (count < START_DELAY) && ena ? count + 1'b1 : 0;
                ph_count <= 0;
                state <= (count == START_DELAY) ? ST_TRAIN_WAIT : ST_TRAIN_START;
                rst_counter <= 1;
                convert <= 0;
                captured <= 0;
            end

            // wait for phase adjustment to settle
            ST_TRAIN_WAIT: begin
                adjust_phase <= 1'b0;
                phase_error <= phase_error;
                testpat <= 1'b1;
                done <= 1'b0;
                count <= (count < WAIT_COUNT) ? (all_pattern_valid) ? count + 1'b1 : count : 0;
                ph_count <= ph_count;
                state <= (count == WAIT_COUNT) ? ST_TRAIN_CHECK : ST_TRAIN_WAIT;
                rst_counter <= 1;
                convert <= 1;
                captured <= 0;
            end

            // check for errors over a number of samples
            ST_TRAIN_CHECK: begin
                adjust_phase <= 1'b0;
                phase_error <= (all_pattern_valid) ?  {phase_error[PHASE_POS-1:1], all_pattern_match} : phase_error;
                testpat <= 1'b1;
                done <= 1'b0;
                count <= (count < CHECK_COUNT) ? (all_pattern_valid) ? count + 1'b1 : count : 0;
                ph_count <= ph_count;
                // count till the end
                state <= (count == CHECK_COUNT) ? ST_TRAIN_MOVE : ST_TRAIN_CHECK;
                captured <= (count == CHECK_COUNT) ? 1'b1 : 1'b0;
                rst_counter <= 1;
                convert <= 1;
            end

            // move to the next phase position
            ST_TRAIN_MOVE: begin
                adjust_phase <= 1'b1;
                phase_error <= (ph_count != (PHASE_POS-1)) ? { phase_error[(PHASE_POS-2):0], phase_error[(PHASE_POS-1)]} : phase_error;
                testpat <= 1'b1;
                done <= 1'b0;
                count <= 0;
                ph_count <= ph_count + 1'b1;
                state <= (ph_count == (PHASE_POS-1)) ? ST_TRAIN_SEARCH : ST_TRAIN_WAIT;
                rst_counter <= 1;
                convert <= 0;
                captured <= 0;
            end

            ST_TRAIN_SEARCH: begin
                adjust_phase <= 1'b0;
                phase_error <= phase_error;
                testpat <= 1'b0;
                done <= 1'b0;
                count <= 0;
                ph_count <= 0;
                state <= (one_counter_done) ? ST_TRAIN_RELOCATE : ST_TRAIN_SEARCH;
                rst_counter <= 0;
                convert <= 0;
                captured <= 0;
            end

            // if all 56 phases have been tested, go to the best one
            ST_TRAIN_RELOCATE: begin


                testpat <= 1'b0;
                done <= 1'b0;

                if(ph_count != one_counter_pos) begin
                    state <= ST_TRAIN_RELOCATE;
                    if(count < PHASE_ADJUST_DELAY) begin
                        phase_error <= phase_error;
                        adjust_phase <= 1'b0;
                        count <= count + 1'b1;
                        ph_count <= ph_count;
                    end else begin
                        phase_error <= { phase_error[(PHASE_POS-2):0], phase_error[(PHASE_POS-1)]};
                        adjust_phase <= 1'b1;
                        count <= 0;
                        ph_count <= ph_count + 1;
                    end
                end else begin
                    phase_error <= phase_error;
                    adjust_phase <= 1'b0;
                    count <= 0;
                    ph_count <= ph_count;
                    state <= ST_TRAIN_DONE;
                end

                rst_counter <= 0;
                convert <= 0;
                captured <= 0;
            end

            ST_TRAIN_DONE: begin
                adjust_phase <= 1'b0;
                phase_error <= phase_error;
                testpat <= 1'b0;
                done <= 1'b1;
                count <= 0;
                ph_count <= 0;
                state <= (ena) ? ST_TRAIN_DONE : ST_TRAIN_START;
                rst_counter <= 0;
                convert <= 0;
                captured <= 0;
            end

            default: begin
                adjust_phase <= 1'b0;
                phase_error <= phase_error;
                testpat <= 1'b0;
                done <= 1'b1;
                count <= 0;
                ph_count <= 0;
                state <= ST_TRAIN_DONE;
                rst_counter <= 0;
                convert <= 0;
                captured <= 0;
            end
        endcase
    end
end

pos_finder #(
    .WIDTH( (PHASE_POS*2) )
) pf (
    .clk(clk),
    .rst(rst | rst_counter),
    .d(phase_bits_unrolled),
    .q(one_counter_pos),
    .done(one_counter_done)
);

simple_packetizer #(
    .ID(8'hAD),
	.ENDIAN_SWAP(1'b0),
	.PREPEND_LEN(1),
    .NUM_INPUTS(1+(NUM_ADC/2)), // half number of ADCs, because counters are 32-bit, and we are using 64-bit words
    .WIDTH(64)
) trainer_packetizer (
    .clk    (clk),
    .rst    (rst),
    .capture(captured),
    .d      ({
        {57'h0, ph_count },
        ch_match_counters
    }),
    .tready	(fifo_tready),
    .tdata	(fifo_tdata),
    .tvalid	(fifo_tvalid),
    .tlast	(fifo_tlast)
);

endmodule