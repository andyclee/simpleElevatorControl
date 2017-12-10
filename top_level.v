`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2017 04:14:02 AM
// Design Name: 
// Module Name: top_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_level(
    input [5:0] sw,
    input button_up,
    input button_down,
    input button_in,
    input clk,
    input resetBtn,
    output [6:0] seg,
    output [3:0] an,
    output led0
    );
    wire reset;
    assign reset = resetBtn;
    
    wire clkout_double, clkout_half;
    
    // we will put the clock in here with the wizard, call it clkout_wiz
    clk_wiz_0 cw(clk, clkoutwiz, reset);
    clock_divider #(5000) div(clkoutwiz, clkout);
    
    wire [2:0] im_write_floor;
    wire im_in_out, im_call_dir, im_floor_called;
    
    wire [2:0] ctrl_floor_out;
    wire [7:0] ctrl_call_up, ctrl_call_down, ctrl_call_inside;
    wire ctrl_direction, ctrl_should_move;
    
    wire [2:0] sim_floor_out;
    wire sim_direction_out, sim_floor_reached;
    
    wire [3:0] anode;
    wire [6:0] floor_seg, dir_seg;
    
    input_manager im(im_write_floor, im_in_out, im_call_dir, im_floor_called, button_down, button_up, button_in, sw[5:3], sw[2:0]);
    controller ctrl(ctrl_should_move, ctrl_call_inside, ctrl_call_up, ctrl_call_down, ctrl_floor_out, ctrl_direction, sim_floor_out, im_write_floor, im_floor_called, im_in_out, im_call_dir, sim_floor_reached, clkout, reset);
    simulator sim(sim_floor_out, sim_direction_out, sim_floor_reached, ctrl_floor_out, ctrl_direction, ctrl_call_inside, ctrl_call_up, ctrl_call_down, ctrl_should_move, clkout);
    display_adapter da(led0, floor_seg, dir_seg, sim_direction_out, sim_floor_out, sim_floor_reached);

    mux2v #(7) m(seg, floor_seg, dir_seg, clkout);
    assign an[3] = 1'b1;
    assign an[2] = 1'b1;
    assign an[1] = ~clkout;
    assign an[0] = clkout;
    
endmodule

