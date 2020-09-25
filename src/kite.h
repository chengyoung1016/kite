#ifndef KITE_H
#define KITE_H

#include "common.h"

typedef struct
{	
	uint32_t width;
	uint32_t height;
	bool fullscreen;
	char *icon;
	char *title;
} __Window;


typedef struct
{
	const char *gamedir;
	__Window window;
} Conf;


typedef struct
{
	lua_State *L;
	Conf conf;

	//callback
	int (*load)(void);
	void (*update)(double);
	void (*draw)(void);
	void (*_cursor_enter)(GLFWwindow*, int);
	void (*_cursor_move)(GLFWwindow*, double, double);
	void (*_iconify)(GLFWwindow*, int);
	void (*mouse)(GLFWwindow*, int, int, int);
	void (*keyboard)(GLFWwindow*, int, int, int, int);
	void (*textinput)(GLFWwindow*, uint32_t);
	void (*scroll)(GLFWwindow*, double, double);
	void (*exit)(void);

	void (*destroy)(void);
} Kite;






Kite *
create_kite(const char *);



#endif