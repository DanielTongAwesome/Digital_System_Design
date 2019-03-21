
module DE1_SoC_QSYS (
	audio2fifo_0_data_divfrec_export,
	audio2fifo_0_empty_export,
	audio2fifo_0_fifo_full_export,
	audio2fifo_0_fifo_used_export,
	audio2fifo_0_out_data_audio_export,
	audio2fifo_0_out_pause_export,
	audio2fifo_0_out_stop_export,
	audio2fifo_0_wrclk_export,
	audio2fifo_0_wrreq_export,
	audio_sel_export,
	clk_clk,
	clk_25_out_clk,
	clk_sdram_clk,
	div_freq_export,
	key_external_connection_export,
	keyboard_keys_export,
	modulation_selector_export,
	mouse_pos_export,
	pll_locked_export,
	reset_reset_n,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	signal_selector_export,
	vga_alt_vip_itc_0_clocked_video_vid_clk,
	vga_alt_vip_itc_0_clocked_video_vid_data,
	vga_alt_vip_itc_0_clocked_video_underflow,
	vga_alt_vip_itc_0_clocked_video_vid_datavalid,
	vga_alt_vip_itc_0_clocked_video_vid_v_sync,
	vga_alt_vip_itc_0_clocked_video_vid_h_sync,
	vga_alt_vip_itc_0_clocked_video_vid_f,
	vga_alt_vip_itc_0_clocked_video_vid_h,
	vga_alt_vip_itc_0_clocked_video_vid_v,
	vga_vga_clk_clk);	

	output	[31:0]	audio2fifo_0_data_divfrec_export;
	input		audio2fifo_0_empty_export;
	input		audio2fifo_0_fifo_full_export;
	input	[11:0]	audio2fifo_0_fifo_used_export;
	output	[31:0]	audio2fifo_0_out_data_audio_export;
	output		audio2fifo_0_out_pause_export;
	output		audio2fifo_0_out_stop_export;
	output		audio2fifo_0_wrclk_export;
	output		audio2fifo_0_wrreq_export;
	output		audio_sel_export;
	input		clk_clk;
	output		clk_25_out_clk;
	output		clk_sdram_clk;
	output	[31:0]	div_freq_export;
	input	[3:0]	key_external_connection_export;
	input	[31:0]	keyboard_keys_export;
	output	[3:0]	modulation_selector_export;
	input	[31:0]	mouse_pos_export;
	output		pll_locked_export;
	input		reset_reset_n;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[7:0]	signal_selector_export;
	input		vga_alt_vip_itc_0_clocked_video_vid_clk;
	output	[23:0]	vga_alt_vip_itc_0_clocked_video_vid_data;
	output		vga_alt_vip_itc_0_clocked_video_underflow;
	output		vga_alt_vip_itc_0_clocked_video_vid_datavalid;
	output		vga_alt_vip_itc_0_clocked_video_vid_v_sync;
	output		vga_alt_vip_itc_0_clocked_video_vid_h_sync;
	output		vga_alt_vip_itc_0_clocked_video_vid_f;
	output		vga_alt_vip_itc_0_clocked_video_vid_h;
	output		vga_alt_vip_itc_0_clocked_video_vid_v;
	output		vga_vga_clk_clk;
endmodule
