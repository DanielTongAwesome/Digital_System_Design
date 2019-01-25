/*

Be aware of the difference of sychronous and asychronous
They reference to the clk, if the output update sychronous with the clk ---> sychronous
also that means this will create some delay

on the other hand, update immediately does not care about the clk ----> asychronous

*/

/*
8-bit register with very basic function
    sychrnous reset
*/

module register_8_bit(reset, clk, D, Q);
    input reset;
    input clk;
    input [7:0] D;
    output reg [7:0] Q;

    always @(posedge clk) begin
        if (reset) 
            Q <= 0;
        else
            Q <= D;
    end 
endmodule


/*
9-bit register with asynchronous reset
*/

module register_9_bit_with_asynchronous_reset(reset, clk, D, Q);
    input reset;
    input clk;
    input [8:0] D;
    output reg [8:0] Q;

    // asychronous logic here
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end 
        else if (clk == 1) begin
            Q <= D;
        end
    end
endmodule

/*
N-bit Register with Synchronous Reset where N is a parameter
*/

module register_sychronous_reset(reset, clk, D, Q);
    parameter width;
    input reset;
    input clk;
    input [width - 1 : 0] D;
    output reg [width - 1 : 0] Q;

    always @(posedge clk) begin
        if (reset) 
            Q <= 0;
        else
            Q <= D;
    end
endmodule

/*

N-bit register with Enable and Asynchronous reset
where N is a parameter

Enable --> 1 update
Enable --> 0 do not update

*/ 
module register_with_enable_and_asynchronous_reset(reset, enable, clk, D, Q);
    parameter width;
    input clk;
    input reset;
    input enable;
    input [width - 1 : 0] D;
    output reg [width - 1 : 0] Q;

    // asychronous, so detect the rising edge of reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end
        else 
            if (enable) begin
                Q <= D;
            end
            else begin
                Q <= 0;
            end
        end 
    end
endmodule 