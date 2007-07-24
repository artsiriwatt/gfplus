function GM:PlayerSpawn (pl) end
function GM:PlayerInitialSpawn (pl)
	umsg.Start ("intro", pl)
	umsg.End ()
end
