/*
 * This code was provided by "alex79roma"
 * Source: http://www.cplusplus.com/forum/beginner/317/
 *
 * I (Hajo) Only updated the code to be compiled and work with miliseconds
 * instead of seconds.
 * Thanks :)!
 */

#include "timer.hpp"
#include <conio.h>
#include <time.h>	// class needs this inclusion

timer::timer() {
	resetted = true;
	running = false;
	beg = 0;
	end = 0;
}


void timer::start() {
	if(! running) {
		if(resetted)
			beg = (unsigned long) clock();
		else
			beg -= end - (unsigned long) clock();
		running = true;
		resetted = false;
	}
}


void timer::stop() {
	if(running) {
		end = (unsigned long) clock();
		running = false;
	}
}


void timer::reset() {
	bool wereRunning = running;
	if(wereRunning)
		stop();
	resetted = true;
	beg = 0;
	end = 0;
	if(wereRunning)
		start();
}


bool timer::isRunning() {
	return running;
}


unsigned long timer::getTime() {
	if(running)
		return ((unsigned long) clock() - beg)  / (CLOCKS_PER_SEC/1000);
	else
		return end - beg  / (CLOCKS_PER_SEC/1000);
}


bool timer::isOver(unsigned long miliSeconds) {
	return miliSeconds <= getTime();
}
