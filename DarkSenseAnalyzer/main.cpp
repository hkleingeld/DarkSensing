using namespace std;
#define DEBUG
#include <fstream>
#include <iostream>
#include <string>
#include <stdlib.h>

#include "../Shared/algorithm/Algorithm.hpp"
#include "../Shared/Filters/FIR_Filter.hpp"


char itoaBuffer[10];
char FileToOpen[100] = {0};
char startFileName[] = "bjarki center\\Result_";
char fromMatlab[100] = {0};
char endFileName[] = ".txt";

uint16_t FromFile;
uint16_t ToFile;
uint16_t NrOFiles;


#define MAX_NR_OF_FILES 1000
#define NR_OF_ALGS 100

uint16_t data[200][20000] = {0};
uint32_t lessons[200][20];

/* -1 = False positive (detection before 800) *
 *  0 = No detection                         *
 *  1 = True detection (detection after 799) *
 *
 *  Total fitness = sum of all results.
 */


// Best for paper with filter: 79   618   745     4   165      Result -> 28

// Best for paper no filter: 63    670   691     2   127       Result -> 32
//                           107   703   691     3   134
//                           107   728   628     1   130

// Best for stone with filter:    128   739   799     5   117   Result -> 38
//								  129   740   799     5   116
//								  131   766   798     4   119

// Best for stone no filter: 151   695   777     3    77	Result -> 38
//							 132   707   781     1    72
//							 132   707   781     1    72


//   155   751   747     1   130
//   155   751   747     1   130
//   154   750   747     2   129

//157   426   629     4    55
//149   438   684     2    51
//117   496   538     2    46


//55   592   597     4   251 -> 78


//Beste opties met dubbel FIFO
// Beide
// 34    95   794     3    54 -> 72
// 34    95   793     3    54-> 72
// Papier
// 52   755   707     2    81 -> 27
// Steen
// 65   728   673     3    45 -> 34

uint32_t results[NR_OF_ALGS][MAX_NR_OF_FILES];

uint32_t lastDetectionLoc = 0;

void resetDetection(void){
	lastDetectionLoc = 0;
}

int CheckDetection(uint32_t n, uint16_t fileNumber){
	int i = 0;
	while(lessons[fileNumber][i] != 0){
		if((n > lessons[fileNumber][i]) && (n < lessons[fileNumber][i]+lessons[fileNumber][i+1])){
			if((lastDetectionLoc > lessons[fileNumber][i]) && (lastDetectionLoc < lessons[fileNumber][i]+lessons[fileNumber][i+1])){
				return 0; /*we have already detected this one*/
			}
			cout << "x";
			return 1; /*new detection!*/
		}
		i++;
	}
	cout << "o";
	return -1; /*false positive*/
}



int main(int argc, char *argv[]){
	/*
	 * Argc:
	 * [0] = Path?
	 * [1] = n
	 * [2] = d
	 * [3] = m
	 * [4] = T
	 * [5] = Lowpass filter enabled
	 */
	int16_t n;
	int16_t d;
	int16_t m;
	uint8_t z;
	float T;

	uint16_t NrOfScenarios = 0;

	int16_t score = 0;

	if(argc == 9){
		strcpy(fromMatlab,argv[1]);
		n = (int16_t) atof(argv[2]);
		d = (int16_t) atof(argv[3]);
		m = (int16_t) atof(argv[4]);
		z = (uint8_t) atof(argv[5]);
		T = (float) atof(argv[6]);
		FromFile = atoi(argv[7]);
		ToFile = atoi(argv[8]);

		if((n < 0) || (d < 0) || (m < 3) || (T < 1) || (z < 1)){
			cout << "Argument too small to run properly! please fix!\n";
			return -9001;
		}

		if(ToFile < FromFile){
			cout << "You screw up the file numbers! please fix!\n";
			return -9002;
		}

		NrOFiles = ToFile - FromFile + 1;
#ifdef DEBUG
		cout << "Running via Commandline\n";
#endif
	}
	else{
		n = 100;
		d = 300;
		m = 800;
		z = 4;
		T = 8.2;
		FromFile = 1;
		ToFile = 6;
		NrOFiles = ToFile - FromFile + 1;

#ifdef DEBUG
		cout << "Running default mode, args found where:\n";
		for(int i = 0; i < argc; i++){
			cout << argv[i] << "\n";
		}
#endif
	}

#ifdef DEBUG
	cout << fromMatlab << "\t" << n << "\t" << d<< "\t" << m << "\t" << z << "\t" << T << "\t" << FromFile  << "\t" << ToFile << "\n";
#endif
	fstream file;

	for(uint16_t fileNumber = 0; fileNumber+FromFile<NrOFiles+1; fileNumber++){
		if(fromMatlab[0] != 0)
			strcpy(FileToOpen,fromMatlab);
		else
			strcpy(FileToOpen,startFileName);

		strcat(FileToOpen, itoa(fileNumber + FromFile,itoaBuffer,10));
		strcat(FileToOpen,endFileName);

		file.open(FileToOpen);
		if(!file.is_open()){
#ifdef DEBUG
			cout << "failed to open file (" << FileToOpen << ")#" << fileNumber << ". Now testing algorithm.\n\n";
#endif
			NrOfScenarios = fileNumber;
			break;
		}
		string line;
		uint16_t newVal = 0;
		uint16_t index = 0;

		/*
		 * first line is special, it contains all locations of *detectable activities* in the following format:
		 * [Activety1],[lenght1],[Activety2],[lenght2]
		 */
		getline(file,line);
		int k = 0;
		int j = 0;
		while(1){
			lessons[fileNumber][k] = atoi(&((line.data())[j]));
			j = line.find(',',j) + 1;
			k++;
			if (j == 0) break;
		}


		do{
			getline(file,line);
			if(VAL_FROM_FILE == 1){
				newVal = atoi(line.data());
			}
			else{
				int16_t readFrom = line.find_first_of(",");
				if(readFrom == -1){
					continue;//no comma was found....
				}
				const char * str = line.data();
				newVal = atoi(&str[readFrom+1]);
			}
			data[fileNumber][index] = newVal;
			index++;
		}while(file.eof() == false);

		file.close();
	}

	if(NrOfScenarios == 0){
		NrOfScenarios = NrOFiles;
	}

	Algorithm * Alg = algorithmInit(n,d,m,z,T);

	for(int i = 0; i < NrOfScenarios; i++){
		uint32_t sampleNumber = 0;
		int32_t prevScore = score;
		do{

			if(algorithmUpdate(Alg,IIR_2(data[i][sampleNumber]))){
#ifdef DEBUG
//				cout << i+1 << " @ " << sampleNumber << "\n";
#endif
				score += CheckDetection(sampleNumber, i);
				break;
			}

			sampleNumber++;
		}while(data[i][sampleNumber] != 0);

		if(score == prevScore){
			cout << "_";
		}
		if(score < prevScore){
			score++;
		}
		cout.flush();
		algorithmReset(Alg);
	}

	algorithmDelete(Alg);
	cout << "\n\nTotal Score: " << score << "\n\n";
#ifdef DEBUG
	system("pause");
#endif
	return(score);
}
