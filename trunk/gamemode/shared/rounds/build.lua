ROUND.Name = "Build"
ROUND.Description = {}
ROUND.Length = 10

function ROUND:PlayerSpawn (pl)
	pl:StripWeapons ()
	pl:Give ("weapon_physgun")
	pl:Give ("weapon_physcannon")
end

function ROUND:End ()
	return "fight"
end
