// Takes an incoming signal and delays it by DELAY amount
// This module has a shortcoming, if a signal is sent into the 'future' but the surrounding code
// is then 'reset', the any delays placed in the DELAY buffer will not be cleared
module trigger_delay #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire delay, // amount to delay, if set to zero delay logic is bypassed
    input wire d, // input signal to delay
    output wire q // delayed output signal
);

reg [WIDTH-1:0] raddr;
reg [WIDTH-1:0] waddr;

wire int_d;
wire int_q;

// Bypass RAM block if delay is zero
assign int_d = (delay == 0) ? 1'b0 : d;
assign q = (delay == 0) ? d : int_q;

// RAM block for trigger delay
sync_dual_port_ram #(
    .data_width(1),
    .addr_width(WIDTH)
) delay_block (
    .clk(clk),
    .waddr(waddr),
    .raddr(raddr), 
    .we(1'b1), 
    .d(int_d),
    .q(int_q)
);  

// Rotate through read addresses at a constant pace
// Write address is determined by current read address + delay
// so should DELAY amount into future
always@(posedge clk) begin
    raddr <= raddr + 1'b1;      
    waddr <= raddr + delay;      
end

endmodule