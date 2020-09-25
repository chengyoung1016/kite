return function(self)


local pause = true
local yspeed = 1

local helloworld, button


function self.ready()
	button = self.find("startgame")
	helloworld = self.find("helloworld")
	helloworld.color = 0xaa5500ff


	function button.on_pressed()
		print("GAME START")
		pause = not pause
	end
end


function self.update(dt)
	if pause then
		return
	end

	if helloworld.y >= 160 then
		yspeed = -1
	end

	if helloworld.y <= -160 then
		yspeed = 1
	end

	helloworld.y = helloworld.y + yspeed
end


end