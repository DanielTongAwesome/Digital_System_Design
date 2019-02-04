/*  
Viterbi STEL-2060C/CR
Purpose: use the module to control the read and write of the chip

Glitch-free design:
Note: According the state machine we can find there are in total 8 states
                
    state-bit   0987_6543210
                10-7  state bit
                 6-0  output related -- important: so base on this we can design
                                        glitch free output and transaction

    idle            -- 0000  --append--  000_0000
    check_oper      -- 0010              010_1000
    handle_write_op -- 0011              010_1000
    strobe_write    -- 0100              010_1010
    handle_read_op  -- 0101              010_1001
    wait_read       -- 0110              010_1001
    strobe_read     -- 0111              011_1001
    finished        -- 1000              010_1100

we can design the state-bit 0-6 according to the following arrangement

    state-bit 0 -- ~out_RD
    state-bit 1 -- ~out_WR
    state-bit 2 -- finish
    state-bit 3 -- vit_cs_allow
    state-bit 4 -- strobe_read_reg
    state-bit 5 -- allow_data_output

*/

module viterbi_ctrl (   
                        // input
                        clk,
                        reset_all,
                        in_addr,    // addr input
                        in_data,    // data input
                        is_write,   // write(1) or read(0) 
                        start,      // start operation
                        vit_num,    // 0 --> chip1 ,  1 --> chip2
                        
                        // output
                        vit1_cs,    // activate chip 1 ---> Active Low
                        vit2_cs,    // activate chip 2 ---> Active Low
                        out_addr,   // connects to chip's addr pin 
                        out_RD,     // Connects to RD pin ---> Active Low
                        out_WR,     // Connects to WR pin ---> Active Low
                        return_data, // return the read data if there is
                        finish      // finish operation

                        // bidirectional
                        vit_data,   // bidirectional connects to chip's data pin
                        );

    // input declare
    input clk, reset_all;
    input[7:0] in_data;
    input[2:0] in_addr;
    input is_write;
    input start;
    input vit_num;

    // output declare
    output vit1_cs;
    output vit2_cs;
    output[2:0] out_addr;
    output out_RD,out_WR,finish;
    output[7:0] return_data;

    // bidirectional
    inout[7:0] vit_data;

    wire[7:0] return_data;
    reg[10:0] state;
    reg[7:0] read_reg;
    wire vit_cs_allow;
    wire strobe_read_reg;
    wire allow_data_output;

    // chip parameter - assign a parameter for each chip
    parameter vit1_code = 1'b0;
    parameter vit2_code = 1'b1;
    
    // state-bits and states
    parameter idle              = 11'b0000_0000000;
    parameter check_oper        = 11'b0010_0101000;
    parameter handle_write_op   = 11'b0011_0101000;
    parameter strobe_write      = 11'b0100_0101010;
    parameter handle_read_op    = 11'b0101_0101001;
    parameter wait_read         = 11'b0110_0101001;
    parameter strobe_read       = 11'b0111_0111001;
    parameter finished          = 11'b1000_0101100;
    
    // connect output to the state-bits
    assign out_RD = ~state[0];
    assign out_WR = ~state[1];
    assign finish = state[2];
    assign vit_cs_allow = state[3];
    assign strobe_read_reg = state[4];
    assign allow_data_output = state[5];
    
    assign vit1_cs = !((vit_num == vit1_code) && (vit_cs_allow));
    assign vit2_cs = !((vit_num == vit2_code) && (vit_cs_allow));
    assign out_addr = in_addr;
    assign vit_data = (allow_data_output && is_write) ? in_data[7:0] : 8'bz;
    assign return_data = read_reg;


    // state transaction -- FSM logic
    always_ff @(posedge clk or negedge reset_all) begin
        if (~reset_all)
            state <= idle;
        else
            case(state) /* synthesis full_case */
                idle :begin
                    if (start) 
                        state <= check_oper;
                end
                
                check_oper : begin
                    if (is_write)
                        state <= handle_write_op;
                    else
                        state <= handle_read_op;
                end
                handle_write_op: state <= strobe_write;
                strobe_write: state <= finished;
                handle_read_op: state <= wait_read;
                wait_read : state <= strobe_read;
                strobe_read: state <= finished;
                finished : state <= idle;
            endcase
    end

    // 
    always_ff @(posedge strobe_read_reg or negedge reset_all) begin
        if (~reset_all)
            read_reg <= 7'b0;
        else
            read_reg <= vit_data[7:0];
    end

endmodule