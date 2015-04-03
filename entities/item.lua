require 'entities.bases'

item = class('item', BarItem)
item.w = 32 * scale
item.h = 32 * scale
item.persistent = false

--color values are selected based on the item's id (set in the constructor)
item.r, item.g, item.b = 0, 0, 0

item.drag = false

function item:load()
	--choose  color based on id
	if self.id == 0 then
		self.r = 255
	elseif self.id == 1 then
		self.g = 255
	elseif self.id == 2 then
		self.b = 255
	end
end

function item:update(dt)
	--when dragging, set pos
	if self.drag == true then
		self.x = cx - (self.w / 2)
		self.y = cy - (self.h / 2)
	else
		self.x = self.ox
		self.y = self.oy
	end
end

function item:draw()
	--draw rectangle
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function item:tap(id, x, y, pressure)
	--start drag
	if checkTouch( x, y, self ) then
		self.drag = true
	end
end

function item:released(id, x, y, pressure)
	if checkTouch( x, y, self ) then
	end

	--end drag
	if self.drag == true then
		self.drag = false
	end
end

function item:die()
end