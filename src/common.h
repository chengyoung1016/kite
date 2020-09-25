#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>

#define GLFW_INCLUDE_NONE
#include <glad/glad.h>
#include <glfw/glfw3.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stb_image.h>


#define FREE(p); if(p) {free(p); p = NULL;}

#define COLOR_R(c) ((c>>24)&0xFF)/255.0f
#define COLOR_G(c) ((c>>16)&0xFF)/255.0f
#define COLOR_B(c) ((c>>8) &0xFF)/255.0f
#define COLOR_A(c) (c      &0xFF)/255.0f


static inline void
ASSERT(int ok, const char * msg) {
	if (!ok) {
		fprintf(stderr, "%s\n", msg);
		exit(EXIT_FAILURE);
	}
}



#endif