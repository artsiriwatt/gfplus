AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")

include ("cl_init.lua")
include ("shared.lua")

for k,v in pairs (file.Find ("../gamemodes/geofortsplus/gamemode/server/*.lua")) do
	Msg ("Loading server/"..v.." . . .\n")
	AddCSLuaFile ("server/"..v)
	include ("server/"..v)
end

for k,v in pairs (file.Find ("../gamemodes/geofortsplus/gamemode/client/*.lua")) do
	Msg ("Making available clientside client/"..v.." . . .\n")
	AddCSLuaFile ("client/"..v)
end