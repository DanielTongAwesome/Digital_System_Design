module decode_tb();

logic clk, reset, start;
logic [7:0] s_mem_q, encr_mem_q;
	
logic [7:0] s_mem_addr, s_mem_data;
logic s_mem_wren;
	
logic [4:0] encr_mem_addr, decr_mem_addr;
logic [7:0] decr_mem_data;
logic decr_mem_wren;
logic finish;


 decode   DUT(	.clk            (clk),
				.start          (start),
				.reset          (reset),
				
				.s_mem_addr     (s_mem_addr), 
                .s_mem_data     (s_mem_data), 
				.s_mem_wren     (s_mem_wren), //state bit
				.s_mem_q        (s_mem_q),
				
				.encr_mem_addr  (encr_mem_addr), 
                .encr_mem_q     (encr_mem_q),
				
				.decr_mem_addr  (decr_mem_addr), 
                .decr_mem_data  (decr_mem_data), 
				.decr_mem_wren  (decr_mem_wren), //state bit
				.finish         (finish) //state bit
				);

initial begin
		clk = 0; #10;
		forever begin
			clk = 1; #10;
			clk = 0; #10;
		end
	end
	
	initial begin
		reset = 1;
		start = 1;
		s_mem_q = 8'd1;
		encr_mem_q = 8'b10101010;
		#15;
		reset = 0;
		#100;
		s_mem_q = 8'b11111111;
		#200;
		$stop;
	end
endmodule