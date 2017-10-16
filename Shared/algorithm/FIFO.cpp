#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <float.h>
#include <math.h>

#include "FIFO.hpp"

static void updateSum(FIFO * This, float newSample, float oldSample){
	This->sum = This->sum - oldSample + newSample;
}

static void updateSquaredSum(FIFO * This, float newSample, float oldSample){
	This->squaredSum = This->squaredSum - pow(oldSample,2) + pow(newSample,2);
}

float FIFOUpdate(FIFO * This, float newSample){
	float retval = This->Array[This->index];
	This->Array[This->index] = newSample;
	This->index++;
	if(This->index == This->size){
		This->index = 0;
	}

	if(This->updateSum == true){
		updateSum(This, newSample, retval);
	}

	if(This->updateSquaredSum == true){
		updateSquaredSum(This, newSample, retval);
	}

	return retval;
}

void FIFOReset(FIFO * This){
	This->index = 0;

	/*memset for floats*/
	for(uint16_t i = 0; i < This->size; i++){
		This->Array[i] = 99999;
	}

	This->updateSum = false;
	This->sum = 0;

	This->updateSquaredSum = false;
	This->squaredSum = 0;
}

float FIFOSum(FIFO * This){
	float sum = 0;
	if(This->updateSum){
		return This->sum;
	}

	for(uint16_t i = 0; i < This->size; i++){
		sum += This->Array[i];
	}

	This->sum = sum;
	This->updateSum = true;
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

	if(This->updateSquaredSum){
		return This->squaredSum;
	}

	for(i = 0; i < This->size; i++){
		squaredSum += pow(This->Array[i],2);
	}

	This->squaredSum = squaredSum;
	This->updateSquaredSum = true;
	return squaredSum;
}

float FIFOAverage(FIFO * This){
	return ((float) FIFOSum(This) / (float) This->size);
}

float FIFOPartialAverage(FIFO * This, uint16_t n){
	return FIFOPartialSum(This,n)/n;
}

float FIFOVariance(FIFO * This, float mean){
// Old method
//	for(i = 0; i < This->size; i++){
//		variance += pow((float) This->Array[i] - mean,2);
//	}
	float sqSum = FIFOSquaredSum(This);
	float sum = FIFOSum(This);

	float devisor = (This->size*(This->size-1));
	// New method
	//https://www.johndcook.com/blog/2008/09/26/comparing-three-methods-of-computing-standard-deviation/
	return ((float) (This->size * sqSum - pow(sum,2))) / (devisor);
}

FIFO * FIFOInit(uint16_t size){
	FIFO * F = (FIFO *) malloc(sizeof(FIFO));
	if(F == NULL) return NULL;

	F-> Array = (float *) malloc(sizeof(float) * size);
	if(F == NULL) return NULL;

	/*memset for floats*/
	for(uint16_t i = 0; i < size; i++){
		F->Array[i] = 99999;
	}

	F->size = size;
	F->index = 0;

	F->updateSum = false;
	F->updateSquaredSum = false;

	F->sum = 0;
	F->squaredSum = 0;

	return(F);
}

void FIFODelete(FIFO * This){
	free(This->Array);
	free(This);
}

