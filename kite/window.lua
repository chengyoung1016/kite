local core = require 'window.core'

-- dispaly size
local display = core.get_display()


local M = {
	icon = application.window.icon,
	title = application.window.title,
	width = application.window.width,
	height = application.window.height,
	fullscreen = application.window.fullscreen
}


function M.fullscreen()
	if M.fullscreen then return end
	M.width = display.width
	M.height = display.height
	M.fullscreen = true
	core.fullscreen()
end


function M.resize(w, h)
	M.width = w
	M.height = h
	M.fullscreen = false
	core.resize(w, h)
end


function M.set_title(title)
	M.title = title
	core.set_title(title)
end


function M.set_icon(icon)
	M.icon = icon
	core.set_icon(icon)
end


return M