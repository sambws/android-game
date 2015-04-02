class = require 'lib.30log'

--base ent class
Entity = class("Entity")

function Entity:init(x, y, name)
	self.x = x
	self.y = y
	self.name = name
	self.dead = false
end