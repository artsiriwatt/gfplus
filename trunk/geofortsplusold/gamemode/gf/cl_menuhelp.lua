surface.CreateFont ("coolvetica", 21, 300, true, false, "SmallVetica")

local Menu = {}

function Menu:Init()
	self.buttonsPanel = vgui.Create("gf_buttongroup", self)
	self.messagelines = {
		"GeoForts+ is a custom, non-sandbox gamemode for Garry's Mod 10.",
		"Players build on their flag defense then play a flag-capture game allternately.",
		"The objective of the game is to have your team finish with the most points.",
		"One point is gained every time you capture a flag, but a point is lost if your",
		"flag gets captured by another team.",
		"",
		"F1: Toggle this help window",
		"F2: Change team",
		"F3: Weapons select",
		"",
		"If you are ever unsure of what to do, ask other players for help. Good luck!"
	}
	self.itemselected = "Overview"
end

function Menu:Paint()
	draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 100))
	draw.SimpleText("How to Play", "ScoreS", self:GetWide() / 2, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	local y = 39
	for k,v in pairs(self.messagelines) do
		draw.SimpleText(v, "SmallVetica", self:GetWide() / 2, y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		y = y + 21
	end
	self:SetSize(535, y+5)
	self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
end

function Menu:PerformLayout()

end

function Menu:Reset()
end

vgui.Register("gf_menuhelp", Menu, "Panel")
GF.Menus.Help = Menu
