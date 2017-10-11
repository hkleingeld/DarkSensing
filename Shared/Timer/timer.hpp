#ifndef _TIMER_H_GUARD_
#define _TIMER_H_GUARD_
/*
 * This code was provided by "alex79roma"
 * Source: http://www.cplusplus.com/forum/beginner/317/
 *
 * I (Hajo) Only updated the code to be compiled and work with miliseconds
 * instead of seconds.
 * Thanks :)!
 */

class timer {
	public:
		timer();
		void           start();
		void           stop();
		void           reset();
		bool           isRunning();
		unsigned long  getTime();
		bool           isOver(unsigned long miliSeconds);
	private:
		bool           resetted;
		bool           running;
		unsigned long  beg;
		unsigned long  end;
};

#endif
