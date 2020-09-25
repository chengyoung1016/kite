local gfx = require "kite.graphics"
local sprite2d = require "sprite2d.core"
local texmgr = require "kite.manager.texture"
local fontmgr = require "kite.manager.font"
local program = (require "kite.manager.program").get_sprite_program()

local transform_attr = {x=true, y=true, xscale=true, yscale=true, angle=true}


local function get_text_width(font, text, size)
	local x = 0
	local w = 0
	local xadvance = 0
	local scale = size/font.info.size
	local last_w

	for _,id in utf8.codes(text) do
		local c = assert(font.char[id])
		x = x + xadvance
		last_w = c.width
		xadvance = c.xadvance*scale 
	end

	return math.floor(x + 2 + last_w * scale)
end

local function get_limit_text(text, n)
	local t = {}
	local c = 0
	for _, code in utf8.codes(text) do
		table.insert(t, utf8.char(code))
		c = c + 1
		if c == n then
			break
		end
	end
	return table.concat(t, "")
end


local function create_text_sprites(text, font, x, y, scale, color)
	local sprites = {}
	local x1 = x + 1	-- 1px border
	local xadvance = 0
	local y1, x3, y3

	for _,code in utf8.codes(text) do
		local c = assert(font.char[code])
		x1 = x1 + xadvance
		y1 = y - c.yoffset * scale
		x3 = x1 + c.width * scale
		y3 = y1 - c.height * scale

		xadvance = c.xadvance * scale
		local sp = sprite2d.create(program.id, font.texture.id, color, x1, y1, x1, y3, x3, y3, x3, y1, table.unpack(c.texcoord))
		table.insert(sprites, sp)
	end
	return sprites
end

local function update_sprites_transform(sprites, text, font, x, y, scale)
	local x1 = x + 1	-- 1px border
	local xadvance = 0
	local y1, x3, y3

	for i,code in utf8.codes(text) do
		local c = assert(font.char[code])
		x1 = x1 + xadvance
		y1 = y - c.yoffset * scale
		x3 = x1 + c.width * scale
		y3 = y1 - c.height * scale

		xadvance = c.xadvance * scale
		sprite2d.set_position(sprites[i], x1, y1, x1, y3, x3, y3, x3, y1)
	end
end


local function start_xy(mt, align, font, size, scale, text)
	local x = mt.world_x
	local y = mt.world_y - math.floor(scale) + size//2 -- y center
	local w = get_text_width(font, text, size)

	if align == "center" then
		x = x - w//2
	elseif align == "right" then
		x = x - w
	end
	return x, y
end


return function (node, mt, proxy)
	local font = fontmgr.get(node.font)
	local size = node.size or font.info.size
	local scale = size/font.info.size
	local align = node.align or "left"
	local text = node.text
	local limit = node.limit
	local color = node.color or 0xffffffff

	local x, y = start_xy(mt, align, font, size, scale, text)
	local sprites = create_text_sprites(text, font, x, y, scale, color)

	function mt.draw()
		for _,sp in ipairs(sprites) do
			gfx.draw(sp)
		end
	end

	function mt.update_transform()
		local x, y = start_xy(mt, align, font, size, scale, text)
		update_sprites_transform(sprites, text, font, x, y, scale)
	end

	setmetatable(proxy, {__index = node, __newindex = function (_, k, v)
		if k == "color" then
			assert(type(v) == "number" and v >= 0)
			node.color = v
			for _,sp in ipairs(sprites) do
				sprite2d.set_color(sp, v)
			end
		elseif k == "text" then
			text = v
			if limit and utf8.len(v) > limit then
				text = get_limit_text(v, text)
			end
			node.text = text
			
			local x, y = start_xy(mt, align, font, size, scale, text)
			sprites = create_text_sprites(text, font, x, y, scale, color)
		elseif node[k] then
			if transform_attr[k] then
				mt.modify[k] = v
			else
				error(k.." is read-only")
			end
		else
			rawset(proxy, k, v)
		end
	end})
end