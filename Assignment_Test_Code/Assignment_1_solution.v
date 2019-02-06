/*
Assignment 1 Question 7 
*/


module Assignment_1(async_sig, outclk, out_sync_sig);
    input async_sig;
    input outclk;
    output out_sync_sig;


    wire FDC_TOP_1_OUT;
    wire FDC_TOP_2_OUT;
    wire FDC_1_OUT;

    FDC FDC_TOP_1( .D(1'b1),
                    .Q(FDC_TOP_1_OUT),
                    .c(async_sig),
                    .clr(FDC_1_OUT));

    FDC FDC_TOP_2( .D(FDC_TOP_1_OUT),
                .Q(FDC_TOP_2_OUT),
                .c(outclk),
                .clr(1'b0));

    FDC FDC_TOP_3( .D(FDC_TOP_2_OUT),
                .Q(out_sync_sig),
                .c(outclk),
                .clr(1'b0));

    FDC FDC_1( .D(out_sync_sig),
            .Q(FDC_1_OUT),
            .c(outclk),
            .clr(1'b0));   
endmodule


module FDC(D, Q, c, clr);
    input c;
    input D;
    input clr;
    output reg Q;

    always @(posedge c or posedge clr) begin
        if (clr) begin
            Q <= 0;
        end
        else begin
            Q <= D; 
		  end
    end
endmodule