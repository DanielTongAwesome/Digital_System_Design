/*
 * student_code.h
 *
 *  Created on: Mar 7, 2017
 *      Author: user
 */

#ifndef STUDENT_CODE_H_
#define STUDENT_CODE_H_
#include <system.h>
#include <io.h>
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
void handle_button_interrupts(void* context);
#else
void handle_lfsr_interrupts(void* context, alt_u32 id);
#endif

void init_lfsr_interrupt();



#endif /* STUDENT_CODE_H_ */
