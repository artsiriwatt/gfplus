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
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
end

function ENT:Use()
end

function ENT:Think()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
