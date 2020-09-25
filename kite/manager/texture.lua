---------------------------------------------------------------
--
-- texture manager
--
---------------------------------------------------------------
local gfx = require "graphics.core"


local M = {}
local textures = {}


local function load_texture(name)
	local id, w, h = gfx.texture(name)
	local tex = { id = id, name = name,  width = w, height = h }
	textures[name] = tex
	return tex
end


function M.get(name)
	return textures[name] or load_texture(name)
end


function M.load(t)
	for _,name in ipairs(t) do
		load_texture(name)
	end
end



return M