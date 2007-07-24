local PANEL = {}

function PANEL:Init ()
	self.PrintName = "welcome to"
	self:SetSize (300, 400)
	self.UnchangedSize = false
	self.ScrollFrame = vgui.Create ("gmf_scrollframe", self)
	self.ScrollFrame:SetPos (8, 116)
	self.ScrollFrame:SetSize (self:GetWide()-16,self:GetTall() - 124)
end

function PANEL:MorePaint ()
	draw.SimpleText ("gmforts", "Airstrip48", 50, 32, self.PrintNameColour)
	draw.SimpleText ("build and conquer", "Airstrip32", 14, 80, self.PrintNameColour)
end

vgui.Register ("gmf_introscreen", PANEL, "gmf_baseframe")