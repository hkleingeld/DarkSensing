#include <stdint.h>

//static float b0 = 0.059971545124981651;
//static float b1 = 0.2499852874769348;
//static float b2 = 0.38008633479616699;
//static float b3 = 0.2499852874769348;
//static float b4 = 0.059971545124981651;




static double b_10[] = {0.022859071548198193,0.13637542206313105,0.34076550638867076,0.34076550638867076,0.13637542206313105,0.022859071548198193};
static double b_5[]  = {-0.0101, -0.0833, -0.5733, 0.5733, 0.0833, 0.0101};

float FIR_5(uint16_t X0){
	static double X1 = 0;
	static double X2 = 0;
	static double X3 = 0;
	static double X4 = 0;
	static double X5 = 0;

	float Y0 = b_5[0]*X0 + b_5[1]*X1 + b_5[2]*X2 + b_5[3]*X3 + b_5[4]*X4 + b_5[5]*X5;

	X5 = X4;
    X4 = X3;
    X3 = X2;
    X2 = X1;
    X1 = X0;

	return Y0;
}

float FIR_10(uint16_t X0){
	static double X1 = 0;
	static double X2 = 0;
	static double X3 = 0;
	static double X4 = 0;
	static double X5 = 0;

	float Y0 = b_10[0]*X0 + b_10[1]*X1 + b_10[2]*X2 + b_10[3]*X3 + b_10[4]*X4 + b_10[5]*X5;

	X5 = X4;
    X4 = X3;
    X3 = X2;
    X2 = X1;
    X1 = X0;

	return Y0;
}

float G[] = {0.0055, 1.0000};
float SOS[] = {1.0000, 2.0000, 1.0000, 1.0000, -1.7786, 0.8008};

float IIR_2(float X0){
	static float W0 = 0;
	static float W1 = 0;
	static float W2 = 0;

	const float a0 = G[1]*SOS[3];
	const float a1 = G[1]*SOS[4];
	const float a2 = G[1]*SOS[5];
	const float b0 = G[0]*SOS[0];
	const float b1 = G[0]*SOS[1];
	const float b2 = G[0]*SOS[2];

	float Yn;

	W0 = X0 - a1 * W1 - a2 * W2;
	Yn = b0 * W0 + b1 * W1 + b2 * W2;

	W2 = W1;
	W1 = W0;
	return(Yn);
}

float IIR_2_HP_0_2Hz(uint16_t X0){
	static float W0 = 0;
	static float W1 = 0;
	static float W2 = 0;

	const float b0 = 0.9929;
	const float b1 = -1.9858;
	const float b2 = 0.9929;
	const float a0 = 1;
	const float a1 = -1.9858;
	const float a2 = 0.9859;

	float Yn;

	W0 = X0 - a1 * W1 - a2 * W2;
	Yn = b0 * W0 + b1 * W1 + b2 * W2;

	W2 = W1;
	W1 = W0;
	return(Yn);
}

