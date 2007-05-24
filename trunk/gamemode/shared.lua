GM.Name 	= "GeoForts+"
GM.Author 	= "The GF+ Team (original GeoForts Night-Eagle)"
GM.Email 	= ""
GM.Website 	= "http://gmod.phuce.com"

for k,v in pairs (file.Find ("../gamemodes/geofortsplus/gamemode/shared/*.lua")) do
	Msg ("Loading shared/"..v.." . . .\n")
	AddCSLuaFile ("shared/"..v)
	include ("shared/"..v)
end
