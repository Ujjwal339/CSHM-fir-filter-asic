`timescale 1ns/1ps
`timescale 1ns/1ps

module cshm_mult(
    input  signed [15:0] x,
    input  signed [15:0] c,
    output signed [31:0] y
);
wire signed [19:0] p1,p3,p5,p7,p9,p11,p13,p15;

precompute pc(x,p1,p3,p5,p7,p9,p11,p13,p15);

// --- BUG FIX: Handle negative coefficients ---
// 1. Extract the sign bit
wire sign_c = c[15];

// 2. Take the absolute value of the coefficient for the CSHM logic
wire [15:0] abs_c = sign_c ? (~c + 1) : c;

// 3. Split the ABSOLUTE coefficient into 4-bit nibbles
wire [3:0] c0 = abs_c[3:0];
wire [3:0] c1 = abs_c[7:4];
wire [3:0] c2 = abs_c[11:8];
wire [3:0] c3 = abs_c[15:12];

wire signed [22:0] s0,s1,s2,s3;
select_unit u0(p1,p3,p5,p7,p9,p11,p13,p15,c0,s0);
select_unit u1(p1,p3,p5,p7,p9,p11,p13,p15,c1,s1);
select_unit u2(p1,p3,p5,p7,p9,p11,p13,p15,c2,s2);
select_unit u3(p1,p3,p5,p7,p9,p11,p13,p15,c3,s3);

// Final accumulation tree (Calculates the unsigned magnitude)
wire signed [31:0] abs_y = (s0) + (s1 <<< 4) + (s2 <<< 8) + (s3 <<< 12);

// --- BUG FIX: Apply Sign ---
// 4. Invert the final answer if the original coefficient was negative
assign y = sign_c ? -abs_y : abs_y;

endmodule
