#include <math.h>

#include "lgraphics.h"
#include "lsprite2d.h"
#include "game.h"
#include "util.h"


extern Game * G;



static int
ldraw(lua_State *L) {
	Sprite2D *sprite = lua_touserdata(L, 1);
	G->renderer->draw(sprite);
	return 0;
}


static int
lset_clearcolor(lua_State *L) {
	uint32_t c;
	c = luaL_checkinteger(L, 1);
	G->renderer->set_clearcolor(c);
	return 0;
}


static int
ltexture(lua_State *L) {
	uint32_t texture;
	const char *filename;
	int width, height, channel;
	unsigned char *data;

	filename = luaL_checkstring(L, 1);
	data = load_image(filename, &width, &height, &channel, true);

	glGenTextures(1, &texture);
	G->renderer->flush();
	G->renderer->bind_texture(texture);

	// GL_NEAREST (邻近过滤）  GL_LINEAR (线性过滤)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	destroy_image(data);

	lua_pushinteger(L, texture);
	lua_pushinteger(L, width);
	lua_pushinteger(L, height);
	return 3;
}


int
lib_graphics(lua_State *L)
{
	luaL_Reg l[] = {
		{"draw", ldraw},
		{"set_clearcolor", lset_clearcolor},
		{"texture", ltexture},
		{NULL, NULL}
	};
	luaL_newlib(L, l);
	return 1;
}