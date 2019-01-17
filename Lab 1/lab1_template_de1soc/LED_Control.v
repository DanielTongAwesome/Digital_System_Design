/*
The LED Control Module
Input: clock_in -- input clock cycle, in my case is 1Hz
Output: LED on and off output
*/
module LED_Control(clock_in, LEDR);
    input clock_in;
    output reg [7:0] LEDR = 8'b0000_0001; // default the 1 
    reg shift_direction = 0;  // 0 represent >>    1 represent <<

    always @(posedge clock_in) begin
        if (LEDR == 8'b0000_0001 && (shift_direction == 1'b0)) begin
            // start to shift the led blink to the left
            LEDR = LEDR << 1;
            shift_direction = ~shift_direction;
        end
        else if ((LEDR == 8'b1000_0000) && (shift_direction == 1'b1)) begin
            // Start to shift the led blink to the right
            LEDR = LEDR >> 1;
            shift_direction = ~shift_direction;
        end
        // General condition: if shift_direction = '1 --> <<'  '0 --> >>'
        else begin
            if (shift_direction == 1'b0) begin
                LEDR = LEDR >> 1;
            end
            else begin
                LEDR = LEDR << 1;
            end
        end
    end
endmodule