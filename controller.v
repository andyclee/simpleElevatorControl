//Switches are used to simulate the call from outside of the elevator
//The positions of the switches indicate in binary what floor the
//elevator is being called from
//The keypad or keypad substitute is meant to simulate the calling
//of the elevator from within the carriage (i.e. use pushes the button
//to select the floor they wish to go to)
//
//Outputs current floor and direction for a top_level module to display
module controller(should_move, call_inside, call_up, call_down, cur_floor_out, direction, cur_floor_in, write_floor, floor_called, in_out, call_dir, floor_reached, clk, reset);
	output [2:0] cur_floor_out;
	output direction;
	output should_move;

	output [7:0] call_inside, call_up, call_down;
	input [2:0] write_floor;
	input [2:0] cur_floor_in;
	input 	    in_out, call_dir;
	input	    floor_called, floor_reached;
	input clk, reset;

	wire [7:0] call_all, rf_call_up, rf_call_down, rf_call_inside;
	wire [5:0] wr_data;
	wire curr_dir;

	assign wr_data[2:0] = write_floor; //Floor
	assign wr_data[3] = in_out; //Called inside
	assign wr_data[4] = call_dir;
	assign wr_data[5] = floor_called & ~floor_reached;

	regfile rf(rf_call_inside, rf_call_up, rf_call_down, wr_data, wr_floor, clk, reset);
	assign call_all[1] = rf_call_up[1] | rf_call_down[1] | rf_call_inside[1];
    assign call_all[2] = rf_call_up[2] | rf_call_down[2] | rf_call_inside[2];
    assign call_all[3] = rf_call_up[3] | rf_call_down[3] | rf_call_inside[3];
    assign call_all[4] = rf_call_up[4] | rf_call_down[4] | rf_call_inside[4];
    assign call_all[5] = rf_call_up[5] | rf_call_down[5] | rf_call_inside[5];
    assign call_all[6] = rf_call_up[6] | rf_call_down[6] | rf_call_inside[6];
    assign call_all[7] = rf_call_up[7] | rf_call_down[7] | rf_call_inside[7];

	//Used for calculation and display
	register #(3, 0) currentFloor(cur_floor_out, cur_floor_in, 1'b1, clk, reset);

	DirectionCalculator dc(direction, should_move, call_all, cur_floor_out, clk, reset);
	
	assign call_inside = rf_call_inside;
	assign call_up = rf_call_up;
	assign call_down = rf_call_down;
endmodule //controller

//call_down/call_up is the direction of the elevator call (up/down) (dpad button
//up/down)
//in_out is 1 if button called from inside (last_switch)
//button_call is whether button was pushed inside (dpad button center)
//in_floor is the floor called from inside (Switches 5:3)
//out_floor is floor called from outside (Switches 2:0)
//floorCalled is whether a floor was called at all
//call_dir is 1 if called up, 0 if called down
module input_manager(write_floor, in_out, call_dir, floorCalled, call_down, call_up, button_call, in_floor, out_floor);
	output [2:0] write_floor;
	output in_out;
	output call_dir;
	output floorCalled;
	input call_up, call_down;
	input button_call;
	input [3:0] in_floor, out_floor;

	wire floorCalled;

	assign in_out = call_up | call_down;
	assign floorCalled = in_out | button_call;
	mux2v wfMux(write_floor, out_floor, in_floor, in_out);
	assign call_dir = call_up;
endmodule //input_manager
