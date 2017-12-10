module clock_divider( input clkin, output clkout);
    reg [31:0] counter = 1;
    reg temp_clk = 0;
    always @ (posedge(clkin))
    begin
        if (counter == 6)
        begin
            counter <= 1;
            temp_clk <= ~temp_clk;
        end
        else
            counter <= counter+1;
    end
    assign clkout = temp_clk;
endmodule // clock_divider
