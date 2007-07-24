function ENT:Initialize()
	self.Entity:SetModel ("models/buildingblocks/playerspawn_1.mdl")
	self.Entity:PhysicsInit (SOLID_VPHYSICS)
	self.Entity:SetMoveType (MOVETYPE_VPHYSICS)
	self.Entity:SetSolid (SOLID_VPHYSICS)
end
