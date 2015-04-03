require 'entities.bases'

toolbar = class('toolbar', Entity)
toolbar.w = 400 * scale
toolbar.h = 48 * scale
toolbar.persistent = false

function toolbar:load()
end

function toolbar:update(dt)
end

function toolbar:draw()
	love.graphics.setColor(0, 255, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function toolbar:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function toolbar:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function toolbar:die()
end