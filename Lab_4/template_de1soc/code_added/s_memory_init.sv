/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/s_memory_init.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added
 * Created Date: Saturday, March 9th 2019, 3:11:43 pm
 * Author: DanielTong
 * 
 * Purpose: task1 of cpen311 lab4, need to initialize the memory, start from address 0 -> 255
 *          each address assign value from 0 -> 255
 */
                        // input
module s_memory_init(   input clk,
                        input reset,
                        input start,
                        // output
                        output wire [7:0] written_address,
                        output wire [7:0] data,
                        output wire written_enable,
                        output wire finish);
    
    // counter - count address and output data
    logic [7:0] counter;

    // state define
    typedef enum logic [1:0] {  
        IDLE    = 2'b0_0,
        START   = 2'b1_0,
        FINISH  = 2'b0_1
    } stateType;    
    stateType state = IDLE;

    // output logic
    assign data = counter;
    assign written_address = counter;
    assign written_enable = state[1];
    assign finish = state[0];

    // state transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            case(state)
                // STATE - IDLE 
                IDLE:   if (start) state <= START;
                        else state <= IDLE;
                
                // STATE - START
                START:  if (counter == 8'hff) begin
                            state <= FINISH;
                            counter <= 8'b0;
                        end
                        else begin
                            counter <= counter + 8'b1; 
                        end
                
                // STATE - FINISH
                FINISH: state <= IDLE;
                
                default: state <= IDLE;
            endcase
    end

endmodule

    
    