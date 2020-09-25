#ifndef LMATRIX_H
#define LMATRIX_H

#include "common.h"


typedef struct
{
	float m0[4];
	float m1[4];
	float m2[4];
	float m3[4];
} mat4x4;



int
lib_matrix(lua_State *L);




#endif