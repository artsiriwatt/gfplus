function GM:OnPhysgunFreeze(weapon, phys, ent, ply)
	if type(ent) == "Entity" and ent:GetClass() == "gf_playerspawn" then
		ent:SetAngles(Angle(0, ent:GetAngles().y, 0))
	end
	phys:EnableMotion(false)
end

function GM:PhysgunPickup(ply, ent)
	local c = ent:GetClass()
	if ent:GetName() == "gfbb" or c == "gf_bb_spawner" or c == "gf_flag" or c == "gf_playerspawn" or c == "gf_scoreboard" or c == "gf_timeboard" then
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		return true
	end
	return false	  
end

function GM:PhysgunDrop(ply, ent)
	if ent and ent:IsValid() then
		ent:SetCollisionGroup(COLLISION_GROUP_NONE)
	end
end

function GF:SpawnBlock(pl, block)
	local blocks = {
		{"models/buildingblocks/3d_1_2.mdl",Angle(0,0,0)},
		{"models/buildingblocks/3d_1_1.mdl",Angle(0,0,0)},
		{"models/buildingblocks/2d_1_8.mdl",Angle(90,90,0)},
		{"models/buildingblocks/2d_2_3.mdl",Angle(90,0,0)},
		{"models/buildingblocks/2d_1_2.mdl",Angle(90,90,0)},
		{"gf_scoreboard",Angle(90,90,0)},
		{"gf_timeboard",Angle(90,90,0)},
		{"gf_supply",Angle(90,90,0)},
		}
	if GF.round == 2 and pl:Team() > 0 and pl:Team() <= 4 then
		local id = pl:UniqueID()
		
		local ent
		local acc = -1
		for k,entity in pairs(ents.FindByClass("gf_bb_spawner")) do
			if (pl:GetShootPos() - entity:GetPos()):Length() < 200 then
				local ang = ((entity:GetPos() - pl:GetShootPos()):GetNormalized()):DotProduct(pl:GetAimVector())
				if ang > acc then
					ent = entity
					acc = ang
				end
			end
		end
		
		if ent then
			local self = ent:GetTable()
			if not self.timer[id] or self.timer[id] < CurTime() - self.delay then
				self.timer[id] = CurTime()
				if blocks[block] then
					local trace = {}
						trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 32
						trace.endpos = self.Entity:GetUp() * 68 + trace.start
						trace.filter = self.Entity
					local trace = util.TraceLine(trace)				
					
					if not trace.Hit then
						if string.find(blocks[block][1],".mdl",nil,true) then
							local bb = ents.Create("prop_physics")
							bb:SetModel(blocks[block][1])
							bb:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 64)
							bb:SetAngles(self.Entity:GetAngles() + blocks[block][2])
							bb:SetSkin(pl:Team())
							bb:SetName("gfbb")
							bb:Spawn()
						else
							local bb = ents.Create(blocks[block][1])
							bb:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 64)
							bb:SetAngles(self.Entity:GetAngles() + blocks[block][2])
							bb:SetSkin(pl:Team())
							bb:SetName("gfbb")
							bb:Spawn()
						end
						
						self.Entity:EmitSound(Sound("buttons/combine_button7.wav"))
					end
				end
			end
		end
	end
	hook.Call ("PlayerSpawnedBlock", GFHS, pl, block)
end

function GM.ccgfa(pl,cmd,args)
	local gm = gmod.GetGamemode()
	local ent = ents.GetByIndex(args[2])
	local type = tonumber(args[1])
	if (not ent) or (not type) then
		return
	end
	
	if ent:IsValid() and (pl:GetShootPos()-ent:GetPos()):Length() < 64 then
		ent:GetTable().leeches[pl] = type
	end
end
concommand.Add("gfa",GM.ccgfa)
