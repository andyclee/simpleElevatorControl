module controller(switches, in_out, keypad, clk, reset);
	input [2:0] switches;
	input 	    in_out;
	input	    keypad;

	wire [7:0] call_mask, floors;
	wire [4:0] wr_data;

	assign wr_data[2:0] = switches;
	assign wr_data[4] = in_out;
	assign wr_data[3] = //TODO: SOME KEYPAD INPUT

	regfile(call_mask, floors, wr_data, switches, clk, reset);

	//TODO: CONNECT TO SEQUENTIAL LOGIC CALCULATOR
endmodule; //controller
