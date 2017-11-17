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

module regfile(call_mask, floors, wr_data, wr_regnum, clk, reset);
	output [7:0] call_mask, floors;
	input  [2:0] wr_regnum;
	input  [4:0] wr_data;
	input clk, reset;

	wire [7:0] regIn;
	wire [5:0] regOut [7:0];

	decoder8 getReg(regIn, wr_regnum, 1'b1);

	//Data for floors (Called in/out car, Called up/down, Floor num)
	register #(5, 5'b00000) reg0(regOut[0], wr_data, regIn[0], clk, reset);
	register #(5, 5'b00001) reg1(regOut[1], wr_data, regIn[1], clk, reset);
	register #(5, 5'b00010) reg2(regOut[2], wr_data, regIn[2], clk, reset);
	register #(5, 5'b00011) reg3(regOut[3], wr_data, regIn[3], clk, reset);
	register #(5, 5'b00100) reg4(regOut[4], wr_data, regIn[4], clk, reset);
	register #(5, 5'b00101) reg5(regOut[5], wr_data, regIn[5], clk, reset);
	register #(5, 5'b00110) reg6(regOut[6], wr_data, regIn[6], clk, reset);
	register #(5, 5'b00111) reg7(regOut[7], wr_data, regIn[7], clk, reset);

	//Highest flor is MSB
	assign call_mask[0] = regOut[0][4];
	assign call_mask[1] = regOut[1][4];
	assign call_mask[2] = regOut[2][4];
	assign call_mask[3] = regOut[3][4];
	assign call_mask[4] = regOut[4][4];
	assign call_mask[5] = regOut[5][4];
	assign call_mask[6] = regOut[6][4];
	assign call_mask[7] = regOut[7][4];

	assign floors[0] = regOut[0][3];
	assign floors[1] = regOut[1][3];
	assign floors[2] = regOut[2][3];
	assign floors[3] = regOut[3][3];
	assign floors[4] = regOut[4][3];
	assign floors[5] = regOut[5][3];
	assign floors[6] = regOut[6][3];
	assign floors[7] = regOut[7][3];

endmodule //register
