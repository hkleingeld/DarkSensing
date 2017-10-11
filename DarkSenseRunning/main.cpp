//============================================================================
// Name        : DarkSenseDataGatherer.cpp
// Author      : Hajo Kleingeld
// Version     :
// Copyright   :
// Description : Hello World in C++, Ansi-style
//============================================================================


#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;

#include <windows.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>


#include "../Shared/Comm/comm.hpp"
#include "../Shared/Filters/IRR_Filter.hpp"
#include "../Shared/Filters/FIR_Filter.hpp"
#include "../Shared/algorithm/Algorithm.hpp"

#define TIMEOUT 10000
#define DONT_CARE 0

void GoToXY(int column, int line)
{
    // Create a COORD structure and fill in its members.
    // This specifies the new position of the cursor that we will set.
    COORD coord;
    coord.X = column;
    coord.Y = line;

    // Obtain a handle to the console screen buffer.
    // (You're just using the standard console, so you can use STD_OUTPUT_HANDLE
    // in conjunction with the GetStdHandle() to retrieve the handle.)
    // Note that because it is a standard handle, we don't need to close it.
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

    // Finally, call the SetConsoleCursorPosition function.
    if (!SetConsoleCursorPosition(hConsole, coord))
    {
        // Uh-oh! The function call failed, so you need to handle the error.
        // You can call GetLastError() to get a more specific error code.
        // ...
    }
}

uint8_t ShineReceiveBuffer[20] = {0};

HANDLE Arduino;
HANDLE Shine;
ofstream myfile;


uint8_t BlinkCommand[7] = 		{0xC0, 0x03, 0x20, 0x00, 0x0E, 0x01, 0xC0}; //high% dc
uint8_t BlinkCommandDetect[7] = {0xC0, 0x03, 0x20, 0x00, 0x0E, 0x01, 0xC0};  //2% dc
uint8_t sendListenCommand[1] =  {0x02};

void sendBlinkCommand(uint8_t * msg){
	int BytesSend = 0;
	while(BytesSend != 7){
		BytesSend += SendData(&Arduino, msg, 7-BytesSend);
	}
}

uint8_t currMode = 10; // 0 = detect mode, 1 = illumination mode
void LightDetectMode(void){
	if(currMode != 0){
		sendBlinkCommand(BlinkCommandDetect);
		currMode = 0;
	}
}

void LightIlluminationMode(void){
	if(currMode != 1){
		sendBlinkCommand(BlinkCommand);
		currMode = 1;
	}
}

#define NR_OF_ALGS 5

int main(void) {
	uint32_t samplenr = 0;
	uint16_t BytesRead = 0;
	uint16_t error_cnt = 0;

	std::cout << std::fixed;
	std::cout << std::setprecision(2);

	Algorithm * Alg[NR_OF_ALGS];


	Alg[0] = algorithmInit(1, 200, 800, 3, 4);

    /*stone selection*/
    if((Alg[0] == NULL)){
    	cout << "something went wrong while allocating space for the algorithms.... \n";
    	return -9001;
    }

	if(OpenComm(&Arduino,"COM6",57600)){
		cout << "Can't find COM 6, quitting";
		return -1; //something went wrong :'(
	}

	if(OpenComm(&Shine  ,"COM3",115200)){
		cout << "Can't find COM 3, quitting";
		return -2; //something went wrong :'(
	}

	ofstream myfile;
	myfile.open ("example.txt");

	cout.flush();
	GoToXY(0,0);
	Sleep(3000); /*this time is required for super blink to boot. or it wont receive the blink settings*/
	SendData(&Shine, sendListenCommand, 1);
	LightDetectMode();
	memset(ShineReceiveBuffer, 0, sizeof(ShineReceiveBuffer));
	PurgeComm(&Shine, PURGE_RXCLEAR);
	while(1){
		BytesRead += ReadData(&Shine,&ShineReceiveBuffer[BytesRead],1);

		if(BytesRead == 0) continue;

		if(ShineReceiveBuffer[BytesRead-1] == '\n'){ //Full number in buffer?

			BytesRead = 0;

			uint16_t newSample = atoi((char *) ShineReceiveBuffer);

			if(newSample < 100){
				error_cnt++;
				continue;
			}
			samplenr++;

			float newSample_FIR5 = FIR_5(newSample);
			float postHighpass = IIR_2_HP_0_2Hz(newSample);
			float newSample_IIR_2 = IIR_2(newSample_FIR5);

			algorithmUpdate(Alg[0],newSample_IIR_2);
//			result[1] = algorithmUpdate(Alg[1],newSample_IIR_2);
//			result[2] = algorithmUpdate(Alg[2],newSample_IIR_2);
//			result[3] = algorithmUpdate(Alg[3],newSample_IIR_2);
//			result[4] = algorithmUpdate(Alg[4],newSample_IIR_2);

			static uint64_t rndCounter = 0;
			if(rndCounter++ % 10){
				GoToXY(0,5);
				algorithmPrintStatus(Alg[0]);
			}

			myfile << fixed << setprecision(2) << newSample << ',' << newSample_FIR5 << ',' << newSample_IIR_2 << ',' << algorithmGetX(Alg[0]) << ',' << algorithmGetMu(Alg[0])+algorithmGetT(Alg[0]) *algorithmGetSigma(Alg[0]) << ',' << algorithmGetMu(Alg[0])-algorithmGetT(Alg[0])*algorithmGetSigma(Alg[0]) <<'\n';

//			if(result[0]){
//				LightIlluminationMode();
//			}
//			else{
//				LightDetectMode();
//			}
		}
	}
	CloseComm(&Arduino);
	CloseComm(&Shine);

	myfile.close();
}
