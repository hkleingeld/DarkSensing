#include <windows.h>
#include <stdio.h>
#include <stdint.h>

#include "Comm.hpp"

//int setComTimouts(HANDLE * hCom){
//
//	LPCOMMTIMEOUTS timeouts;
//	GetCommTimeouts(hCom, timeouts);
//	timeouts->ReadIntervalTimeout = 1;
//}

int OpenComm(HANDLE * hCom, const char *pcCommPort, DWORD Boudrate)
{
   DCB dcb;
   //HANDLE hCom;
   BOOL fSuccess;
   //char *pcCommPort = "COM2";

   *hCom = CreateFile( pcCommPort,
                    GENERIC_READ | GENERIC_WRITE,
                    0,    // must be opened with exclusive-access
                    NULL, // no security attributes
                    OPEN_EXISTING, // must use OPEN_EXISTING
                    0,    // not overlapped I/O
                    NULL  // hTemplate must be NULL for comm devices
                    );

   if (*hCom == INVALID_HANDLE_VALUE) 
   {
       // Handle the error.
       printf ("CreateFile failed with error %d.\n", (int) GetLastError());
       return (1);
   }

   // Build on the current configuration, and skip setting the size
   // of the input and output buffers with SetupComm.

   fSuccess = GetCommState(*hCom, &dcb);

   if (!fSuccess) 
   {
      // Handle the error.
      printf ("GetCommState failed with error %d.\n", (int) GetLastError());
      return (2);
   }

   // Fill in DCB: 57,600 bps, 8 data bits, no parity, and 1 stop bit.

   dcb.BaudRate = Boudrate;     // set the baud rate
   dcb.ByteSize = 8;             // data size, xmit, and rcv
   dcb.Parity = NOPARITY;        // no parity bit
   dcb.StopBits = ONESTOPBIT;    // one stop bit

   fSuccess = SetCommState(*hCom, &dcb);

   if (!fSuccess) 
   {
      // Handle the error.
      printf ("SetCommState failed with error %d.\n", (int) GetLastError());
      return (3);
   }

   printf ("Serial port %s successfully reconfigured.\n", pcCommPort);
   return (0);
}

DWORD SendData(HANDLE * hCom, uint8_t * Data, DWORD NumberOfBytes)
{
	DWORD BytesWritten;

	WriteFile(
			*hCom,     		// open file handle
			Data,      		// start of data to write
			NumberOfBytes,  // number of bytes to write
	        &BytesWritten,  // number of bytes that were written
	        (LPOVERLAPPED)NULL);          // no overlapped structure
	
	return(BytesWritten);
}

DWORD ReadData(HANDLE * hCom, uint8_t * Buffer, DWORD SizeOfBuffer)
{
	DWORD bytesRead = 0;

	BOOL res = ReadFile(
			*hCom,        // handle to file
			Buffer,       // data buffer
			SizeOfBuffer, // number of bytes to read
			&bytesRead,   // number of bytes read
			NULL);        // overlapped buffer );

	if(!res){
		printf("\n\n Reading failed, Last error: %d", (int) GetLastError());
	}

	return bytesRead;
}


void CloseComm(HANDLE * hCom)
{
	CloseHandle(*hCom);
}
