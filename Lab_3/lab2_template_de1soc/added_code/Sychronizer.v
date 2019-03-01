/*

Sychronizer logic 
the logic diagram can be found on the issue ticket #7
The test wave form can be found on the issue ticket #7

Basics: async_sig and outclk are two periodic signal, but in different frequency
The Sychronizer will detect the async_sig rising edge and rise the output

*/

// the logic diagram code
module Sychronizer(async_sig, outclk, out_sync_sig);
    input async_sig, outclk;
    output reg out_sync_sig;

    // wire for each FDD output
    wire FDC_1_OUT, FDC_2_OUT, FDC_3_OUT, FDC_4_OUT;
    // some parameters need to be used
    parameter VCC = 1'b1;
    parameter GND = 1'b0;

    // from left to right top to down count 1 2 3 4
    FDC FDC_1(  .D(VCC),          .Q(FDC_1_OUT),    .C(async_sig), .CLR(FDC_4_OUT));
    FDC FDC_2(  .D(FDC_1_OUT),    .Q(FDC_2_OUT),    .C(outclk),    .CLR(GND)      );
    FDC FDC_3(  .D(FDC_2_OUT),    .Q(out_sync_sig), .C(outclk),    .CLR(GND)      );
    FDC FDC_4(  .D(out_sync_sig), .Q(FDC_4_OUT),    .C(outclk),    .CLR(GND)      );

endmodule


// flip-flop 
module FDC(D, Q, C, CLR);
    input D, C, CLR;
    output reg Q;

    always_ff @(posedge CLR or posedge C) begin
        if (CLR)    Q <= 1'b0;
        else        Q <= D;
    end
endmodule
