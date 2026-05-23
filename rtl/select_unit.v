`timescale 1ns/1ps
module select_unit(
    input  signed [19:0] p1, p3, p5, p7, p9, p11, p13, p15,
    input  [3:0] c_part,
    output reg signed [22:0] out
);
reg [2:0] sel;
reg [1:0] shift;
reg signed [19:0] mux_out;

always @(*) begin
    casez(c_part)
        4'b0000: begin sel=0; shift=0; end
        4'b0001: begin sel=0; shift=0; end
        4'b0010: begin sel=0; shift=1; end
        4'b0011: begin sel=1; shift=0; end
        4'b0100: begin sel=0; shift=2; end
        4'b0101: begin sel=2; shift=0; end
        4'b0110: begin sel=1; shift=1; end
        4'b0111: begin sel=3; shift=0; end
        4'b1000: begin sel=0; shift=3; end
        4'b1001: begin sel=4; shift=0; end
        4'b1010: begin sel=2; shift=1; end
        4'b1011: begin sel=5; shift=0; end
        4'b1100: begin sel=1; shift=2; end
        4'b1101: begin sel=6; shift=0; end
        4'b1110: begin sel=3; shift=1; end
        4'b1111: begin sel=7; shift=0; end
    endcase

    case(sel)
        0: mux_out = p1;
        1: mux_out = p3;
        2: mux_out = p5;
        3: mux_out = p7;
        4: mux_out = p9;
        5: mux_out = p11;
        6: mux_out = p13;
        7: mux_out = p15;
    endcase

    if (c_part == 4'b0000)
        out = 0;
    else
        out = mux_out <<< shift;
end
endmodule
