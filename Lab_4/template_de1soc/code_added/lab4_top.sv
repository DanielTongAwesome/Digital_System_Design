/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/lab4_top.v
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added
 * Created Date: Saturday, March 9th 2019, 2:52:38 pm
 * Author: DanielTong
 * 
 * Purpose: The top-level entity of the project
 */
                    // input
 module lab4_top(   input 				CLOCK_50,
				    input	[3:0]		KEY,
				    input	[9:0]		SW,
				    // output
                    output	wire [9:0]	LEDR,
				    output	wire [6:0]	HEX0,
				    output	wire [6:0]	HEX1,
				    output	wire [6:0]	HEX2,
				    output	wire [6:0]	HEX3,
				    output	wire [6:0]	HEX4,
				    output	wire [6:0]	HEX5);

	// internal wire
   	wire clk = CLOCK_50;
	wire reset = ~KEY[3];
	wire decode_start = ~KEY[0];
	
	// switch LED indicator
	assign LEDR = SW;
	
	
	// lab1 and lab2 module here
	decode_with_key
	decode_with_key_inst(	.clk		(clk),
							.reset		(reset),
							.start		(decode_start),
							.secret_key	({14'b0, SW}));
	
	

 endmodule
