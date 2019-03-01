/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code/Flash_Read.v
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code
 * Created Date: Tuesday, February 5th 2019, 3:15:11 pm
 * Author: DanielTong
 * 
 *
 *
 *
 *This module can be considered as the master module of the 
 *Pipelined Read Transfers with Variable Latency
*/
module Flash_Read(  // input
                    clk,
                    start,
                    read,
                    wait_Request,
                    data_Valid,
                    // output 
                    finish);

    input clk, start, read, wait_Request, data_Valid;
    output finish;

    // state-bit design
    typedef enum logic [4:0] { 
        idle        = 5'b000_00,
        check_read  = 5'b001_00,
        slave_ready = 5'b010_00,
        wait_read   = 5'b011_00,
        finished    = 5'b100_01
    } state_Type;
    state_Type state = idle;

    // assign output state-bit
    assign finish = state[0];

    always_ff @(posedge clk) begin
        case(state)
            
            idle: if (start) state <= check_read;

            check_read: if (read) state <= slave_ready;

            slave_ready: if (!wait_Request) state <= wait_read;

            wait_read: if (!data_Valid) state <= finished;

            finished: state <= idle;

            default: state <= idle;
        endcase
    end

endmodule