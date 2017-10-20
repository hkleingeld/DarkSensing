#ifndef _FIFO_H_GUARD_
#define _FIFO_H_GUARD_

#include <stdint.h>

#define FIFO_USE_AVG 0x01
#define FIFO_USE_VAR 0x02

typedef struct FIFO{
	uint16_t size;
	uint16_t index;
	float * Array;

	bool FIFOFull;
	bool needAvg;
	bool needVar;

	float sum;
	float squaredSum;
	double avg;
	double var;
} FIFO;

float FIFOUpdate(FIFO * This, float newSample);

float FIFOPartialAverage(FIFO * This, uint16_t n);

float FIFOVariance(FIFO * This);
float FIFOSum(FIFO * This);
float FIFOAverage(FIFO * This);

FIFO * FIFOInit(uint16_t size, uint8_t options);
void FIFODelete(FIFO * This);
void FIFOReset(FIFO * This);

#endif
