#ifndef _COMMH_
#define _COMMH_

#include <stdint.h>

int OpenComm(HANDLE * hCom, const char *pcCommPort, DWORD Boudrate);
void CloseComm(HANDLE * hCom);
DWORD SendData(HANDLE * hCom, uint8_t * Data, DWORD NumberOfBytes);
DWORD ReadData(HANDLE * hCom, uint8_t * Buffer, DWORD SizeOfBuffer);
#endif
