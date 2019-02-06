/*
LED COntrol Test Bench Code
*/
module LED_Control_Test();
    reg clock_in;

    wire [7:0] LEDR;

    LED_Control DUT( .clock_in(clock_in),
                       .LEDR(LEDR));
                    
    initial begin 
        clock_in = 0;
        
        forever begin
            clock_in = 0;
            #1;
            clock_in = 1;
            #1;
        end
    end

    initial begin
        #40;
        $stop;
    end
endmodule
