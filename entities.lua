ents = {}
path = "entities/"

--optimize this later; maybe make it so that every file in the folder is required
require(path .. "dragbox") --var table is "playertwo"
require(path .. "ok")
require(path .. "coolerbox")
require(path .. "button")

--create
function create_ent(obj)
	--add it to the table
	table.insert(ents, obj)
	if obj.load then
		--run the load function
		obj:load()
	end
end

--destroy ent by name defined in their table
function destroy_ent(obj)
	--loop through everything and delete it by name
	for i, e in pairs(ents) do
		if e.name == obj then
			print(obj .. " was destroyed")
			--let it die
			if e.die then
				e:die()
			end	
			table.remove(ents, i)
		end
	end
end

function updateEnts(dt)
	--update everything
	for i, e in pairs(ents) do
		if e.update
		and e.dead == false then
			e:update(dt)
		end
	end
end

function drawEnts()
	--draw everything
	for i, e in pairs(ents) do
		if e.draw
		and e.dead == false then
			e:draw()
		end
	end
end

function tapEnts(id, x, y, pressure)
	--activate all tap events
	for i, e in pairs(ents) do
		if e.tap
		and e.dead == false then
			e:tap(id, x, y, pressure)
		end
	end
end

function releaseEnts(id, x, y, pressure)
	--activate all release events
	for i, e in pairs(ents) do
		if e.released
		and e.dead == false then
			e:released(id, x, y, pressure)
		end
	end
end

function wipeEnts()
	--kill everything that isn't persistent
	for i, e in pairs(ents) do
		if e.persistent == false then
			if e.die then
				e:die()
			end
			table.remove(ents, i)
		end
	end
end

--create a local entity and add it straight to the table
function spawn_ent(name, obj, class, x, y)
	local obj = class:new(x, y, name)
	create_ent(obj)
end