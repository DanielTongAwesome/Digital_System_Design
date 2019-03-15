                                       // input
module decode_with_key_main_control(    input clk,
                                        input reset,
                                        input start,

                                        input init_finish,
                                        input shuffle_finish,
                                        input decode_finish,
                                        input verify_finish,
                                        
                                        // output
                                        output start_init,
                                        output start_shuffle,
                                        output start_decode,
                                        output start_verify,
										output [1:0] select_share);

// define states
typedef enum logic [4:0] {
    IDLE            = 5'b00_000, 
    // init
    START_INIT      = 5'b01_001,    // start init 
    WAIT_INIT       = 5'b01_000,
    // shuffle
    START_SHUFFLE   = 5'b10_010,    // start shuffle
    WAIT_SHUFFLE    = 5'b10_000,
    // decode
    START_DECODE    = 5'b11_100,    // start deode
    WAIT_DECODE     = 5'b11_000
    //

}stateType;
stateType state = IDLE; // default

// assgin output
assign start_init    = state[0];
assign start_shuffle = state[1];
assign start_decode  = state[2];
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
            WAIT_INIT:  if (init_finish) state <= START_SHUFFLE;

            // shuffle stage
            START_SHUFFLE: state <= WAIT_SHUFFLE;
            WAIT_SHUFFLE: if (shuffle_finish) state <= START_DECODE;

            // decode stage
            START_DECODE: state <= WAIT_DECODE;
            WAIT_DECODE: if (decode_finish) state <= IDLE;
            
            default: state <= IDLE; 
        endcase
end

endmodule