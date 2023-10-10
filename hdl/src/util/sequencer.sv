`timescale 1 ns / 1 ps

module sequencer
#(
	parameter NUM_SEQ = 2,
	parameter CYCLES_TO_TIMEOUT = 1
)
(
	input wire rst,
	input wire clk,

	input wire [NUM_SEQ-1:0] seq_rdy,
	input wire [NUM_SEQ-1:0] seq_done,

	output reg [NUM_SEQ-1:0] seq_start,
	output reg done
);

localparam ST_START = 1;
localparam ST_WAIT = 2;
localparam ST_FINISHED = 4;

integer state;

reg [31:0] timed_out;
reg [NUM_SEQ-1:0] seq_pos;

always@(posedge clk) begin
    if(rst) begin
        state <= ST_START;
        timed_out <= CYCLES_TO_TIMEOUT;
        seq_pos <= 1;
      	seq_start <= 0;
        done <= 1'b0;
    end else begin
        case(state)
        ST_START: begin
            done <= 1'b0;
            seq_pos <= seq_pos;
            // is the sequence ready?
            if(seq_pos & seq_rdy) begin
                state <= ST_WAIT;
                seq_start <= seq_pos;
                timed_out <= CYCLES_TO_TIMEOUT;
            // did we timeout waiting for it to start?
            end else if(timed_out == 0) begin
                timed_out <= CYCLES_TO_TIMEOUT;
                seq_start <= 0;
                if(seq_pos[NUM_SEQ-1]) begin
                    state <= ST_FINISHED;
                end else begin
                    state <= ST_START;
                end
            end else begin
                state <= ST_START;

                seq_start <= 0;
              timed_out <= timed_out - 1'b1;
            end
        end

        ST_WAIT: begin
            done <= 1'b0;
            seq_start <= seq_start;
            // is the sequence ready?
            if(seq_pos & seq_done) begin
              	if(seq_pos[NUM_SEQ-1]) begin
                	state <= ST_FINISHED;
                	seq_pos <= seq_pos;
                	timed_out <= CYCLES_TO_TIMEOUT;
                end else begin
                	state <= ST_START;
                	seq_pos <= {seq_pos, 1'b0};
                	timed_out <= CYCLES_TO_TIMEOUT;
                end
                // did we timeout waiting for it to start?
            end else if(timed_out == 0) begin
                timed_out <= CYCLES_TO_TIMEOUT;
                if(seq_pos[NUM_SEQ-1]) begin
                    state <= ST_FINISHED;
                    seq_pos <= seq_pos;
                end else begin
                    state <= ST_START;
                    seq_pos <= {seq_pos, 1'b0};
                end
            end else begin
                state <= ST_WAIT;
                timed_out <= timed_out - 1'b1;
                seq_pos <= seq_pos;
            end
        end

        ST_FINISHED: begin
            done <= 1'b1;
            state <= ST_FINISHED;
            timed_out <= CYCLES_TO_TIMEOUT;
            seq_start <= 0;
            seq_pos <= seq_pos;
        end

        default: begin
            done <= 1'b1;
            state <= ST_FINISHED;
            timed_out <= CYCLES_TO_TIMEOUT;
            seq_start <= 0;
            seq_pos <= seq_pos;
        end
        endcase
    end
end

endmodule
