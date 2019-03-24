/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_5/Lab5_template_de1soc/added_code/LFSR.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_5/Lab5_template_de1soc/added_code
 * Created Date: Saturday, March 23rd 2019, 6:00:53 pm
 * Author: DanielTong
 * 
 * LFSR --- used for generate 5-bit pesudo random number --> since it is 5-bit so 2 ^ 5 - 1 different outputs
 */

 // parameter to test different initalized value
parameter initial_value = 5'b0_0001;

module LFSR(    input clk,
                input reset;
                output [4:0] out_random_number = initial_value);
    
    reg feedback = out_random_number[0] ^ out_random_number[2];

    always @(posedge clk) begin
        // reset logic
        if (reset) begin
            output_random_number <= initial_value;
        end
        // output logic
        else begin
            // output changed to feedback, 4->3, 3->2, 2->1, 1->0
            output_random_number <= {    feedback, 
                                        output_random_number[4],
                                        output_random_number[3],
                                        output_random_number[2],
                                        output_random_number[1] } 
        end
    end

endmodule

