include("shared.lua")

surface.CreateFont("csd", 256, 400, false, true, "supply")
function ENT:Draw()
	self.Entity:DrawModel()
	local color = team.GetColor(self.Entity:GetSkin())
	local pos = self.Entity:GetPos() + (self.Entity:GetForward() * self.offset)
	local ang = self.Entity:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	cam.Start3D2D(pos, ang, 0.25)
		-- background
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(self.x, self.y, self.w, self.h)
		-- logo
		surface.SetDrawColor(color.r, color.g, color.b, 255)
		surface.SetTexture(self.logo)
		surface.DrawTexturedRect(self.x + (self.w * 0.5) - 44, self.y + (self.h * 0.5) - 32, 96, 96)
		-- icons and text
		local cursor = self.Entity:Cursor(LocalPlayer())
		if cursor.onPanel then
			surface.SetDrawColor(255, 255, 255, 50)
			surface.DrawRect(self.x + (self.w * 0.5 * (cursor.onPanel - 1)), self.y, self.w * 0.5, self.h)
		end 
		draw.DrawText("Supplies", "ScoreS", self.x + (self.w * 0.5), self.y + 4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("F", "supply", self.x + (self.w * 0.25) - 8, self.y + 40, (cursor.onPanel == 1) and Color(255, 255, 255, 255) or Color(color.r, color.g, color.b, 100), TEXT_ALIGN_CENTER)
		draw.DrawText("J", "supply", self.x + (self.w * 0.75) + 32, self.y + 48, (cursor.onPanel == 2) and Color(255, 255, 255, 255) or Color(color.r, color.g, color.b, 100), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
