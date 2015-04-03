require 'entities.bases'

mech = class('mech', c_mech)
mech.w = 64 * scale
mech.h = 64 * scale
mech.persistent = false

mech.r, mech.g, mech.b = 0, 0, 0

function mech:load()
	--choose color based on mech type
	if self.type == "lancer" then
		self.r = 255
		self.g = 0
		self.b = 0
	elseif self.type == "gunner" then
		self.r = 0
		self.g = 0
		self.b = 255
	end

	print(pilot[self.id])
end

function mech:update(dt)
end

function mech:draw()
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function mech:tap(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function mech:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end
end

function mech:die()
end