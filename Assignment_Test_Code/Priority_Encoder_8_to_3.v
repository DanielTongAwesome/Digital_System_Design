
/*
Priority Encoder 8-to-3 each wide is 1 bit 
*/
module priority_encoder_8_to_3( Input, Output);
    input [7:0] Input;
    output reg [2:0] Output;

    // below code follow the truth table
    always @(*) begin
        case(Input)
            8'b0000_0001: Output = 3'b000;
            8'b0000_001x: Output = 3'b001;
            8'b0000_01xx: Output = 3'b010;
            8'b0000_1xxx: Output = 3'b011;
            8'b0001_xxxx: Output = 3'b100;
            8'b001x_xxxx: Output = 3'b101;
            8'b01xx_xxxx: Output = 3'b110;
            8'b1xxx_xxxx: Output = 3'b111;
            default: Output = 3'b000;
        endcase
    end
endmodule