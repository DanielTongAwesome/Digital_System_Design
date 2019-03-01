/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code/Memory_Address_Control.v
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code
 * Created Date: Thursday, February 7th 2019, 12:34:47 pm
 * Author: DanielTong
 * 
 * This module controls the address that we want to read from the flash memory
 */

`define address_max 23'h7FFFF


module Memory_Address_Control(  // input
                                clk, 
                                sychronized_clock, 
                                start, 
                                dir, 
                                restart, 
                                end_Flash,
                                song_Data, // -- flash_men_readdata
                                // output
                                start_Flash, 
                                finish, 
                                read,
                                address, 
                                byteenable,  
                                out_Data,
										  volume_sig);
    
    input clk, sychronized_clock, start, dir, restart, end_Flash;
    input [31:0] song_Data;
    output start_Flash, finish,read,volume_sig;
    output [22:0] address;
    output [3:0] byteenable;
    output [7:0] out_Data;
    
    assign byteenable = 4'b1111; // default

    // state enum 
    typedef enum logic [6:0] { 
        idle        = 7'b0000_000, 
        readFlash   = 7'b0001_001, 
        get_data_1  = 7'b0010_000, 
        read_data_1 = 7'b0011_100, 
        get_data_2  = 7'b0100_000, 
        read_data_2 = 7'b0101_100, 
        checkInc    = 7'b0110_000, 
        inc_addr    = 7'b0111_000, 
        dec_addr    = 7'b1000_000, 
        finished    = 7'b1001_010
     } state_Type;
     state_Type state = idle; // set default state

    // assign output
    assign start_Flash = state[0];
    assign read = state[0];
    assign finish = state[1];
	 assign volume_sig = state[2];

    // state transition logic
    always_ff @(posedge clk) begin
        case(state)
            // start to read flash
            idle: if (start) state <= readFlash;
            // finished data reading process
            readFlash: if (end_Flash) state <= get_data_1;
            // wait until the sychronized clock start to read data
            get_data_1: if (sychronized_clock) state <= read_data_1;
            // reading data 1
            read_data_1: state <= get_data_2;
            // wait until the sychronized clock start to read data again
            get_data_2: if (sychronized_clock) state <= read_data_2;
            // reading data 2
            read_data_2: state <= checkInc;
            // check the dir
            checkInc:   if (dir) state <= dec_addr;
                        else state <= inc_addr;
            // if increment
            inc_addr: state <= finished;
            // if decrement
            dec_addr: state <= finished;
            // finish process
            finished: state <= idle;
        
            default: state <= idle;
        endcase
    end


    // output logic corresponds to each state
    always_ff @(posedge clk) begin
        case(state)
            // read data 1 
            read_data_1: begin
                            if (dir) out_Data <= song_Data[31:24];
                            else out_Data <= song_Data[7:0];
                            address <= address;
            end
            // read data 2
            read_data_2: begin
                            if (dir) out_Data <= song_Data[7:0];
                            else out_Data <= song_Data[31:24];
                            address <= address;
            end
            // decrement address
            dec_addr: begin
                            if (restart) address <= `address_max;
                            else begin
                                address <= address - 23'd1;  // minus one
                                if (address == 0) begin
                                    address <= `address_max; // if already reach the end, go to the top
                                end
                            end
                            out_Data <= out_Data;
            end
            // increment address
            inc_addr: begin
                            if (restart) address <= 0;
                            else begin
                                address <= address + 23'd1;  // plus one
                                if (address > `address_max) begin 
                                    address <= 0; // if already reach the top, go back to start
                                end
                            end 
                            out_Data <= out_Data;
            end
            // default
            default: begin
                address <= address;
                out_Data <= out_Data;
            end
        endcase
    end
endmodule