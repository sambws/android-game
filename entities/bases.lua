--[[class = require 'lib.30log'

--base ent class
Entity = class("Entity")

function Entity:init(x, y, name)
	self.x = x * scale
	self.y = y * scale
	self.name = name
	self.dead = false
end
]]

class = require 'lib.middleclass'
require 'game'

--basic entity class
Entity = class('Entity')

function Entity:initialize(x, y, name)
	self.x = x * scale
	self.y = y * scale
	self.name = name
	self.dead = false
end

--item class
BarItem = class('BarItem', Entity)

function BarItem:initialize(name, x, y, id)
	Entity.initialize(self, x, y, name)
	self.id = id
	self.ox = x * scale
	self.oy = y * scale
end

--mech class
c_mech = class('c_mech', Entity)

function c_mech:initialize(name, x, y, type, id)
	Entity.initialize(self, x, y, name)
	self.type = type
	self.id = id
end

--monster class
monster = class('monster', Entity)

function monster:initialize(name, x, y, type)
	Entity.initialize(self, x, y, name)
	self.type = type
end