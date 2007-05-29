roundcycle = {
	round = {}
}

function roundcycle.BeginCycle ()
	Msg ("Entities created. Continuing to begin round cycle . . .\n")
	roundcycle:BeginRound (GMF.startRound)
	roundcycle.round:Begin ()
end

hook.Add ("InitPostEntity", "roundcycle.BeginCycle", roundcycle.BeginCycle)

function roundcycle:BeginRound (rname)
	Msg ("beginning round "..rname.." . . .\n")
	self.round = rounds[rname]
	self.round:Begin ()
	self.roundTime = self.round.Length
	self.roundStart = CurTime ()
	--sync with the client here
end

function roundcycle.Think ()
	roundcycle:CheckRoundTime ()
end

hook.Add ("Think", "roundcycle.Think", roundcycle.Think)

function roundcycle:CheckRoundTime ()
	self.roundTime = self.round.Length - (CurTime() - self.roundStart)
	if self.roundTime < 0 then
		roundcycle:EndRound ()
	end
end

function roundcycle:EndRound ()
	Msg ("ending round "..self.round.Name.." . . .\n")
	local nround = self.round:End ()
	if type(nround) == "string" then
		roundcycle:BeginRound (nround)
	else
		Msg ("round has no sequel!\n")
	end
end
