module decoder2(out, in, enable);
	input		in;
	input		enable;
	output [1:0]	out;

	and a0(out[0], enable, ~in);
	and a1(out[1], enable, in);
endmodule //decoder2

module decoder4(out, in, enable);
	input [1:0]	in;
	input		enable;
	output [3:0]	out;
	wire [1:0]	w_enable;

	decoder2 out0(out[1:0], in[0], enable & ~in[1]);
	decoder2 out1(out[3:2], in[0], enable & in[1]);
endmodule //decoder4

module decoder8(out, in, enable);
	input [2:0]	in;
	input		enable;
	output [7:0]	out;
	wire [1:0]	w_enable;

	decoder4 out0(out[3:)], in[1:0], enable & ~in[2]);
	decoder4 out1(out[7:4], in[1:0], enable & in[2]);
endmodule //decoder8

module mux2v(out, A, B, sel);

   parameter
     width = 32;
   
   output [width-1:0] out;
   input  [width-1:0] A, B;
   input              sel;

   wire [width-1:0] temp1 = ({width{(!sel)}} & A);
   wire [width-1:0] temp2 = ({width{(sel)}} & B);
   assign out = temp1 | temp2;

endmodule // mux2v
