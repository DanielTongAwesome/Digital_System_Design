/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Assignment_Test_Code/Assignment3_code/share_access_to_one_state_machine.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Assignment_Test_Code/Assignment3_code
 * Created Date: Monday, February 25th 2019, 7:54:56 pm
 * Author: DanielTong
 * 
 * Shared_access_to_one_state_machine: check issue for more detailed info
 */

module shared_access_to_one_state_machine(  // input signal
                                            reset,
                                            sm_clk,
                                            start_request_a,
                                            start_request_b,
                                            target_state_machine_finished,
                                            input_arguments_a,
                                            input_arguments_b,
                                            in_received_data,
                                            // output signal
                                            finish_a,
                                            finish_b,
                                            reset_start_request_a,
                                            reset_start_request_b,
                                            start_target_state_machine,
                                            output_arguments,
                                            received_data_a,
                                            received_data_b);
    // define input output
    output reg [(N-1):0] output_arguments;
    output start_target_state_machine;
    input target_state_machine_finished;
    input sm_clk;
    input logic start_request_a;
    input logic start_request_b;
    output logic finish_a;
    output logic finish_b;
    output logic reset_start_request_a;
    output logic reset_start_request_b;
    input [(N-1):0] input_arguments_a;
    input [(N-1):0] input_arguments_b;
    output reg [(M-1):0] received_data_a;
    output reg [(M-1):0] received_data_b;
    input reset;
    input [M-1:0] in_received_data;

    // internal signal
    logic select_b_output_parameters, register_data_a_enable, register_data_b_enable;

    parameter N = 32,
    parameter M = 8

    // state definition enum
    typedef enum logic {
        // state a logic 
        check_state_a       = 12'b0000_0000_0000;
        give_start_a        = 12'b0001_0110_0000;
        wait_for_finish_a   = 12'b0010_0000_0000;
        register_data_a     = 12'b0011_0000_0010;
        give_finish_a       = 12'b0100_0000_1000;

        // state b logic
        check_state_b       = 12'b0101_1000_0000;
        give_start_b        = 12'b0110_1101_0000;
        wait_for_finish_b   = 12'b0111_1000_0000;
        register_data_b     = 12'b1000_1000_0001;
        give_finish_b       = 12'b1001_1000_0100;
    } state_type;
    state_type state = check_state_a;

    // assign output
    assign register_data_b_enable     = state[0];
    assign register_data_b_enable     = state[1];
    assign finish_b                   = state[2];
    assign finish_a                   = state[3];
    assign reset_start_request_b      = state[4];
    assign reset_start_request_a      = state[5];
    assign start_target_state_machine = state[6];
    assign select_b_output_parameters = state[7];
    // output arguments logic
    assign output_arguments = select_b_output_parameters ? input_arguments_b : input_arguments_a;


    // register_data_a_enable logic
    always @(posedge sm_clk) begin
        if (reset)
            received_data_a <= 0;
        else if (register_data_a_enable)
            received_data_a <= in_received_data;
    end

     // register_data_b_enable logic
    always @(posedge sm_clk) begin
        if (reset)
            received_data_b <= 0;
        else if (register_data_b_enable)
            received_data_b <= in_received_data;
    end


    // state control logic
    always @(posedge sm_clk) begin
        if (reset)
            state = check_state_a;
        else
            case(state)
                // a gives request
                check_state_a:  if (!start_request_a) state <= check_state_b;
                                else if (start_request_a) state <= give_start_a;

                give_start_a:   state <= wait_for_finish_a;

                wait_for_finish_a:  if (target_state_machine_finished) state <= register_data_a;
                                    else if (!target_state_machine_finished) state <= wait_for_finish_a;

                register_data_a:    state <= give_finish_a;

                give_finish_a:  state <= check_state_b;

                // b gives request
                check_state_b:  if (!start_request_b) state <= check_state_a;
                                else if (start_request_b) state <= give_start_b;
                
                give_start_b:   state <= wait_for_finish_b;

                wait_for_finish_b:  if (target_state_machine_finished) state <= register_data_b;
                                    else if (!target_state_machine_finished) state <= wait_for_finish_b;
                
                register_data_b:    state <= give_finish_b;

                give_finish_b:  state <= check_state_a;

            endcase
    end
endmodule