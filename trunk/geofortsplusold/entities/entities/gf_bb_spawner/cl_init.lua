include('shared.lua')

function ENT:Draw()
	self.Entity:DrawModel()
	local cursor = self.Entity:Cursor(LocalPlayer())
	if not cursor.onPanel then
		self.menu[LocalPlayer()] = 1
	end
	local ang = self.Entity:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	self:DrawPanel(1, self.Entity:GetPos() + (self.Entity:GetForward() * self.offset), ang, cursor)
	ang = self.Entity:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)
	self:DrawPanel(2, self.Entity:GetPos() + (self.Entity:GetForward() * -self.offset), ang, cursor)
end

function ENT:DrawPanel(panel, pos, ang, cursor)
	-- draw the panel
	cam.Start3D2D(pos, ang, 0.25)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(self.x, self.y, self.w, self.h)
		if GF.round == GF.ROUND_BUILD then
			local status
			local remaining = (self.timer[LocalPlayer()] or 0) - CurTime()
			if not self.cleared then
				status = "Blocked"
			elseif remaining <= 0 then
				status = "Ready"
			else
				status = math.max(math.Round(remaining * 10), 0)
			end
			draw.DrawText(status .. "\nBlock Spawner", "Trebuchet18", self.x + 4, self.y + self.h - 36, Color(255, 255, 255, 255))
			for i, block in pairs(self.blocks[(self.menu[LocalPlayer()] or 1)]) do
				if self:CursorOnBlock(cursor, panel, block) then
					surface.SetDrawColor(150, 150, 150, 255)
				else
					local color = team.GetColor(self.Entity:GetSkin()) or Color(255, 255, 255, 255)
					surface.SetDrawColor(color.r, color.g, color.b, 255)
				end
				surface.DrawRect(self.x + block.x, self.y + block.y, block.w, block.h)
				if block.text then
					draw.DrawText(block.text, "Trebuchet18", self.x + block.x + 1, self.y + block.y - 3, Color(255, 255, 255, 255))
				end
			end
			if cursor.onPanel then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawRect(self.x + cursor.x - 0.5, self.y + cursor.y - 0.5, 1, 1)
			end
		else
			draw.DrawText(GF.rounds[GF.round].name .. "\n" .. string.ToMinutesSecondsMilliseconds(math.max(GF.roundTimer - CurTime(), 0)), "Trebuchet24", self.x + self.w * 0.5, self.y + 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end
