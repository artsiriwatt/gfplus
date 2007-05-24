local Menu = {}

function Menu:Init()
	surface.CreateFont("csd", 80, 400, true, false, "CSIconsL")
	surface.CreateFont("csd", 36, 400, true, false, "CSIconsS")
	surface.CreateFont("coolvetica", 24, 500, true, false, "WMPRIMARY")
	surface.CreateFont("coolvetica", 18, 500, true, false, "WMSECONDARY")
	self.buttonsPanel = vgui.Create("gf_buttongroup", self)
	self.columns =
	{
		{
			command = "gf_primary",
			font = "CSIconsL",
			rows = GF.weapons.primary,
			size = {215, 50},
			text = "PRIMARY", 
		},
		{
			command = "gf_secondary",
			font = "CSIconsS",
			rows = GF.weapons.secondary,
			size = {155, 40},
			text = "SECONDARY",
		}
	}
end

function Menu:Paint()
	local color = GF.teams[LocalPlayer():Team()].color.neutral
	draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 100))
	draw.DrawText("Choose Your Weapons", "ScoreS", self:GetWide() / 2, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end

function LerpColor(a, b, f)
	return Color(
		a.r + ((b.r - a.r) * f),
		a.g + ((b.g - a.g) * f),
		a.b + ((b.b - a.b) * f),
		a.a + ((b.a - a.a) * f)
		)
end

function Menu:PaintButton(button)
	local bg = table.Copy(GF.teams[LocalPlayer():Team()].color.neutral)
	local fg = Color(255, 255, 255, 255)
	if button.Armed then
		bg = Color(255, 255, 255, 255)
		fg = Color(0, 0, 0, 255)
	end
	button:PaintBackground(bg)
	draw.SimpleText(
		button.weapon.IconLetter,
		button.column.font,
		6 + (button.weapon.IconOffset and button.weapon.IconOffset[1] or 0),
		6 + (button.weapon.IconOffset and button.weapon.IconOffset[2] or 0),
		fg,
		TEXT_ALIGN_LEFT)
	if button.Armed or button.weapon == LocalPlayer().gf.primary or button.weapon == LocalPlayer().gf.secondary then
		draw.SimpleText(
			(button.Armed and not button.selected) and button.weapon.PrintName or button.column.text,
			"WM" .. button.column.text,
			button:GetWide() - 12,
			button:GetTall() / 2,
			Color(fg.r, fg.g, fg.b, 100),
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER)
	end  
end

function Menu:PerformLayout()
	local x, y, my = 0, 0, 0
	for _, column in ipairs(self.columns) do
		y = 0
		for i, button in ipairs(column.buttons) do
			button:SetPos(x, y)
			y = y + button:GetTall() + 6
		end
		x = x + column.size[1] + 6
		my = math.max(my, y)
	end
	self.buttonsPanel:SetSize(x - 6, my)
	self.buttonsPanel:SetPos(5, 39)
	self.buttonsPanel:GetCanvas():SetSize(self.buttonsPanel:GetWide(), self.buttonsPanel:GetTall())
	self.close:SetPos(self.buttonsPanel:GetWide() - self.close:GetWide(), self.buttonsPanel:GetTall() - self.close:GetTall() - 6)
	self:SetSize(self.buttonsPanel:GetWide() + 10, self.buttonsPanel:GetTall() + 39)
	self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
end

function Menu:Reset()
	self:RemoveItems()
	local color = GF.teams[LocalPlayer():Team()].color.neutral
	for _, column in ipairs(self.columns) do
		column.buttons = {}
		for index, class in pairs(column.rows) do
			local weapon = weapons.GetStored(class)
			if weapon then
				local button = vgui.Create("gf_button", self.buttonsPanel:GetCanvas())
				button.DoClick =
					function()
						LocalPlayer():ConCommand(column.command .. " " .. index)
						button.selected = true
						//GF:HideMenu("weapon")
					end
				button.OnCursorExited =
					function()
						button.selected = false
					end
				button.Paint =
					function()
						self:PaintButton(button)
						return true
					end
				button:SetColor(Color(255, 255, 255, 100), color)
				button:SetSize(column.size[1], column.size[2])
				button.column = column
				button.weapon = weapon
				table.insert(column.buttons, button)
			end
		end	
	end
	self.close = vgui.Create("gf_button", self.buttonsPanel:GetCanvas())
	self.close.DoClick = function() GF:HideMenu("weapon") end
	self.close.Paint =
		function()
			local bg, fg
			if self.close.Armed then
				//bg = Color(255, 255, 255, 100)
				bg = Color(0, 0, 0, 175)
				fg = Color(255, 255, 255, 255)
			else
				bg = Color(0, 0, 0, 100)
				fg = Color(150, 150, 150, 255)
			end
			//surface.SetDrawColor(bg.r, bg.g, bg.b, bg.a)
			//surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self.close:PaintBackground(bg)
			draw.SimpleText("Done", "WMSECONDARY", self.close:GetWide() / 2, self.close:GetTall() / 2, fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return true
		end
	self.close:SetSize(100, 32)
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

vgui.Register("gf_menuweapon", Menu, "Panel")
GF.Menus.Weapon = Menu
