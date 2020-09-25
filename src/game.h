#ifndef GAME_H
#define GAME_H

#include "common.h"
#include "kite.h"
#include "window.h"
#include "renderer.h"

typedef struct
{
	Kite *kite;
	Window *window;
	Renderer *renderer;

	double time;
	uint32_t drawcall;

	void (*run)(void);
	void (*destroy)(void);
} Game;




Game *
create_game(const char *);



#endif