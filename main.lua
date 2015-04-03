--MOST LOOPS IN THIS FILE ARE DEDICATED TO CYCLING THROUGH THE ENTITIES AND RUNNING THEIR FUNCTIONS!!

--[[

	TODO:
	clean up the goddamn create functions
	make all the functions/variables in the libraries (util, entities, bases) follow a similar naming convention (spawnEnt, spawn_ent, SpawnEnt, etc.)

	GIST:
	making games in this engine is easy
	you have states, based off of your room string, that will clone entity classes based on the string
	the active entities (or classes) are added to the ents{} table, which is iterated over. everything in this table is drawn, updated, and more (found in the entities.lua file)
	entities are essentially instances of classes. classes are often the subclass of the omnipotent Entity class, which is every game object's parent. This Entity class purely sets the class' name, x, and y value
	children (subclasses) of this class will often take different arguments, such as an ID or type to define what it is.

]]

require 'utils'
require 'game'
require 'lib.entities'

--x and y position of the finger
cx = 0
cy = 0

--room id
room = ""

function love.load()
	changeRoom("hunt")

end

function love.update(dt)
	updateEnts(dt) --update the ents
end

function love.draw()
	drawEnts() --draw the ents
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
	if rm == "hunt" then
		--spawn toolbar
		spawn_ent("tbar", tbar, toolbar, 40, 222)

		--spawn monster
		local enc = encounter:new("enc", 25, 46, "monster")
		create_ent(enc)

		spawnParty()

		--spawn toolbar items
		spawnItems()


	elseif rm == "second" then
	end
end

if phone == false then
	require("lib.LADS").hook()
end
