/*
 * frame.h
 *
 *  Created on: Dec 12, 2015
 *      Author: Adrizcorp
 */

#ifndef FRAME_H_
#define FRAME_H_




#define SCREEN_WIDTH (1280)
#define SCREEN_HEIGHT (800)
typedef struct
{
    unsigned int vfr_index;
    unsigned int width;
    unsigned int height;
    unsigned int address;
    unsigned int words_divider;
    unsigned int cpr_halve;
    unsigned int vfr_register;
    unsigned int base0;
    unsigned int base1;
}
VFR_PARAMETERS;

enum FRAMEREADER_REGISTER
{
    FRAMEREADER_REGISTER_CONTROL = 0,
    FRAMEREADER_REGISTER_STATUS,
    FRAMEREADER_REGISTER_FRAME_SELECT = 3,
    FRAMEREADER_REGISTER_FRAME0_BASE,
    FRAMEREADER_REGISTER_FRAME0_WORDS,
    FRAMEREADER_REGISTER_FRAME0_SCCP,
    FRAMEREADER_REGISTER_FRAME0_WIDTH = 8,
    FRAMEREADER_REGISTER_FRAME0_HEIGHT,
    FRAMEREADER_REGISTER_FRAME0_INTERLACED,
    FRAMEREADER_REGISTER_FRAME1_BASE,
    FRAMEREADER_REGISTER_FRAME1_WORDS,
    FRAMEREADER_REGISTER_FRAME1_SCCP,
    FRAMEREADER_REGISTER_FRAME1_WIDTH = 15,
    FRAMEREADER_REGISTER_FRAME1_HEIGHT,
    FRAMEREADER_REGISTER_FRAME1_INTERLACED,
};

void ConfigVFR( unsigned int vfr_register, int width, int height, unsigned int frame_buffer0,unsigned int frame_buffer1, unsigned int divider_for_words, int cpr_halve );
unsigned int GetFrameBuffer( unsigned int vfr_register, unsigned int buffer_index );


void cleanscreen(unsigned int * framebuffer);

#endif /* FRAME_H_ */
