AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:OnRemove()
end

function ENT:KeyValue(key,value)
	if key == "skin" then
		local val = tonumber(value)
		if val >= 1 and val <= 4 then
			self.team = val
		end
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/buildingblocks/playerspawn_1.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
end

function ENT:Use()
end

function ENT:Think()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:StartTouch(ply)
	if not ply or not ply:IsValid() or not ply:IsPlayer() then return end
	if ply:Team() <= 0 or ply:Team() > 4 then return end 
	if not ply.gf.flag or GF.teams[ply:Team()].qualify != 0 then return end
	self.Entity:EmitSound(Sound("ambient/energy/weld" .. math.random(1, 2) .. ".wav"))
	ply.gf.flag = nil
	GF:Qualify(ply)
end
