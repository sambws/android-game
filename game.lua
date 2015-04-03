pilot = {}
pilot[0] = "qwe"
pilot[1] = "asd"
pilot[2] = "zxc"

weapon = {}
weapon[0] = ""
weapon[1] = ""
weapon[2] = ""

model = {}
model[0] = ""
model[1] = ""
model[2] = ""

function spawnParty()
	--will spawn the hunting party
	local mech1 = mech:new("mech1", 239, 110, "lancer", 0)
	create_ent(mech1)
	local mech2 = mech:new("mech2", 317, 110, "lancer", 1)
	create_ent(mech2)
	local mech3 = mech:new("mech3", 395, 110, "gunner", 2)
	create_ent(mech3)
end

function spawnItems()
	--spawn toolbar items
	local item1 = item:new("item1", 72, 231, 0)
	local item2 = item:new("item2", 224, 231, 1)
	local item3 = item:new("item3", 376, 231, 2)
	create_ent(item1)
	create_ent(item2)
	create_ent(item3)
end