#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <float.h>
#include <math.h>

#include "FIFO.hpp"


float FIFOUpdate(FIFO * This, float newSample){
	float oldSample = This->Array[This->index];
	This->Array[This->index] = newSample;
	This->index++;
	if(This->index == This->size){
		This->index = 0;
		This->FIFOFull = true;
	}

	if(This->needAvg||This->needVar){
		double oldavg = This->avg;
		This->avg = oldavg + (newSample - oldSample) / This->size;
		if(This->needVar){
			This->var += (newSample - oldSample) * (newSample - This->avg + oldSample - oldavg) / (This->size-1);
		}
	}

	return oldSample;
}

void FIFOReset(FIFO * This){
	This->index = 0;

	/*memset for floats*/
	for(uint16_t i = 0; i < This->size; i++){
		This->Array[i] = 0;
	}

	This->FIFOFull = false;

	This->sum = 0;
	This->squaredSum = 0;
	This->avg = 0;
	This->var = 0;
}

float FIFOSum(FIFO * This){
	float sum = 0;

	for(uint16_t i = 0; i < This->size; i++){
		sum += This->Array[i];
	}

	return sum;
}

float FIFOPartialSum(FIFO * This, uint16_t n) {
	uint16_t tempindex = This->index;
	float partialSum = 0;

	for(int i = 0; i < n; i++){
		partialSum += This->Array[tempindex];
		if(tempindex == 0){
			tempindex = This->size;
		}
		tempindex --;
	}

	return(partialSum);
}

float FIFOSquaredSum(FIFO * This){
	uint16_t i;
	float squaredSum = 0;

	for(i = 0; i < This->size; i++){
		squaredSum += pow(This->Array[i],2);
	}

	return squaredSum;
}

float FIFOAverage(FIFO * This){
	return This->avg;
}

float FIFOPartialAverage(FIFO * This, uint16_t n){
	return FIFOPartialSum(This,n)/n;
}

float FIFOVariance(FIFO * This){
	return This->var;
}

FIFO * FIFOInit(uint16_t size, uint8_t options){
	FIFO * F = (FIFO *) malloc(sizeof(FIFO));
	if(F == NULL) return NULL;

	F-> Array = (float *) malloc(sizeof(float) * size);
	if(F == NULL) return NULL;

	/*memset for floats*/
	for(uint16_t i = 0; i < size; i++){
		F->Array[i] = 0;
	}

	F->size = size;
	F->index = 0;

	F->sum = 0;
	F->squaredSum = 0;
	F->avg = 0;
	F->var = 0;

	if(options & FIFO_USE_AVG){
		F->needAvg = true;
	}
	else{
		F->needAvg = false;
	}

	if(options & FIFO_USE_VAR){
		F->needVar = true;
	}
	else{
		F->needVar = false;
	}

	return(F);
}

void FIFODelete(FIFO * This){
	free(This->Array);
	free(This);
}

