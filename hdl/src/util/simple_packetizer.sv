`timescale 1 ns / 1 ps

// Takes N inputs and puts them into a AXI Stream in order

module simple_packetizer #(
    parameter PREPEND_LEN = 0,
    parameter NUM_INPUTS = 1,
  	parameter ENDIAN_SWAP = 0,
    parameter ID = 0,
    parameter WIDTH = 32
)(
    input wire rst,
    input wire clk,

    input wire capture, // Signal to capture inputs
    input wire [NUM_INPUTS-1:0][WIDTH-1:0] d,

    // AXI Stream
    input wire tready,
    output reg [WIDTH-1:0] tdata,
    output reg tvalid,
    output reg tlast
);

wire [WIDTH-1:0] num_words = NUM_INPUTS;
reg [NUM_INPUTS-1:0][WIDTH-1:0] captured_d;
reg [$clog2(NUM_INPUTS+1):0] count;
reg active;

wire ready_for_capture = (!active) && (!tvalid) ? 1'b1 : 1'b0;

genvar n;
generate

for(n=0; n < NUM_INPUTS; n = n + 1) begin
  always@(posedge clk) begin
    if(ENDIAN_SWAP) begin
      captured_d[n] <= (ready_for_capture && capture) ? {<<8{d[n]}} : captured_d[n];
    end else begin
      captured_d[n] <= (ready_for_capture && capture) ? d[n] : captured_d[n];
    end
  end
end

// Transmit length before sending the actual data
always@(posedge clk) begin
  if(rst) begin
    count <= 0;
    active <= 1'b0;
    tlast <= 1'b0;
    tvalid <= 1'b0;
    tdata <= 0;
  end else begin
    if(tvalid) begin
      if(tready) begin
        active <= (count < NUM_INPUTS-1) ? active : 1'b0;
        count <= (active) ? count + 1'b1 : 0;
        tvalid <= (active) ? 1'b1 : 1'b0;
        tdata <= (active) ? captured_d[count] : 0;
        tlast <= (active) && (count == NUM_INPUTS-1) ? 1'b1 : 1'b0;
      end else begin
        active <= active;
        count <= count;
        tvalid <= tvalid;
        tdata <= tdata;
        tlast <= tlast;
      end
    end else if (!active && capture) begin
      active <= 1'b1;
      count <= 0;
      tvalid <= 1'b1;
      //  tdata <= (ENDIAN_SWAP) ? { {<<8{num_words[WIDTH-9:0]}}, ID[7:0] } : { ID[7:0], num_words[WIDTH-9:0] };
      tdata <= { ID[7:0], num_words[WIDTH-9:0] };
      tlast <= 1'b0;
    end else begin
      active <= 1'b0;
      count <= 0;
      tvalid <= 1'b0;
      tdata <= 0;
      tlast <= 1'b0;
    end
  end
end

endgenerate

endmodule
