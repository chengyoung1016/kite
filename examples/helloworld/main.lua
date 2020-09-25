local kite = require "kite"
local ui = require "ui"
local gfx = require "graphics.core"
local fontmgr = require "kite.manager.font"


-- load
fontmgr.load('generic', 'examples/asset/generic.fnt', 'examples/asset/generic_0.png')

local tree = ui.tree {
	x = 480, y = 320, type = "empty", script = "examples.helloworld.Game",
	{
		name="bg", x=0, y=0, width=960, height=640, image="examples/asset/bg.jpg", type="sprite",
		{
			name="head1", x=0, y=0, width=200, height=200,
			image="examples/asset/head1.jpg", type="sprite"
		},
		{
			type="label", name="helloworld", x=0, y=-160, text="Hello World",
			font="generic", align="center", size=32, color=0xbe2137ff
		},
		{
			type="button",name="startgame", press_scale = 0.9, x=0,y=-240, width=163, height=44, image="examples/asset/btn_start.png"
		}
	},
}



gfx.set_clearcolor(0xf5f5f5ff)


local game = {}


function game.update(dt)
	tree.dispatch("update", dt)
end

function game.draw()
	tree.draw()
end


function game.mouse(what, x, y, who)
	if who == "right" then
		return
	end
	tree.dispatch("mouse_"..what, x, y)
end

function game.keyboard(key, what)
	if what == 'release' and key == 'escape' then
		kite.exit()
	end
end

function game.textinput(char)
end

function game.scroll(ox, xy)
end

function game.pause()
	print('pause')
end

function game.resume()
	print('resume')
end

function game.exit()
end



kite.start(game)