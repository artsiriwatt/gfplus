local Menu = {}

function Menu:Init()
	self.canvas = vgui.Create("Panel", self)
	self.offset = 0
end

function Menu:GetCanvas()
	return self.canvas
end

function Menu:OnMouseWheeled(delta)
	local maxOffset = self.canvas:GetTall() - self:GetTall()
	if maxOffset > 0 then
		self.offset = math.Clamp(self.offset + delta * -100, 0, maxOffset)
	else
		self.offset = 0
	end
	self:InvalidateLayout()
end

function Menu:PerformLayout()
	self.canvas:SetPos(0, self.offset * -1)
	self.canvas:SetSize(self:GetWide(), self.canvas:GetTall())
end

vgui.Register("gf_buttongroup", Menu, "Panel")
GF.Menus.ButtonsGroup = Menu
