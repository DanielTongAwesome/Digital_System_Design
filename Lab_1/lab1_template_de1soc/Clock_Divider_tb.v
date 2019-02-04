
/*
Clock Divider Test Bench Code
*/
module Clock_Divider_Test();
    reg clock_in;
    reg reset;
    reg [31:0] count_end;
    
    wire clock_out;

    Clock_Divider DUT( .clock_in(clock_in),
                       .clock_out(clock_out),
                       .reset(reset),
                       .count_end(count_end));
                    
    initial begin 
        clock_in = 0;
        
        forever begin
            clock_in = 0;
            #10;
            clock_in = 1;
            #10;
        end
    end

    initial begin
        reset = 1'b1;
        count_end = 32'd2;
        #20;
        reset = 1'b0;
        #170;
        reset = 1'b1;
        count_end = 32'd3;
        #20;
        reset = 1'b0;
        #250;
        reset = 1'b1;
        count_end = 32'd4;        
        #20;
        reset = 1'b0;
        #330;
        $stop;
    end
endmodule
