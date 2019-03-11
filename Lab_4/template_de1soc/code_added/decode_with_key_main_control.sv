                                        // input
module decode_with_key_main_control(    input clk,
                                        input reset,
                                        input start,

                                        input init_finish,
                                        input shuffle_finish,
                                        
                                        // output
                                        output start_init,
                                        output start_shuffle,
													 output [1:0] select_share);

// define states
typedef enum logic [4:0] {
    IDLE            = 5'b000_00, 
    // init
    START_INIT      = 5'b011_01,    // start init 
    WAIT_INIT       = 5'b011_00,
    // shuffle
    START_SHUFFLE   = 5'b100_10,    // start shuffle
    WAIT_SHUFFLE    = 5'b100_00

}stateType;
stateType state = IDLE; // default

// assgin output
assign start_init    = state[0];
assign start_shuffle = state[1];
assign select_share  = state[4:3];

// state transition logic
always @(posedge clk) begin
    if  (reset) 
        state = IDLE;  
    else
        case(state)
            
            // default
            IDLE: if (start) state <= START_INIT;

            // init memory
            START_INIT: state <= WAIT_INIT;
            WAIT_INIT:  if (init_finish) state <= IDLE;

            // shuffle stage
            START_SHUFFLE: state <= WAIT_SHUFFLE;
            WAIT_SHUFFLE: if (shuffle_finish) state <= IDLE;
            
            default: state <= IDLE; 
        endcase
end

endmodule