ROUND.Name = "Preround"
ROUND.Description = {}
ROUND.Length = 15

function ROUND:Think ()
	--Msg ("preround thinking . . .\n")
end

function ROUND:PlayerSpawn (pl)
	pl:StripWeapons ()
	pl:StripAmmo ()
	pl:Give ("weapon_smg1")
	pl:GiveAmmo (225, "smg1")
end

function ROUND:End ()
	return "initialbuild"
end
