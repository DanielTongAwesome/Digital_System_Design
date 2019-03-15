module s_memory_shuffle_tb();

logic clk, start, reset;
logic [23:0] secret_key;
logic [7:0] q;

logic [7:0] address;
logic [7:0] data;
logic write_enable, finish;

s_memory_shuffle    DUT(    clk,
                            start,
                            reset,
                            secret_key,
                            q,
                            // output
                            address,
                            data,
                            write_enable,
                            finish);

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
		q = 8'd0;
		secret_key = 24'h249;
		#10;
        	start = 1;
		reset = 0;
		#100;
		#200;
		$stop;
end

endmodule
