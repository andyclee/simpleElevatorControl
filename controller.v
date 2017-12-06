//Switches are used to simulate the call from outside of the elevator
//The positions of the switches indicate in binary what floor the
//elevator is being called from
//The keypad or keypad substitute is meant to simulate the calling
//of the elevator from within the carriage (i.e. use pushes the button
//to select the floor they wish to go to)
//
//Outputs current floor and direction for a top_level module to display
module controller(current_floor, direction, switches, in_out, keypad, clk, reset);
	output [2:0] current_floor;
	output direction;

	input [2:0] switches;
	input 	    in_out; //Last switch
	input	    keypad;

	wire [7:0] call_mask, floors;
	wire [4:0] wr_data;
	wire [2:0] curFloorOut, tarFloorOut, curFloorIn, tarFloorIn;
	wire currentDirection;

	assign wr_data[2:0] = switches;
	assign wr_data[3] = //TODO: SOME KEYPAD INPUT (UP OR DOWN)
	assign wr_data[4] = in_out;

	regfile(call_mask, floors, wr_data, switches, clk, reset);

	//Used for calculation and display
	register #(3, 0) currentFloor(curFloorOut, curFloorIn, 1'b1, clk, reset);
	register #(3, 0) targetFloor(tarFloorOut, tarFloorIn, 1'b1, clk, reset);

	movement_calculator mcalc(currentDirection, curFloorOut, tarFloorOut);

	assign current_floor = curFloor;
endmodule; //controller

//Given the current floor, call/floor masks, and current direction of travel,
//returns the new target floor
module floor_calculator(newTarget, currentFloor, direction, call_mask, floors);
	output [2:0] newTarget;
	input [2:0] currentFloor;
	input [7:0] call_mask, floors;
	input direction;

	//GENERAL ALGO:
	//IF FLOORS IN DIRECTION TRAVELING HAVE ANY CALLS, 
endmodule; //floor_calculator

//Calculates the direction in which the elevator should be moving
//1 is up, 0 is down
module  movement_calculator(direction, current_floor, target_floor);
	output direction;
	input [3:0] current_floor, target_floor;

	wire notNeg;

	alu32 floorLT( , , , notNeg, current_floor, target_floor, 3'h3);
	assign direction = ~notNeg;

endmodule //movement_calculator
