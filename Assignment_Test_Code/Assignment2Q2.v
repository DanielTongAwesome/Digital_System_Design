module Assignment2Q2(clk, reset, restart, pause, go_to_third, terminal, out1, out2, even, odd);
	input clk, reset, restart, pause, go_to_third;
	output reg terminal, even, odd;
	output reg [2:0] out1, out2;
	// define state
	// state-bit [11-9]state  [8]terminal  [7-5]out1 [4-2]out2 [1]even [0]odd
	reg [11:0] state = 12'b001_0_011_010_0_1;
	parameter first  = 12'b001_0_011_010_0_1;
	parameter second = 12'b010_0_101_100_1_0;
	parameter third  = 12'b100_0_010_111_0_1;
	parameter fourth = 12'b011_0_110_011_1_0;
	parameter fifth  = 12'b111_1_101_010_0_1;
	// state transaction
	always_ff @(posedge clk or posedge reset) begin
		if (reset)
			state <= first;
		else
			case(state)
				first:	if (restart | pause) state <= first;
							else if (!restart & !pause) state <= second;
				second:	if (!restart & pause) state <= second;
							else if (restart) state <= first;
							else if (!restart & !pause) state <= third;
				third:	if (!restart & pause) state <= third;
							else if (restart) state <= first;
							else if (!restart & !pause) state <= fourth;
				fourth:	if (!restart & pause) state <= fourth;
							else if (!restart & !pause) state <= fifth;
							else if (restart) state <= first;
				fifth:	if (go_to_third) state <= third;
							else if (restart & !go_to_third) state <= first;
							else if (!restart & pause & !go_to_third) state <= fifth;
				default: state <= first;
			endcase
	end
	// output logic combined with state-bit
	always_comb begin
		terminal <= state[8];
		out1 <= state[7:5];
		out2 <= state[4:2];
		even <= state[1];
		odd <= state[0];
	end
endmodule