if not GMF then include ("variables.lua") end

teams = {}

--function teams.Initialize ()
	for i = 1, 4 do
		Msg ("Creating team "..GMF.teams[i].name.." . . .\n")
		team.SetUp (i, GMF.teams[i].name, GMF.teams[i].color.brighter)
	end
--end

--hook.Add ("Initialize", "t.I", teams.Initialize)

function teams.PlayerInitialSpawn(pl)
	if CLIENT then return end
	Msg ("allocating team for "..pl:Nick().." . . .\n")
	local smallestTeam, smallestTeamSize = 1, 10
	for ti, t in pairs(GMF.teams) do
		local ts = #team.GetPlayers(ti)
		Msg ("team "..team.GetName(ti).." has "..ts.." players.\n")
		if ts < smallestTeamSize then
			Msg ("this is our new selection.\n")
			smallestTeam = ti
			smallestTeamSize = ts
		end
	end 
	pl:SetTeam (smallestTeam)
	Msg ("chosen team "..smallestTeam..".\n")
	for k,v in pairs (team.GetPlayers(smallestTeam)) do
		Msg ("team player "..v:Name().."\n")
	end
end

hook.Add ("PlayerInitialSpawn", "t.PIS", teams.PlayerInitialSpawn)