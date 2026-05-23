`timescale 1ns/1ps

module fir_11tap_cshm(
    input clk,
    input signed [15:0] x,
    // Dynamic runtime programmable coefficients
    input signed [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,
    output reg signed [35:0] y
);
reg signed [15:0] d[0:10];
integer i;

// Shift-Register Delay Line
always @(posedge clk) begin
    d[0] <= x;
    for(i=1; i<11; i=i+1)
        d[i] <= d[i-1];
end

wire signed [31:0] m[0:10];
// Instantiating the optimized multipliers
cshm_mult cm0 (.x(d[0]), .c(h0), .y(m[0]));
cshm_mult cm1 (.x(d[1]), .c(h1), .y(m[1]));
cshm_mult cm2 (.x(d[2]), .c(h2), .y(m[2]));
cshm_mult cm3 (.x(d[3]), .c(h3), .y(m[3]));
cshm_mult cm4 (.x(d[4]), .c(h4), .y(m[4]));
cshm_mult cm5 (.x(d[5]), .c(h5), .y(m[5]));
cshm_mult cm6 (.x(d[6]), .c(h6), .y(m[6]));
cshm_mult cm7 (.x(d[7]), .c(h7), .y(m[7]));
cshm_mult cm8 (.x(d[8]), .c(h8), .y(m[8]));
cshm_mult cm9 (.x(d[9]), .c(h9), .y(m[9]));
cshm_mult cm10(.x(d[10]),.c(h10),.y(m[10]));

// Accumulation Stage
always @(posedge clk) begin
    y <= m[0]+m[1]+m[2]+m[3]+m[4]+
         m[5]+m[6]+m[7]+m[8]+m[9]+m[10];
end
endmodule
