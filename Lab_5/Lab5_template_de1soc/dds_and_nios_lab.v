`default_nettype none
`include "scan_events.h"
//`define ENABLE_AUDIO_DEMO
module dds_and_nios_lab(

      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      input              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// FAN /////////
      output             FAN_CTRL,

      ///////// FPGA /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO /////////
      inout     [35:0]         GPIO_0,
      inout     [35:0]         GPIO_1,
 

      ///////// HEX0 /////////
      output      [6:0]  HEX0,
 
      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// IRDA /////////
      input              IRDA_RXD,
      output             IRDA_TXD,

      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LEDR /////////
      output      [9:0]  LEDR,

      ///////// PS2 /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW /////////
      input       [9:0]  SW,

      ///////// TD /////////
      input              TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output             TD_RESET_N,
      input             TD_VS,

      ///////// VGA /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
);

parameter COMPILE_HISTOGRAM_SUPPORT = 0;

wire video_clk_40Mhz;
wire vga_de;

//VGA
wire [10:0]CounterX;
wire [10:0]CounterY;
wire      [7:0]  vga_R;
wire      [7:0]  vga_G;
wire      [7:0]  vga_B;
wire cursor_on;
wire [11:0]cursor_RGB;    
wire graph_on;
wire [7:0]R_graph;
wire [7:0]G_graph;
wire [7:0]B_graph;
wire graph_on2;
wire [7:0]R_graph2;
wire [7:0]G_graph2;
wire [7:0]B_graph2;
wire graph_on3;
wire [7:0]R_graph3;
wire [7:0]G_graph3;
wire [7:0]B_graph3;
wire [9:0]data_plot;
(* keep = 1, preserve = 1 *) wire sampler;
wire[9:0]mouse_x;
wire[9:0]mouse_y;

//KEYBOARD
wire        wKeyboardEventReady;
wire [7:0]  wKeyboardEventType;

//HISTOGRAM
logic bar_on;
logic bar_on_raw;
wire [2047:0]histoGrama;
logic [15:0]to_histogram;
logic synced_bar_on;
logic [15:0] flash_audio_data_left_to_histogram, actual_audio_to_histogram;


//modulator
wire [7:0]signal_selector;
wire [3:0]modulation_selector;
wire [31:0]div_freq_count;
wire [31:0]keyboard_keys;

//Audio Generation Signal
//Note that the audio needs signed data - so convert 1 bit to 8 bits signed
wire [31:0]nios_audio_syn_data;
wire audio_selector;
wire [15:0] flash_audio_data;
wire [15:0] flash_audio_data_left, flash_audio_data_right;
(* keep = 1, preserve = 1 *) wire [15:0] actual_audio_data_left;
(* keep = 1, preserve = 1 *) wire [15:0] actual_audio_data_right;
wire audio_left_clock, audio_right_clock;

logic [31:0]DATA_AUDIO; 
logic [31:0]DATA_DIV_FREG; 
logic L;
logic R;
logic [15:0]Left_channel;
logic [15:0]Right_channel;
logic WRREQ;
logic WRCLK;
logic STOP; 
logic PAUSE;
logic FIFO_FULL;
logic EMPTY;
logic audio_sampling;
logic [11:0]used_fifo;

/*Keyboard Keys*/
reg HOLDING_1;
reg HOLDING_2;
reg HOLDING_3;
reg HOLDING_4;
reg HOLDING_5;
reg HOLDING_6;
reg HOLDING_7;
reg HOLDING_8;

reg HOLDING_F1;
reg HOLDING_F2;
reg HOLDING_N;
reg HOLDING_M;
reg HOLDING_SPACE;
reg HOLDING_LEFT_ARROW;
reg HOLDING_RIGHT_ARROW;
reg HOLDING_UP_ARROW;
reg HOLDING_DOWN_ARROW;
 
logic CLK_25MHZ;



//=======================================================
//  Structural coding 
//=======================================================
assign VGA_BLANK_N=vga_de;
assign VGA_CLK=video_clk_40Mhz;
assign VGA_SYNC_N=1'b1 & SW[1];

logic lfsr_clk;
logic [4:0]LFSR;
logic [31:0] dds_increment;

/// NIOS II Qsys

DE1_SoC_QSYS U0( 
		.clk_clk(CLOCK_50),                        //                     clk.clk
		.reset_reset_n(1'b1),                  //                   reset.reset_n
		.key_external_connection_export(KEY), // key_external_connection.export
		
		.clk_sdram_clk(DRAM_CLK),                  //               clk_sdram.clk
	   .sdram_wire_addr(DRAM_ADDR),                //              sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                  //                        .ba
		.sdram_wire_cas_n(DRAM_CAS_N),               //                        .cas_n 
		.sdram_wire_cke(DRAM_CKE),                 //                        .cke
		.sdram_wire_cs_n(DRAM_CS_N),                //                        .cs_n
		.sdram_wire_dq(DRAM_DQ),                  //                        .dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),                 //                        .dqm
		.sdram_wire_ras_n(DRAM_RAS_N),               //                        .ras_n
		.sdram_wire_we_n(DRAM_WE_N) ,                //                        .we_n
		.vga_alt_vip_itc_0_clocked_video_vid_clk       (video_clk_40Mhz),       // vga_alt_vip_itc_0_clocked_video.vid_clk
	   .vga_alt_vip_itc_0_clocked_video_vid_data      ({vga_R[7:0],vga_G[7:0],vga_B[7:0]}),      //                                .vid_data
	   .vga_alt_vip_itc_0_clocked_video_vid_datavalid (vga_de), //                                .vid_datavalid
	   .vga_alt_vip_itc_0_clocked_video_vid_v_sync    (VGA_VS),    //                                .vid_v_sync
	   .vga_alt_vip_itc_0_clocked_video_vid_h_sync    (VGA_HS),    //                                .vid_h_sync
	   //.vga_vga_clk_clk                               (video_clk_40Mhz) ,
		
		//AUDIO 
		.audio2fifo_0_data_divfrec_export              (DATA_DIV_FREG),              //       audio2fifo_0_data_divfrec.export
	   .audio2fifo_0_empty_export                     (EMPTY),                     //              audio2fifo_0_empty.export
	   .audio2fifo_0_fifo_full_export                 (FIFO_FULL),                 //          audio2fifo_0_fifo_full.export
	   .audio2fifo_0_fifo_used_export                 (used_fifo),                 //          audio2fifo_0_fifo_used.export
	   .audio2fifo_0_out_data_audio_export            (DATA_AUDIO),            //     audio2fifo_0_out_data_audio.export
	   .audio2fifo_0_out_pause_export                 (PAUSE),                 //          audio2fifo_0_out_pause.export
	   .audio2fifo_0_out_stop_export                  (STOP),                  //           audio2fifo_0_out_stop.export
	   .audio2fifo_0_wrclk_export                     (WRCLK),                     //              audio2fifo_0_wrclk.export
	   .audio2fifo_0_wrreq_export                     (WRREQ),                   //              audio2fifo_0_wrreq.export
		
		
		//interfaces
	   .signal_selector_export                        (signal_selector[7:0]),                        //                 signal_selector.export
	   .modulation_selector_export                    (modulation_selector[3:0]),                    //             modulation_selector.export
	   .keyboard_keys_export                          (keyboard_keys[31:0]),                          //                   keyboard_keys.export
	   .mouse_pos_export                              ({12'd0,mouse_x[9:0],mouse_y[9:0]}),                              //                       mouse_pos.export
	   .div_freq_export                               (nios_audio_syn_data[31:0]),                               //                        div_freq.export
	   .audio_sel_export                              (audio_selector),                               //                       audio_sel.export
	   
       .vga_vga_clk_clk                               (video_clk_40Mhz),                               //                     vga_vga_clk.clk
       .clk_25_out_clk                                (CLK_25MHZ)                                 //                      clk_25_out.clk
       
	);
	
 
////////////////////////////////////////////////////////////////////
// 
//                       Put DDS + LFSR Code Here
//
////////////////////////////////////////////////////////////////////		   

	
(* keep = 1, preserve = 1 *) logic [11:0] actual_selected_modulation;
(* keep = 1, preserve = 1 *) logic [11:0] actual_selected_signal;


////////////////////////////////////////////////////////////////////
// 
//                       End of Student Code Section
//
////////////////////////////////////////////////////////////////////	
assign keyboard_keys[31:0]={15'd0,HOLDING_1,HOLDING_2,HOLDING_3,HOLDING_4,HOLDING_5,HOLDING_6,HOLDING_7,HOLDING_8,HOLDING_F1,HOLDING_F2,HOLDING_N,HOLDING_M,HOLDING_SPACE,HOLDING_LEFT_ARROW,HOLDING_RIGHT_ARROW,HOLDING_UP_ARROW,HOLDING_DOWN_ARROW};


///KEYBOARD --------------------

Keyboard_Controller kc0 (
	  .iPS2_CLK    (PS2_CLK),
	  .iPS2_DAT    (PS2_DAT),
	  .iCLK        (CLK_25MHZ),
	  .iRESET      (1'b0),
	  .oEventReady (wKeyboardEventReady),
	  .oEventType  (wKeyboardEventType)
 );

 logic reset_from_key, reset_from_key_clk_40, graph_enable_scroll;
 
 doublesync_no_reset sync_reset_from_key (.indata (!KEY[0]),    .outdata(reset_from_key),    .clk    (CLK_25MHZ));
 doublesync_no_reset sync_reset_from_key_clk_40 (.indata (!KEY[0]),    .outdata(reset_from_key_clk_40),    .clk    (video_clk_40Mhz));
 doublesync_no_reset sync_graph_enable_scroll (.indata (SW[0]),    .outdata(graph_enable_scroll),    .clk    (video_clk_40Mhz));


// Detectar letras.
 always @(posedge CLK_25MHZ) begin
	  if(reset_from_key) begin
			HOLDING_SPACE         <= 1'b0;
			HOLDING_LEFT_ARROW   <= 1'b0;
			HOLDING_RIGHT_ARROW  <= 1'b0;
			HOLDING_UP_ARROW     <= 1'b0;
			HOLDING_DOWN_ARROW   <= 1'b0;
			HOLDING_M<=1'b0;
			HOLDING_N<=1'b0;
			HOLDING_F1<=1'b0;
			HOLDING_F2<=1'b0;
			
			HOLDING_1<=1'b0;
			HOLDING_2<=1'b0;
			HOLDING_3<=1'b0;
			HOLDING_4<=1'b0;
			HOLDING_5<=1'b0;
			HOLDING_6<=1'b0;
			HOLDING_7<=1'b0;
			HOLDING_8<=1'b0;
	  end
	  else begin
			if(wKeyboardEventType == `SC_MAKE_SPACE)             HOLDING_SPACE        <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_SPACE)       HOLDING_SPACE        <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_LEFT_ARROW)        HOLDING_LEFT_ARROW  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_LEFT_ARROW)  HOLDING_LEFT_ARROW  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_RIGHT_ARROW)       HOLDING_RIGHT_ARROW <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_RIGHT_ARROW)   HOLDING_RIGHT_ARROW <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_UP_ARROW)          HOLDING_UP_ARROW    <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_UP_ARROW)    HOLDING_UP_ARROW    <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_DOWN_ARROW)        HOLDING_DOWN_ARROW  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_DOWN_ARROW)  HOLDING_DOWN_ARROW  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_N)        HOLDING_N  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_N)  HOLDING_N  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_M)        HOLDING_M  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_M)  HOLDING_M  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_F1)        HOLDING_F1  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_F1)  HOLDING_F1  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_F2)        HOLDING_F2  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_F2)  HOLDING_F2  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_1)        HOLDING_1  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_1)  HOLDING_1  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_2)        HOLDING_2  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_2)  HOLDING_2  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_3)        HOLDING_3  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_3)  HOLDING_3  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_4)        HOLDING_4  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_4)  HOLDING_4  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_5)        HOLDING_5  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_5)  HOLDING_5  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_6)        HOLDING_6  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_6)  HOLDING_6  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_7)        HOLDING_7  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_7)  HOLDING_7  <= 1'b0;
			if(wKeyboardEventType == `SC_MAKE_8)        HOLDING_8  <= 1'b1;
			else if(wKeyboardEventType == `SC_BREAK_8)  HOLDING_8  <= 1'b0;
	  end
 end
 
 
 
/* video X Y counter generation */
hack_ltm_sincronization hack_ltm_sincronization_inst
(
	.clk_lcd(video_clk_40Mhz) ,	// input  clk_lcd_sig
	.den_lcd(vga_de) ,	// input  den_lcd_sig
	.count_x(CounterX) ,	// output [10:0] count_x_sig
	.count_y(CounterY) , 	// output [10:0] count_y_sig
	.reset(1'b1)
);

 logic HOLDING_LEFT_ARROW_sync_to_video ;
 logic HOLDING_UP_ARROW_sync_to_video   ;
 logic HOLDING_DOWN_ARROW_sync_to_video ;
 logic HOLDING_RIGHT_ARROW_sync_to_video;
 logic HOLDING_M_sync_to_video;
 logic HOLDING_SPACE_sync_to_video;
 
 
 doublesync_no_reset sync_HOLDING_LEFT_ARROW  (.indata (HOLDING_LEFT_ARROW),    .outdata(HOLDING_LEFT_ARROW_sync_to_video),    .clk    (video_clk_40Mhz));
 doublesync_no_reset sync_HOLDING_UP_ARROW    (.indata (HOLDING_UP_ARROW),      .outdata(HOLDING_UP_ARROW_sync_to_video),      .clk    (video_clk_40Mhz));
 doublesync_no_reset sync_HOLDING_DOWN_ARROW  (.indata (HOLDING_DOWN_ARROW),    .outdata(HOLDING_DOWN_ARROW_sync_to_video),    .clk    (video_clk_40Mhz));
 doublesync_no_reset sync_HOLDING_RIGHT_ARROW (.indata (HOLDING_RIGHT_ARROW),   .outdata(HOLDING_RIGHT_ARROW_sync_to_video),   .clk    (video_clk_40Mhz));
 doublesync_no_reset sync_HOLDING_M (.indata (HOLDING_M),   .outdata(HOLDING_M_sync_to_video),   .clk    (video_clk_40Mhz));
 doublesync_no_reset sync_HOLDING_SPACE (.indata (HOLDING_SPACE),   .outdata(HOLDING_SPACE_sync_to_video),   .clk    (video_clk_40Mhz));

//Cursor
/*Cursor Control*/ 
Cursor Cursor_inst
(
	.iLeft (HOLDING_LEFT_ARROW_sync_to_video  ) ,	// input  iLeft_sig
	.iUp   (HOLDING_UP_ARROW_sync_to_video    ) ,	// input  iUp_sig
	.iDown (HOLDING_DOWN_ARROW_sync_to_video  ) ,	// input  iDown_sig
	.iRight(HOLDING_RIGHT_ARROW_sync_to_video ) ,	// input  iRight_sig
	.iVGA_X(CounterX) ,	// input [10:0] iVGA_X_sig
	.iVGA_Y(CounterY) ,	// input [10:0] iVGA_Y_sig
	.oRGB(cursor_RGB[11:0]) ,	// output [11:0] oRGB_sig
	.iRST(reset_from_key_clk_40) ,	// input  iRST_sig
	.iCLK(video_clk_40Mhz) ,	// input  iCLK_sig
	.slow(HOLDING_M_sync_to_video) ,	// input  slow_sig
	.ichangeC(HOLDING_SPACE_sync_to_video) ,	// input  ichangeC_sig
	.arrow_on(cursor_on) ,	// output  arrow_on_sig
	.pointer_x(mouse_x[9:0]),
	.pointer_y(mouse_y[9:0])
	
);	 

Generate_Arbitrary_Divided_Clk32 
Generate_LCD_scope_Clk(
.inclk(CLK_25MHZ),
.outclk(sampler),
.outclk_Not(),
.div_clk_count(32'd70000),
.Reset(1'h1));

//VGA Oscilloscope Modules
plot_graph plot_graph1
(
	.CountX_in(CounterX) ,	// input [Xcount-1:0] CountX_in_sig
	.CountY_in(CounterY) ,	// input [Ycount-1:0] CountY_in_sig
	.data_graph({~actual_selected_modulation[11],actual_selected_modulation[10:4]}) ,	// input [size_data-1:0] data_graph_sig
	.data_graph_rdy(sampler) ,	// input  data_graph_rdy_sig
	.display_clk(video_clk_40Mhz) ,	// input  display_clk_sig
	.color_graph(24'h00ff30) ,	// input [numberRGB-1:0] color_graph_sig
	.scroll_en(graph_enable_scroll) ,	// input  scroll_en_sig
	.Pos_X(11'd0) ,	// input [Xcount-1:0] Pos_X_sig
	.Pos_Y(11'd266) ,	// input [Ycount-1:0] Pos_Y_sig
	.Witdh(11'd640) ,	// input [width_grp-1:0] Witdh_sig
	.Height(3'd2) ,	// input [height_grp-1:0] Height_sig
	.line_width(2'd0) ,	// input [2:0] line_width_sig
	.Graph_en(1'b1) ,	// input  Graph_en_sig
	.Graph_on(graph_on) ,	// output  Graph_on_sig 
	.R(R_graph[7:0]) ,	// output [numberRGB-17:0] R_sig
	.G(G_graph[7:0]) ,	// output [numberRGB-17:0] G_sig
	.B(B_graph[7:0]) ,	// output [numberRGB-17:0] B_sig
	.reset_n(1'b1) ,	// input  reset_n_sig
	.pause_graph(1'b0) 	// input  pause_graph_sig
);

plot_graph plot_graph2
(
	.CountX_in(CounterX) ,	// input [Xcount-1:0] CountX_in_sig
	.CountY_in(CounterY) ,	// input [Ycount-1:0] CountY_in_sig
	.data_graph({~actual_selected_signal[11],actual_selected_signal[10:4]}) ,	// input [size_data-1:0] data_graph_sig
	.data_graph_rdy(sampler) ,	// input  data_graph_rdy_sig
	.display_clk(video_clk_40Mhz) ,	// input  display_clk_sig
	.color_graph(24'h00ff30) ,	// input [numberRGB-1:0] color_graph_sig
	.scroll_en(graph_enable_scroll) ,	// input  scroll_en_sig
	.Pos_X(11'd0) ,	// input [Xcount-1:0] Pos_X_sig
	.Pos_Y(11'd438) ,	// input [Ycount-1:0] Pos_Y_sig
	.Witdh(11'd640) ,	// input [width_grp-1:0] Witdh_sig
	.Height(3'd2) ,	// input [height_grp-1:0] Height_sig
	.line_width(2'd0) ,	// input [2:0] line_width_sig
	.Graph_en(1'b1) ,	// input  Graph_en_sig
	.Graph_on(graph_on2) ,	// output  Graph_on_sig 
	.R(R_graph2[7:0]) ,	// output [numberRGB-17:0] R_sig
	.G(G_graph2[7:0]) ,	// output [numberRGB-17:0] G_sig
	.B(B_graph2[7:0]) ,	// output [numberRGB-17:0] B_sig
	.reset_n(1'b1) ,	// input  reset_n_sig
	.pause_graph(1'b0) 	// input  pause_graph_sig
);



/*MUX DE VIDEO*/

// VGA NIOS II
reg [7:0]video_r_out;
reg [7:0]video_g_out;
reg [7:0]video_b_out;


always@(negedge video_clk_40Mhz)
begin	
	if(cursor_on)
	begin
				video_r_out[7:0]<={cursor_RGB[11:8],4'd0};
				video_g_out[7:0]<={cursor_RGB[7:4],4'd0};
				video_b_out[7:0]<={cursor_RGB[3:0],4'd0};
	end
	else if(graph_on || graph_on2 || graph_on3 )
	begin
				video_r_out[7:0]<=graph_on ? R_graph[7:0]:
									   graph_on2 ? R_graph2[7:0]:
										R_graph3[7:0];
				video_g_out[7:0]<=graph_on ? G_graph[7:0]:
									   graph_on2 ? G_graph2[7:0]:
										G_graph3[7:0];
				video_b_out[7:0]<=graph_on ? B_graph[7:0]:
									   graph_on2 ? B_graph2[7:0]:
										B_graph3[7:0];
	end
	 else if(bar_on)
	 begin
				video_r_out[7:0]<=8'd255;
				video_g_out[7:0]<=Left_channel[7:0]+Left_channel[15:8];
				video_b_out[7:0]<=Right_channel[7:0];
	 end
	else
	begin
				video_r_out[7:0]<=vga_R[7:0];
				video_g_out[7:0]<=vga_G[7:0];
				video_b_out[7:0]<=vga_B[7:0];
	end			
end
 
 assign {VGA_R[7:0],VGA_G[7:0],VGA_B[7:0]}={video_r_out[7:0],video_g_out[7:0],video_b_out[7:0]};

 extern module audio_subsystem_w_histogram	
(
  input [31:0]DATA_AUDIO, 
   input logic WRREQ,
   input logic WRCLK,
   input logic STOP,
   input logic PAUSE,
   input logic [31:0]DATA_DIV_FREG, 
   input CLOCK_50,
   output FIFO_FULL,
   output EMPTY,
   input video_clk_40Mhz,
   input              AUD_ADCDAT,
   inout              AUD_ADCLRCK,
   inout              AUD_BCLK,
   output             AUD_DACDAT,
   inout              AUD_DACLRCK,
   output             AUD_XCK,
   output             FPGA_I2C_SCLK,
   inout              FPGA_I2C_SDAT,
   input  logic [10:0]CounterX,
   input  logic [10:0]CounterY,
   output logic       bar_on,
   output logic [11:0]used_fifo
);	 
  
  extern module audio_subsystem_no_histogram	
(
  input [31:0]DATA_AUDIO, 
   input logic WRREQ,
   input logic WRCLK,
   input logic STOP,
   input logic PAUSE,
   input logic [31:0]DATA_DIV_FREG, 
   input CLOCK_50,
   output FIFO_FULL,
   output EMPTY,
   input video_clk_40Mhz,
   input              AUD_ADCDAT,
   inout              AUD_ADCLRCK,
   inout              AUD_BCLK,
   output             AUD_DACDAT,
   inout              AUD_DACLRCK,
   output             AUD_XCK,
   output             FPGA_I2C_SCLK,
   inout              FPGA_I2C_SDAT,
   input  logic [10:0]CounterX,
   input  logic [10:0]CounterY,
   output logic       bar_on,
   output logic [11:0]used_fifo
);	 

 `ifdef ENABLE_AUDIO_DEMO 
			  generate 
                          if (COMPILE_HISTOGRAM_SUPPORT)
						  begin										 
								 audio_subsystem_w_histogram
								 audio_subsystem_inst
								 (
								 .*
								 );
						  end
						  else
						  begin						  
								 audio_subsystem_no_histogram
								 audio_subsystem_inst
								 (
								 .*
								 );						  								 
						  end						  
			endgenerate				
`endif 

endmodule
`default_nettype wire
