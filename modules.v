`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

//// ALU Code from Lab 5
module alu32(out, overflow, zero, negative, inA, inB, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] inA, inB;
    input  [2:0]  control;

    assign out = (({32{(control == `ALU_AND)}} & (inA & inB)) |
        ({32{(control == `ALU_OR)}} & (inA | inB)) |
        ({32{(control == `ALU_XOR)}} & (inA ^ inB)) |
        ({32{(control == `ALU_NOR)}} & ~(inA | inB)) |
        ({32{(control == `ALU_ADD)}} & (inA + inB)) |
        ({32{(control == `ALU_SUB)}} & (inA - inB)));
    assign zero = (out[31:18] == 14'b0) & (out[17:1] == 17'd0) & ~out[0];
    xor x1(negative, out[31], 1'b0);
    assign overflow = 1'b0;  // Not used
   
endmodule

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
