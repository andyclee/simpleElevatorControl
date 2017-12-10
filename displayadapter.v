module display_adapter(led, floor_seg, dir_seg, direction, current_floor, open);
	output led;
	output [6:0] floor_seg;
	output [6:0] dir_seg;
	input direction;
	input [2:0] current_floor;
	input open;

	wire [15:0] ddecIn;
	wire [3:0] ddecOut;
	wire [6:0] downSeg;
	wire 6:0] upSeg;

	assign [15:4] ddecIn = 0;
	assign [3:0] ddecIn = current_floor;

	DecimalDigitDecoder ddec(ddecIn, , , , , ddecOut);
	BCDToLED bcdLed(ddecOut, floor_seg, );
	assign downSeg[0] = 1;
	assign downSeg[1] = 1;
	assign downSeg[2] = 1;
	assign downSeg[6:3] = 0;
	assign upSeg[4] = 1;
	assign upSeg[5] = 1;
	assign upSeg[6] = 1;
	assign upSeg[3:0] = 0;
	mux2v dirMux(dir_seg, downSeg, upSeg, direction);

	assign led = open;

endmodule //display_adapter

module BCDToLED(
	input [3:0] x, //wxyz
	output [6:0] seg,
	output [3:0] an );

	assign seg[0] = (x[2] & ~x[1] & ~x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]); //xy'z' + w'x'y'z
	assign seg[1] = (x[2] & ~x[1] & x[0]) | (x[2] & x[1] & ~x[0]); //xy'z + xyz'
	assign seg[2] = ~x[2] & x[1] & ~x[0]; //x'yz'
	assign seg[3] = (x[2] & ~x[1] & ~x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]) | (x[2] & x[1] & x[0]); //xy'z' + w'x'y'z + xyz
	assign seg[4] = (x[2] & ~x[1]) | x[0]; //xy' + z
	assign seg[5] = (~x[3] & ~x[2] & x[0]) | (x[1] & x[0]) | (~x[2] & x[1]); //w'x'z + yz + x'y
	assign seg[6] = (~x[3] & ~x[2] & ~x[1]) | (x[2] & x[1] & x[0]); //w'x'y' + xyz

	assign an[3:0] = 4'b1110;
endmodule

module DecimalDigitDecoder(
	input [15:0] binary,
	output reg [3:0] tenthousands,
	output reg [3:0] thousands,
	output reg [3:0] hundreds,
	output reg [3:0] tens,
	output reg [3:0] ones
	);
	integer i;
	always @(binary)
	begin
		tenthousands = 4'd0;
		thousands = 4'd0;
		hundreds = 4'd0;
		tens = 4'd0;
		ones = 4'd0;

		for(i=15;i>=0;i=i-1)
		begin
		    if(tenthousands>=5)
                tenthousands=tenthousands+3;
		    if(thousands>=5)
                thousands=thousands+3;
			if(hundreds>=5)
				hundreds=hundreds+3;
			if(tens>=5)
				tens=tens+3;
			if(ones>=5)
				ones=ones+3;

			tenthousands = tenthousands << 1;
            tenthousands[0] = thousands[3];

			thousands = thousands << 1;
            thousands[0] = hundreds[3];

			hundreds = hundreds << 1;
			hundreds[0] = tens[3];

			tens = tens << 1;
			tens[0] = ones[3];

			ones = ones << 1;
			ones[0] = binary[i];
		end
	end
endmodule
