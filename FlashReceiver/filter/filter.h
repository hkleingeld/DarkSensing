/*
 * filter.h
 *
 * Created: 26-1-2017 14:16:26
 *  Author: Hajo
 */ 

#ifndef _H_GUARD_FILTER_
#define _H_GUARD_FILTER_

void filter10_IRR(uint16_t * X);
void filter75_IRR(uint16_t * X);
void filter5_IRR(uint16_t * X);
void filterFIR(uint16_t * X);
void filter_CalculateStartupValues(uint16_t * X);

#endif
