/*
 * filter.c
 *
 * Created: 26-1-2017 14:16:10
 *  Author: Hajo
 */ 

#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <string.h>
#include "../features/Features.h"

/*-6db@ 500Hz @210kHz*/ 
float c0 = 0.032446209457407477;
float c1 = 0.15741030989609275;
float c2 = 0.31014348064649977;
float c3 = 0.31014348064649977;
float c4 = 0.15741030989609275;
float c5 = 0.032446209457407477;

float W0 = 2174; /*default W0 value for the dark room*/

#define numofsamples 50
void filter75_IRR(uint16_t * X){
	/*filter coefficients determined by MATLAB (1st ORDER IRR @250Khz with -3DB @10Khz)*/
	float a1 = -1.6848;
	float a2 = 0.7281;
	float b0 = 0.0108;
	float b1 = 0.0217;
	float b2 = 0.0108;
	
	uint16_t * Y = X;
	float W[numofsamples] = {0};
	//preset first value of W, this should improve settling time.
	W[0] = W0;
	W[1] = W0;	
	float Xn;
	uint16_t Yn;
	/*first order IRR filter. Coefficients are global*/
	for(uint16_t n = 2; n < numofsamples; n++){
		Xn = (float) X[n];
		W[n] = (Xn - a1 * W[n-1] - a2 * W[n-2]);
		Yn = (uint16_t) (b0 * W[n] + b1* W[n-1] + b2*W[n-2]); //as b0 == b1, this stage was simplefied
		Y[n-2] = Yn;
		/*note, this overwrites X[n-2], and can no longer be used*/
	}

	/* Stubbing final Y with previous value to keep an array of 100 values.*/
	Y[numofsamples-2] = Y[numofsamples-3];
	Y[numofsamples-1] = Y[numofsamples-2];
}

void filter5_IRR(uint16_t * X){
	/*filter coefficients determined by MATLAB (1st ORDER IRR @250Khz with -3DB @10Khz)*/
	float a1 = -1.7891;
	float a2 = 0.8093;
	float b0 = 0.0051;
	float b1 = 0.0101;
	float b2 = 0.0051;
	
	uint16_t * Y = X;
	float W[numofsamples] = {0};
	//preset first value of W, this should improve settling time.
	W[0] = W0;
	W[1] = W0;
	float Xn;
	uint16_t Yn;
	/*first order IRR filter. Coefficients are global*/
	for(uint16_t n = 2; n < numofsamples; n++){
		Xn = (float) X[n];
		W[n] = (Xn - a1 * W[n-1] - a2 * W[n-2]);
		Yn = (uint16_t) (b0 * W[n] + b1* W[n-1] + b2*W[n-2]); //as b0 == b1, this stage was simplefied
		Y[n-2] = Yn;
		/*note, this overwrites X[n-2], and can no longer be used*/
	}

	/* Stubbing final Y with previous value to keep an array of 100 values.*/
	Y[numofsamples-2] = Y[numofsamples-3];
	Y[numofsamples-1] = Y[numofsamples-2];
}

void filter10_IRR(uint16_t * X){
	/*filter coefficients determined by MATLAB (1st ORDER IRR @250Khz with -3DB @10Khz)*/
	float a1 = -1.8227;
	float a2 = 0.8372;
	float b0 = 0.0036;
	float b1 = 0.0072;
	float b2 = 0.0036;
	
	uint16_t * Y = X;
	float W[numofsamples] = {0};
	//preset first value of W, this should improve settling time.
	W[0] = W0;
	W[1] = W0;
	float Xn;
	uint16_t Yn;
	/*first order IRR filter. Coefficients are global*/
	for(uint16_t n = 2; n < numofsamples; n++){
		Xn = (float) X[n];
		W[n] = (Xn - a1 * W[n-1] - a2 * W[n-2]);
		Yn = (uint16_t) (b0 * W[n] + b1* W[n-1] + b2*W[n-2]); //as b0 == b1, this stage was simplefied
		Y[n-2] = Yn;
		/*note, this overwrites X[n-2], and can no longer be used*/
	}

	/* Stubbing final Y with previous value to keep an array of 100 values.*/
	Y[numofsamples-2] = Y[numofsamples-3];
	Y[numofsamples-1] = Y[numofsamples-2];
}

void filterFIR(uint16_t * X){
	uint16_t * Y = X;
	
	float x5 = 0;
	float x4 = 0;
	float x3 = 0;
	float x2 = 0;
	float x1 = 0;
	float x0;
	
	float y = 0;
	
	for(uint8_t i = 0; i < numofsamples; i++){
		x0 = X[i];
		y = x0*c0 + x1*c1 + x2*c2 + x3*c3 + x4*c4 + x5*c5;
		Y[i] = (uint16_t) y;
		x5 = x4;
		x4 = x3;
		x3 = x2;
		x2 = x1;
		x1 = x0;		
	}
}

void filter_CalculateStartupValues(uint16_t * X){
	//create copy, so the original wont be modified
	uint16_t Copy[40];
	memcpy(Copy,X,40);
	filter10_IRR(Copy);
	uint16_t avg = Average(20,&Copy[19]);
	
	W0 = avg;
}