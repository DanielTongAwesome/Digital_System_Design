`default_nettype none
module Picoblaze_Practice(

    //////////// CLOCK //////////
    CLOCK_50,

    //////////// LED //////////
    LEDG,
    LEDR,

    //////////// KEY //////////
    KEY,

    //////////// SW //////////
    SW,

    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,
    HEX6,
    HEX7,

    //////////// Audio //////////
    AUD_ADCDAT,
    AUD_ADCLRCK,
    AUD_BCLK,
    AUD_DACDAT,
    AUD_DACLRCK,
    AUD_XCK,

    //////////// I2C for Audio  //////////
    I2C_SCLK,
    I2C_SDAT,
            
    //////// GPIO //////////
    GPIO_0,
    GPIO_1,
    
//////////// LCD //////////
    LCD_DATA,
    LCD_EN,
    LCD_ON,
    LCD_RS,
    LCD_RW

);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;

//////////// LED //////////
output           [8:0]      LEDG;
output          [17:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input           [17:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;
output           [6:0]      HEX6;
output           [6:0]      HEX7;

//////////// LCD //////////
inout            [7:0]      LCD_DATA;
output                      LCD_EN;
output                      LCD_ON;
output                      LCD_RS;
output                      LCD_RW;

//////////// Audio //////////
input                       AUD_ADCDAT;
inout                       AUD_ADCLRCK;
inout                       AUD_BCLK;
output                      AUD_DACDAT;
inout                       AUD_DACLRCK;
output                      AUD_XCK;

//////////// I2C for Audio  //////////
output                      I2C_SCLK;
inout                       I2C_SDAT;

//////////// GPIO //////////
inout           [35:0]      GPIO_0;
inout           [35:0]      GPIO_1;

       
//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [7:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDG[7:0] = LED[7:0];
wire audio_enable = SW[0];
//Character definitions

//numbers
parameter character_0 =8'h30;
parameter character_1 =8'h31;
parameter character_2 =8'h32;
parameter character_3 =8'h33;
parameter character_4 =8'h34;
parameter character_5 =8'h35;
parameter character_6 =8'h36;
parameter character_7 =8'h37;
parameter character_8 =8'h38;
parameter character_9 =8'h39;


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //'!'

            

            
    wire [3:0] sync_SW;
    reg CLK_25;
    
    always @(posedge CLK_50M)
    begin
         CLK_25 <= !CLK_25;
    end
    
doublesync syncsw3(.indata(SW[3]),
                      .outdata(sync_SW[3]),
                          .clk(CLK_25),
                          .reset(1'b1));                
                          

doublesync syncsw2(.indata(SW[2]),
                      .outdata(sync_SW[2]),
                          .clk(CLK_25),
                          .reset(1'b1));    

doublesync syncsw1(.indata(SW[1]),
                      .outdata(sync_SW[1]),
                          .clk(CLK_25),
                          .reset(1'b1)); 

doublesync syncsw0(.indata(SW[0]),
                      .outdata(sync_SW[0]),
                          .clk(CLK_25),
                          .reset(1'b1));                          
                        
// PicoBlaze Circuit                        
assign LCD_ON   = 1'b1;

picoblaze_template
#(
.clk_freq_in_hz(25000000)
) 
picoblaze_template_inst(
                        .led(LED[7:0]),
                      .lcd_d(LCD_DATA),
                      .lcd_rs(LCD_RS),
                      .lcd_rw(LCD_RW),
                      .lcd_e(LCD_EN),
                        .clk(CLK_25),
                .input_data({4'h0,sync_SW[3:0]})
                 );
                                                        
            
endmodule
