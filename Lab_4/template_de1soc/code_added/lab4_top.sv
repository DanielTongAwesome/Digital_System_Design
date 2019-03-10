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

    logic clk = CLOCK_50;
	logic reset = ~KEY[3];
	logic start = ~KEY[0];

	//memory relevant logic wire
	logic [7:0] s_memory_address, s_memory_data, s_memory_q;
	logic s_memory_written_enable;
	logic s_memory_init_finish;
	s_memory
	s_memory_inst(	.address(s_memory_address),
					.clock	(clk),
					.data	(s_memory_data),
					.wren	(s_memory_written_enable),
					.q		(s_memory_q));
	
	s_memory_init
	s_memory_init_inst(	.clk			(clk),
						.reset			(1'b0),
						.start			(start),
						.written_address(s_memory_address),
						.data			(s_memory_data),
						.written_enable	(s_memory_written_enable),
						.finish			(s_memory_init_finish));

 endmodule
