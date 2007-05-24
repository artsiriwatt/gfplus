local Menu = {}

function Menu:Init()
	self.buttonsPanel = vgui.Create("gf_buttongroup", self)
end

function Menu:Paint()
	draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 100))
	draw.DrawText("Choose Team", "ScoreS", self:GetWide() / 2, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end

function Menu:PerformLayout()
	if not self.buttons or #self.buttons <= 0 then
		return
	end
	local x, y = 0, 0
	local columns = math.ceil(#self.buttons / 2)
	for i, button in ipairs(self.buttons) do
		button:SetPos(x, y)
		x = x + button:GetWide() + 5
		if i % columns == 0 then
			x = 0
			y = y + button:GetTall() + 6
		end
	end
	self.buttonsPanel:SetSize((self.buttons[1]:GetWide() + 5) * columns - 5, y)
	self.buttonsPanel:SetPos(5, 39)
	self.buttonsPanel:GetCanvas():SetSize(self.buttonsPanel:GetWide(), self.buttonsPanel:GetTall())
	self:SetSize(self.buttonsPanel:GetWide() + 10, self.buttonsPanel:GetTall() + 39)
	self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
end

function Menu:Reset()
	self:RemoveItems()
	for ti, t in pairs(GF.teams) do
		if t.open then
			local button = vgui.Create("gf_button", self.buttonsPanel:GetCanvas())
			button.DoClick =
				function()
					LocalPlayer():ConCommand("gf_team " .. ti)
					GF:HideMenu("team")
				end
			button.Paint =
				function(self)
					self.color = self.Armed and t.color.brighter or t.color.neutral
					self:PaintBackground()
					return true
				end
			button:SetSize(80, 70)
			table.insert(self.buttons, button)
		end
	end
	self:InvalidateLayout()
end

function Menu:RemoveItems()
	if self.buttons then
		for _, button in pairs(self.buttons) do
			button:Remove()
		end
	end
	self.buttons = {}
end

vgui.Register("gf_menuteam", Menu, "Panel")
GF.Menus.Team = Menu
