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
#include "comm.hpp"

// Changing default values of enum
enum states {IDLE, START, DETECTING, FINISHING, RESET};

typedef struct Measurement{
    uint16_t number;
    uint16_t StartDetecting;
    uint64_t Max[5000];
    uint64_t Filtered[5000];
    uint64_t Sum[5000];
    uint64_t FilteredSum[5000];
    Measurement * next;
}Measurement;

Measurement * NewMeasurement(uint16_t nr){
	Measurement * ptr = (Measurement *) calloc(1,sizeof(Measurement));
	ptr->number = nr;
	ptr->next = NULL;
	return ptr;
}

void SaveMeasurement(Measurement * node){
	ofstream fiets;
	char itoabuffer[10];
	char filname[100] = {0};

	strcpy(filname,"Result_");
	strcat(filname,itoa(node->number,itoabuffer,10));
	strcat(filname,".txt");

	fiets.open(filname);

	fiets << node->StartDetecting << "," << itoa(5000,itoabuffer,10) << "\n";
	printf("saving ...\n");
	uint16_t i = 0;
	while(node->Max[i] != 0){
		fiets << node->Max[i] << ",";
		fiets << node->Filtered[i] << ",";
		fiets << node->Sum[i] << ",";
		fiets << node->FilteredSum[i] << "\n";
		i++;
	}
	printf("done ...\n");
	fiets.close();
}

/*this should free all nodes recursively, as well as generate the files.*/
void FreeMeasurements(Measurement * node){
	if(node->next == NULL){
		printf("save node: %d @%d\n", node->number,&node);
		SaveMeasurement(node);
		printf("free node: %d @%d\n", node->number,&node);

		free(node);
	}
	else{
		printf("moving from %d to: %d @%d\n", node->number, node->next->number);
		FreeMeasurements(node->next);
		node->next = NULL;
		printf("save node: %d @%d\n", node->number,&node);
		SaveMeasurement(node);
		free(node);
	}
}

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

uint8_t ShineReceiveBuffer[100] = {0};

HANDLE Arduino;
HANDLE Shine;
ofstream myfile;


uint8_t BlinkCommand[7] = 		{0xC0, 0x03, 0x20, 0x00, 0x14, 0x00, 0xC0}; //high% dc
uint8_t BlinkCommandDetect[7] = {0xC0, 0x03, 0x20, 0x00, 0x14, 0x00, 0xC0};  //2% dc
uint8_t sendListenCommand[1] =  {0x03};

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

	uint16_t MeasurementNumber = 1;
	uint16_t SampleInMeasure = 0;
	Measurement * Measurements = NULL;
	Measurement * NewMeasure;
	Measurements = NewMeasurement(MeasurementNumber);
	NewMeasure = Measurements;
	Measurement * PrevMeasure = NULL;


	enum states capturestate = IDLE;

	std::cout << std::fixed;
	std::cout << std::setprecision(2);

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
	Sleep(3000); /*this time is required for super blink to boot. or it wont receive the blink settings*/
	SendData(&Shine, sendListenCommand, 1);
	LightDetectMode();
	memset(ShineReceiveBuffer, 0, sizeof(ShineReceiveBuffer));
	PurgeComm(&Shine, PURGE_RXCLEAR);

	cout << "Ready to go!\n";
	while(1){
		BytesRead += ReadData(&Shine,&ShineReceiveBuffer[BytesRead],1);

		if(BytesRead == 0) continue;

		if(ShineReceiveBuffer[BytesRead-1] == '\n'){ //Full number in buffer?

			uint64_t newSample[4] = {0};
			void * index = (void *) ShineReceiveBuffer;

			for(int i = 0; i<4; i++){
				newSample[i] = atoi((char *)index);
				index = memchr(index,',',100) + 1;
			}

			BytesRead = 0;
			if(newSample[0] < 100){
				error_cnt++;
				continue;
			}
			samplenr++;


			switch(capturestate){
			case IDLE:
				if(GetAsyncKeyState(VK_LCONTROL)){
					printf("Start");
					capturestate = START;
				}
				break;
			case START:
				NewMeasure->Max[SampleInMeasure] = newSample[0];
				NewMeasure->Filtered[SampleInMeasure] = newSample[1];
				NewMeasure->Sum[SampleInMeasure] = newSample[2];
				NewMeasure->FilteredSum[SampleInMeasure] = newSample[3];
				SampleInMeasure++;

				if(SampleInMeasure == 2000){
					printf(" - 2000 samples!");
//					popen("vlc.exe --stop-time 5 \"C:\\Users\\Hajo\\workspace\\SubJava\\Nuclear alarm siren sound effect NUKE.mp3\" vlc://quit", "r");
				}

				if(GetAsyncKeyState(VK_RCONTROL)){
					printf(" - Detecting");
					capturestate = DETECTING;

					NewMeasure->StartDetecting = SampleInMeasure;

				}
				break;
			case DETECTING:
				NewMeasure->Max[SampleInMeasure] = newSample[0];
				NewMeasure->Filtered[SampleInMeasure] = newSample[1];
				NewMeasure->Sum[SampleInMeasure] = newSample[2];
				NewMeasure->FilteredSum[SampleInMeasure] = newSample[3];

				SampleInMeasure++;

				if(!GetAsyncKeyState(VK_RCONTROL)){
					printf(" - FINISHING");
					capturestate = FINISHING;
				}
				break;
			case FINISHING:
				printf(" - Done\n");

				NewMeasure->Max[SampleInMeasure] = newSample[0];
				NewMeasure->Filtered[SampleInMeasure] = newSample[1];
				NewMeasure->Sum[SampleInMeasure] = newSample[2];
				NewMeasure->FilteredSum[SampleInMeasure] = newSample[3];

				PrevMeasure = NewMeasure;
				SampleInMeasure = 0;
				NewMeasure = NewMeasurement(NewMeasure->number+1);
				PrevMeasure->next = NewMeasure;

				capturestate = IDLE;
				break;
			case RESET:

				break;
			default:
				capturestate = RESET;
				break;
			}

			myfile << fixed << setprecision(2) << newSample << "\n";

//			if(result[0]){
//				LightIlluminationMode();
//			}
//			else{
//				LightDetectMode();
//			}

			if(GetAsyncKeyState(VK_RSHIFT)){
				break;
			}
		}
	}
	FreeMeasurements(Measurements);
	CloseComm(&Arduino);
	CloseComm(&Shine);

	myfile.close();
}
