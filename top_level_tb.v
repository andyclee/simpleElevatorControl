module top_level_tb(
    );
    reg [5:0] sw_in;
    reg button_up_in;
    reg button_down_in;
    reg button_in_in;
    reg resetBtn;
    wire [6:0] seg_out;
    wire [3:0] an_out;
    wire led0_out;
    
    reg clk = 0;
    always #10 clk = !clk;
    
    top_level tl(sw_in, button_up_in, button_down_in, button_in_in, clk, resetBtn, seg_out, an_out, led0_out);
    
    initial
    begin
           resetBtn = 1;
           sw_in[5:0] = 0;
           button_up_in = 0;
           button_down_in = 0;
           button_in_in = 0;
           #20;
           
           resetBtn = 0;
           sw_in[5:3] = 3'b1;
           button_up_in = 1'b1;
           #20;
    end
endmodule
