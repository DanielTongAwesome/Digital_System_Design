/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code/Speed_Control.v
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code
 * Created Date: Thursday, February 7th 2019, 11:23:16 am
 * Author: DanielTong
 * 
 * This module been used to control the flash read speed in order to control the play speed
 */
parameter default_speed = 32'd2274;

module Speed_Control(clk, speed_up, speed_down, speed_reset, out_count_to);
    input clk, speed_up, speed_down, speed_reset;
    output reg [31:0] out_count_to;

    
    reg [31:0] count_out_temp = default_speed;

    always_ff @(posedge clk) begin
        case({speed_up, speed_down, speed_reset})
            3'b001: count_out_temp <= default_speed;
            3'b010: count_out_temp <= count_out_temp - 32'd16;
            3'b100: count_out_temp <= count_out_temp + 32'd16;
        endcase
    end

    assign out_count_to = count_out_temp;
endmodule