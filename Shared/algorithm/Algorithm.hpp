#ifndef _ALGORITHM_H_GUARD_
#define _ALGORITHM_H_GUARD_

#include <stdint.h>
#include <stdbool.h>
#include "FIFO.hpp"
#include "kissfft/kiss_fftr.h"

#define FFT_SIZE 256    //FFT Size
#define SAMPLE_RATE 125 //Sample rate of the system
#define MIN_MOV_AVG 5   //Frequencies above x Hz need to be filtered with the moving average
#define FREQ_STEP_RATIO (float)SAMPLE_RATE/(float)FFT_SIZE
#define FFT_BORDER (float)MIN_MOV_AVG/((float)SAMPLE_RATE/(float)FFT_SIZE)

typedef struct Algorithm{
	float LastSample;
	uint16_t n;
	uint16_t d;
	uint16_t m;
	uint8_t z;
	FIFO * FIFO_n;
	FIFO * FIFO_d;
	FIFO * FIFO_m;
	float T;
	float X;
	float mu;
	float sigma;
	bool scalingThresholdMode;
	uint32_t Time;
	uint32_t TimeOut;
	uint32_t SampleNr;
	kiss_fftr_cfg FFT;
} Algorithm;

/**************************************************************************
 * n = number of samples in moving average, n == 0 means scaling mode
 * d = delay between moving average and standard deviation
 * m = number of samples in standard deviation
 * T = Sets the threshhold at T*sigma
 * scaleValue = factor to scale n with if sigma mode is set.
 **************************************************************************/
Algorithm * algorithmInit(uint16_t n, uint16_t d, uint16_t m, uint8_t z, float T);

/*add new sample and run algorithm*/
bool algorithmUpdate(Algorithm * This, float NewSample);

/* Delete algorithm, clean up memory, etc*/
void algorithmDelete(Algorithm * This);

/* reset algorithm for a new test case*/
void algorithmReset(Algorithm * This);

float algorithmGetX(Algorithm * This);
float algorithmGetMu(Algorithm * This);
float algorithmGetSigma(Algorithm * This);
uint32_t algorithmGetTime(Algorithm * This);
uint32_t algorithmGetTimeOut(Algorithm * This);
uint32_t algorithmGetM(Algorithm * This);
uint32_t algorithmGetN(Algorithm * This);
uint32_t algorithmGetD(Algorithm * This);
uint32_t algorithmGetZ(Algorithm * This);
float algorithmGetT(Algorithm * This);

void algorithmPrintStatus(Algorithm * This);

#endif
