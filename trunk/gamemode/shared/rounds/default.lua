ROUND.Base = "default"

ROUND.Name = "Default"
ROUND.Description = {}
ROUND.Length = 3

function ROUND:Begin ()
	for k,v in pairs(player.GetAll()) do
		v:Spawn ()
	end
end

function ROUND:Think ()
	
end

function ROUND:End ()
	return "default"
end
