#include <stdint.h>

//static float b0 = 0.059971545124981651;
//static float b1 = 0.2499852874769348;
//static float b2 = 0.38008633479616699;
//static float b3 = 0.2499852874769348;
//static float b4 = 0.059971545124981651;

static double b_10[] = {0.022859071548198193,0.13637542206313105,0.34076550638867076,0.34076550638867076,0.13637542206313105,0.022859071548198193};
static double b_5[]  = {-0.0101, -0.0833, -0.5733, 0.5733, 0.0833, 0.0101};

/* FIR with cutoff @ 5Hz */
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

/*FIR with cutoff @ 10Hz */
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



