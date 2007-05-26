roundcycle = {
	round = {}
}

function roundcycle.BeginCycle ()
	Msg ("Entities created. Continuing to begin round cycle . . .\n")
	roundcycle:BeginRound (GFV.startRound)
	roundcycle.round:Begin ()
end

hook.Add ("InitPostEntity", "roundcycle.BeginCycle", roundcycle.BeginCycle)

function roundcycle:BeginRound (rname)
	self.round = rounds[rname]
	self.round:Begin ()
	self.roundTime = self.round.Length
end
