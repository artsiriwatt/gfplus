return

if SERVER then
	folder = "../gamemodes/"..GMName.."/gamemode/shared/upgrades/"
else
	folder = "../lua/_downloaded/lua/"..GMName.."/gamemode/shared/upgrades/"
end

upgrades = {}

upgrademt = {}

function upgrademt:New ()
	t = table.Copy (self)
	return t
end

UPGRADE = upgrademt:New ()
include ("upgrades/default.lua")
upgrades.default = UPGRADE

local function AddNewUpgrade (filename)
	--only temporary (horrible derivision technique)
		UPGRADE = upgrademt:New ()
		include ("upgrades/"..filename)
		if not UPGRADE.Base then UPGRADE.Base = "default" end
		if upgrades[UPGRADE.Base] then
			newupgrade = table.Copy (upgrades[UPGRADE.Base])
			table.Merge (newupgrade, UPGRADE)
		else
			if file.Exists (folder..UPGRADE.Base..".lua") then
				AddNewUpgrade (UPGRADE.Base..".lua")
				newupgrade = table.Copy (upgrades[UPGRADE.Base])
				table.Merge (newupgrade, UPGRADE)
			else
				Msg ("Invalid base file, skipping\n")
			end
		end
		upgrades[string.gsub(filename, ".lua", "")] = newupgrade
end

for k,v in pairs (file.Find (folder.."*.lua")) do
	if v != "default.lua" then
		AddNewUpgrade (v)
	end
	AddCSLuaFile ("upgrades/"..v)
end

for k,v in pairs (upgrades) do
	--if k != "default" then
		Msg ("\nupgrade "..k..":\n")
		Msg ("name: "..tostring(v.TypeName).."\ndescription: "..tostring(v.TypeDescription).."\n--LEVELS:\n")
		for k2,v2 in pairs (v.Levels) do
			Msg ("lv"..k2..": "..v2[1].." ("..v2[3].."c)\n")
		end
		Msg ("\n")
	--end
end
