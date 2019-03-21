	component DE1_SoC_QSYS is
		port (
			audio2fifo_0_data_divfrec_export              : out   std_logic_vector(31 downto 0);                    -- export
			audio2fifo_0_empty_export                     : in    std_logic                     := 'X';             -- export
			audio2fifo_0_fifo_full_export                 : in    std_logic                     := 'X';             -- export
			audio2fifo_0_fifo_used_export                 : in    std_logic_vector(11 downto 0) := (others => 'X'); -- export
			audio2fifo_0_out_data_audio_export            : out   std_logic_vector(31 downto 0);                    -- export
			audio2fifo_0_out_pause_export                 : out   std_logic;                                        -- export
			audio2fifo_0_out_stop_export                  : out   std_logic;                                        -- export
			audio2fifo_0_wrclk_export                     : out   std_logic;                                        -- export
			audio2fifo_0_wrreq_export                     : out   std_logic;                                        -- export
			audio_sel_export                              : out   std_logic;                                        -- export
			clk_clk                                       : in    std_logic                     := 'X';             -- clk
			clk_25_out_clk                                : out   std_logic;                                        -- clk
			clk_sdram_clk                                 : out   std_logic;                                        -- clk
			div_freq_export                               : out   std_logic_vector(31 downto 0);                    -- export
			key_external_connection_export                : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			keyboard_keys_export                          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			modulation_selector_export                    : out   std_logic_vector(3 downto 0);                     -- export
			mouse_pos_export                              : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			pll_locked_export                             : out   std_logic;                                        -- export
			reset_reset_n                                 : in    std_logic                     := 'X';             -- reset_n
			sdram_wire_addr                               : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                                 : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n                              : out   std_logic;                                        -- cas_n
			sdram_wire_cke                                : out   std_logic;                                        -- cke
			sdram_wire_cs_n                               : out   std_logic;                                        -- cs_n
			sdram_wire_dq                                 : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                                : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n                              : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                               : out   std_logic;                                        -- we_n
			signal_selector_export                        : out   std_logic_vector(7 downto 0);                     -- export
			vga_alt_vip_itc_0_clocked_video_vid_clk       : in    std_logic                     := 'X';             -- vid_clk
			vga_alt_vip_itc_0_clocked_video_vid_data      : out   std_logic_vector(23 downto 0);                    -- vid_data
			vga_alt_vip_itc_0_clocked_video_underflow     : out   std_logic;                                        -- underflow
			vga_alt_vip_itc_0_clocked_video_vid_datavalid : out   std_logic;                                        -- vid_datavalid
			vga_alt_vip_itc_0_clocked_video_vid_v_sync    : out   std_logic;                                        -- vid_v_sync
			vga_alt_vip_itc_0_clocked_video_vid_h_sync    : out   std_logic;                                        -- vid_h_sync
			vga_alt_vip_itc_0_clocked_video_vid_f         : out   std_logic;                                        -- vid_f
			vga_alt_vip_itc_0_clocked_video_vid_h         : out   std_logic;                                        -- vid_h
			vga_alt_vip_itc_0_clocked_video_vid_v         : out   std_logic;                                        -- vid_v
			vga_vga_clk_clk                               : out   std_logic                                         -- clk
		);
	end component DE1_SoC_QSYS;

	u0 : component DE1_SoC_QSYS
		port map (
			audio2fifo_0_data_divfrec_export              => CONNECTED_TO_audio2fifo_0_data_divfrec_export,              --       audio2fifo_0_data_divfrec.export
			audio2fifo_0_empty_export                     => CONNECTED_TO_audio2fifo_0_empty_export,                     --              audio2fifo_0_empty.export
			audio2fifo_0_fifo_full_export                 => CONNECTED_TO_audio2fifo_0_fifo_full_export,                 --          audio2fifo_0_fifo_full.export
			audio2fifo_0_fifo_used_export                 => CONNECTED_TO_audio2fifo_0_fifo_used_export,                 --          audio2fifo_0_fifo_used.export
			audio2fifo_0_out_data_audio_export            => CONNECTED_TO_audio2fifo_0_out_data_audio_export,            --     audio2fifo_0_out_data_audio.export
			audio2fifo_0_out_pause_export                 => CONNECTED_TO_audio2fifo_0_out_pause_export,                 --          audio2fifo_0_out_pause.export
			audio2fifo_0_out_stop_export                  => CONNECTED_TO_audio2fifo_0_out_stop_export,                  --           audio2fifo_0_out_stop.export
			audio2fifo_0_wrclk_export                     => CONNECTED_TO_audio2fifo_0_wrclk_export,                     --              audio2fifo_0_wrclk.export
			audio2fifo_0_wrreq_export                     => CONNECTED_TO_audio2fifo_0_wrreq_export,                     --              audio2fifo_0_wrreq.export
			audio_sel_export                              => CONNECTED_TO_audio_sel_export,                              --                       audio_sel.export
			clk_clk                                       => CONNECTED_TO_clk_clk,                                       --                             clk.clk
			clk_25_out_clk                                => CONNECTED_TO_clk_25_out_clk,                                --                      clk_25_out.clk
			clk_sdram_clk                                 => CONNECTED_TO_clk_sdram_clk,                                 --                       clk_sdram.clk
			div_freq_export                               => CONNECTED_TO_div_freq_export,                               --                        div_freq.export
			key_external_connection_export                => CONNECTED_TO_key_external_connection_export,                --         key_external_connection.export
			keyboard_keys_export                          => CONNECTED_TO_keyboard_keys_export,                          --                   keyboard_keys.export
			modulation_selector_export                    => CONNECTED_TO_modulation_selector_export,                    --             modulation_selector.export
			mouse_pos_export                              => CONNECTED_TO_mouse_pos_export,                              --                       mouse_pos.export
			pll_locked_export                             => CONNECTED_TO_pll_locked_export,                             --                      pll_locked.export
			reset_reset_n                                 => CONNECTED_TO_reset_reset_n,                                 --                           reset.reset_n
			sdram_wire_addr                               => CONNECTED_TO_sdram_wire_addr,                               --                      sdram_wire.addr
			sdram_wire_ba                                 => CONNECTED_TO_sdram_wire_ba,                                 --                                .ba
			sdram_wire_cas_n                              => CONNECTED_TO_sdram_wire_cas_n,                              --                                .cas_n
			sdram_wire_cke                                => CONNECTED_TO_sdram_wire_cke,                                --                                .cke
			sdram_wire_cs_n                               => CONNECTED_TO_sdram_wire_cs_n,                               --                                .cs_n
			sdram_wire_dq                                 => CONNECTED_TO_sdram_wire_dq,                                 --                                .dq
			sdram_wire_dqm                                => CONNECTED_TO_sdram_wire_dqm,                                --                                .dqm
			sdram_wire_ras_n                              => CONNECTED_TO_sdram_wire_ras_n,                              --                                .ras_n
			sdram_wire_we_n                               => CONNECTED_TO_sdram_wire_we_n,                               --                                .we_n
			signal_selector_export                        => CONNECTED_TO_signal_selector_export,                        --                 signal_selector.export
			vga_alt_vip_itc_0_clocked_video_vid_clk       => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_clk,       -- vga_alt_vip_itc_0_clocked_video.vid_clk
			vga_alt_vip_itc_0_clocked_video_vid_data      => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_data,      --                                .vid_data
			vga_alt_vip_itc_0_clocked_video_underflow     => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_underflow,     --                                .underflow
			vga_alt_vip_itc_0_clocked_video_vid_datavalid => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_datavalid, --                                .vid_datavalid
			vga_alt_vip_itc_0_clocked_video_vid_v_sync    => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_v_sync,    --                                .vid_v_sync
			vga_alt_vip_itc_0_clocked_video_vid_h_sync    => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_h_sync,    --                                .vid_h_sync
			vga_alt_vip_itc_0_clocked_video_vid_f         => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_f,         --                                .vid_f
			vga_alt_vip_itc_0_clocked_video_vid_h         => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_h,         --                                .vid_h
			vga_alt_vip_itc_0_clocked_video_vid_v         => CONNECTED_TO_vga_alt_vip_itc_0_clocked_video_vid_v,         --                                .vid_v
			vga_vga_clk_clk                               => CONNECTED_TO_vga_vga_clk_clk                                --                     vga_vga_clk.clk
		);

