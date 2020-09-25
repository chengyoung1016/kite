CFLAGS = -s -O3 -Wall -Isrc -Isrc/renderer -Iluaclib -I3rd/include -I3rd/lua-5.4.0/src
LINK = -L3rd/lib -L3rd/lua-5.4.0/src -lglfw3 -lgdi32 -lopengl32 -llua54
SHARED := -FPIC --shared

SRC := \
	src/main.c \
	src/game.c \
	src/kite.c \
	src/window.c \
	src/util.c \
	src/renderer.c \

LUACLIB := \
	luaclib/lkite.c \
	luaclib/lwindow.c \
	luaclib/lgraphics.c \
	luaclib/lsprite2d.c \
	luaclib/lmatrix.c \
	luaclib/lprogram.c \



THIRD_PARTY := \
	3rd/src/glad.c \
	# 3rd/src/stb_vorbis.c \


.PHONY : kite


kite:
	gcc $(CFLAGS) $(SRC) $(LUACLIB) $(THIRD_PARTY) -o kite.exe $(LINK)