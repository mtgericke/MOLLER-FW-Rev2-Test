module subsystem_led #(
    parameter CLK_FREQ = 125000000,
    parameter NUM_LED = 4,
    parameter INVERTED = 0
)(
    input wire rst,
    input wire clk,
    input wire [NUM_LED-1:0] led_in,
    output wire [NUM_LED-1:0] led_out,
    output wire ready
);

localparam WAIT_TIME = (CLK_FREQ / 4);
localparam ST_IDLE = 1, ST_TEST_ALL = 2, ST_TEST_EACH = 3;

reg [NUM_LED-1:0] led;
reg [$clog2(CLK_FREQ+1)-1:0] counter;
reg [$clog2(NUM_LED+1)-1:0] led_count;

integer state;

// Once initial test is done, bypass logic
genvar n;
generate
    for(n=0; n<NUM_LED; n=n+1) begin
        assign led_out[n] = (ready) ? led_in[n] ^ INVERTED : led[n] ^ INVERTED;
    end
endgenerate


assign ready = (state == ST_IDLE) ? 1'b1 : 1'b0;

always@(posedge clk) begin
    if(rst) begin
        counter <= 0;
        led_count <= 0;
        led <= 1'b0;
        state <= ST_TEST_ALL;
    end else begin
        case(state)
            ST_TEST_ALL: begin
                led_count <= 1;
                if(counter < WAIT_TIME) begin
                    counter <= counter + 1'b1;
                    led <= {NUM_LED{1'b1}};
                    state <= ST_TEST_ALL;
                end else begin
                    counter <= 0;
                    led <= {{(NUM_LED-1){1'b0}}, 1'b1};
                    state <= ST_TEST_EACH;
                end
            end
            ST_TEST_EACH: begin
                if(counter < WAIT_TIME) begin
                    counter <= counter + 1'b1;
                    led_count <= led_count;
                    led <= led;
                    state <= ST_TEST_EACH;
                end else begin
                    counter <= 0;
                    if(led_count == NUM_LED) begin
                      	led_count <= 0;
                        led <= 0;
                        state <= ST_IDLE;
                    end else begin
                      	led_count <= led_count + 1'b1;
                        led <= {led[NUM_LED-2:0], 1'b0};
                        state <= ST_TEST_EACH;
                    end
                end
            end
            ST_IDLE: begin
                counter <= 0;
                led_count <= 0;
                led <= 0;
                state <= ST_IDLE;
            end
            default: begin
                counter <= 0;
                led_count <= 0;
                led <= 0;
                state <= ST_IDLE;
            end
        endcase
    end
end

endmodule