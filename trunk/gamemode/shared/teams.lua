teams = {}

function teams.Initialize ()
	for i = 1, 4 do
		team.SetUp(i, GMF.teams[i].name, GMF.teams[i].color.brighter)
	end
end

hook.Add ("Initialize", "t.I", teams.Initialize)