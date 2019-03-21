/*
 * drivers.c
 *
 *  Created on: Mar 5, 2017
 *      Author: Holguer
 */

#include "includes.h"
#include "drivers.h"
#include "system.h"
#include <io.h>

/*Esta función pone en zeros entradas al FIFO, carga la muestra y genera un pulso de reloj WRCLK,
 * y vuelve a poner en zeros los puertos de entrada al fifo */
int audio_dac_wr_fifo(unsigned char muestra) {
// poner en zeros
	// ESRITURA
	IOWR(AUDIO_WRREQ_BASE, 0, 0);
	IOWR(AUDIO_WRCLK_BASE, 0, 0);
	IOWR(AUDIO_OUT_DATA_AUDIO_BASE, 0, 0);

//cargar la muestra
	IOWR(AUDIO_OUT_DATA_AUDIO_BASE, 0, (muestra << 8) | (muestra << 24));

//pulso clk
	IOWR(AUDIO_WRREQ_BASE, 0, 1);
	IOWR(AUDIO_WRCLK_BASE, 0, 0);
	IOWR(AUDIO_WRCLK_BASE, 0, 1);
	IOWR(AUDIO_WRCLK_BASE, 0, 0);

//poner zeros

	// ESRITURA
	IOWR(AUDIO_WRREQ_BASE, 0, 0);
	IOWR(AUDIO_WRCLK_BASE, 0, 0);
	IOWR(AUDIO_OUT_DATA_AUDIO_BASE, 0, 0);

	return 0;
}

/*Esta función pone stop en 1, detener la canción*/
int stop_wav() {
	IOWR(AUDIO_OUT_STOP_BASE, 0, 1);
	IOWR(AUDIO_OUT_STOP_BASE, 0, 0);
	IOWR(AUDIO_OUT_PAUSE_BASE, 0, 1);
	return 0;
}
/*Esta función pone stop y pause en 0*/
int play_wav() {
	IOWR(AUDIO_OUT_STOP_BASE, 0, 0);
	IOWR(AUDIO_OUT_PAUSE_BASE, 0, 0);
	return 0;
}

/*Esta función pone pause en 1, para pausar el archivo de audio*/
int pause_wav() {
	IOWR(AUDIO_OUT_PAUSE_BASE, 0, 1);
	return 0;
}

int audio_dac_fifo_full() {
	//leer el si el fifo esta lleno y devolverlo
	unsigned char FIFO_full;
	FIFO_full = IORD(AUDIO_FIFO_FULL_BASE, 0);
	return (FIFO_full);
}

int init_audio_hw() {
	IOWR(AUDIO_WRREQ_BASE, 0, 0);
	IOWR(AUDIO_WRCLK_BASE, 0, 0);
	IOWR(AUDIO_OUT_DATA_AUDIO_BASE, 0, 0);
	IOWR(AUDIO_OUT_STOP_BASE, 0, 1);
	IOWR(AUDIO_OUT_PAUSE_BASE, 0, 0);
	IOWR(AUDIO_DATA_FREGEN_BASE, 0, 0);
}

int set_audio_frequency_audio_controller(int freq) {
	//calcular con srate lo que debe enviarse a div_freq_data
	int div_data = (50000000 / (2 * freq)) - 1;
	//printf("div frec=%d\n", div_data);
	IOWR(AUDIO_DATA_FREGEN_BASE, 0, div_data);

	return 0;
}

//Audio Synthesis
int set_note(int freq) {
	//calcular con srate lo que debe enviarse a div_freq_data
	int div_data = (50000000 / (2 * freq)) - 1;
	IOWR(DIV_FREQ_BASE, 0, div_data);

	return 0;

}

//modulation selector
void select_modulation(unsigned char modulator) {
	IOWR(MODULATION_SELECTOR_BASE, 0, modulator);
}

void select_signal(unsigned char signal) {
	IOWR(SIGNAL_SELECTOR_BASE, 0, signal);
}

void audio_selector(unsigned char audio_sel) {
	IOWR(AUDIO_SEL_BASE, 0, audio_sel);
}

unsigned int read_keyboard() {
	return IORD(KEYBOARD_KEYS_BASE, 0);
}

char mouse_pos(int *x, int *y) {
	static char space = 0;
	static char space_last = 0;
	unsigned int pos = IORD(MOUSE_POS_BASE, 0);
	*x = (pos >> 10) & 0x3ff;
	*y = (pos) & 0x3ff;

	unsigned int space_key = read_keyboard();
	space_key = (space_key >> 4) & 1;
	space_last = space;
	if (space_last != space_key) {
		space = space_key;
	}

	if (space_last == 0 && space == 1 || space_key == 1) {
		return 1;	//down event
	} else if (space_last == 1 && space == 0) {
		return 2;	//down up
	} else {
		return 0;	//not_pressing
	}

}

//songs

void Sleep(int millseconds) {
	while (millseconds > 0) {

		OSTimeDlyHMSM(0, 0, 0, 1);
		millseconds--;
	}
}

void Beep(float freq, int millseconds) {
	set_note(freq);
	Sleep(millseconds);
	set_note(0);
}

void starwars() {
	Beep(440, 500);
	Beep(440, 500);
	Beep(440, 500);
	Beep(349, 350);
	Beep(523, 150);
	Beep(440, 500);
	Beep(349, 350);
	Beep(523, 150);
	Beep(440, 1000);
	Beep(659, 500);
	Beep(659, 500);
	Beep(659, 500);
	Beep(698, 350);
	Beep(523, 150);
	Beep(415, 500);
	Beep(349, 350);
	Beep(523, 150);
	Beep(440, 1000);
}

void gloria() {
	Beep(D5, full);	//RE
	Beep(G5, full);	//SOL
	Sleep(half / 8);
	Beep(G5, full * 3 / 2);	//SOL
	Beep(Gb5, full * 1 / 2);	//FA#
	Beep(G5, full);	//SOL
	Beep(B5, full);	//SI
	Sleep(half / 8);
	Beep(B5, full);	//SI
	Beep(A5, full);	//LA
	Beep(D6, full);	//RE
	Sleep(half / 8);
	Beep(D6, full);	//RE
	Sleep(half / 8);
	Beep(D6, full * 3 / 2);	//RE
	Beep(C6, full * 1 / 2);	//DO
	Beep(B5, full);	//SI
	Beep(A5, full);	//LA
	Beep(B5, full * 2);	//SI
	Beep(D5, full);	//RE
	Sleep(half / 4);
	Beep(G5, full);	//SOL
	Sleep(half / 8);
	Beep(G5, full * 3 / 2);	//SOL
	Beep(Gb5, full * 1 / 2);	//FA#
	Beep(G5, full);	//SOL
	Beep(B5, full);	//SI
	Sleep(half / 8);
	Beep(B5, full);	//SI
	Beep(A5, full);	//LA
	Beep(D6, full);	//RE
	Beep(A5, full);	//LA
	Sleep(half / 8);
	Beep(A5, full * 3 / 2);	//LA
	Beep(G5, full * 1 / 2);	//SOL
	Beep(Gb5, full);	//FA#
	Beep(E5, full);	//MI
	Beep(D5, full * 2);	//RE
	Beep(D6, full);	//RE
	Sleep(half / 8);
	Beep(D6, full);	//RE
	Sleep(half / 8);
	Beep(D6, full * 3 / 2);	//RE
	Beep(G5, full * 1 / 2);	//SOL
	Beep(C6, full);	//DO
	Beep(B5, full);	//SI
	Sleep(half / 8);
	Beep(B5, full);	//SI
	Beep(A5, full);	//LA
	Beep(D6, full);	//RE
	Sleep(half / 8);
	Beep(D6, full);	//RE
	Sleep(half / 8);
	Beep(D6, full * 3 / 2);	//RE
	Beep(G5, full * 1 / 2);	//SOL
	Beep(C6, full);	//DO
	Beep(B5, full);	//SI
	Beep(A5, full * 2);	//LA
	Beep(E6, full);	//MI
	Sleep(half / 8);
	Beep(E6, full);	//MI
	Sleep(half / 8);
	Beep(E6, full * 3 / 2);	//MI
	Beep(D6, full * 1 / 2);	//RE
	Beep(C6, full);	//DO
	Beep(B5, full);	//SI
	Beep(C6, full * 2);	//DO
	Sleep(half / 4);
	Beep(A5, full);	//LA
	Beep(B5, full / 2);	//SI
	Beep(C6, full / 2);	//DO
	Beep(D6, full * 3 / 2);	//RE
	Beep(G5, full * 1 / 2);	//SOL
	Sleep(half / 8);
	Beep(G5, full);	//SOL
	Beep(A5, full);	//LA
	Beep(B5, full * 2);	//SI
	Beep(E6, full);	//MI
	Sleep(half / 8);
	Beep(E6, full);	//MI
	Sleep(half / 8);
	Beep(E6, full * 3 / 2);	//MI
	Beep(D6, full / 1 / 2);	//RE
	Beep(C6, full);	//DO
	Beep(B5, full);	//SI
	Beep(C6, full * 2);	//DO
	Sleep(half / 4);
	Beep(A5, full);	//LA
	Beep(B5, full / 2);	//SI
	Beep(C6, full / 2);	//DO
	Beep(D6, full * 3 / 2);	//RE
	Beep(G5, full * 1 / 2);	//SOL
	Sleep(half / 8);
	Beep(G5, full);	//SOL
	Beep(Gb5, full);	//FA#
	Beep(G5, full * 2);	//SOL

}


void mario(){
	 Beep(1480,200);

	    Beep(1568,200);

	    Beep(1568,200);

	    Beep(1568,200);



	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);



	    Beep(369.99,200);

	    Beep(392,200);

	    Beep(369.99,200);

	    Beep(392,200);

	    Beep(392,400);

	    Beep(196,400);



	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(880,200);

	    Beep(830.61,200);

	    Beep(880,200);

	    Beep(987.77,400);


	    Beep(880,200);

	    Beep(783.99,200);

	    Beep(698.46,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(880,200);

	    Beep(830.61,200);

	    Beep(880,200);

	    Beep(987.77,400);

	      Sleep(200);

	    Beep(1108,10);
	    Beep(1174.7,200);
	    Beep(1480,10);
	    Beep(1568,200);


	    Sleep(200);
	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(783.99,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(880,200);

	    Beep(830.61,200);

	    Beep(880,200);

	    Beep(987.77,400);


	    Beep(880,200);

	    Beep(783.99,200);

	    Beep(698.46,200);


	    Beep(659.25,200);

	    Beep(698.46,200);

	    Beep(784,200);

	    Beep(880,400);

	    Beep(784,200);

	    Beep(698.46,200);

	    Beep(659.25,200);



	    Beep(587.33,200);

	    Beep(659.25,200);

	    Beep(698.46,200);

	    Beep(784,400);

	    Beep(698.46,200);

	    Beep(659.25,200);

	    Beep(587.33,200);



	    Beep(523.25,200);

	    Beep(587.33,200);

	    Beep(659.25,200);

	    Beep(698.46,400);

	    Beep(659.25,200);

	    Beep(587.33,200);

	    Beep(493.88,200);

	    Beep(523.25,200);


	    Sleep(400);
	    Beep(349.23,400);

	    Beep(392,200);

	    Beep(329.63,200);

	    Beep(523.25,200);

	    Beep(493.88,200);

	    Beep(466.16,200);



	    Beep(440,200);

	    Beep(493.88,200);

	    Beep(523.25,200);

	    Beep(880,200);

	    Beep(493.88,200);

	    Beep(880,200);

	    Beep(1760,200);

	    Beep(440,200);



	    Beep(392,200);

	    Beep(440,200);

	    Beep(493.88,200);

	    Beep(783.99,200);

	    Beep(440,200);

	    Beep(783.99,200);

	    Beep(1568,200);

	    Beep(392,200);



	    Beep(349.23,200);

	    Beep(392,200);

	    Beep(440,200);

	    Beep(698.46,200);

	    Beep(415.2,200);

	    Beep(698.46,200);

	    Beep(1396.92,200);

	    Beep(349.23,200);



	    Beep(329.63,200);

	    Beep(311.13,200);

	    Beep(329.63,200);

	    Beep(659.25,200);

	    Beep(698.46,400);

	    Beep(783.99,400);



	    Beep(440,200);

	    Beep(493.88,200);

	    Beep(523.25,200);

	    Beep(880,200);

	    Beep(493.88,200);

	    Beep(880,200);

	    Beep(1760,200);

	    Beep(440,200);



	    Beep(392,200);

	    Beep(440,200);

	    Beep(493.88,200);

	    Beep(783.99,200);

	    Beep(440,200);

	    Beep(783.99,200);

	    Beep(1568,200);

	    Beep(392,200);



	    Beep(349.23,200);

	    Beep(392,200);

	    Beep(440,200);

	    Beep(698.46,200);

	    Beep(659.25,200);

	    Beep(698.46,200);

	    Beep(739.99,200);

	    Beep(783.99,200);

	    Beep(392,200);

	    Beep(392,200);

	    Beep(392,200);

	    Beep(392,200);

	    Beep(196,200);

	    Beep(196,200);

	    Beep(196,200);



	    Beep(185,200);

	    Beep(196,200);

	    Beep(185,200);

	    Beep(196,200);

	    Beep(207.65,200);

	    Beep(220,200);

	    Beep(233.08,200);

	    Beep(246.94,200);
}

void tetris(){
	Beep(658, 125);
	Beep(1320, 500);
	Beep(990, 250);
	Beep(1056, 250);
	Beep(1188, 250);
	Beep(1320, 125);
	Beep(1188, 125);
	Beep(1056, 250);
	Beep(990, 250);
	Beep(880, 500);
	Beep(880, 250);
	Beep(1056, 250);
	Beep(1320, 500);
	Beep(1188, 250);
	Beep(1056, 250);
	Beep(990, 750);
	Beep(1056, 250);
	Beep(1188, 500);
	Beep(1320, 500);
	Beep(1056, 500);
	Beep(880, 500);
	Beep(880, 500);
	Sleep(250);
	Beep(1188, 500);
	Beep(1408, 250);
	Beep(1760, 500);
	Beep(1584, 250);
	Beep(1408, 250);
	Beep(1320, 750);
	Beep(1056, 250);
	Beep(1320, 500);
	Beep(1188, 250);
	Beep(1056, 250);
	Beep(990, 500);
	Beep(990, 250);
	Beep(1056, 250);
	Beep(1188, 500);
	Beep(1320, 500);
	Beep(1056, 500);
	Beep(880, 500);
	Beep(880, 500);
	Sleep(500);
	Beep(1320, 500);
	Beep(990, 250);
	Beep(1056, 250);
	Beep(1188, 250);
	Beep(1320, 125);
	Beep(1188, 125);
	Beep(1056, 250);
	Beep(990, 250);
	Beep(880, 500);
	Beep(880, 250);
	Beep(1056, 250);
	Beep(1320, 500);
	Beep(1188, 250);
	Beep(1056, 250);
	Beep(990, 750);
	Beep(1056, 250);
	Beep(1188, 500);
	Beep(1320, 500);
	Beep(1056, 500);
	Beep(880, 500);
	Beep(880, 500);
	Sleep(250);
	Beep(1188, 500);
	Beep(1408, 250);
	Beep(1760, 500);
	Beep(1584, 250);
	Beep(1408, 250);
	Beep(1320, 750);
	Beep(1056, 250);
	Beep(1320, 500);
	Beep(1188, 250);
	Beep(1056, 250);
	Beep(990, 500);
	Beep(990, 250);
	Beep(1056, 250);
	Beep(1188, 500);
	Beep(1320, 500);
	Beep(1056, 500);
	Beep(880, 500);
	Beep(880, 500);
	Sleep(500);
	Beep(660, 1000);
	Beep(528, 1000);
	Beep(594, 1000);
	Beep(495, 1000);
	Beep(528, 1000);
	Beep(440, 1000);
	Beep(419, 1000);
	Beep(495, 1000);
	Beep(660, 1000);
	Beep(528, 1000);
	Beep(594, 1000);
	Beep(495, 1000);
	Beep(528, 500);
	Beep(660, 500);
	Beep(880, 1000);
	Beep(838, 2000);
	Beep(660, 1000);
	Beep(528, 1000);
	Beep(594, 1000);
	Beep(495, 1000);
	Beep(528, 1000);
	Beep(440, 1000);
	Beep(419, 1000);
	Beep(495, 1000);
	Beep(660, 1000);
	Beep(528, 1000);
	Beep(594, 1000);
	Beep(495, 1000);
	Beep(528, 500);
	Beep(660, 500);
	Beep(880, 1000);
	Beep(838, 2000);
}
