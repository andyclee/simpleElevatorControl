// Registers for elevator floors
module register(q, d, enable, clk, reset);
	parameter
		width = 32,
		reset_value = 0;

	output [(width-1):0] q;
	reg    [(width-1):0] q;
	input  [(width-1):0] d;
	input	clk, enable, reset;

	always@(reset)
		if (reset == 1'b1)
			q <= reset_value;

	always@(posedge clk)
		if ((reset == 1;b0) && (enable == 1'b1))
			q <= d;
	
endmodule //register

//call_mask = floor called from outside
//floors = floor called from inside
module regfile(call_inside, call_up, call_down, wr_data, wr_regnum, clk, reset);
	output [7:0] call_inside, call_up, call_down;
	input  [2:0] wr_regnum;
	input  [5:0] wr_data;
	input clk, reset;

	wire [5:0] regOut [7:0];
	wire enable;

	assign enable = wr_data[4];

	//Data for floors (Called in/out car, Called up/down, Floor num)
	register #(6, 6'b00000) reg0(regOut[0], wr_data, enable, clk, reset);
	register #(6, 6'b00001) reg1(regOut[1], wr_data, enable, clk, reset);
	register #(6, 6'b00010) reg2(regOut[2], wr_data, enable, clk, reset);
	register #(6, 6'b00011) reg3(regOut[3], wr_data, enable, clk, reset);
	register #(6, 6'b00100) reg4(regOut[4], wr_data, enable, clk, reset);
	register #(6, 6'b00101) reg5(regOut[5], wr_data, enable, clk, reset);
	register #(6, 6'b00110) reg6(regOut[6], wr_data, enable, clk, reset);
	register #(6, 6'b00111) reg7(regOut[7], wr_data, enable, clk, reset);

	//Highest flor is MSB
	assign call_inside[0] = regOut[0][3] & regOut[0][5];
	assign call_inside[1] = regOut[1][3] & regOut[1][5];
	assign call_inside[2] = regOut[2][3] & regOut[2][5];
	assign call_inside[3] = regOut[3][3] & regOut[3][5];
	assign call_inside[4] = regOut[4][3] & regOut[4][5];
	assign call_inside[5] = regOut[5][3] & regOut[5][5];
	assign call_inside[6] = regOut[6][3] & regOut[6][5];
	assign call_inside[7] = regOut[7][3] & regOut[7][5];

	assign call_up[0] = ~regOut[0][3] & regOut[0[4] & regOut[0][5];
	assign call_up[1] = ~regOut[1][3] & regOut[1[4] & regOut[1][5];
	assign call_up[2] = ~regOut[2][3] & regOut[2[4] & regOut[2][5];
	assign call_up[3] = ~regOut[3][3] & regOut[3[4] & regOut[3][5];
	assign call_up[4] = ~regOut[4][3] & regOut[4[4] & regOut[4][5];
	assign call_up[5] = ~regOut[5][3] & regOut[5[4] & regOut[5][5];
	assign call_up[6] = ~regOut[6][3] & regOut[6[4] & regOut[6][5];
	assign call_up[7] = ~regOut[7][3] & regOut[7[4] & regOut[7][5];

	assign call_down[0] = ~regOut[0][3] & ~regOut[0[4] & regOut[0][5];
	assign call_down[1] = ~regOut[1][3] & ~regOut[1[4] & regOut[1][5];
	assign call_down[2] = ~regOut[2][3] & ~regOut[2[4] & regOut[2][5];
	assign call_down[3] = ~regOut[3][3] & ~regOut[3[4] & regOut[3][5];
	assign call_down[4] = ~regOut[4][3] & ~regOut[4[4] & regOut[4][5];
	assign call_down[5] = ~regOut[5][3] & ~regOut[5[4] & regOut[5][5];
	assign call_down[6] = ~regOut[6][3] & ~regOut[6[4] & regOut[6][5];
	assign call_down[7] = ~regOut[7][3] & ~regOut[7[4] & regOut[7][5];

~endmodule //register
