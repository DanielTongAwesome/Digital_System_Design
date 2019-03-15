
module decode_with_key_main_control_tb();

logic clk, reset, start;
logic init_finish, shuffle_finish, decode_finish;
logic start_init, start_shuffle, start_decode;
logic [1:0] select_share;



decode_with_key_main_control    DUT(    clk,
                                        reset,
                                        start,

                                        init_finish,
                                        shuffle_finish,
                                        decode_finish,
                                        
                                        // output
                                        start_init,
                                        start_shuffle,
                                        start_decode,
										select_share);

// clock
initial begin
		clk = 0; #10;
		forever begin
			clk = 1; #10;
			clk = 0; #10;
		end
end

// logic
initial begin
		reset = 1;
		start = 0;
        init_finish = 0;
        shuffle_finish = 0;
        decode_finish = 0;
		#10;
        start = 1;
		reset = 0;
		#30;
        init_finish = 1;
        #20;
        init_finish = 0;
		#20;
        shuffle_finish = 1;
        #20;
        shuffle_finish = 0;
        #20;
        decode_finish = 1;
        #20;
        decode_finish = 0;
        #30;
        #30;
		$stop;
end



endmodule