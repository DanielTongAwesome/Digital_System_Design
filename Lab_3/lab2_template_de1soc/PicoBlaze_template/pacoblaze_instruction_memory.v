module pacoblaze_instruction_memory
(
 input [9:0] addr,
 output  [17:0] outdata
 );
 
           reg [19:0] memory [1024];
           integer   index;

           initial begin
              $readmemh("pracpico.mem",memory);
           end
		   
		  assign     outdata = memory[addr];
		 
 endmodule
