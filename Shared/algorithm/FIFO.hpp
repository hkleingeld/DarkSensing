#ifndef _FIFO_H_GUARD_
#define _FIFO_H_GUARD_

#include <stdint.h>

typedef struct FIFO{
	uint16_t size;
	uint16_t index;
	float * Array;

	bool updateSum;
	bool updateSquaredSum;

	float sum;
	float squaredSum;
} FIFO;

float FIFOUpdate(FIFO * This, float newSample);
float FIFOSum(FIFO * This);
float FIFOAverage(FIFO * This);
float FIFOPartialAverage(FIFO * This, uint16_t n);
float FIFOVariance(FIFO * This, float mean);

FIFO * FIFOInit(uint16_t size);
void FIFODelete(FIFO * This);
void FIFOReset(FIFO * This);

#endif
