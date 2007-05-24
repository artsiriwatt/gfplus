GF.Messages = {}

function GF.Messages.EndGame(bf)
	GF:ShowEndGame()
end
usermessage.Hook("endgame", GF.Messages.EndGame)

function GF.Messages.Round(bf)
	local oldRound = GF.round
	GF.round = bf:ReadShort()
	GF.roundTimer = bf:ReadFloat()
	GF.roundsLeft = bf:ReadShort()
	if GF.round != oldRound then
		GF:ShowRound()
	end
end
usermessage.Hook("round", GF.Messages.Round)

function GF.Messages.SetPrimaryWeapon(bf)
	LocalPlayer():SetPrimaryWeapon(bf:ReadShort())
end
usermessage.Hook("gfm_primary", GF.Messages.SetPrimaryWeapon)

function GF.Messages.SetSecondaryWeapon(bf)
	LocalPlayer():SetSecondaryWeapon(bf:ReadShort())
end
usermessage.Hook("gfm_secondary", GF.Messages.SetSecondaryWeapon)

function GF.Messages.Teams(bf)
	local numTeams = bf:ReadLong()
	for i = 1, numTeams do
		GF.teams[i].open = bf:ReadBool()
		GF.teams[i].score = bf:ReadLong()
		GF.teams[i].qualify = bf:ReadFloat()
	end 
end
usermessage.Hook("teams", GF.Messages.Teams)
