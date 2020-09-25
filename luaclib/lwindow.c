#include "game.h"
#include "util.h"
#include "lwindow.h"

extern Game * G;



static int
lfullscreen(lua_State *L) {
	int w = G->window->display->width;
	int h = G->window->display->height;
	glfwSetWindowMonitor(G->window->handle, G->window->monitor, 0, 0, w, h, G->window->display->refreshRate);
	G->window->fullscreen = true;
	G->window->width = w;
	G->window->height = h;
	return 0;
}


static int
lresize(lua_State *L) {
	int w = luaL_checkinteger(L, 1);
	int h = luaL_checkinteger(L, 2);
	if (G->window->fullscreen) {
		glfwSetWindowMonitor(G->window->handle, NULL, G->window->display->width/2 - w/2, G->window->display->height/2 - h/2, w, h, 0);
		G->window->fullscreen = false;
	} else {
		glfwSetWindowSize(G->window->handle, w, h);
	}
	G->window->width = w;
	G->window->height = h;
	return 0;
}


static int
lset_title(lua_State *L) {
	const char *title = luaL_checkstring(L, 1);
	glfwSetWindowTitle(G->window->handle, title);
	return 0;
}


static int
lset_icon(lua_State *L) {
	GLFWimage icon;
	const char *filename;

	filename = luaL_checkstring(L, 1);
	icon.pixels = load_image(filename, &icon.width, &icon.height, NULL, false);
	glfwSetWindowIcon(G->window->handle, 1, &icon);
	destroy_image(icon.pixels);
	return 0;
}


static int
lget_display(lua_State *L) {
	lua_newtable(L);
	lua_pushstring(L, "width");
	lua_pushinteger(L, G->window->display->width);
	lua_settable(L, -3);
	lua_pushstring(L, "height");
	lua_pushinteger(L, G->window->display->height);
	lua_settable(L, -3);
	return 1;
}


int
lib_window(lua_State *L)
{
	luaL_Reg l[] = {
		{"fullscreen", lfullscreen},
		{"resize", lresize},
		{"set_title", lset_title},
		{"set_icon", lset_icon},
		{"get_display", lget_display},
		{NULL, NULL}
	};
	luaL_newlib(L, l);
	return 1;
}