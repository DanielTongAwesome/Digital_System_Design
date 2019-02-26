/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Assignment_Test_Code/Assignment3_code/trap_edge.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Assignment_Test_Code/Assignment3_code
 * Created Date: Monday, February 25th 2019, 7:01:20 pm
 * Author: DanielTong
 * 
 * trap_edge module: detailed description can be founded on github issue
 * Basics: async_sig and outclk are two periodic signal, but in different frequency
 * The Sychronizer will detect the async_sig rising edge and rise the output
 */

module trap_edge(async_sig, outclk, reset, out_sync_sig);
    input async_sig;
    input outclk;
    input reset;
    output out_sync_sig;

    wire FDC_TOP_1_OUT;

    FDC FDC_TOP_1( .D(1'b1),
                    .Q(FDC_TOP_1_OUT),
                    .c(async_sig),
                    .clr(reset));

    FDC FDC_TOP_2( .D(FDC_TOP_1_OUT),
                .Q(out_sync_sig),
                .c(outclk),
                .clr(reset));
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