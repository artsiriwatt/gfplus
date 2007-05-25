rounds = {}

roundmt = {}

function roundmt:New ()
	t = table.Copy (self)
	return t
end

ROUND = roundmt:New ()
include ("rounds/default.lua")
rounds.default = ROUND

local function AddNewRound (filename)
	--only temporary
		ROUND = roundmt:New ()
		include ("rounds/"..filename)
		if not ROUND.Base then ROUND.Base = "default" end
		if rounds[ROUND.Base] then
			newround = table.Copy (rounds[ROUND.Base])
			table.Merge (newround, ROUND)
		else
			if file.Exists ("../gamemodes/geofortsplus/gamemode/shared/rounds/"..ROUND.Base..".lua") then
				AddNewRound (ROUND.Base..".lua")
				newround = table.Copy (rounds[ROUND.Base])
				table.Merge (newround, ROUND)
			else
				Msg ("Invalid base file, skipping\n")
			end
		end
		rounds[string.gsub(filename, ".lua", "")] = newround
end

for k,v in pairs (file.Find ("../gamemodes/geofortsplus/gamemode/shared/rounds/*.lua")) do
	if v != "default.lua" then
		AddNewRound (v)
	end
end

for k,v in pairs (rounds) do
	--if k != "default" then
		Msg ("round "..k..":\n")
		Msg ("name: "..tostring(v.Name).."\n")
		Msg ("length: "..tostring(v.Length).."\n\n")
	--end
end
