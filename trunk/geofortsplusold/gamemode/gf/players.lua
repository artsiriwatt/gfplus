function GF:AutoBalance()
	local numPlayers = 0
	local numPlayersOnTeam = {}
	local teams = {}
	for ti, t in pairs(self.teams) do
		local i = team.NumPlayers(ti)
		if i > 0 then
			numPlayersOnTeam[ti] = i 
			numPlayers = numPlayers + i
			table.insert(teams, ti)
		end
	end
	-- don't autobalance if there's only one populated team
	if #teams > 1 then
		-- how many players should there be on each team?
		local playersPerTeam = math.ceil(numPlayers / #teams)
		local playersToSwitch = {}
		for _, ti in pairs(teams) do
			local i = numPlayersOnTeam[ti] 
			while i > playersPerTeam do
				local latestTime, latestPlayer = 0, nil
				for _, ply in pairs(team.GetPlayers(ti)) do
					local time = ply.joinedTeamAt or CurTime()
					if time > latestTime then
						latestTime = time
						latestPlayer = ply
					end
				end
				print(latestPlayer)
				table.insert(playersToSwitch, latestPlayer)
				i = i - 1
			end
		end
		-- do we need to switch anyone?
		if #playersToSwitch > 0 then
			for _, ply in pairs(player.GetAll()) do
				ply:PrintMessage(HUD_PRINTCENTER, "Autobalancing teams....")
			end
		end
		-- switch them
		for _, ti in pairs(teams) do
			local i = numPlayersOnTeam[ti]
			if i < playersPerTeam then
				while i < playersPerTeam do
					if #playersToSwitch <= 0 then
						break
					end
					local j = math.random(#playersToSwitch)
					playersToSwitch[j]:SetTeam(ti)
					playersToSwitch[j]:Spawn()
					table.remove(playersToSwitch, j)
					i = i - 1
				end
			end
		end 
	end
	timer.Simple(20, self.AutoBalance, self)
end

function GF:CleanupPlayer(ply, quit)
	if not ply.gf then return end
	if ply.gf.flag then
		if ply.gf.flag.state == GF.FLAG_GRABBED then
			ply.gf.flag:Dropped()
		end
		ply.gf.flag = nil
	end
end

function GF:InitializePlayer(ply)
	if not ply.gf then
		ply.gf = {}
	end
	ply.gf.flag = nil
	if not ply.gf.primary then
		ply:SetPrimaryWeapon(1)
	end
	if not ply.gf.secondary then
		ply:SetSecondaryWeapon(1)
	end
end

function GF:SendRoundMessage(ply)
	umsg.Start("round", ply)
	umsg.Short(GF.round)
	umsg.Float(GF.roundTimer)
	umsg.Short(GF.roundsLeft)
	umsg.End()
end

function GF:SendTeamsMessage(ply)
	umsg.Start("teams", ply)
	umsg.Long(#self.teams)
	for _, t in pairs(self.teams) do
		umsg.Bool(t.open)
		umsg.Long(t.score)
		umsg.Float(t.qualify)
	end
	umsg.End()
end

function GF:SendEndGameMessage(ply)
	umsg.Start("endgame", ply)
	umsg.End()
end

function GF:Spawn(ply)
	-- choose a random spawnpoint
	local spawn = GAMEMODE:PlayerSelectSpawn(ply)

	-- make sure there isn't anything in the way
	local blocked, blocker = self:IsSpawnBlocked(ply, spawn)
	if blocked then
		self.spawnBlockers[blocker] = (self.spawnBlockers[blocker] or 0) + 1
		if self.spawnBlockers[blocker] >= 3 then
			if blocker:GetClass() == "player" then
				blocker.gf.spawnTimer = CurTime() + 1
				blocker:Kill()
			elseif blocker:GetName() == "gfbb" or blocker:GetClass() == "gf_scoreboard" or blocker:GetClass() == "gf_timeboard" then
				blocker:Remove()
			elseif blocker:GetClass() == "gf_bb_spawner" then
				-- [CP] this was v:GetPhysicsObject??? wtf is this section trying to do anyway
				blocker:Spawn()
				local phys = blocker:GetPhysicsObject()
				if phys:IsValid() then
					phys:EnableMotion(false)
				end
			end		
		end
		return
	end

	-- spawn the player
	ply.gf.spawnTimer = nil
	ply:UnSpectate()
	ply:SetAngles(spawn:GetAngles())
	ply:SetPos(spawn:GetPos() + Vector(0,0,16))
	timer.Simple(3, ply.SetMaterial, ply, "")
	ply:SetMaterial("models/spawn_effect")

	-- assign a team color
	if GF.teams[ply:Team()] then
		local c = GF.teams[ply:Team()].color.player
		ply:SetColor(c.r, c.g, c.b, c.a)
	else
		ply:SetColor(255, 255, 255, 255)
	end
	ply:SetRenderMode(RENDERMODE_NORMAL)
	
	--set player collision type
	if self.round == self.ROUND_QUALIFY then
		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	else
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end
	
	if self.rounds[self.round].weapons == self.WEAPONS_FIGHTING then
		timer.Simple (2, GF.IssueEquipment, GF, ply)
	else
		GF:IssueEquipment(ply)
	end
	ply:SetVar ("invulnerability", CurTime() + 3)
end

function GF:IssueEquipment(ply)
	-- give em the appropriate weapons
	if self.rounds[self.round].weapons == self.WEAPONS_BUILDING then
		ply:Give("weapon_physcannon")
		ply:Give("weapon_physgun")
	elseif self.rounds[self.round].weapons == self.WEAPONS_FIGHTING then
		ply:Give(ply.gf.primary.Classname)
		ply:Give(ply.gf.secondary.Classname)
		ply:GiveAmmo(50,ply.gf.primary.Primary.Ammo)
		ply:GiveAmmo(50,ply.gf.secondary.Primary.Ammo)
		ply:Give("weapon_crowbar")
		if ply:IsSuperAdmin() then
			ply:Give("weapon_c4")
		end
	end
	local w = ply:GetInfo("cl_defaultweapon")
	if ply:HasWeapon(w) then
		ply:SelectWeapon(w)
	end
end

function GF:SpawnQueue(ply)
	self.spawnBlockers[ply] = nil
	ply.gf.spawnTimer = CurTime() + self.DELAY_RESPAWN
	ply:SetPos(ply:GetPos() + Vector(0, 0, 16))
	ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	if self.round != self.ROUND_QUALIFY then
		ply:SetColor(255, 255, 255, 100)
		ply:SetRenderMode(RENDERMODE_TRANSTEXTURE)
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(GAMEMODE:PlayerSelectSpawn(ply))
		ply:StripAmmo()
		ply:StripWeapons()
	end	
end

function GF:SpawnThink()
	if self.round == self.ROUND_QUALIFY then
		return
	end
	if self.spawnQueueTimer < CurTime() then
		for _, ply in pairs(player.GetAll()) do
			if ply.gf.spawnTimer and ply.gf.spawnTimer < CurTime() then
				ply:Spawn()
			end
		end
		self.spawnQueueTimer = CurTime() + 1
	end
end
