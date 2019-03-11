/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/share_access_to_s_memory.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added
 * Created Date: Sunday, March 10th 2019, 9:32:33 pm
 * Author: DanielTong
 * 
 * Purpose: share_access_to_s_memory, control the output from different FSM to memeory module
 */
                                    // input
                                    // init input
module share_access_to_s_memory(    input [7:0] init_address, 
									input [7:0] init_data, 
									input 		init_write_enable,
									// shuffle input
									input [7:0] shuffle_address, 
									input [7:0] shuffle_data, 
									input 		shuffle_write_enable,
                                    // used to determine which one is the controlling the output
                                    input start_init,
                                    input start_shuffle,
                                    // output
                                    output [7:0] output_address,
                                    output [7:0] output_data,
                                    output       output_write_enable);

    // combinational logic state define
    typedef enum logic [1:0] { 
        IDLE    = 2'b00;
        INIT    = 2'b01;
        SHUFFLE = 2'b10;
     } stateType;
     stateType state = IDLE;

    // combinational logic here for difference cases
    always @(*) begin
        case({start_shuffle, start_init})
            // output 0 for everything if the state is IDLE
            IDLE:       begin 
                            output_address      = 8'b0;
                            output_data         = 8'b0;
                            output_write_enable = 1'b0;
                        end
            // INIT is controlling
            INIT:       begin
                            output_address      = init_address;
                            output_data         = init_data;
                            output_write_enable = init_write_enable;
                        end
            // shuffle is controlling
            SHUFFLE:    begin
                            output_address      = shuffle_address;
                            output_data         = shuffle_data;
                            output_write_enable = shuffle_write_enable;
                        end
            // defalut everything to 0
            default:    begin 
                            output_address      = 8'b0;
                            output_data         = 8'b0;
                            output_write_enable = 1'b0;
                        end
        endcase
    end

endmodule



