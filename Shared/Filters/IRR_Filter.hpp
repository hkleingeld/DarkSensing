#ifndef _IRR_FILTER_H_GUARD_
#define _IRR_FILTER_H_GUARD_

#include <stdint.h>

float Filter82_10(uint16_t X0);
float IIR_2(float X0);
float IIR_2_HP_0_2Hz(uint16_t X0);
#endif
