/*************************************************************************
 * Copyright (c) 2004 Altera Corporation, San Jose, California, USA.      *
 * All rights reserved. All use of this software and documentation is     *
 * subject to the License Agreement located at the end of this file below.*
 **************************************************************************
 * Description:                                                           *
 * The following is a simple hello world program running MicroC/OS-II.The *
 * purpose of the design is to be a very simple application that just     *
 * demonstrates MicroC/OS-II running on NIOS II.The design doesn't account*
 * for issues such as checking system call return codes. etc.             *
 *                                                                        *
 * Requirements:                                                          *
 *   -Supported Example Hardware Platforms                                *
 *     Standard                                                           *
 *     Full Featured                                                      *
 *     Low Cost                                                           *
 *   -Supported Development Boards                                        *
 *     Nios II Development Board, Stratix II Edition                      *
 *     Nios Development Board, Stratix Professional Edition               *
 *     Nios Development Board, Stratix Edition                            *
 *     Nios Development Board, Cyclone Edition                            *
 *   -System Library Settings                                             *
 *     RTOS Type - MicroC/OS-II                                           *
 *     Periodic System Timer                                              *
 *   -Know Issues                                                         *
 *     If this design is run on the ISS, terminal output will take several*
 *     minutes per iteration.                                             *
 **************************************************************************/

#include <stdio.h>
#include "includes.h"
#include <stdlib.h>
#include <system.h>
#include "io.h"

#include "./drivers/drivers.h"

//VIDEO and GRAPS
#include "vip_fr.h"
#include "./graphic_lib/simple_graphics.h"
#include "./graphic_lib/gimp_bmp.h"
#include "./graphic_lib/draw_gimps.h"
//OS

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
#define FREQ_READER_INCREMENT (100)
#define FREQ_READER_NOMINAL (44000)
#define FREQ_READER_MAX (2*FREQ_READER_NOMINAL)


OS_STK task1_stk[TASK_STACKSIZE];
OS_STK task2_stk[TASK_STACKSIZE];
OS_STK task3_stk[TASK_STACKSIZE];
OS_STK task4_stk[TASK_STACKSIZE];
OS_STK task5_stk[TASK_STACKSIZE];
OS_STK task6_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2
#define TASK3_PRIORITY      3
#define TASK4_PRIORITY      4
#define TASK5_PRIORITY      5
#define TASK6_PRIORITY      6

//tasks
void task1(void* pdata);
void task2(void* pdata);

//video
VIP_FRAME_READER *SW_Frame;

//IMAGENES GUARDADAS Y LEIDAS POR SOFWTARE
extern struct gimp_image_struct back_down;
extern struct gimp_image_struct back_up;
extern struct gimp_image_struct ford_up;
extern struct gimp_image_struct ford_down;
extern struct gimp_image_struct pause_up;
extern struct gimp_image_struct pause_down;
extern struct gimp_image_struct ford_down;
extern struct gimp_image_struct play_down;
extern struct gimp_image_struct play_up;
extern struct gimp_image_struct stop_down;
extern struct gimp_image_struct stop_up;

extern unsigned char song[];
extern unsigned int size_song;
// VARIABLES GLOBALES DE BOTONES
unsigned char buttons_control1[12];
unsigned char buttons_control2[12];

void draw_button(int x, int y, int w, int h, int color, char * text,
		char event_type, alt_video_display* display) {

	vid_draw_box(x, y, x + w, y + h, BLACK_24, DO_FILL, display);
	vid_draw_box(x, y, x + w, y + h, event_type ? ~color : color, DO_FILL,
			display);
	vid_print_string_alpha(x + w / 4, y + h / 8, WHITE_24,
			event_type ? ~color : color, tahomabold_20, display, text);

}

void init_background() { // INIT BACKGROUND

	//Clean screen
	vid_clean_screen(SW_Frame, BLACK_24);

	//Init Images
	DispIMAGE_from_gimp(SW_Frame, &play_up, 296, 45, BLACK_24);
	DispIMAGE_from_gimp(SW_Frame, &stop_up, 404, 45, BLACK_24);
	DispIMAGE_from_gimp(SW_Frame, &pause_up, 523, 45, BLACK_24);
	DispIMAGE_from_gimp(SW_Frame, &back_up, 333, 177, BLACK_24);
	DispIMAGE_from_gimp(SW_Frame, &ford_up, 512, 177, BLACK_24);

	//init lines
	vid_draw_line(652, 234, 800, 234, 4, WHITE_24, SW_Frame);
	vid_draw_line(0, 407, 800, 407, 4, WHITE_24, SW_Frame);
	vid_draw_line(0, 598, 800, 598, 4, WHITE_24, SW_Frame);
	vid_draw_line(647, 0, 647, 600, 4, WHITE_24, SW_Frame);
	vid_draw_line(795, 0, 795, 600, 4, WHITE_24, SW_Frame);
	vid_draw_line(261, 0, 261, 262, 4, WHITE_24, SW_Frame);
	vid_draw_line(261, 262, 647, 262, 4, WHITE_24, SW_Frame);
	vid_draw_line(261, 0, 800, 0, 4, WHITE_24, SW_Frame);

	draw_button(667, 252, 120, 35, 0x0066CC, "ASK", 1, SW_Frame);
	draw_button(667, 289, 120, 35, 0x0066CC, "FSK", 0, SW_Frame);
	draw_button(667, 326, 120, 35, 0x0066CC, "BPSK", 0, SW_Frame);
	draw_button(667, 365, 120, 35, 0x0066CC, "LFSR", 0, SW_Frame);

	draw_button(667, 426, 120, 35, 0xCC6600, "SINE", 0, SW_Frame);
	draw_button(667, 470, 120, 35, 0xCC6600, "COS", 0, SW_Frame);
	draw_button(667, 512, 120, 35, 0xCC6600, "SAW", 0, SW_Frame);
	draw_button(667, 554, 120, 35, 0xCC6600, "SQUARE", 1, SW_Frame);

}

/*Read song from EPCS, and send it to the FIFO*/
#define MAX_ADDRESS 524287
#define NUMERO_DE_MUESTRAS 1000 // mini buffervoid send_audio_fifo(unsigned char *buf) {int i;for (i = 0; i < NUMERO_DE_MUESTRAS; i++) {while (audio_dac_fifo_full() == 1);audio_dac_wr_fifo( buf[i % size_song]);
}

}

unsigned char play_song = 0;
unsigned char pause_song = 0;
unsigned char stop_song = 0;


int freq_reader = FREQ_READER_NOMINAL;

/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata) // ANIMATION BY SOFTWARE TASK
{
int address_counter = 0;
set_audio_frequency_audio_controller(freq_reader);
while (1) {

if (play_song == 1) {

	send_audio_fifo(&song[address_counter % size_song]);
	if (address_counter < size_song) {
		address_counter += NUMERO_DE_MUESTRAS;

	} else {
		address_counter = 0;
	}
} else if (pause_song == 1) {

} else if (stop_song == 1) {
	address_counter = 0;
}
OSTimeDlyHMSM(0, 0, 0, 10);
}

}

/*refresh buttons states, and actions*/
void task2(void* pdata) {

int x_mouse, y_mouse;
unsigned char event;

while (1) {
event = mouse_pos(&x_mouse, &y_mouse);

if (event == 1) {	//down event


	//Logic for the modulation buttons
	if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 252
			&& y_mouse <= (252 + 35)) {
		draw_button(667, 252, 120, 35, 0x0066CC, "ASK", 1, SW_Frame);
		draw_button(667, 289, 120, 35, 0x0066CC, "FSK", 0, SW_Frame);
		draw_button(667, 326, 120, 35, 0x0066CC, "BPSK", 0, SW_Frame);
		draw_button(667, 365, 120, 35, 0x0066CC, "LFSR", 0, SW_Frame);

		select_modulation(0);
	}

	else if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 289
			&& y_mouse <= (289 + 35)) {
		draw_button(667, 252, 120, 35, 0x0066CC, "ASK", 0, SW_Frame);
		draw_button(667, 289, 120, 35, 0x0066CC, "FSK", 1, SW_Frame);
		draw_button(667, 326, 120, 35, 0x0066CC, "BPSK", 0, SW_Frame);
		draw_button(667, 365, 120, 35, 0x0066CC, "LFSR", 0, SW_Frame);

		select_modulation(1);
	} else if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 326
			&& y_mouse <= (326 + 35)) {
		draw_button(667, 252, 120, 35, 0x0066CC, "ASK", 0, SW_Frame);
		draw_button(667, 289, 120, 35, 0x0066CC, "FSK", 0, SW_Frame);
		draw_button(667, 326, 120, 35, 0x0066CC, "BPSK", 1, SW_Frame);
		draw_button(667, 365, 120, 35, 0x0066CC, "LFSR", 0, SW_Frame);

		select_modulation(2);
	} else if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 365
			&& y_mouse <= (365 + 35)) {
		draw_button(667, 252, 120, 35, 0x0066CC, "ASK", 0, SW_Frame);
		draw_button(667, 289, 120, 35, 0x0066CC, "FSK", 0, SW_Frame);
		draw_button(667, 326, 120, 35, 0x0066CC, "BPSK", 0, SW_Frame);
		draw_button(667, 365, 120, 35, 0x0066CC, "LFSR", 1, SW_Frame);

		select_modulation(3);
	}

	//Logic for the signal selector buttons
	if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 426
			&& y_mouse <= (426 + 35)) {
		draw_button(667, 426, 120, 35, 0xCC6600, "SINE", 1, SW_Frame);
		draw_button(667, 470, 120, 35, 0xCC6600, "COS", 0, SW_Frame);
		draw_button(667, 512, 120, 35, 0xCC6600, "SAW", 0, SW_Frame);
		draw_button(667, 554, 120, 35, 0xCC6600, "SQUARE", 0, SW_Frame);

		select_signal(0);
	}

	else if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 470
			&& y_mouse <= (470 + 35)) {
		draw_button(667, 426, 120, 35, 0xCC6600, "SINE", 0, SW_Frame);
		draw_button(667, 470, 120, 35, 0xCC6600, "COS", 1, SW_Frame);
		draw_button(667, 512, 120, 35, 0xCC6600, "SAW", 0, SW_Frame);
		draw_button(667, 554, 120, 35, 0xCC6600, "SQUARE", 0, SW_Frame);

		select_signal(1);
	} else if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 512
			&& y_mouse <= (512 + 35)) {
		draw_button(667, 426, 120, 35, 0xCC6600, "SINE", 0, SW_Frame);
		draw_button(667, 470, 120, 35, 0xCC6600, "COS", 0, SW_Frame);
		draw_button(667, 512, 120, 35, 0xCC6600, "SAW", 1, SW_Frame);
		draw_button(667, 554, 120, 35, 0xCC6600, "SQUARE", 0, SW_Frame);

		select_signal(2);
	} else if (x_mouse >= 667 && x_mouse <= (667 + 120) && y_mouse >= 554
			&& y_mouse <= (554 + 35)) {
		draw_button(667, 426, 120, 35, 0xCC6600, "SINE", 0, SW_Frame);
		draw_button(667, 470, 120, 35, 0xCC6600, "COS", 0, SW_Frame);
		draw_button(667, 512, 120, 35, 0xCC6600, "SAW", 0, SW_Frame);
		draw_button(667, 554, 120, 35, 0xCC6600, "SQUARE", 1, SW_Frame);

		select_signal(3);
	}

	//play song buttons
	if (x_mouse >= 296 && x_mouse <= (296 + play_up.width) && y_mouse >= 45
			&& y_mouse <= (45 + play_up.height)) {
		DispIMAGE_from_gimp(SW_Frame, &play_down, 296, 45,
		BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &stop_up, 404, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &pause_up, 523, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &back_up, 333, 177, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &ford_up, 512, 177, BLACK_24);

		play_song = 1;
		pause_song = 0;
		stop_song = 0;

	} else if (x_mouse >= 404 && x_mouse <= (404 + stop_down.width)
			&& y_mouse >= 45 && y_mouse <= (45 + stop_down.height)) {
		DispIMAGE_from_gimp(SW_Frame, &play_up, 296, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &stop_down, 404, 45,
		BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &pause_up, 523, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &back_up, 333, 177, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &ford_up, 512, 177, BLACK_24);

		play_song = 0;
		pause_song = 0;
		stop_song = 1;
	} else if (x_mouse >= 523 && x_mouse <= (523 + pause_down.width)
			&& y_mouse >= 45 && y_mouse <= (45 + pause_down.height)) {
		DispIMAGE_from_gimp(SW_Frame, &play_up, 296, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &stop_up, 404, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &pause_down, 523, 45,
		BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &back_up, 333, 177, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &ford_up, 512, 177, BLACK_24);

		play_song = 0;
		pause_song = 1;
		stop_song = 0;
	} else if (x_mouse >= 333 && x_mouse <= (333 + back_up.width)
			&& y_mouse >= 177 && y_mouse <= (177 + back_up.height)) {
		DispIMAGE_from_gimp(SW_Frame, &play_up, 296, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &stop_up, 404, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &pause_up, 523, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &back_down, 333, 177,
		BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &ford_up, 512, 177, BLACK_24);

		freq_reader -= FREQ_READER_INCREMENT;
		if (freq_reader < FREQ_READER_INCREMENT) {
			freq_reader = FREQ_READER_INCREMENT;
		}
		set_audio_frequency_audio_controller(freq_reader);
	} else if (x_mouse >= 512 && x_mouse <= (512 + ford_down.width)
			&& y_mouse >= 177 && y_mouse <= (177 + ford_down.height)) {
		DispIMAGE_from_gimp(SW_Frame, &play_up, 296, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &stop_up, 404, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &pause_up, 523, 45, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &back_up, 333, 177, BLACK_24);
		DispIMAGE_from_gimp(SW_Frame, &ford_down, 512, 177,
		BLACK_24);

		freq_reader += FREQ_READER_INCREMENT;
		if (freq_reader > FREQ_READER_MAX) {
			freq_reader = FREQ_READER_MAX;
		}
		set_audio_frequency_audio_controller(freq_reader);
	}
}

OSTimeDlyHMSM(0, 0, 0, 100);
}

}

/* The main function creates two task and starts multi-tasking */
int main(void) {
//Init video
init_lfsr_interrupt();
SW_Frame = VIPFR_Init(VGA_ALT_VIP_VFR_0_BASE, (void *) FR_FRAME_0,
	(void *) FR_FRAME_0, FRAME_WIDTH, FRAME_HEIGHT);
VIPFR_Go(SW_Frame, TRUE);
VIPFR_ActiveDrawFrame(SW_Frame);

//Draw background images, and start the desktop
init_background();

//init hw
//default audio channel
audio_selector(1);
//init selectors
select_modulation(0);
select_signal(3);

//task song
OSTaskCreateExt(task1,
NULL, (void *) &task1_stk[TASK_STACKSIZE - 1],
TASK1_PRIORITY,
TASK1_PRIORITY, task1_stk,
TASK_STACKSIZE,
NULL, 0);

//events and graphics refreshing
OSTaskCreateExt(task2,
NULL, (void *) &task2_stk[TASK_STACKSIZE - 1],
TASK2_PRIORITY,
TASK2_PRIORITY, task2_stk,
TASK_STACKSIZE,
NULL, 0);

OSStart();

while (1) {
}

return 0;
}
