local system_touch = require "ui.system.touch"



local create = {
	empty = require "ui.node.empty",
	sprite = require "ui.node.sprite",
	label = require "ui.node.label",
	button = require "ui.node.button",
}

local WORLD = {world_x=0, world_y=0, world_angle=0, world_xscale=1, world_yscale=1, lv=-1}


local function create_list()
	local list = {}

	function list.foreach(f)
		local cur = list.head

		while cur do
			if f(cur) then
				break
			else
				cur = cur.next
			end
		end
	end

	function list.foreach_from_tail(f)
		local cur = list.tail

		while cur do
			if f(cur) then
				break
			else
				cur = cur.previous
			end
		end
	end


	function list.append(node)
		if not list.head then
			list.head = node
		end

		local tail = list.tail
		if tail then
			tail.next = node
			node.previous = tail
			list.tail = node
		else
			list.tail = node
		end
	end

	-- find node in children with name
	function list.find(node, name)
		local current = node
		while true do
			local n = current.next
			if n and n.lv > node.lv then
				if n.name == name then
					return n.proxy
				else
					current = n
				end
			else
				return
			end
		end
	end

	function list.remove(node)
		-- body
	end

	return list
end



local M = {}


function M.tree(root)

	local list = create_list()

	local function init(node, parent_mt)
		node.xscale = node.xscale or 1
		node.yscale = node.yscale or 1
		node.angle = node.angle or 0
		
		local proxy = {}

		local mt = {
			name = node.name,
			lv = parent_mt.lv + 1,
			node = node,
			proxy = proxy,
			parent = parent_mt,

			world_x = node.x + parent_mt.world_x,
			world_y = node.y + parent_mt.world_y,
			world_angle = node.angle + parent_mt.world_angle,
			world_xscale = node.xscale * parent_mt.world_xscale,
			world_yscale = node.yscale * parent_mt.world_yscale,
			modify = {}
		}
		
		function proxy.find_in_tree(name)
			local target
			list.foreach(function (mt)
				if mt.name == name then
					target = mt.proxy
					return true
				end
			end)
			return target
		end
		
		function proxy.find(name)
			return list.find(mt, name)
		end

		function proxy.remove_self()
			list.remove(mt)
		end

		function proxy.add_child(node)
			-- body
			-- local sub_list = {}
			-- init(node, mt, sub_list)
			-- add sub_list to list
		end

		if node.script then
			require(node.script)(proxy)
		end

		local f = assert(create[node.type], tostring(node.type))
		f(node, mt, proxy)

		list.append(mt)

		for i,child in ipairs(node) do
			init(child, mt)
		end
	end

	init(root, WORLD)


	local self = {}


	local function draw_node(mt)
		local parent_mt = mt.parent
		local node = mt.node
		mt.modified = false
		if next(mt.modify) then
			mt.modified = true
			for k,v in pairs(mt.modify) do
				node[k] = v
			end
			mt.modify = {}
		end

		if mt.modified or parent_mt.modified then
			mt.world_x = node.x + parent_mt.world_x
			mt.world_y = node.y + parent_mt.world_y
			mt.world_angle = node.angle + parent_mt.world_angle
			mt.world_xscale = node.xscale * parent_mt.world_xscale
			mt.world_yscale = node.yscale * parent_mt.world_yscale
			if mt.update_transform then
				mt.update_transform()
			end
			mt.modified = true
		end

		if mt.draw then
			mt.draw()
		end
	end

	local systems = {}


	function self.draw()
		list.foreach(draw_node)
	end

	function self.add_system(system)
		table.insert(systems, system(list))
	end

	function self.dispatch(event, ...)
		for _,sys in ipairs(systems) do
			if sys(event, ...) then
				return
			end
		end
		local cur = list.head
		while cur do
			local f = cur.proxy[event]
			if f and f(...)then
				break
			end
			cur = cur.next
		end
	end

	-- add ui system
	self.add_system(system_touch)


	self.dispatch("ready")

	return self
end


return M