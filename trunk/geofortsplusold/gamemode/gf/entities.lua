function GF:FindEntities()
	self.spawns = {}
	local spawns = ents.FindByClass("gf_playerspawn")
	for _, spawn in pairs(spawns) do
		local i = spawn:GetSkin()
		if not self.spawns[i] then
			self.spawns[i] = {}
			self.teams[i].open = true
		end
		table.insert(self.spawns[i], spawn)
		spawn.defaultPos = spawn:GetPos()
		spawn.defaultAng = spawn:GetAngles()
	end

	self.spawnsQualify = {}
	local spawns = ents.FindByClass("gf_qualifyspawn")
	for _, spawn in pairs(spawns) do
		local i = spawn:GetSkin()
		if not self.spawnsQualify[i] then
			self.spawnsQualify[i] = {}
		end
		table.insert(self.spawnsQualify[i], spawn)
		spawn:PhysicsInit(SOLID_NONE)
		spawn:SetMoveType(MOVETYPE_NONE)
		spawn:SetSolid(SOLID_NONE)
		spawn:SetCollisionGroup(COLLISION_GROUP_NONE)
		spawn.defaultPos = spawn:GetPos()
		spawn.defaultAng = spawn:GetAngles()
	end

	self.flags = {}
	local flags = ents.FindByClass("gf_flag")
	for _, flag in pairs(flags) do
		local i = flag:GetTable().team
		if not self.flags[i] then
			self.flags[i] = {}
		end
		table.insert(self.flags[i], flag)
		flag.defaultPos = flag:GetPos()
		flag.defaultAng = flag:GetAngles()
	end

	local spawners = ents.FindByClass("gf_bb_spawner")
	for _, spawner in pairs(spawners) do
		spawner.defaultPos = spawner:GetPos()
		spawner.defaultAng = spawner:GetAngles()
	end
end

function GF:FindSpawns(teamIndex)
	if self.round == self.ROUND_QUALIFY then
		return self.spawnsQualify[teamIndex]
	else
		return self.spawns[teamIndex]
	end
end

-- fire the events on the gf_gametimer entities
function GF:FireOutputs(event)
	for _, gametimer in pairs(ents.FindByClass("gf_gametimer")) do
		local outputs = gametimer:GetTable()[event] or {}
		for i, output in pairs(outputs) do
			for _, ent in pairs(ents.FindByName(output.entity)) do
				ent:Fire(output.input, output.parameter, output.delay)
			end
			if output.repetitions > 0 then
				output.repetitions = output.repetitions - 1
			elseif outputs.repetitions == 0 then
				outputs[i] = nil
			end
		end
	end
end

function GF:IsSpawnBlocked(ply, spawn)
	local t = {}
	t.start = spawn:GetPos() + spawn:GetUp() * 16
	t.endpos = t.start + spawn:GetUp() * 72
	t.filter = {ply, spawn}
	local tr = util.TraceLine(t)
	return tr.Hit, tr.Entity
end

-- prepare entities for a fight round
function GF:PrepareEntities()
	for _, teamFlags in pairs(self.flags) do
		for _, flag in pairs(teamFlags) do
			flag.roundPos = flag:GetPos()
			flag.roundAng = flag:GetAngles()
			flag:SetHome()
		end
	end
	local classes = {"gf_playerspawn", "gf_scoreboard", "gf_timeboard", "gf_bb_spawner"}
	for _, class in pairs(classes) do
		for _, ent in pairs(ents.FindByClass(class)) do
			ent.roundPos = ent:GetPos()
			ent.roundAng = ent:GetAngles()
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end
		end
	end
	for k,ent in pairs(ents.FindByName("gfbb")) do
		ent.roundPos = ent:GetPos()
		ent.roundAng = ent:GetAngles()
		ent:SetCollisionGroup(COLLISION_GROUP_NONE)
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
end

-- restore entities to their former glory for the build round
function GF:RestoreEntities()
	for _, teamFlags in pairs(GF.flags) do
		for _, flag in pairs(teamFlags) do
			flag:Extinguish()
			flag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			flag:ReturnToHome()
		end
	end
	local classes = {"gf_playerspawn", "gf_scoreboard", "gf_timeboard", "gf_bb_spawner"}
	for _, class in pairs(classes) do
		for _, ent in pairs(ents.FindByClass(class)) do
			ent:Extinguish()
			if ent.roundPos then
				ent:SetPos(ent.roundPos)
				ent:SetAngles(ent.roundAng)
			end
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end
		end
	end
	for k,ent in pairs(ents.FindByName("gfbb")) do
		ent:Extinguish()
		if ent.roundPos then
			ent:SetPos(ent.roundPos)
			ent:SetAngles(ent.roundAng)
		end
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
end
