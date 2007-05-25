roundcycle = {
	round = {}
}

function roundcycle.BeginCycle ()
	Msg ("Entities created. Continuing to begin round cycle . . .\n")
	roundcycle.round = rounds[GFV.round]
	roundcycle.round:Begin ()
end

hook.Add ("InitPostEntity", "roundcycle.BeginCycle", roundcycle.BeginCycle)