require 'entities.bases'

coolerbox = Entity:extend("coolerbox")
coolerbox.w = 64 * scale
coolerbox.h = 64 * scale
coolerbox.persistent = false

function coolerbox:load()
end

function coolerbox:update()
	local db = g_instances.db

	if CheckCollision(self.x, self.y, self.w, self.h, db.x, db.y, db.w, db.h) then
		print(self.name)
	end

end

function coolerbox:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function coolerbox:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function coolerbox:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function coolerbox:die()
end