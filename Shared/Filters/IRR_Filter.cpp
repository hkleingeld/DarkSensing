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
