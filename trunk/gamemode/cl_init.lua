for k,v in pairs (file.Find ("../gamemodes/geofortsplus/gamemode/client/*.lua")) do
	Msg ("Loading client/"..v.." . . .\n")
	include ("client/"..v)
end
