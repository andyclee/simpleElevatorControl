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
module regfile(call_inside, call_outside, wr_data, wr_regnum, clk, reset);
	output [7:0] call_inside, call_outside;
	input  [2:0] wr_regnum;
	input  [4:0] wr_data;
	input clk, reset;

	wire [5:0] regOut [7:0];
	wire enable;

	assign enable = wr_data[4];

	//Data for floors (Called in/out car, Called up/down, Floor num)
	register #(5, 5'b00000) reg0(regOut[0], wr_data, enable, clk, reset);
	register #(5, 5'b00001) reg1(regOut[1], wr_data, enable, clk, reset);
	register #(5, 5'b00010) reg2(regOut[2], wr_data, enable, clk, reset);
	register #(5, 5'b00011) reg3(regOut[3], wr_data, enable, clk, reset);
	register #(5, 5'b00100) reg4(regOut[4], wr_data, enable, clk, reset);
	register #(5, 5'b00101) reg5(regOut[5], wr_data, enable, clk, reset);
	register #(5, 5'b00110) reg6(regOut[6], wr_data, enable, clk, reset);
	register #(5, 5'b00111) reg7(regOut[7], wr_data, enable, clk, reset);

	//Highest flor is MSB
	assign call_inside[0] = regOut[0][3];
	assign call_inside[1] = regOut[1][3];
	assign call_inside[2] = regOut[2][3];
	assign call_inside[3] = regOut[3][3];
	assign call_inside[4] = regOut[4][3];
	assign call_inside[5] = regOut[5][3];
	assign call_inside[6] = regOut[6][3];
	assign call_inside[7] = regOut[7][3];

	assign call_outside[0] = ~regOut[0][3];
	assign call_outside[1] = ~regOut[1][3];
	assign call_outside[2] = ~regOut[2][3];
	assign call_outside[3] = ~regOut[3][3];
	assign call_outside[4] = ~regOut[4][3];
	assign call_outside[5] = ~regOut[5][3];
	assign call_outside[6] = ~regOut[6][3];
	assign call_outside[7] = ~regOut[7][3];

~endmodule //register
