require 'entities.bases'

dragbox = Entity:extend("dragbox")
dragbox.w = 64 * scale
dragbox.h = 64 * scale
dragbox.persistent = true

local drag = false

function dragbox:load()
end

function dragbox:update()
	if drag == true then
		self.x = cx - (self.w / 2)
		self.y = cy - (self.h / 2)
	else
		self.x = 0
		self.y = 0
	end
end

function dragbox:draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.line(0, 0, self.x, self.y)
end

function dragbox:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
		drag = true
	end
end

function dragbox:released(id, x, y, pressure)
	if drag == true then
		drag = false
	end
end

function dragbox:die()
end