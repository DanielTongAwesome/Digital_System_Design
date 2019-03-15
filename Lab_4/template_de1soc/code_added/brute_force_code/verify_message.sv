/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/brute_force_code/verify_message.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/brute_force_code
 * Created Date: Friday, March 15th 2019, 1:39:21 am
 * Author: DanielTong
 * 
 * verify message is successfully encrypted or not
 */

module verify_message(  input clk,
                        input reset,
                        input start,
                        input [7:0] message,
                        
                        output logic finish,
                        output logic result,
                        output logic [4:0] address);


    // logic
    logic address_enable, address_reset;

    // state define
    typedef enum logic [4:0] { 
        IDLE            = 4'b0_00_0,
        RESET           = 4'B1_10_0,
        WAIT_FOR_DATA   = 4'b1_00_0,
	    VERIFY		    = 4'b1_00_1,
	    UPDATE_ADDR 	= 4'b1_01_0
    } stateType;
    stateType state = IDLE;

    // output logic
    assign finish           = ~state[3];
    assign address_reset    = state[2];
    assign address_enable   = state[1];

    // state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            core_found <= 1'b0;
            state <= IDLE;
        end
        else
            case(state)
                IDLE: if (start) state <= RESET;
                
                RESET: state <= WAIT_FOR_DATA;
                
                WAIT_FOR_DATA:  state <= VERIFY;

                VERIFY:     if ((message >= 8'd97 && message <= 122) ||
								message == 8'd32)
								if (addr == 5'd31)	begin
									core_found <= 1'b1;
									state <= IDLE;
								end else
									state <= UPDATE_ADDR;
							else
								state <= IDLE;
				
				UPDATE_ADDR :	state <= WAIT_FOR_DATA;
                
                default:
            endcase
    end


    // output logic
    always_ff @(posedge clk) begin
        if (reset | address_reset)
            address <= 5'b0;
        else if (address_enable)
            address <= address + 5'b1;
    end
endmodule