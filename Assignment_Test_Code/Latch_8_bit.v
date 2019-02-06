/*
8-bit latch
*/

module latch_8_bit (in, out, enable);
    input [7:0] in;
    input enable;
    output reg [7:0] out;

    always @(enable or in) begin
        if (enable) begin
        end
        else begin
            out <= in;
        end
    end
endmodule