// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/14.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2014/10/06 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module DE1_SoC_QSYS_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 10,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 17 
   )
  (output [103 - 99 : 0] default_destination_id,
   output [22-1 : 0] default_wr_channel,
   output [22-1 : 0] default_rd_channel,
   output [22-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[103 - 99 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 22'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 22'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 22'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module DE1_SoC_QSYS_mm_interconnect_0_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [117-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [117-1    : 0] src_data,
    output reg [22-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 103;
    localparam PKT_DEST_ID_L = 99;
    localparam PKT_PROTECTION_H = 107;
    localparam PKT_PROTECTION_L = 105;
    localparam ST_DATA_W = 117;
    localparam ST_CHANNEL_W = 22;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h8000000 - 64'h4000000); 
    localparam PAD1 = log2ceil(64'h8001000 - 64'h8000800); 
    localparam PAD2 = log2ceil(64'h8001080 - 64'h8001000); 
    localparam PAD3 = log2ceil(64'h80010a0 - 64'h8001080); 
    localparam PAD4 = log2ceil(64'h80010d0 - 64'h80010c0); 
    localparam PAD5 = log2ceil(64'h80010e0 - 64'h80010d0); 
    localparam PAD6 = log2ceil(64'h80010f0 - 64'h80010e0); 
    localparam PAD7 = log2ceil(64'h8001100 - 64'h80010f0); 
    localparam PAD8 = log2ceil(64'h8001110 - 64'h8001100); 
    localparam PAD9 = log2ceil(64'h8001120 - 64'h8001110); 
    localparam PAD10 = log2ceil(64'h8001130 - 64'h8001120); 
    localparam PAD11 = log2ceil(64'h8001140 - 64'h8001130); 
    localparam PAD12 = log2ceil(64'h8001150 - 64'h8001140); 
    localparam PAD13 = log2ceil(64'h8001160 - 64'h8001150); 
    localparam PAD14 = log2ceil(64'h8001170 - 64'h8001160); 
    localparam PAD15 = log2ceil(64'h8001180 - 64'h8001170); 
    localparam PAD16 = log2ceil(64'h8001190 - 64'h8001180); 
    localparam PAD17 = log2ceil(64'h80011a0 - 64'h8001190); 
    localparam PAD18 = log2ceil(64'h80011b0 - 64'h80011a0); 
    localparam PAD19 = log2ceil(64'h80011c0 - 64'h80011b0); 
    localparam PAD20 = log2ceil(64'h80011c8 - 64'h80011c0); 
    localparam PAD21 = log2ceil(64'h80011d0 - 64'h80011c8); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h80011d0;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [22-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    DE1_SoC_QSYS_mm_interconnect_0_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x4000000 .. 0x8000000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 28'h4000000   ) begin
            src_channel = 22'b0000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x8000800 .. 0x8001000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 28'h8000800   ) begin
            src_channel = 22'b0000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x8001000 .. 0x8001080 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 28'h8001000   ) begin
            src_channel = 22'b0010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x8001080 .. 0x80010a0 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 28'h8001080   ) begin
            src_channel = 22'b0000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x80010c0 .. 0x80010d0 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 28'h80010c0   ) begin
            src_channel = 22'b1000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x80010d0 .. 0x80010e0 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 28'h80010d0   ) begin
            src_channel = 22'b0100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x80010e0 .. 0x80010f0 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 28'h80010e0   ) begin
            src_channel = 22'b0001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x80010f0 .. 0x8001100 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 28'h80010f0   ) begin
            src_channel = 22'b0000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x8001100 .. 0x8001110 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 28'h8001100  && read_transaction  ) begin
            src_channel = 22'b0000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x8001110 .. 0x8001120 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 28'h8001110  && read_transaction  ) begin
            src_channel = 22'b0000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x8001120 .. 0x8001130 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 28'h8001120   ) begin
            src_channel = 22'b0000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x8001130 .. 0x8001140 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 28'h8001130   ) begin
            src_channel = 22'b0000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x8001140 .. 0x8001150 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 28'h8001140   ) begin
            src_channel = 22'b0000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x8001150 .. 0x8001160 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 28'h8001150   ) begin
            src_channel = 22'b0000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x8001160 .. 0x8001170 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 28'h8001160   ) begin
            src_channel = 22'b0000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x8001170 .. 0x8001180 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 28'h8001170   ) begin
            src_channel = 22'b0000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x8001180 .. 0x8001190 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 28'h8001180  && read_transaction  ) begin
            src_channel = 22'b0000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x8001190 .. 0x80011a0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 28'h8001190  && read_transaction  ) begin
            src_channel = 22'b0000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x80011a0 .. 0x80011b0 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 28'h80011a0  && read_transaction  ) begin
            src_channel = 22'b0000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x80011b0 .. 0x80011c0 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 28'h80011b0   ) begin
            src_channel = 22'b0000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x80011c0 .. 0x80011c8 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 28'h80011c0  && read_transaction  ) begin
            src_channel = 22'b0000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x80011c8 .. 0x80011d0 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 28'h80011c8   ) begin
            src_channel = 22'b0000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


