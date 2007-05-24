AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:CanBeGrabbed()
	if GF.round == GF.ROUND_PRE or GF.round == GF.ROUND_BUILD then return false end
	if GF.teams[self.team].qualify == GF.PENALTY_NOCAPTURE then return false end
	if self.state == GF.FLAG_GRABBED then return false end
	return true
end

function ENT:CanBeGrabbedBy(ply)
	if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() then return false end
	if GF.round == GF.ROUND_PRE or GF.round == GF.ROUND_BUILD then return false end
	if GF.teams[ply:Team()].qualify == GF_PENALTY_NOCAPTURE then return false end
	if self.state == GF.FLAG_GRABBED then return false end
	return true
end

-- the flag has been dropped by the carrier
function ENT:Dropped()
	self.Entity:SetParent(nil)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end
	self.Entity:SetPos(self.Entity:GetPos() - Vector(0, 0, 28))
	self.state = GF.FLAG_DROPPED
	self.returnTimer = CurTime() + GF.DELAY_FLAGRETURN
	GFHS:HookCall ("FlagDropped", self.team)
end

-- the flag has been picked up by a player
function ENT:Grabbed(ply)
	self.Entity:SetPos(ply:GetPos() + Vector(0, 0, 84))
	self.Entity:SetParent(ply)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	self.state = GF.FLAG_GRABBED
	self.returnTimer = nil
end

function ENT:Initialize()
	self.Entity:SetModel("models/roller_spikes.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:KeyValue(key, value)
	if key == "TeamNum" then
		local i = tonumber(value)
		if i > 0 and i <= 4 then
			self.team = i
			local color = team.GetColor(i)
			self.Entity:SetColor(color.r, color.g, color.b, 255)
			self.Entity:SetRenderMode(RENDERMODE_TRANSTEXTURE)
		end
	end
end

-- return the flag to it's home position
function ENT:ReturnToHome()
	if self.roundPos and self.roundAng then
		self.state = GF.FLAG_HOME
		self.returnTimer = nil
		self.Entity:SetParent(nil)
		self.Entity:SetPos(self.roundPos)
		self.Entity:SetAngles(self.roundAng)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
end

-- set the flag's home position and lock it in place
function ENT:SetHome()
	self.state = GF.FLAG_HOME
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:Think()
	if self.returnTimer and self.returnTimer < CurTime() then
		self.returnTimer = nil
		self:ReturnToHome()
	end
	if ((self.soundTimer or 0) < CurTime()) and self:CanBeGrabbed() then
		local nearby = ents.FindInSphere(self.Entity:GetPos(), 10)
		for _, ply in pairs(nearby) do
			if self:CanBeGrabbedBy(ply) then
				self.soundTimer = CurTime() + 1
				self.Entity:EmitSound(Sound("items/battery_pickup.wav"))
				if GF.round == GF.ROUND_FIGHT then
					if self.team == ply:Team() then
						if self.state == GF.FLAG_DROPPED then
							self:ReturnToHome()
							ply:AddFrags(1)
							for _, p in pairs(player.GetAll()) do
								p:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " returned the " .. GF.teams[ply:Team()].name .. " flag.")
							end
							GFHS:HookCall ("FlagReturned", self.team, ply)
						elseif ply.gf.flag then
							-- score! (the team module is corrupt, so we have to use our own scoring system.)
							-- [CP] FIXME: team module is corrupt? wtf?
							-- [DEV] God damn, you write the best random code comments...
							for _, p in pairs(player.GetAll()) do
								p:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " captured the " .. GF.teams[ply.gf.flag.team].name .. " flag.")
							end
							GF.teams[ply:Team()].score = GF.teams[ply:Team()].score + 1
							-- GF.teams[ply.gf.flag.team].score = GF.teams[ply.gf.flag.team].score - 1
							ply:AddFrags(10)
							ply.gf.flag:ReturnToHome()
							ply.gf.flag = nil
							GF:SendTeamsMessage()
							GFHS:HookCall ("FlagCaptured", self.team, ply)
						end
					elseif not ply.gf.flag then
						ply.gf.flag = self
						self:Grabbed(ply)
						for _, p in pairs(player.GetAll()) do
							p:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " grabbed the " .. GF.teams[self.team].name .. " flag.")
						end
						GFHS:HookCall ("FlagGrabbed", self.team, ply)
					end
				elseif GF.round == GF.ROUND_QUALIFY then
					ply.gf.flag = self
				end 
				break
			end
		end
	end
end

function ENT:Use()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
