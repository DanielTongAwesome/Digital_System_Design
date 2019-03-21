/*
 * frame.c
 *
 *  Created on: Dec 12, 2015
 *      Author: Adrizcorp
 */





#include "frame.h"


#include "io.h"

/**
 *  @input:
 *      vfr_register - VFR register base address
 *      width - VFR width in pixel
 *      height - VFR height in pixel
 *      frame_buffer - frame buffer address
 *      divider_for_words - divider used to calculate words (VFR master port width / bpp)
 *      cpr_halve - Color Plane Sequencer's Halve control packet width flag
 */
void ConfigVFR( unsigned int vfr_register, int width, int height, unsigned int frame_buffer0,unsigned int frame_buffer1, unsigned int divider_for_words, int cpr_halve )
{
    /* turn VFR off */
    IOWR( vfr_register, FRAMEREADER_REGISTER_CONTROL, 0 );

    /* set up front buffer */
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME0_BASE, frame_buffer0 );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME0_WORDS, (width * height) / divider_for_words );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME0_SCCP, width * height );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME0_WIDTH, cpr_halve ? (width * 2) : width);
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME0_HEIGHT, height );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME0_INTERLACED, 0 );

    /* set up back buffer */
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME1_BASE, frame_buffer1);
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME1_WORDS, (width * height) / divider_for_words );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME1_SCCP, width * height );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME1_WIDTH, cpr_halve ? (width * 2) : width );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME1_HEIGHT, height );
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME1_INTERLACED, 0 );

    /* turn VFR on */
    IOWR( vfr_register, FRAMEREADER_REGISTER_CONTROL, 1 );
    /* set the front buffer as the default */
    IOWR( vfr_register, FRAMEREADER_REGISTER_FRAME_SELECT, 0 );
}

/**
 *  Get frame buffer address
 */
unsigned int GetFrameBuffer( unsigned int vfr_register, unsigned int buffer_index )
{
    return (unsigned int)IORD( vfr_register,  (0==buffer_index)? FRAMEREADER_REGISTER_FRAME0_BASE : FRAMEREADER_REGISTER_FRAME1_BASE );
}

void cleanscreen(unsigned int * framebuffer){
	int y,x;
	for(y=0; y<SCREEN_HEIGHT; y++){
		for(x=0; x<SCREEN_WIDTH; x++){
				*(framebuffer+x+y*SCREEN_WIDTH)=0x00ffff00;
			}
	}
}
