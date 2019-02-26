module shared_tb();

wire [31:0] output_arguments;
wire start_target_state_machine;

reg target_state_machine_finished;
reg clk;
reg start_request_a;
reg start_request_b;

wire finish_a;
wire finish_b;
wire reset_start_request_a;
wire reset_start_request_b;

reg [31:0] input_arguments_a;
reg [31:0] input_arguments_b;

wire [7:0] received_data_a;
wire [7:0] received_data_b;
reg reset;
reg [7:0] in_received_data;

shared_access_to_one_state_machine	SATOSM
									(
									.output_arguments(output_arguments),
									.start_target_state_machine(start_target_state_machine),
									.target_state_machine_finished(target_state_machine_finished),
									.sm_clk(clk),
									.start_request_a(start_request_a),
									.start_request_b(start_request_b),
									.finish_a(finish_a),
									.finish_b(finish_b),
									.reset_start_request_a(reset_start_request_a),
									.reset_start_request_b(reset_start_request_b),
									.input_arguments_a(input_arguments_a),
									.input_arguments_b(input_arguments_b),
									.received_data_a(received_data_a),
									.received_data_b(received_data_b),
									.reset(reset),
									.in_received_data(in_received_data)
									);
									
	initial begin
		clk = 0;
		#10;
		forever begin
			clk = 1;
			#10;
			clk = 0;
			#10;
		end
	end
	
	initial begin
		reset = 1;
		
		target_state_machine_finished = 0;
		start_request_a = 0;
		start_request_b = 0;
		input_arguments_a = 0;
		input_arguments_b = 0;
		in_received_data = 0;
		
		#15;
		reset = 0;
		input_arguments_a = 32'b11000011;
		input_arguments_b = 32'b00111100;
		#40;
		
		start_request_a = 1;
		#20;
		start_request_a = 0;
		#40;
		in_received_data = 8'b11110000;
		target_state_machine_finished = 1;
		#20;
		target_state_machine_finished = 0;
		#100;
		
		start_request_b = 1;
		#40;
		start_request_a = 1;
		start_request_b = 0;
		#60;
		in_received_data = 8'b00001111;
		target_state_machine_finished = 1;
		#20;
		target_state_machine_finished = 0;
		#40;
		target_state_machine_finished = 1;
		#200;
		$stop;
	end
endmodule