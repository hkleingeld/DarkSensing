#include <stdint.h>

static float a1 = -0.9669;
static float a2 = 0.3420;
static float b0 = 0.0938;
static float b1 = 0.1875;
static float b2 = 0.0938;

float Filter82_10(uint16_t X0){
	static float Y1 = 0;
	static float Y2 = 0;
	static float X1 = 0;
	static float X2 = 0;

	float Y0 = b0*X0 + b1*X1 + b2 * X2 - a1 * Y1 - a2 * Y2;

	Y2 = Y1;
	Y1 = Y0;

	X2 = X1;
	X1 = X0;

	return Y0;
}

// s = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);
//0.0134 0.0267 0.0134 1 -1.6475 0.7009
float IIR_2(float X0){
	static float W0 = 0;
	static float W1 = 0;
	static float W2 = 0;

	//const float a0 = 1;
	const float a1 = -1.6475;
	const float a2 = 0.7009;
	const float b0 = 0.0134;
	const float b1 = 0.0267;
	const float b2 = 0.0134;

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
