include('shared.lua')

function ENT:Initialize()
	Sound("items/battery_pickup.wav")
end

function ENT:Draw()
	self.Entity:DrawModel()
end
