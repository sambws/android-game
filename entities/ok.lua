require 'entities.bases'

ok = Entity:extend("ok")

ok.w = 16 * scale
ok.h = 16 * scale
ok.persistent = false

math.randomseed(os.time())
math.random(); math.random(); math.random();
local timer = math.random(180)

function ok:load()
end

function ok:update()
	timer = timer - 1
	if timer <= 0 then
		destroy_ent(self.name)
	end
end

function ok:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function ok:tap()
end

function ok:released()
end

function ok:die()
end