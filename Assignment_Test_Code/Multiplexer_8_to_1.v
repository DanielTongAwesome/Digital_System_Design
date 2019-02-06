
/*
8-to-1 multiplexer  32-bit wide
*/

module mux_8_to_1( Select_Input, Output, In1, In2, In3, In4, In5, In6, In7, in8);
    // multiplexer selector
    input [2:0] Select_Input;

    // all possible output
    input [31:0] In1;
    input [31:0] In2;
    input [31:0] In3;
    input [31:0] In4;
    input [31:0] In5; 
    input [31:0] In6;
    input [31:0] In7;
    input [31:0] In8;

    // selected output
    output reg [31:0] Output;

    always @(*) begin
        case(Select_Input)
            3'b000: Output = In1; // choose 1
            3'b001: Output = In2; // choose 2
            3'b010: Output = In3; // choose 3 
            3'b011: Output = In4; // choose 4 
            3'b100: Output = In5; // choose 5 
            3'b101: Output = In6; // choose 6 
            3'b110: Output = In7; // choose 7 
            3'b111: Output = In8; // choose 8 
            default: Output = 3'b; // default output 000
        endcase
    end
endmodule