#ifndef RENDERER_H
#define RENDERER_H

#include "common.h"
#include "lsprite2d.h"

#define MAX_BATCH_SLOT 512



typedef struct
{
	GLuint program;
	GLuint texture;
	uint32_t count;
	float vertices[];	
} Batch;


typedef struct
{	
	GLuint vao;
	GLuint vbo;
	GLuint ebo;
	
	uint32_t drawc;
	float clearcolor_r;
	float clearcolor_g;
	float clearcolor_b;
	float clearcolor_a;

	GLuint cur_program;
	GLuint cur_texture;
	void(*set_clearcolor)(GLuint);
	void(*use_program)(GLuint);
	void(*bind_texture)(GLuint);
	void(*draw_start)(void);
	void(*draw)(Sprite2D *);
	void(*flush)(void);
	void(*draw_end)(void);
	void(*destroy)(void);

	Batch batch;
} Renderer;



Renderer *
create_renderer();

#endif