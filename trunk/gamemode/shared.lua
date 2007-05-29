GMName = "gmforts"

--[[if CLIENT then
	for k,v in pairs (file.Find ("../lua/_downloaded/lua/"..GMName.."/gamemode/client/*.lua")) do
		Msg ("Loading client/"..v.." . . .\n")
		include ("_downloaded/lua/"..GMName.."/gamemode/client/"..v)
	end
else]]
	AddCSLuaFile ("shared.lua")

	GAMEMODE.Name 	= "GeoForts+"
	GAMEMODE.Author 	= "The GF+ Team (original GeoForts Night-Eagle)"
	GAMEMODE.Email 	= ""
	GAMEMODE.Website 	= "http://gmod.phuce.com"

	for k,v in pairs (file.Find ("../gamemodes/"..GMName.."/gamemode/shared/*.lua")) do
		Msg ("Loading shared/"..v.." . . .\n")
		--AddCSLuaFile ("shared/"..v)
		include ("shared/"..v)
	end
--end
