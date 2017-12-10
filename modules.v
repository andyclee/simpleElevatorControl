`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

module dffe(q, d, clk, enable, reset);
    parameter
        width = 1,
        reset_value = 0;

    output reg [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;

always@(posedge clk or posedge reset)
  if (reset == 1'b1)
    q <= reset_value;
  else if (enable == 1'b1)
    q <= d;
endmodule // dffe

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

	decoder2 out0(out[1:0], in[0], enable & ~in[1]);
	decoder2 out1(out[3:2], in[0], enable & in[1]);
endmodule //decoder4

module decoder8(out, in, enable);
	input [2:0]	in;
	input		enable;
	output [7:0]	out;

	decoder4 out0(out[3:0], in[1:0], enable & ~in[2]);
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

module mux4v(out, A, B, C, D, sel);

   parameter
     width = 32;

   output [width-1:0] out;
   input  [width-1:0] A, B, C, D;
   input  [1:0]       sel;
   wire   [width-1:0] wAB, wCD;

   mux2v #(width) mAB (wAB, A, B, sel[0]);
   mux2v #(width) mCD (wCD, C, D, sel[0]);
   mux2v #(width) mfinal (out, wAB, wCD, sel[1]);

endmodule // mux4v

module DirectionCalculator(direction, shouldMove, floorsCalled, currentFloor, clock, reset);
    // implement a FSM
    output direction, shouldMove;
    input [7:0] floorsCalled;
    input [2:0] currentFloor;
    input clock, reset;
    wire sChoose, sDown, sUp;
    wire choose_next, down_next, up_next;
    wire [31:0] dcount, ucount;
    //wire [31:0] diff;
    wire above0, below0, negDiff;

    DownCounter dc(dcount, floorsCalled, currentFloor);
    UpperCounter uc(ucount, floorsCalled, currentFloor);

    assign above0 = ucount == 0;
    assign below0 = dcount == 0;
    alu32 a(, , , negDiff, dcount, ucount, `ALU_SUB);

    assign choose_next = (sChoose & above0 & below0) | (sDown & below0) | (sUp & above0);
    assign down_next = (sChoose & negDiff) | (sDown & ~below0);
    assign up_next = (sChoose & ~negDiff & ~above0) | (sUp & ~above0);

    assign shouldMove = (sDown | sUp);
    assign direction = sUp;

    dffe #(1, 0) fsChoose(sChoose, choose_next, clock, 1'b1, 1'b0);
    dffe #(1, 0) fsUp(sUp, up_next, clock, 1'b1, 1'b0);
    dffe #(1, 0) fsDown(sDown, down_next, clock, 1'b1, 1'b0);
//    output goingUp;
//    input [2:0] currentFloor;
//    input [7:0] floorsCalled;
//
//    wire isLower0 , isLower1 , isLower2 , isLower3 , isLower4 , isLower5 , isLower6 ;
//    wire isUpper0 , isUpper1 , isUpper2 , isUpper3 , isUpper4 , isUpper5 , isUpper6 ;
//    wire [31:0] lowerout0 , lowerout1 , lowerout2 , lowerout3 , lowerout4 , lowerout5 ;
//    wire [31:0] upperout0 , upperout1 , upperout2 , upperout3 , upperout4 , upperout5 ;
//    wire fcomp0 , fcomp1 , fcomp2 , fcomp3 , fcomp4 , fcomp5, fcomp6;
//    wire goingDown;
//    // lower adders
//    alu32 la0(lowerout0, , , , isLower0, isLower1, `ALU_ADD);
//    alu32 la1(lowerout1, , , , isLower1, isLower2, `ALU_ADD);
//    alu32 la2(lowerout2, , , , isLower2, isLower3, `ALU_ADD);
//    alu32 la3(lowerout3, , , , isLower3, isLower4, `ALU_ADD);
//    alu32 la4(lowerout4, , , , isLower4, isLower5, `ALU_ADD);
//    alu32 la5(lowerout5, , , , isLower5, isLower6, `ALU_ADD);
//
//    // upper adders
//    alu32 ua0(upperout0, , , , isUpper0, isUpper1, `ALU_ADD);
//    alu32 ua1(upperout1, , , , isUpper1, isUpper2, `ALU_ADD);
//    alu32 ua2(upperout2, , , , isUpper2, isUpper3, `ALU_ADD);
//    alu32 ua3(upperout3, , , , isUpper3, isUpper4, `ALU_ADD);
//    alu32 ua4(upperout4, , , , isUpper4, isUpper5, `ALU_ADD);
//    alu32 ua5(upperout5, , , , isUpper5, isUpper6, `ALU_ADD);
//    // level comparators
//    alu32 comp0( , , , fcomp0, currentFloor, 32'b1, `ALU_SUB);
//    alu32 comp1( , , , fcomp1, currentFloor, 32'b10, `ALU_SUB);
//    alu32 comp2( , , , fcomp2, currentFloor, 32'b11, `ALU_SUB);
//    alu32 comp3( , , , fcomp3, currentFloor, 32'b100, `ALU_SUB);
//    alu32 comp4( , , , fcomp4, currentFloor, 32'b101, `ALU_SUB);
//    alu32 comp5( , , , fcomp5, currentFloor, 32'b110, `ALU_SUB);
//    alu32 comp6( , , , fcomp6, currentFloor, 32'b111, `ALU_SUB);
//    // decoders
//    decoder2 d0({isUpper0, isLower0}, 1'b1, ~fcomp0);
//    decoder2 d1({isUpper1, isLower1}, 1'b1, ~fcomp1);
//    decoder2 d2({isUpper2, isLower2}, 1'b1, ~fcomp2);
//    decoder2 d3({isUpper3, isLower3}, 1'b1, ~fcomp3);
//    decoder2 d4({isUpper4, isLower4}, 1'b1, ~fcomp4);
//    decoder2 d5({isUpper5, isLower5}, 1'b1, ~fcomp5);
//    decoder2 d6({isUpper6, isLower6}, 1'b1, ~fcomp6);
//
//    alu32 fin( , , , goingDown, upperout5, lowerout5, `ALU_SUB);
//    assign goingUp = ~goingDown;

endmodule // DirectionCalculator

module DownCounter(count, floorsCalled, currentFloor);
    output [31:0] count;
    input [2:0] currentFloor;
    input [7:0] floorsCalled;

    wire isLower0 , isLower1 , isLower2 , isLower3 , isLower4 , isLower5 , isLower6 ;
    wire isUpper0 , isUpper1 , isUpper2 , isUpper3 , isUpper4 , isUpper5 , isUpper6 ;
    wire [31:0] lowerout0 , lowerout1 , lowerout2 , lowerout3 , lowerout4 , lowerout5 ;
    wire fcomp0 , fcomp1 , fcomp2 , fcomp3 , fcomp4 , fcomp5, fcomp6;
    // lower adders
    alu32 la0(lowerout0, , , , isLower0, isLower1, `ALU_ADD);
    alu32 la1(lowerout1, , , , lowerout0, isLower2, `ALU_ADD);
    alu32 la2(lowerout2, , , , lowerout1, isLower3, `ALU_ADD);
    alu32 la3(lowerout3, , , , lowerout2, isLower4, `ALU_ADD);
    alu32 la4(lowerout4, , , , lowerout3, isLower5, `ALU_ADD);
    alu32 la5(count, , , , lowerout4, isLower6, `ALU_ADD);

    // level comparators
    alu32 comp0( , , , fcomp0, currentFloor, 32'b1, `ALU_SUB);
    alu32 comp1( , , , fcomp1, currentFloor, 32'b10, `ALU_SUB);
    alu32 comp2( , , , fcomp2, currentFloor, 32'b11, `ALU_SUB);
    alu32 comp3( , , , fcomp3, currentFloor, 32'b100, `ALU_SUB);
    alu32 comp4( , , , fcomp4, currentFloor, 32'b101, `ALU_SUB);
    alu32 comp5( , , , fcomp5, currentFloor, 32'b110, `ALU_SUB);
    alu32 comp6( , , , fcomp6, currentFloor, 32'b111, `ALU_SUB);

    // decoders
    decoder2 d0({isUpper0, isLower0}, 1'b1, ~fcomp0);
    decoder2 d1({isUpper1, isLower1}, 1'b1, ~fcomp1);
    decoder2 d2({isUpper2, isLower2}, 1'b1, ~fcomp2);
    decoder2 d3({isUpper3, isLower3}, 1'b1, ~fcomp3);
    decoder2 d4({isUpper4, isLower4}, 1'b1, ~fcomp4);
    decoder2 d5({isUpper5, isLower5}, 1'b1, ~fcomp5);
    decoder2 d6({isUpper6, isLower6}, 1'b1, ~fcomp6);
endmodule // LowerCounter

module UpperCounter(count, floorsCalled, currentFloor);
    output [31:0] count;
    input [2:0] currentFloor;
    input [7:0] floorsCalled;

    wire isLower0 , isLower1 , isLower2 , isLower3 , isLower4 , isLower5 , isLower6 ;
    wire isUpper0 , isUpper1 , isUpper2 , isUpper3 , isUpper4 , isUpper5 , isUpper6 ;
    wire [31:0] upperout0 , upperout1 , upperout2 , upperout3 , upperout4 , upperout5 ;
    wire fcomp0 , fcomp1 , fcomp2 , fcomp3 , fcomp4 , fcomp5, fcomp6;

    // upper adders
    alu32 ua0(upperout0, , , , isUpper0, isUpper1, `ALU_ADD);
    alu32 ua1(upperout1, , , , upperout0, isUpper2, `ALU_ADD);
    alu32 ua2(upperout2, , , , upperout1, isUpper3, `ALU_ADD);
    alu32 ua3(upperout3, , , , upperout2, isUpper4, `ALU_ADD);
    alu32 ua4(upperout4, , , , upperout3, isUpper5, `ALU_ADD);
    alu32 ua5(count, , , , upperout4, isUpper6, `ALU_ADD);
    // level comparators
    alu32 comp0( , , , fcomp0, currentFloor, 32'b1, `ALU_SUB);
    alu32 comp1( , , , fcomp1, currentFloor, 32'b10, `ALU_SUB);
    alu32 comp2( , , , fcomp2, currentFloor, 32'b11, `ALU_SUB);
    alu32 comp3( , , , fcomp3, currentFloor, 32'b100, `ALU_SUB);
    alu32 comp4( , , , fcomp4, currentFloor, 32'b101, `ALU_SUB);
    alu32 comp5( , , , fcomp5, currentFloor, 32'b110, `ALU_SUB);
    alu32 comp6( , , , fcomp6, currentFloor, 32'b111, `ALU_SUB);
    // decoders
    decoder2 d0({isUpper0, isLower0}, 1'b1, ~fcomp0);
    decoder2 d1({isUpper1, isLower1}, 1'b1, ~fcomp1);
    decoder2 d2({isUpper2, isLower2}, 1'b1, ~fcomp2);
    decoder2 d3({isUpper3, isLower3}, 1'b1, ~fcomp3);
    decoder2 d4({isUpper4, isLower4}, 1'b1, ~fcomp4);
    decoder2 d5({isUpper5, isLower5}, 1'b1, ~fcomp5);
    decoder2 d6({isUpper6, isLower6}, 1'b1, ~fcomp6);
endmodule // UpperCounter
