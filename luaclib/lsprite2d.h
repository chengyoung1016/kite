#ifndef LSPRITE2D_H
#define LSPRITE2D_H

#include "common.h"


typedef struct
{
	GLuint program;
	GLuint texture;
	float p0[8]; 	//{x, y, c_r, c_g, c_b, c_a, u, v}  (let-top Anti-clockwise)
	float p1[8];
	float p2[8];
	float p3[8];
} Sprite2D;


int
lib_sprite2d(lua_State *L);



#endif