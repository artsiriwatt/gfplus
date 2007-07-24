ROUND.Name = "Fight"
ROUND.Description = {}
ROUND.Length = 45

function ROUND:PlayerSpawn (pl)
	pl:StripWeapons ()
	pl:StripAmmo ()
	pl:IssueEquipment ()
end

function ROUND:End ()
	return "build"
end
