/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/decode_with_key.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added
 * Created Date: Sunday, March 10th 2019, 2:49:55 pm
 * Author: DanielTong
 * 
 * Purpose: decode_with_key module, in this module we are going to decode the message by using the input key
 *
 */
                        // input
module decode_with_key( input clk,
                        input reset,
                        input start,
                        input [23:0] secret_key);

	
	// memory relevant logic wire
	logic [7:0] s_memory_address, s_memory_data, s_memory_q;
	logic s_memory_written_enable;


	// s_memory moudle -- the memory module, that we should perform interaction with it
	s_memory
	s_memory_inst(	.address(s_memory_address),
					.clock	(clk),
					.data	(s_memory_data),
					.wren	(s_memory_written_enable),
					.q		(s_memory_q));
    

    // main control logic wire
    logic init_start, init_finish // init
    logic shuffle_start, shuffle_finish // shuffle


    // decode_with_key_main module -- control the workflow of the decode procedure
    decode_with_key_main_control        // input
    decode_with_key_main_control_inst(  .clk            (clk),
                                        .reset          (reset),
                                        .start          (start),
                                        // init
                                        .start_init     (init_start), // output
                                        .init_finish    (init_finish), // input
                                        // shuffle
                                        .start_shuffle  (shuffle_start), // output
                                        .shuffle_finish (shuffle_finish)  // input
                                        );

    // s_memory_init module
	s_memory_init       // input
	s_memory_init_inst(	.clk			(clk),
						.reset			(reset),
						.start			(init_start),
                        // output
						.written_address(s_memory_address),
						.data			(s_memory_data),
						.written_enable	(s_memory_written_enable),
						.finish			(init_finish));
    
    // s_memory_shuffle module
    s_memory_shuffle        // input
    s_memory_shuffle_inst(  .clk            (clk),
                            .start          (shuffle_start),
                            .reset          (reset),
                            .secret_key     (secret_key),
                            .q              (s_memory_q),
                            // output
                            .address        (s_memory_address),
                            .data           (s_memory_data),
                            .write_enable   (s_memory_written_enable),
                            .finish         (shuffle_finish));
	

endmodule