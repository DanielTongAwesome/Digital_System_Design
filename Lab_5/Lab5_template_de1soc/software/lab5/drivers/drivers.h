/*
 * drivers.h
 *
 *  Created on: Mar 5, 2017
 *      Author: Holguer
 */

#ifndef DRIVERS_H_
#define DRIVERS_H_

//audio fifo
int audio_dac_wr_fifo(unsigned char muestra) ;
int stop_wav();
/*Esta función pone stop y pause en 0*/
int play_wav();
/*Esta función pone pause en 1, para pausar el archivo de audio*/
int pause_wav();
//Audio controller sampling frequency
int set_audio_frequency_audio_controller(int freq);
//modulation selector
void select_modulation(unsigned char modulator);
//signal selector
void select_signal(unsigned char signal);
//audio selector
void audio_selector(unsigned char audio_sel);
//Audio Synthesis
int set_note(int freq);
//read keyboard
unsigned int read_keyboard();
//get mouse pos
char mouse_pos(int *x, int *y);
//songs
void starwars();
void tetris();
void gloria();
void mario();

/**Notas
 * */
#define C3 130
#define Db3 138
#define D3 146
#define Eb3 155
#define E3 164
#define F3 174
#define Gb3 185
#define G3 196
#define Ab3 207
#define A3 220
#define Bb3 233
#define B3 246

#define C4 261
#define Db4 277
#define D4 293
#define Eb4 311
#define E4 329
#define F4 349
#define Gb4 369
#define G4 392
#define Ab4 415
#define A4 440
#define Bb4 466
#define B4 493

#define C5 523
#define Db5 544
#define D5 587
#define Eb5 622
#define E5 659
#define F5 698
#define Gb5 739
#define G5 783
#define Ab5 830
#define A5 880
#define Bb5 932
#define B5 987

#define C6 1046
#define Db6 1108
#define D6 1174
#define Eb6 1244
#define E6 1318
#define F6 1396
#define Gb6 1479
#define G6 1567
#define Ab6 1661
#define A6 1760
#define Bb6 1864
#define B6 1975

#define C7 2093
#define Db7 2217
#define D7 2349
#define Eb7 2489
#define E7 2637
#define F7 2794
#define Gb7 2960
#define G7 3136
#define Ab7 3322
#define A7 3520
#define Bb7 3729
#define B7 3951

#define full 600
#define half full / 2


#endif /* DRIVERS_H_ */
