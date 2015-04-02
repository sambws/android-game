require 'entities.bases'

mech = Entity:extend("mech")
mech.w = 64 * scale
mech.h = 64 * scale
mech.persistent = false

local move = false  

function mech:load()
end

function mech:update()
	if move then
		self.x = self.x + 10
	end
end

function mech:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function mech:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function mech:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
		move = true
	end
end

function mech:die()
end