AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.OnBuild = {}
ENT.OnQualify = {}
ENT.OnFight = {}

function ENT:KeyValue(key, value)
	if key == "OnBuild" or key == "OnQualify" or key == "OnFight" then
		value = string.Explode(",", string.gsub(value, ",,", ", ,"))
		table.insert(self[key], {entity = value[1], input = value[2], parameter = value[3], delay = tonumber(value[4]), repetitions = tonumber(value[5])})
	end
end
