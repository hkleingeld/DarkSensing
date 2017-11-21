/*
 * Main.c
 *
 * Created: 19-11-2014 9:52:57
 *  Author: Lennart Klaver
 */ 
/************************************************************************/
/* LIBRARIES                                                            */
/************************************************************************/
#include "main.h"
#include <stdbool.h>
#include "features/Features.h"
#include "filter/filter.h"
#include "features/StandardDeviation.h"
#include <math.h>
#include <limits.h>
#include <string.h>

/************************************************************************/
/* DEFINITIONS                                                          */
/************************************************************************/
#define NR_OF_SAMPLES 50
#define SIZE_INPUTBUFFER 100
#define SIGMA 4
uint8_t AVG_SAMPLES = 1;


typedef enum state {RESET, LIGHT_INIT, NORMAL_OPERATION} State;
State currentState = RESET;
State nextState = RESET;
/************************************************************************/
/* VARIABLES                                                            */
/************************************************************************/

uint16_t samples[NR_OF_SAMPLES];
uint16_t inputBuffer[SIZE_INPUTBUFFER] = {0};
uint8_t indexinputBuffer = 0;

uint16_t addToBuffer(uint16_t new){
	uint16_t retval = inputBuffer[indexinputBuffer];
	inputBuffer[indexinputBuffer] = new;
	indexinputBuffer++;
	if(indexinputBuffer == SIZE_INPUTBUFFER){
		indexinputBuffer = 0;
	}
	return retval;
}

float calcAvg(void){
	uint64_t tempsum = 0;
	if(indexinputBuffer > AVG_SAMPLES){
		for(int i = 1; i < AVG_SAMPLES+1; i++){
			tempsum += inputBuffer[indexinputBuffer-i];
		}
		return (float) (tempsum/AVG_SAMPLES);
	}
	
	for(int i = 1; i < indexinputBuffer+1; i++){
		tempsum += inputBuffer[indexinputBuffer-i];
	}
	
	for(int i = 0; i < AVG_SAMPLES - indexinputBuffer; i++){
		tempsum += inputBuffer[SIZE_INPUTBUFFER-i-1];
	}
	return (float) (tempsum/AVG_SAMPLES);
}

char itoabuffer[20] = {0};
volatile uint8_t kick = 0;

extern volatile uint8_t ADC_select;
extern volatile uint8_t MODE;

#define SYNCPIN 0x02
void LightOnSync(void){
	while((PINC & SYNCPIN) == SYNCPIN); /*Wait until sync pin is low*/
	while((PINC & SYNCPIN) == 0x00); /*Wait until sync pin is High - The light will turn very soon :)*/
}

void LightOffSync(void){
	while((PINC & SYNCPIN) == 0x00); /*Wait until sync pin is High*/
	while((PINC & SYNCPIN) == SYNCPIN); /*Wait until sync pin is low - The light has now turned off, and will be off until next cycle*/
}

void Error(const char * error_msg){
	uart_write_string("\nCritical Error: ");
	uart_write_string(error_msg);

	while(1); //something went horribly wrong. Perma wait to avoid any damage :O!
}

/************************************************************************/
/* FUNCTIONS                                                            */
/************************************************************************/
int main(void)
{
	ADC_select = 2;
	uint8_t adc = ADC_select;
	int i = 0;
	uint32_t miscCounter = 0;

	bool objDetLight = false;

	bool darkSample = false;
	uint8_t SamplesTaken = 0;
	
	stdDev * lightMaxStdDev;

	uint16_t lastDeviation = 1000; /*std of 1000, is way too much of course :)*/
	/************************************************************************/
	//darkMaxStdDev = StdDev_Init();
	lightMaxStdDev = StdDev_Init();
	
	if(lightMaxStdDev == NULL){
		Error("malloc of stddev failed"); /*malloc of stddev did somehow fail :'( */
	}
	
	//timer1_init();	// Set up Timer 1.
	spi_init();			// Set up SPI.
	spi_gpio_init();	// Set up GPIO.
	uart_init();		// Set up UART.
	
	transmitter_init();	// Set up the transmitter.
	receiver_init();	// Set up the receiver.
	
	spi_gpio_test();	// Test GPIO.
		
	sei();	// Enable global interrupts.
	
	//TODO: full self test.
	
	uart_write('O');	// Test UART.
	uart_write('K');
	uart_write('\n');
	/************************************************************************/
	
	receiver_measure();		// Do a medium measurement.
	receiver_reset();		// Reset the receiver.
	/************************************************************************/
	

	while(1){
		switch(ADC_select){ /*PD select, This ensures the selection cant change during sampling*/
			case 1: adc = 1; break;
			case 2: adc = 2; break;
			case 3: adc = 3; break;
			case 4: adc = 4; break;
			default: adc = 0; break;
		}
		LightOnSync(); /*sync*/
		i = 0;
		if(darkSample){
			LightOffSync(); /*Wait until sync pin is low (light is turned off)*/
			_delay_ms(1); // Just to be sure the light is actually off
		}
		do{ /*sample*/
			switch(adc){
				case 1: samples[i] = spi_adc_read(ADC_CHANNEL1); break;
				case 2: samples[i] = spi_adc_read(ADC_CHANNEL2); break;
				case 3: samples[i] = spi_adc_read(ADC_CHANNEL3); break;
				case 4: samples[i] = spi_adc_read(ADC_CHANNEL4); break;
				default: break;
			}
			i++;
		} while(i < NR_OF_SAMPLES);

		SamplesTaken++;
		if(MODE){
			for(int i = 0; i< NR_OF_SAMPLES;i++){
				uart_write_string(itoa(samples[i],itoabuffer,10));
				uart_write(',');
				while(UCSR0B & (1 << UDRIE0));
			}
			uart_write('\n');
		}
		else{ 
			uint16_t Unfiltered_max = Maximum(40, &samples[0]);
			uint64_t sum = Sum(40, &samples[0]);
			
			if(adc == 2){
				filter75_IRR(&samples[0]);
			}
			else{
				filter10_IRR(&samples[0]);
			}

			uint16_t max = Maximum(NR_OF_SAMPLES, &samples[0]);
			uint64_t filteredSum = Sum(40, &samples[0]);
			
			uart_write_string(itoa(max,itoabuffer,10));
			uart_write(',');
			uart_write_string(itoa(Unfiltered_max,itoabuffer,10));
			uart_write(',');
			uart_write_string(ltoa(sum,itoabuffer,10));
			uart_write('\n');
			uart_write_string(ltoa(filteredSum,itoabuffer,10));
			uart_write('\n');
		}

		while(UCSR0B & (1 << UDRIE0)); /*wait until  data ready interrupt is turned off (aka, we are done sending data)*/
	}
/************************************************************************/
}

/************************************************************************/
/* INTERRUPT SERVICE ROUTINES                                           */
/************************************************************************/
/**
 * ISR for compare interrupt of Timer 1 (16-bit timer).
 */
ISR(TIMER1_COMPA_vect) {
	kick++;
}