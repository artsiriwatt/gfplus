ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Spawnable			= false
ENT.AdminSpawnable		= true

ENT.sound = Sound("buttons/combine_button7.wav")
ENT.delay = 2
ENT.offset = 44.5
ENT.x = -56
ENT.y = -88
ENT.w = 112
ENT.h = 72 
ENT.blocks =
{
	[1] =
	{
		{x = 1,  y = 1,  w = 16, h = 32, command = "1"},
		{x = 18, y = 1,  w = 16, h = 16, command = "2"},
		{x = 35, y = 1,  w = 48, h = 16, command = "3"},
		{x = 84, y = 1,  w = 27, h = 38, command = "4"},
		{x = 56, y = 18, w = 27, h = 19, command = "5"},
		{x = ENT.w - 8, y = ENT.h - 12, w = 7, h = 11, command = 2, text = "S"},
	},
	[2] =
	{
		{x = 1, y = 2,  w = ENT.w - 2, h = 11, command = "6", text = "Scoreboard"},
		{x = 1, y = 15, w = ENT.w - 2, h = 11, command = "7", text = "Timer"},
		{x = 1, y = 28, w = ENT.w - 2, h = 11, command = "8", text = "Supply"},
	},
}

function ENT:Cursor(ply)
	if not ply.cursorTrace then ply:CursorTrace() end
	local v = self.Entity:WorldToLocal(ply.cursorTrace.HitPos)
	cursor = {onPanel = false, x = 0, y = 0}
	if v.x > self.offset - 0.7 and v.x < self.offset then
		cursor.x = math.Round( v.y * 4 - self.x)
		cursor.y = math.Round(-v.z * 4 - self.y)
		if ply.cursorTrace.Entity == self.Entity and cursor.x >= 0 and cursor.y >= 0 and cursor.x < self.w and cursor.y < self.h then
			cursor.onPanel = 1
		end
	elseif -v.x > self.offset - 0.7 and -v.x < self.offset then 
		cursor.x = math.Round(-v.y * 4 - self.x)
		cursor.y = math.Round(-v.z * 4 - self.y)
		if ply.cursorTrace.Entity == self.Entity and cursor.x >= 0 and cursor.y >= 0 and cursor.x < self.w and cursor.y < self.h then
			cursor.onPanel = 2
		end
	end
	return cursor
end

function ENT:CursorOnBlock(cursor, panel, block)
	if cursor.onPanel == panel and cursor.x >= block.x and cursor.x < block.x + block.w and cursor.y >= block.y and cursor.y < block.y + block.h then
		return true
	else
		return false
	end
end

function ENT:Initialize()
	self.menu = {}
	self.timer = {}
	if SERVER then
		self.Entity:SetModel("models/buildingblocks/blockspawn_1.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	else
		self.color = team.GetColor(self.Entity:GetSkin())
	end
end

function ENT:Think()
	local trace = {}
	trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 32
	trace.endpos = self.Entity:GetUp() * 68 + trace.start
	trace.filter = self.Entity
	local trace = util.TraceLine(trace)
	self.cleared = not trace.Hit
	if SERVER then
		for _, ply in pairs(player.GetAll()) do
			local cursor = self:Cursor(ply)
			if not cursor.onPanel then
				self.menu[ply] = 1
			end
		end
	end 
end

function ENT:Use(ply)
	local cursor = self:Cursor(ply)
	if not cursor.onPanel then
		return
	end
	for i, block in pairs(self.blocks[self.menu[ply] or 1]) do
		if self:CursorOnBlock(cursor, cursor.onPanel and cursor.onPanel or -1, block) then
			if type(block.command) == "number" then
				self.menu[ply] = block.command
			elseif (self.timer[ply] or 0) < CurTime() then
				self.timer[ply] = CurTime() + self.delay
				if SERVER then
					GF:SpawnBlock(ply, tonumber(block.command))
				end
			end
		end
	end
end
