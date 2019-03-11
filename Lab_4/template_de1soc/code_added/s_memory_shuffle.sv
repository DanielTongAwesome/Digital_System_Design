/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/s_memory_shuffle.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added
 * Created Date: Sunday, March 10th 2019, 3:57:43 pm
 * Author: DanielTong
 * 
 * Purpose: s_memory_shuffle module, this module can shuffle the vaule inside the meomory
 * 
 */
                            // input
module s_memory_shuffle(    input clk,
                            input start,
                            input reset,
                            input [23:0] secret_key,
                            input [7:0] q,
                            // output
                            output [7:0] address,
                            output [7:0] data,
                            output       write_enable,
                            output       finish);

    // define logic
    logic [7:0] i, j, si, sj; 
    logic i_en, j_en, si_en, sj_en;
    logic i_reset, j_reset; // reset logic here
    // secret key mod keylength
    logic [7:0] secret_key_mod_result;

    // address control
    logic address_select;

    // data control
    logic data_select;

    // define state
    typedef enum logic [9:0] { 
        //                    9 8 7 6 5 4 3 2 1 0
        IDLE            = 10'b0_0_1_0_0_0_0_0_0_0,  
		  // assign address_select  1 with no purpose, but to make IDLE and next state have different state-bit
        SET_I_ADDRESS   = 10'b0_0_0_0_0_0_0_0_0_0,
        READ_SI         = 10'b0_0_0_0_0_1_0_0_0_0,  // si_en
        COMPUTE_J       = 10'b0_0_0_0_0_0_1_0_0_0,  // j_en 

        SET_J_ADDRESS   = 10'b0_0_0_1_0_0_0_0_0_0,  // address_select enable 
        READ_SJ         = 10'b0_0_0_0_1_0_0_0_0_0,  // sj_en
        STORE_SI        = 10'b0_1_1_0_0_0_0_0_0_0,  // write_enable, address_select = 0 -> write to address i, data_select = 1 -> write sj to si
        STORE_SJ        = 10'b0_1_0_1_0_0_0_0_0_0,  // write_enable, address_select = 1 -> write to address j, data_select = 0 -> write si to sj

        I_ADD           = 10'b0_0_0_0_0_0_0_1_0_0,  // i_enable
        FINISH          = 10'b1_0_0_0_0_0_0_0_1_1   // i_reset, j_reset

     }stateType;
    stateType state = IDLE; //default

    // define output logic
    assign i_reset          = state[0];
    assign j_reset          = state[1];
    assign i_en             = state[2]; // address i
    assign j_en             = state[3]; // address j
    assign si_en            = state[4]; // si_en allow the memory to update the value in the address i 
    assign sj_en            = state[5]; // sj_en allow the memory to update the value in the address j 
	assign address_select   = state[6];		
	assign data_select      = state[7];
    assign write_enable     = state[8];
    assign finish           = state[9]; // 1 -> done

    // control data and address logic
    assign address  = address_select ? j  : i ; // select the address ------> 0 for i  1 for j
    assign data     = data_select    ? sj : si; // select the data value ---> 0 for si 1 for sj
		
    // state transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            case(state)
                // if start move to next
                IDLE:   if (start) state <= SET_I_ADDRESS;
                        else state <= IDLE;
                // set I address
                SET_I_ADDRESS:  state <= READ_SI;
                // read SI from address I
                READ_SI:        state <= COMPUTE_J;
                // calculate address value J
                COMPUTE_J:      state <= SET_J_ADDRESS;
                // set address select to j_address
                SET_J_ADDRESS:  state <= READ_SJ;
                // read address j to sj
                READ_SJ:        state <= STORE_SI;
                // store sj to si
                STORE_SI:       state <= STORE_SJ;
                // store si to sj
                STORE_SJ:       state <= I_ADD;
                // loop design
                I_ADD:  if (i == 8'hff) state <= FINISH;
                        else state <= SET_I_ADDRESS; //  going to the second state as a loop
                // done
                FINISH:         state <= IDLE;            
                default: state <= IDLE;
            endcase
    end

    // scychronized control logic
    // if enable memeory to update value at address i
    always_ff @(posedge clk) begin
        if (si_en) begin
            si <= q;
        end
    end

    // if enable memeory to update value at address j
    always_ff @(posedge clk) begin
        if (sj_en) begin
            sj <= q;
        end
    end

    // if j_en, that means start to calculate the j
    always_ff @(posedge clk) begin
        if (reset | j_reset) begin
            j <= 8'b0;
        end
        else if (j_en) begin
            j <= j + si + secret_key_mod_result;  // according to the instruction formula
        end
    end

    // if i_en, that means start to accumulate i + 1
    always_ff @(posedge clk) begin
        if (reset | i_reset) begin
            i <= 8'b0;
        end
        else if (i_en) begin
            i <= i + 8'b1;
        end
    end

    // secret_key_mode_result
    always_comb begin
        // 3 conditions of mod 3 -- 0,1,2
        case (i % 8'd3)
            8'd0: secret_key_mod_result = secret_key[23:16];
            8'd1: secret_key_mod_result = secret_key[15: 8];
            8'd2: secret_key_mod_result = secret_key[ 7: 0];
            default: secret_key_mod_result = 8'b0;
        endcase
    end
endmodule