module subsystem_trigger #(
    parameter NUM_SRC = 1,
    localparam NUM_SEL_BITS = (NUM_SRC > 1) ? $clog2(NUM_SRC) - 1 : 1
)(
    input wire clk_sys,
    input wire rst_sys,

    input wire clk,
    input wire rst,

    input wire [NUM_SEL_BITS-1:0] trig_sel,
    input wire [NUM_SRC-1:0] trig_src,
    input wire [NUM_SRC-1:0] trig_invert,
    input wire [NUM_SRC-1:0][1:0] trig_edge_type,

    output reg [NUM_SRC-1:0][31:0] toggle_count,
    output reg [NUM_SRC-1:0][31:0] toggle_rate,
    output reg q
);

/*


genvar n;
generate

if(NUM_SRC > 1) begin

end else begin

end


wire [NUM_SRC-1:0] toggle_strobe;

for(n=0; n<NUM_SRC; n++) begin

trigger_source #(

) ts (
    .clk(),
    .rst(),
    .d(),
    .invert(),
    .edge_trigger(),
    .toggle_count(),
    .toggle_rate(),
    .toggle_rate_strobe(toggle_strobe),
    .q()
);

//

end
endgenerate

*/
endmodule