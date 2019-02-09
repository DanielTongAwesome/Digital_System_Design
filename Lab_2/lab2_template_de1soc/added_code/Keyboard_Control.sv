/*
 * Created Date: Tuesday, February 5th 2019, 11:28:19 pm
 * Author: DanielTong
 */

/*

Keyboard Control Logic

    E -- Listen
    D -- Stop
    B -- Backwards
    F -- Forward
    R -- Replay

*/


module Keyboard_Control(// input 
                        clk, 
                        kbd_data_ready, 
                        flash_read_finished, 
                        key_pressed,
                        // output
                        dir,
                        start_read_flash,
                        restart);

    // initialize input and output
    input clk, kbd_data_ready, flash_read_finished;
    input [7:0] key_pressed;
    output dir,start_read_flash,restart;

    // state-bit enum
    typedef enum logic [5:0] { 
        
        // state-bit output dir play reset
        // default state
        check_key 	 = 6'b000_000,

        // Forward
        Forward 		 = 6'b001_001,
        Forward_reset = 6'b010_101,
        Forward_pause = 6'b011_000,
        
        // Backward
        Backward 		  = 6'b100_011,
        Backward_reset = 6'b101_111,
        Backward_pause = 6'b110_000
    
    } state_Type;
    state_Type state = check_key;

    // key E,D,B,F,R press ascii code
    parameter character_E =8'h45;
    parameter character_lowercase_e= 8'h65;
    parameter character_D =8'h44;
    parameter character_lowercase_d= 8'h64;
    parameter character_B =8'h42;
    parameter character_lowercase_b= 8'h62;
    parameter character_F =8'h46;
    parameter character_lowercase_f= 8'h66;
    parameter character_R =8'h52;
    parameter character_lowercase_r= 8'h72;

   

    assign restart          = state[2];
    assign dir              = state[1];
    assign start_read_flash = state[0];

    // state transaction
    always_ff @(posedge clk) begin
        case(state)

            //------------------------ Default Operation Logic ---------------------------//
            
            // at check key state ---  E -> forward   B -> Backward
            check_key:  if (key_pressed == character_E || key_pressed == character_lowercase_e)  state <= Forward;
                        else if (key_pressed == character_B || key_pressed == character_lowercase_b) state <= Backward;
                        else state <= check_key;
            
            //------------------------ Forward Operation Logic ---------------------------//

            // Press E
            // Forward play state --- R & kbd_data_ready -> forward_reset 
            //                        D -> forward_pause   B -> Backward
            Forward:    if (key_pressed == character_R || key_pressed == character_lowercase_r) begin
                            if (kbd_data_ready) state <= Forward_reset; // only reset when key pressed
                            else state <= Forward;
                        end
                        else if (key_pressed == character_B || key_pressed == character_lowercase_b) state <= Backward;
                        else if (key_pressed == character_D || key_pressed == character_lowercase_d) state <= Forward_pause;
                        else state <= Forward;  


            // Press R
            // Forward_reset state --- wait flash read finished -> forward music again
            Forward_reset:  if (flash_read_finished) state <= Forward;


            // Press F at check key 
            // Press D at forward
            // Forward_pause state --- R -> forward_reset   E -> forward
            //                         B -> backward_pause
            Forward_pause:  if (key_pressed == character_R || key_pressed == character_lowercase_r) state <= Forward_reset;
                            else if (key_pressed == character_E || key_pressed == character_lowercase_e) state <= Forward;
                            else if (key_pressed == character_B || key_pressed == character_lowercase_b) state <= Backward_pause;
                            else state <= Forward_pause;


            //------------------------ Backward Operation Logic ---------------------------//

            // Press B
            // Backward state ---  R & kbd_data_ready -> backward_reset
            //                     D -> backward_pause  F -> Forward
            Backward:   if (key_pressed == character_R || key_pressed == character_lowercase_r) begin
                            if (kbd_data_ready) state <= Backward_reset; // only reset when key pressed
                            else state <= Backward;
                        end
                        else if (key_pressed == character_D || key_pressed == character_lowercase_d) state <= Backward_pause;
                        else if (key_pressed == character_F || key_pressed == character_lowercase_f) state <= Forward;
                        else state <= Backward;


            // Press R
            // Backward_reset state --- wait flash read finished -> Backward play music again
            Backward_reset: if (flash_read_finished) state <= Backward;


            // Press B at check key
            // Press D at Backwards
            // Backward_pause ---  R -> Backward_reset  E -> Backward
            //                     F -> Forward_pause
            Backward_pause: if (key_pressed == character_R || key_pressed == character_lowercase_r) state <= Backward_reset;
                            else if (key_pressed == character_E || key_pressed == character_lowercase_e) state <= Backward;
                            else if (key_pressed == character_F || key_pressed == character_lowercase_f) state <= Forward_pause;
                            else state <= Backward_pause;
            

            // defualt check key state 
            default: state <= check_key;
        endcase
    end
endmodule