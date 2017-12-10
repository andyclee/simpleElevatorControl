module simulator(cur_floor_out, direction_out, open, cur_floor_in, direction_in, call_in, call_up, call_down, move_in, clock);
	output [2:0] cur_floor_out;
	output	direction_out, open;

	input	[7:0] call_in, call_up, call_down;
	input	[2:0] cur_floor_in;
	input	direction_in;
	input	move_in;
	input   clock;

	wire [3:0] control;
	wire dirOut;
	wire [2:0] floorOut;

	floorChecker fc(open, cur_floor_in, direction_in, call_in, call_up, call_down);
	mux2v subOrAdd(control, 3'h2, 3'h3, direction_in);
	alu32 modFloor(floorOut, , , , cur_floor_in, move_in, control);

	mux2v dirMux(direction_out, direction_in, dirOut, clock);
	mux2v floorMux(cur_floor_out, cur_floor_in, floorOut, clock);

endmodule //simulator

module floorChecker(open, cur_floor, direction, call_in, call_up, call_down);
	output open;
	input [2:0] cur_floor;
	input direction;
	input [7:0] call_in, call_up, call_down;

	wire [7:0] decOut;
	wire [7:0] inOut, upOut, downOut;

	decoder8 floorDec(decOut, cur_floor, 1'b1);
	
	assign inOut[0] = call_in[0] & decOut[0];
	assign inOut[1] = call_in[1] & decOut[1];
	assign inOut[2] = call_in[2] & decOut[2];
	assign inOut[3] = call_in[3] & decOut[3];
	assign inOut[4] = call_in[4] & decOut[4];
	assign inOut[5] = call_in[5] & decOut[5];
	assign inOut[6] = call_in[6] & decOut[6];
	assign inOut[7] = call_in[7] & decOut[7];

	assign upOut[0] = call_up[0] & decOut[0] & direction;
	assign upOut[1] = call_up[1] & decOut[1] & direction;
	assign upOut[2] = call_up[2] & decOut[2] & direction;
	assign upOut[3] = call_up[3] & decOut[3] & direction;
	assign upOut[4] = call_up[4] & decOut[4] & direction;
	assign upOut[5] = call_up[5] & decOut[5] & direction;
	assign upOut[6] = call_up[6] & decOut[6] & direction;
	assign upOut[7] = call_up[7] & decOut[7] & direction;

	assign downOut[0] = call_down[0] & decOut[0] & ~direction;
	assign downOut[1] = call_down[1] & decOut[1] & ~direction;
	assign downOut[2] = call_down[2] & decOut[2] & ~direction;
	assign downOut[3] = call_down[3] & decOut[3] & ~direction;
	assign downOut[4] = call_down[4] & decOut[4] & ~direction;
	assign downOut[5] = call_down[5] & decOut[5] & ~direction;
	assign downOut[6] = call_down[6] & decOut[6] & ~direction;
	assign downOut[7] = call_down[7] & decOut[7] & ~direction;

	or outOr(inOut[0], upOut[0], downOut[0], inOut[1], upOut[1], downOut[1], inOut[2], upOut[2], downOut[2], inOut[3], upOut[3], downOut[3], inOut[4], upOut[4], downOut[4], inOut[5], upOut[5], downOut[5], inOut[6], upOut[6], downOut[6], inOut[7], upOut[7], downOut[7]);

endmodule //floorChecker
