#include "Algorithm.hpp"
#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <float.h>

#include "kissfft/kiss_fftr.h"
#include "FIFO.hpp"

#define MAX(a,b) ((a) > (b) ? (a) : (b))

/**************************************************************************
 * n = number of samples in moving average, n == 0 means scaling mode
 * d = delay between moving average and standard deviation
 * m = number of samples in standard deviation
 * T = Sets the threshhold at T*sigma
 **************************************************************************/
Algorithm * algorithmInit(uint16_t n, uint16_t d, uint16_t m, uint8_t z, float T){
    Algorithm * alg = (Algorithm *) malloc(sizeof(Algorithm));
    if(alg == NULL){
        return NULL;
    }

    if(n == 0){ //n == zero, means scaling n mode
        alg->FFT = kiss_fftr_alloc(FFT_SIZE,0,NULL,NULL);

        n = 1; //If ran in scaling threshold mode, we always start with n = 1;
        alg->scalingThresholdMode = true;

        //We later calculate the FFT or average over FIFO n with FFT_Size samples, and then set n accordingly.
        alg->FIFO_n = FIFOInit(FFT_SIZE,FIFO_USE_AVG);
    }
    else{
        alg->scalingThresholdMode = false;
        alg->FIFO_n = FIFOInit(n,FIFO_USE_AVG);
    }
    if((alg->FIFO_n == NULL)) return NULL;

    if(d != 0){
        alg->FIFO_d = FIFOInit(d,0);
        if(alg->FIFO_d == NULL) return NULL;
    }
    else{
        alg->FIFO_d = NULL;
    }

    if(m == 0){ //m can't be zero, then there is nothing to compare the latest samples with.
        m = 1;
        std::cout << "m == 0! Using m = 1 instead, please double check algorithm settings!!!";
    }
    alg->FIFO_m = FIFOInit(m,FIFO_USE_VAR);
    if((alg->FIFO_m == NULL))    return NULL;

    if(z < 1){
        z = 1;
    }

    //Save algorithm settings for later references
    alg->z = z;
    alg->n = n;
    alg->d = d;
    alg->m = m;
    alg->T = T;

    // Set base values for detection
    alg->mu = 2000;
    alg->sigma = 500;
    alg->X = 2000;
    alg->LastSample = 2000;

    // Init Timeout timer
    alg->Time = 0;
    alg->TimeOut = (FFT_SIZE+m+d);

    alg->SampleNr = 0;
    return alg;
}

static uint16_t Maximum(uint16_t size, float * array){
    uint16_t max = 0;
    uint16_t maxindex = 0;
    for(int i = 0; i < size ; i++){
        if(array[i] > max){
            max = array[i];
            maxindex = i;
        }
    }

    return(maxindex);
}

/* reset algorithm for a new test case*/
void algorithmReset(Algorithm * This){
    This->mu = 0;
    This->sigma = 3000;
    This->X = 0;

    This->Time = 0;


    FIFOReset(This->FIFO_n);
    if(This->scalingThresholdMode){
        This->n = 1;
    }

    FIFOReset(This->FIFO_m);

    if(This->d != 0)
        FIFOReset(This->FIFO_d);

    This->SampleNr = 0;
}

/* Delete algorithm, clean up memory, etc*/
void algorithmDelete(Algorithm * This){

    FIFODelete(This->FIFO_n);

    FIFODelete(This->FIFO_m);

    if(This->d){
        FIFODelete(This->FIFO_d);
    }

    if(This->scalingThresholdMode){
        kiss_fftr_free(This->FFT);
    }

    free(This);
    return;
}

static bool handleTimer(Algorithm * This, bool detection){
    if(detection){
        This->Time++;
        if(This->Time > (uint8_t) (This->z -1)){ //if z detections in a row
            This->Time = This->z;
            return true;
        }
    }
    else{
        if(This->Time > (uint8_t) (This->z -1)){
            This->Time++;
            if(This->Time > This->TimeOut){
                This->Time = 0;
            }
            return true;
        }
        This->Time = 0;
    }
    return false;
}

/*add new sample and run algorithm*/
bool algorithmUpdate(Algorithm * This, float NewSample){
    float S = NewSample;
    This->LastSample = NewSample;
    //Shift the FIFO Register
    This->SampleNr++;

    S = FIFOUpdate(This->FIFO_n,S);
    if(This->scalingThresholdMode){
        This->X = FIFOPartialAverage(This->FIFO_n, This->n);
    }
    else{
        This->X = FIFOAverage(This->FIFO_n);
    }
    S = This->X;


    if(This->d){ //it is possible that there is no delay, thus might have to be skipped.
        S = FIFOUpdate(This->FIFO_d,S);
    }

    S = FIFOUpdate(This->FIFO_m,S);

    if(This->SampleNr < (uint16_t)(This->m + This->d + FFT_SIZE)){
        return false; // we are still in init mode
    }

    //Calculate average over m
    This->mu = FIFOAverage(This->FIFO_m);
    S = This->mu;

    //Calculate deviation over m
    float varriance = FIFOVariance(This->FIFO_m);
    This->sigma = MAX(sqrt(varriance),0.1);

    float Threshold = This->T * This->sigma;

    if(This->scalingThresholdMode){
        if(This->SampleNr % FFT_SIZE == 0){
            kiss_fft_cpx fftResult[FFT_SIZE/2 + 1];

            float fArray[512];
            for(int i = 0; i < FFT_SIZE; i++){
                fArray[i] = This->FIFO_n->Array[i];
            }

            kiss_fftr(This->FFT, fArray, fftResult);
            for(int i = 1; i < FFT_SIZE/2 + 1; i++){
                fArray[i] = sqrt(pow(fftResult[i].i,2) + pow(fftResult[i].r,2));
            }

            uint16_t maxIndex = Maximum(FFT_SIZE/2 - 9,&fArray[10]) + 10;
            if(maxIndex > FFT_BORDER){
                if(fArray[maxIndex] > 10){
                    This->n = (uint16_t) roundf(FREQ_STEP_RATIO * maxIndex);
                }
                else{
                    This->n = 1;
                }
            }
        }
    }
    else{
        Threshold = (This->T * This->sigma);
    }

    //Detection?
    if(fabs(This->mu - This->X) > Threshold){
        return handleTimer(This, true);
    }
    else{
        return handleTimer(This, false);
    }
}

float algorithmGetX(Algorithm * This){
    return This->X;
}

float algorithmGetT(Algorithm * This){
    return This->T;
}

float algorithmGetMu(Algorithm * This){
    return This->mu;
}

float algorithmGetSigma(Algorithm * This){
    return This->sigma;
}

uint32_t algorithmGetTime(Algorithm * This){
    return This->Time;
}

uint32_t algorithmGetTimeOut(Algorithm * This){
    return This->TimeOut;
}

uint32_t algorithmGetM(Algorithm * This){
    return This->m;
}

uint32_t algorithmGetN(Algorithm * This){
    return This->n;
}

uint32_t algorithmGetD(Algorithm * This){
    return This->d;
}

uint32_t algorithmGetZ(Algorithm * This){
    return This->z;
}


void algorithmPrintStatus(Algorithm * This){

    printf("                +----------------+         +------------------------------+\n");
    printf("                |      FIFO      |         |            FIFO              |\n");
    printf("Filtered sample |       n        |         |        d           m         |\n");
    printf("  %-6.2f        |  +----------+  |    X    |  +-----------+-----------+   |\n", This->LastSample);
    printf("----------------|->|   %-6.0d +--|---------|->|   %-7.0d |   %-7.0d +   |\n",This->n, This->d, This->m);
    printf("                |  +----------+  |         |  +-----------+-----------+   |\n");
    printf("                +-------|--------+         +-----------------|------------+\n");
    printf("                        |                                    |             \n");
    printf("                        |                                    | sigma = % .2f  \n", This->sigma);
    printf("                        |                                    | mu    = % .2f  \n", This->mu);
    printf("                        |                                    v             \n");
    printf("                        |                      +--------------------------+\n");
    printf("                        |                      |  %-8.1f  1             |\n", fabs(This->mu - This->X));
    printf("                        | X = %-6.1f           | --------*------ = %-6.4f |\n", This->X,fabs(This->mu - This->X)/This->sigma * (1/This->T));
    printf("                        |--------------------->|  %-6.1f   %-4.1f           |\n", This->sigma, This->T);
    printf("                                               +--------------------------+\n");
    printf("                                               Time   : %-5d\n",This->Time);
    printf("                                               Timeout: %d\n",This->TimeOut);
}
