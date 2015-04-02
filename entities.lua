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
 

	--if ents[obj].die then
		---run the die function
	--	ents[obj]:die()
	--end
	--remove it from the table
	--table.remove(ents, obj)
end

--create a local entity and add it straight to the table
function spawn_ent(name, obj, class, x, y)
	local obj = class:new(x, y, name)
	create_ent(obj)
end