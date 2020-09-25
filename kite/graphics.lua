local core = require 'graphics.core'
local sprite2d = require "sprite2d.core"
local texmgr = require "kite.manager.texture"
local program = (require "kite.manager.program").get_sprite_program()

local M = {}

--
-- it's a ptional, you can make your sprite create function
-- or only use graphics.core and sprite2d.core api
--
function M.test_sprite(t)
	local tex = texmgr.get(t.texname or 'resource/white.png')
	local self = {
		x = t.x or 0,
		y = t.y or 0,
		ax = t.ax or 0.5,
		ay = t.ay or 0.5,
		w = t.w or tex.w,
		h = t.h or tex.h,
		color = t.color or 0xffffffff,
		texcoord = t.texcoord or {0,1, 0,0, 1,0, 1,1},
	}

	local x1 = self.x - self.ax*self.w
	local y1 = self.y - self.ay*self.h

	self.id = sprite2d.create(
		program.id,
		tex.id,
		self.color,
		x1, y1 + self.h,
		x1, y1,
		x1 + self.w, y1,
		x1 + self.w, y1 + self.h,
		table.unpack(self.texcoord))

	function self.pos(x, y)
		if x == self.x and y == self.y then return end
		self.x = x
		self.y = y
		local x1 = self.x - self.ax*self.w
		local y1 = self.y - self.ay*self.h
		
		sprite2d.set_position(
				self.id,
				x1, y1 + self.h,
				x1, y1,
				x1 + self.w, y1,
				x1 + self.w, y1 + self.h
			)
	end

	function self.draw()
		core.draw(self.id)
	end

	return self
end



return setmetatable(M, {__index = core}) 