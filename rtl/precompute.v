`timescale 1ns/1ps


module precompute(
    input  signed [15:0] x,
    output signed [19:0] p1, p3, p5, p7, p9, p11, p13, p15
);
assign p1  = x;
assign p3  = (x << 1) + x;
assign p5  = (x << 2) + x;
assign p7  = (x << 3) - x;
assign p9  = (x << 3) + x;
assign p11 = (x << 3) + (x << 1) + x;
assign p13 = (x << 3) + (x << 2) + x;
assign p15 = (x << 4) - x;
endmodule
