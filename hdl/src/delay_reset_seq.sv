`timescale 1 ns / 1 ps

module delay_reset_seq #(
    parameter CLOCK_FREQ = 250.0
)
(
    input wire rst,
    input wire clk,
    input wire rdy,

    input wire d,
    output wire q,

    input wire [8:0] load_value,
    output wire [8:0] delay_value,
    output reg done
);

localparam ST_RESET = 1, ST_IDLE = 2, ST_START_LOAD = 4, ST_LOAD = 8, ST_FINISH_LOAD = 16;
localparam DELAY_WAIT = 10;

reg en_vtc;
reg load;
reg [7:0] state_count;
reg [8:0] r_current_value;

integer state;

always@(posedge clk, posedge rst) begin
  if(rst) begin
        en_vtc <= 1'b1;
        state <= ST_RESET;
        load <= 1'b0;
        done <= 1'b0;
        state_count <= 0;
        r_current_value <= 0;
    end else begin
        case(state)

        // Stay here even after rst goes low, until calibration ready goes high
        ST_RESET: begin
            state <= (rdy) ? ST_IDLE : ST_RESET;
            en_vtc <= 1'b1;
            load <= 1'b0;
            done <= 1'b0;
            state_count <= 0;
            r_current_value <= 0;
        end

        ST_IDLE: begin
            state <= (r_current_value == load_value) ? ST_IDLE : ST_START_LOAD;
            en_vtc <= 1'b1;
            load <= 1'b0;
            done <= (r_current_value == load_value) ? 1'b1 : 1'b0;
            state_count <= DELAY_WAIT;
          	r_current_value <= load_value;
        end

        ST_START_LOAD: begin
            state <= (state_count > 0) ? ST_START_LOAD : ST_LOAD;
            en_vtc <= 1'b0;
            load <= 1'b0;
            done <= 1'b0;
            state_count <= state_count - 1'b1;
            r_current_value <= r_current_value;
        end

        ST_LOAD: begin
            state <= ST_FINISH_LOAD;
            en_vtc <= 1'b0;
            load <= 1'b1;
            done <= 1'b0;
            state_count <= DELAY_WAIT;
            r_current_value <= r_current_value;
        end

        ST_FINISH_LOAD: begin
            state <= (state_count > 0) ? ST_FINISH_LOAD : ST_IDLE;
            en_vtc <= 1'b0;
            load <= 1'b0;
            done <= 1'b0;
            state_count <= state_count - 1'b1;
            r_current_value <= r_current_value;
        end

        endcase
    end
end

IDELAYE3 #(
    .SIM_DEVICE("ULTRASCALE_PLUS"),
    .CASCADE("NONE"),       // Cascade setting(NONE,MASTER,SLAVE_END,SLAVE_MIDDLE)
    .DELAY_FORMAT("TIME"),  // Units of the DELAY_VALUE(TIME,COUNT)
    .DELAY_SRC("IDATAIN"),  // Delay input(IDATAIN,DATAIN)
    .DELAY_TYPE("VAR_LOAD"),   // Set thet ype of tap delay line(FIXED,VAR_LOAD,VARIABLE)
    .DELAY_VALUE(0),        // Input delay value setting
    .IS_CLK_INVERTED(0), // Optional inversion for CLK
    .IS_RST_INVERTED(0), // Optional inversion for RST
    .REFCLK_FREQUENCY(CLOCK_FREQ),// IDELAYCTRL clock input frequency in MHz(VALUES)
    .UPDATE_MODE("ASYNC")//Determines when updates to the delay will take effect (ASYNC,MANUAL,SYNC)
) idelay (
    .RST(rst),
    .CLK(clk),
    .EN_VTC(en_vtc),
    .CASC_OUT(),
    .CASC_IN(1'b0),
    .CASC_RETURN(1'b0),
    .CE(1'b0),
    .INC(1'b0),
    .LOAD(load),
    .CNTVALUEOUT(delay_value),
    .CNTVALUEIN(r_current_value),
    .DATAIN(1'b0),
    .IDATAIN(d),
    .DATAOUT(q)
);

endmodule