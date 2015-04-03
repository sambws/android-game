require 'entities.bases'

encounter = class('encounter', monster)
encounter.w = 128 * scale
encounter.h = 128 * scale
encounter.persistent = false

function encounter:load()
end

function encounter:update(dt)
end

function encounter:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function encounter:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function encounter:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function encounter:die()
end