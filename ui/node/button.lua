local gfx = require "kite.graphics"
local texmgr = require "kite.manager.texture"
local sprite2d = require "sprite2d.core"
local program = (require "kite.manager.program").get_sprite_program()
local sin = math.sin
local cos = math.cos

local transform_attr = {x=true, y=true, width=true, height=true, xscale=true, yscale=true, angle=true}

-- 旋转原点, 角度, 旋转目标点, 返回值(位置) 
local function ROTATE(x0, y0, a, x1, y1)
	local x = (x1 - x0)*cos(a) - (y1 - y0)*sin(a) + x0
	local y = (x1 - x0)*sin(a) + (y1 - y0)*cos(a) + y0
	return x, y
end

-- 左上角 逆时针
local function sprite_position(sp, mt)
	local w = sp.width * mt.world_xscale
	local h = sp.height * mt.world_yscale

	local x0 = mt.world_x
	local y0 = mt.world_y

	local x1 = x0 - w/2
	local y1 = y0 + h/2

	local x2 = x0 - w/2
	local y2 = y0 - h/2

	local x3 = x0 + w/2
	local y3 = y0 - h/2

	local x4 = x0 + w/2
	local y4 = y0 + h/2

	if mt.world_angle ~= 0 then
		local a = mt.world_angle * math.pi/180
		x1, y1 = ROTATE(x0, y0, a, x1, y1)
		x2, y2 = ROTATE(x0, y0, a, x2, y2)
		x3, y3 = ROTATE(x0, y0, a, x3, y3)
		x4, y4 = ROTATE(x0, y0, a, x4, y4)
	end

	return x1,y1, x2,y2, x3,y3, x4,y4
end


local function sprite_flip_h(sp)
	sp.texcoord[1],sp.texcoord[7] = sp.texcoord[7], sp.texcoord[1]
	sp.texcoord[2],sp.texcoord[8] = sp.texcoord[8], sp.texcoord[2]
	sp.texcoord[3],sp.texcoord[5] = sp.texcoord[5], sp.texcoord[3]
	sp.texcoord[4],sp.texcoord[6] = sp.texcoord[6], sp.texcoord[4]
end


local function sprite_flip_v(sp)
	sp.texcoord[1],sp.texcoord[3] = sp.texcoord[3], sp.texcoord[1]
	sp.texcoord[2],sp.texcoord[4] = sp.texcoord[4], sp.texcoord[2]
	sp.texcoord[7],sp.texcoord[5] = sp.texcoord[5], sp.texcoord[7]
	sp.texcoord[8],sp.texcoord[6] = sp.texcoord[6], sp.texcoord[8]
end


return function (node, mt, proxy)
	local tex = texmgr.get(assert(node.image))
	node.color = node.color or 0xffffffff
	node.texcoord = node.texcoord or {0,1, 0,0, 1,0, 1,1}
	node.hflip = node.hflip or false
	node.vflip = node.vflip or false

	if node.hflip then
		sprite_flip_h(node)
	end

	if node.vflip then
		sprite_flip_v(node)
	end

	local x1, y1, x2, y2, x3, y3, x4, y4 = sprite_position(node, mt)
	local sprite = sprite2d.create(program.id, tex.id, node.color, x1, y1, x2, y2, x3, y3, x4, y4, table.unpack(node.texcoord))
	mt.width = node.width * mt.world_xscale
	mt.height = node.height * mt.world_yscale
	mt.sprite = sprite
	mt.program = program.id
	mt.texture = tex.id

	-- mt func (use by framwork)
	function mt.draw()
		gfx.draw(sprite)
	end

	function mt.update_transform()
		mt.width = node.width * mt.world_xscale
		mt.height = node.height * mt.world_yscale
		local x1, y1, x2, y2, x3, y3, x4, y4 = sprite_position(node, mt)
		sprite2d.set_position(mt.sprite, x1, y1, x2, y2, x3, y3, x4, y4)
	end

	-- proxy func (use by user)
	function proxy.flip_h()
		sprite_flip_h(node)
		sprite2d.set_texcoord(mt.sprite, table.unpack(node.texcoord))
		node.hflip = not node.hflip
	end

	function proxy.flip_v()
		sprite_flip_v(node)
		sprite2d.set_texcoord(mt.sprite, table.unpack(node.texcoord))
		node.vflip = not node.vflip
	end

	-- button attr
	mt.touchable = true

	local normal_xscale
	local normal_yscale

	function proxy.touch_began()
		normal_xscale = node.xscale
		normal_yscale = node.yscale

		proxy.xscale = node.press_scale
		proxy.yscale = node.press_scale
	end

	function proxy.touch_ended()
		proxy.xscale = normal_xscale
		proxy.yscale = normal_yscale
	end


	setmetatable(proxy, {__index = node, __newindex = function (_, k, v)
		if k == "color" then
			assert(type(v) == "number" and v >= 0)
			node.color = v
			sprite2d.set_color(sprite, v)
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