#ifndef WINDOW_H
#define WINDOW_H

#include "common.h"

typedef struct
{
	uint32_t width;
	uint32_t height;
	bool fullscreen;
	const char *title;
	GLFWwindow *handle;

	GLFWmonitor *monitor;
	const GLFWvidmode *display;

	void (*destroy)(void);
} Window;



Window *
create_window();




#endif