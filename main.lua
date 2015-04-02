--MOST LOOPS IN THIS FILE ARE DEDICATED TO CYCLING THROUGH THE ENTITIES AND RUNNING THEIR FUNCTIONS!!

--[[

	TODO:
	overhaul the entity system so it encorporates an actual class library (for instantiating/parents)
	comment comment comment

]]

require 'utils'
require 'entities'
class = require 'lib.30log'

--x and y position of the finger
cx = 0
cy = 0

--room id
room = ""

--define instances that can be accessed by all in a nice way (NAMES MUST BE SUPER UNIQUE!!!)
g_instances = {
	
}

function love.load()
	changeRoom("first")

end

function love.update(dt)
	updateEnts(dt) --update the ents
end

function love.draw()
	drawEnts() --draw the ents

	--print the coordinates of each tap
	--font = love.graphics.newFont(48)
	--love.graphics.setFont(font)
	--love.graphics.print(cx .. ", " .. cy, 100, 100)
	--love.graphics.print(ents[1].w, 100, 200)
	--love.graphics.print(room, 1000, 300)
end

function love.touchmoved(id, x, y, pressure)
	--if the finger moves, set the variable to it's position
	cx = x * love.graphics.getWidth()
	cy = y * love.graphics.getHeight()
end

function love.touchreleased(id, x, y, pressure)
	--x and y position of released
	cx = x * love.graphics.getWidth()
	cy = y * love.graphics.getHeight()

	releaseEnts(id, cx, cy, pressure) --call all ents' release functions
end

function love.touchpressed(id, x, y, pressure)
	--get the x and y position of the tap
	cx = x * love.graphics.getWidth()
	cy = y * love.graphics.getHeight()

	tapEnts(id, cx, cy, pressure) --call all ents' tap functions
end

function changeRoom( rm )
	--set the room to the new room
	room = rm
	wipeEnts() --wipe all the ents on room change

	--room stuff
	if rm == "first" then
		
	elseif rm == "second" then
	end
end

require("lib.LADS").hook()
