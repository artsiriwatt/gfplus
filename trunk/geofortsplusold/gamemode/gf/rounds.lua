--finishes everything
function GF:EndGame()
	for _, ply in pairs(player.GetAll()) do
		ply:StripWeapons()
		ply:Lock() -- lame attempt at stopping people shooting everything
		self:SendEndGameMessage(ply)
	end
	timer.Simple(15, self.Commands.NextMap)
end

-- mark a team as qualified
function GF:Qualify(ply)
	self.teams[ply:Team()].qualify = ((self.roundTimer - CurTime()) / (self.rounds[self.ROUND_QUALIFY].time * 2)) + .5
	local s = ply:Nick() .. " has qualified the " .. self.teams[ply:Team()].name .. " team."
	for _, p in pairs(player.GetAll()) do
		p:PrintMessage(HUD_PRINTTALK, s)
	end
end

-- called each frame for round logic
function GF:RoundThink()
	local ready = false

	if self.round == self.ROUND_QUALIFY then
		ready = true
		for i = 1,4 do
			if self.teams[i].qualify == 0/* and #GF.spawns[i] > 0*/ and team.NumPlayers(i) > 0 then
				ready = false
			end
		end
	end

	if self.roundTimer < CurTime() or ready then
		//Change the round
		if self.round > 1 then
			self.round = self.round + 1
			if self.round > self.ROUND_FIGHT then
				self.round = self.ROUND_BUILD
			end
			self.roundTimer = CurTime() + self.rounds[self.round].time
		else
			self.round = self.ROUND_BUILD
			self.roundTimer = CurTime() + self.rounds[self.round].initialTime
		end
		
		if self.round == self.ROUND_BUILD then
			self:StartBuild()
			self:FireOutputs("OnBuild")
		elseif self.round == self.ROUND_QUALIFY then
			self:StartQualify()
			self:FireOutputs("OnQualify")
		elseif self.round == self.ROUND_FIGHT then
			self:StartFight()
			self:FireOutputs("OnFight")
		end
		
		for k,v in pairs(ents.FindByClass("gf_playerspawn")) do
			v:SetAngles(Angle(0,v:GetAngles().y,0))
		end
		
		GF:SendRoundMessage()
		GF:SendTeamsMessage()
		for k,pl in pairs(player.GetAll()) do
			if pl:IsValid() and pl:IsConnected() then
				GF:CleanupPlayer(pl)
				pl:StripAmmo()
				pl:StripWeapons()
				pl:Spawn()
				--[[if self.round == self.ROUND_QUALIFY then
					pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				elseif self.round == self.ROUND_FIGHT then
					pl:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end]]
				pl.gf.spawnTimer = 0
			end
		end
	end
end

-- start the build round
function GF:StartBuild()
	GF.roundsLeft = GF.roundsLeft - 1
	if GF.roundsLeft < 0 then
		--we've run out of rounds
		GF:EndGame()
	end
	for k,v in pairs(ents.FindByClass("gf_qualifyspawn")) do
		v:PhysicsInit( SOLID_NONE )
		v:SetMoveType( MOVETYPE_NONE )
		v:SetSolid( SOLID_NONE )
		v:SetCollisionGroup( COLLISION_GROUP_NONE )
	end
	for k,v in pairs(ents.FindByClass("gf_flag")) do
		v:SetSolid(SOLID_VPHYSICS)
	end
	GF:RestoreEntities()
	GFHS:HookCall ("BuildStarted")
end

-- start the fight round
function GF:StartFight()
	for k,v in pairs(ents.FindByClass("gf_qualifyspawn")) do
		v:PhysicsInit( SOLID_NONE )
		v:SetMoveType( MOVETYPE_NONE )
		v:SetSolid( SOLID_NONE )
		v:SetCollisionGroup( COLLISION_GROUP_NONE )
	end
	for iteam = 1,4 do
		if self.teams[iteam].qualify and self.teams[iteam].qualify == 0 then
			self.teams[iteam].qualify = self.PENALTY_NOCAPTURE
		end
	end
	for k,v in pairs(ents.FindByClass("gf_flag")) do
		v:SetSolid(SOLID_VPHYSICS)
	end
	GFHS:HookCall ("FightStarted")
end

-- start the qualification round
function GF:StartQualify()
	for _, t in pairs(self.teams) do
		t.qualify = 0
	end
	for _, spawn in pairs(ents.FindByClass("gf_qualifyspawn")) do
		spawn:PhysicsInit(SOLID_VPHYSICS)
		spawn:SetMoveType(MOVETYPE_NONE)
		spawn:SetSolid(SOLID_VPHYSICS)
		spawn:SetCollisionGroup(COLLISION_GROUP_NONE)
	end
	for k,v in pairs(ents.FindByClass("gf_flag")) do
		v:SetSolid(SOLID_NONE)
	end
	GF:PrepareEntities()
	GFHS:HookCall ("QualifyStarted")
end
