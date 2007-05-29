ROUND.Name = "Fight"
ROUND.Description = {}
ROUND.Length = 45

function ROUND:PlayerSpawn (pl)
	pl:StripWeapons ()
	pl:StripAmmo ()
	pl:Give ("weapon_smg1")
	pl:GiveAmmo (225, "smg1")
end

function ROUND:End ()
	return "build"
end
