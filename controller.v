//Switches are used to simulate the call from outside of the elevator
//The positions of the switches indicate in binary what floor the
//elevator is being called from
//The keypad or keypad substitute is meant to simulate the calling
//of the elevator from within the carriage (i.e. use pushes the button
//to select the floor they wish to go to)
//
//Outputs current floor and direction for a top_level module to display
module controller(call_inside, call_outside, cur_floor_out, direction, cur_floor_in, write_floor, floor_called, in_out, clk, reset);
	output [2:0] cur_floor_out;
	output [7:0] call_inside, call_outside;
	output direction;

	input [2:0] write_floor;
	input [2:0] cur_floor_in;
	input 	    in_out;
	input	    floor_called;

	wire [7:0] call_all;
	wire [4:0] wr_data;
	wire curr_dir;

	assign wr_data[2:0] = write_floor;
	assign wr_data[3] = in_out;
	assign wr_data[4] = floor_called;

	regfile rf(call_inside, call_outside, wr_data, wr_floor, clk, reset);
	or cfCombinedMask(call_all, call_inside, call_outside)

	//Used for calculation and display
	register #(3, 0) currentFloor(cur_floor_out, cur_floor_in, 1'b1, clk, reset);

	directionCalculator dc(direction, cur_floor_out, call_all);
endmodule; //controller

//call_down/call_up is the direction of the elevator call (up/down) (dpad button
//up/down)
//in_out is 1 if button called from inside (last_switch)
//button_call is whether button was pushed inside (dpad button center)
//in_floor is the floor called from inside (Switches 5:3)
//out_floor is floor called from outside (Switches 2:0)
//floorCalled is whether a floor was called at all
//
//Button call and call_dir will never both have values
module input_manager(write_floor, in_out, floorCalled, call_down, call_up, call_out, button_call, in_floor, out_floor);
	output [3:0] write_floor;
	output in_out;
	input call_up, call_down, in_out;
	input button_call;
	input [3:0] in_floor, out_floor

	wire floorCalled;

	assign in_out = call_up | call_down;
	assign floorCalled = in_out | button_call;
	mux2v wfMux(write_floor, out_floor, in_floor, in_out)
endmodule; //input_manager
