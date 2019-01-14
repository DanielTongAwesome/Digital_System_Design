
/* 
  The clock divider module 
  Input: clock_in --- input clock, the system clock
         reset    --- reset signal
  Output: clock_out --- output clock
  count --- count the period
*/
module Clock_Divider(clock_in, clock_out, reset, count_end);
    input clock_in;
    input reset;
    input count;
    input [31:0] count_end;
    
    // this register is used to counting the period
    reg [31:0] count;

    output reg clock_out;
    
    
    // logic for the clock divider
    // count is used to count the number of clock_in periof
    // since count & reg both been assigned value in always block so both have to add reg
    always @( posedge clock_in ) begin
        if (reset) begin
            clock_in = 0;
            clock_out = 0;
            end
        else begin
            if (cout < count_end) begin
                count = count + 1;
                end
            else begin
                // clock_out reverse from 0->1 or 1->0
                clock_out = ~clock_out;
                count = 0;
                end
            end
    end

endmodule 

