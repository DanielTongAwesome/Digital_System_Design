/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added/decode.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/template_de1soc/code_added
 * Created Date: Thursday, March 14th 2019, 11:41:33 am
 * Author: DanielTong
 * 
 * Purpose: decode module can perform decode operation
 */


module decode(	input clk,
				input start,
				input reset,
				
				output logic[7:0] s_mem_addr, output logic[7:0] s_mem_data, 
				output logic s_mem_wren, //state bit
				input [7:0] s_mem_q,
				
				output logic [4:0] encr_mem_addr, input [7:0] encr_mem_q,
				
				output logic [4:0] decr_mem_addr, output logic [7:0] decr_mem_data, 
				output logic decr_mem_wren, //state bit
				output logic finish //state bit
				);
	//local varibles
	logic [7:0] i = 0, j = 0, si = 0 , sj = 0, f = 0;
	logic [4:0] k = 0;
	logic [1:0] s_addr_selec;
	logic 	i_reset, i_en, j_reset, j_en, k_reset, k_en, 
			si_en, sj_en, f_en, s_data_selec;//state bits
	
	assign decr_mem_data = f ^ encr_mem_q;
	assign encr_mem_addr = k;
	assign decr_mem_addr = k;
	
	//update i value
	always_ff @(posedge clk) begin
		if (reset | i_reset)
			i <= 8'b0;
		else if (i_en)
			i <= i + 8'b1;
	end
	
	//update j value
	always_ff @(posedge clk) begin
		if (reset | j_reset)
			j <= 8'b0;
		else if (j_en)
			j <= j + si;
	end
	
	//update k value
	always_ff @(posedge clk) begin
		if (reset | k_reset)
			k <= 5'b0;
		else if (k_en)
			k <= k + 5'b1;
	end
	
	//update f value
	always_ff @(posedge clk) begin
		if (f_en)
			f <= s_mem_q;
	end
	
	//update si value
	always_ff @(posedge clk) begin
		if (si_en)
			si <= s_mem_q;
	end
	
	//update sj value
	always_ff @(posedge clk) begin
		if (sj_en)
			sj <= s_mem_q;
	end
	
	//select signals for s_mem_addr
	always_comb
		case (s_addr_selec)
			2'b00 : s_mem_addr = i;
			2'b01 : s_mem_addr = j;
			2'b11 : s_mem_addr = si + sj;
			default : s_mem_addr = 8'b0;
		endcase
		
	//select signals for s_mem_data	
	always_comb
		case (s_data_selec)
			1'b0 : s_mem_data = si;
			1'b1 : s_mem_data = sj;
			default : s_mem_data = 8'b0;
		endcase
	
	//state encoding
	parameter IDLE 				= 15'b0_000_000_000_00_0_00;
	parameter UPDATE_I 			= 15'b1_000_100_000_00_0_00;
	parameter SET_SI_ADDR 		= 15'b1_000_000_000_00_0_00;
	parameter READ_SI 			= 15'b1_000_000_100_00_0_00;
	parameter UPDATE_J 			= 15'b1_000_010_000_00_0_00;
	parameter SET_SJ_ADDR 		= 15'b1_000_000_000_01_0_00;
	parameter READ_SJ			= 15'b1_000_000_010_00_0_00;
	parameter STORE_SI 			= 15'b1_000_000_000_01_0_10;
	parameter STORE_SJ 			= 15'b1_000_000_000_00_1_10;
	parameter SET_F_ADDR 		= 15'b1_000_000_000_11_0_00;
	parameter READ_F 			= 15'b1_000_000_001_00_0_00;
	parameter STORE_DECRYPTED 	= 15'b1_000_000_000_00_0_01;
	parameter UPDATE_K 			= 15'b1_000_001_000_00_0_00;
	parameter FINISH 			= 15'b0_111_000_000_00_0_00;
	
	logic [14:0] state = 0;
	
	assign {finish,
			i_reset, j_reset, k_reset,
			i_en, j_en, k_en,
			si_en, sj_en, f_en,
			s_addr_selec,
			s_data_selec,
			s_mem_wren, 
			decr_mem_wren} = {~state[14],state[13:0]};
	
	//state transition
	always_ff @(posedge clk)
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE 			: if (start) state <= UPDATE_I;
				UPDATE_I 		: state <= SET_SI_ADDR;
				SET_SI_ADDR 	: state <= READ_SI;
				READ_SI 		: state <= UPDATE_J;
				UPDATE_J 		: state <= SET_SJ_ADDR;
				SET_SJ_ADDR 	: state <= READ_SJ;
				READ_SJ 		: state <= STORE_SI;
				STORE_SI 		: state <= STORE_SJ;
				STORE_SJ 		: state <= SET_F_ADDR;
				SET_F_ADDR 		: state <= READ_F;
				READ_F 			: state <= STORE_DECRYPTED;
				STORE_DECRYPTED : state <= UPDATE_K;
				UPDATE_K 		: 	if (k == 8'd31) state <= FINISH;
									else state <= UPDATE_I;
				FINISH 			: state <= IDLE;
			endcase

endmodule