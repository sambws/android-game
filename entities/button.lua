require 'entities.bases'

button = Entity:extend("button")
button.w = 64 * scale
button.h = 32 * scale
button.persistent = false

local r, g, b = 0, 255, 255

function button:load()
end

function button:update()
end

function button:draw()
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function button:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
		g = g / 3
	end
end

function button:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
		g = 255
	end
end

function button:die()
end