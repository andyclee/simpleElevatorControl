module BCDToLED (seg, x);
    output [6:0] seg;
    input  [3:0] x;

    assign seg[0] = (x[2] & ~x[1] & ~x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]);
    assign seg[1] = (x[2] & ~x[1] & x[0]) | (x[2] & x[1] & ~x[0]);
    assign seg[2] = (~x[2] & x[1] & ~x[0]);
    assign seg[3] = (x[2] & ~x[1] & ~x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]) | (x[2] & x[1] & x[0]);
    assign seg[4] = (x[2] & ~x[1]) | (x[0]);
    assign seg[5] = (~x[3] & ~x[2] & x[0]) | (x[1] & x[0]) | (~x[2] & x[1]);
    assign seg[6] = (~x[3] & ~x[2] & ~x[1]) | (x[2] & x[1] & x[0]);


endmodule // BCDtoLED

module Comparator(z, v);
    output      z;
    input [3:0] v;

    assign z = (v[3] & v[2]) | (v[3] & v[1]);

endmodule // Comparator

module CircuitA(m, v);
    output [3:0] m;
    input  [2:0] v;

    assign m[0] = v[0];
    assign m[1] = ~v[1];
    assign m[2] = v[2] & v[1];
    assign m[3] = 0;

endmodule // CircuitA
