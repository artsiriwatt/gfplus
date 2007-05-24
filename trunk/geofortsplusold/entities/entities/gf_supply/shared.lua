ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.players = {}
ENT.sound = Sound("buttons/combine_button7.wav")
ENT.offset = -1.6
ENT.x = -152
ENT.y = -72
ENT.w = 304
ENT.h = 144

function ENT:Cursor(ply)
	if not ply.cursorTrace then ply:CursorTrace() end
	local v = self.Entity:WorldToLocal(ply.cursorTrace.HitPos)
	cursor = {onPanel = false, x = 0, y = 0}
	if v.x + 1 > self.offset - 0.7 and v.x + 0.8 < self.offset then
		cursor.x = math.Round( v.z * 4 - self.x)
		cursor.y = math.Round(-v.y * 4 - self.y)
		if ply.cursorTrace.Entity == self.Entity and cursor.x >= 0 and cursor.x < self.w and cursor.y >= 0 and cursor.y < self.h then
			if cursor.x < self.w * 0.5 then
				cursor.onPanel = 1
			else
				cursor.onPanel = 2
			end
		end
	end
	return cursor
end

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel("models/buildingblocks/2d_1_2.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	else
		self.color = team.GetColor(self.Entity:GetSkin())
		self.logo = surface.GetTextureID("buildingblocks/logowhite")
	end
end
