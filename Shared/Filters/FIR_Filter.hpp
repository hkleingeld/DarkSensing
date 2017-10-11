#ifndef _FIR_H_GUARD_
#define _FIR_H_GUARD_
#include <stdint.h>

float FIR_5(uint16_t X0);
float FIR_10(uint16_t X0);

float IIR_2(float X0);
float IIR_2_HP_0_2Hz(uint16_t X0);
#endif
