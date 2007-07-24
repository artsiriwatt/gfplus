--I am teh sandbox-scoreboard-code-thief

local PANEL = {}

PANEL.Colour = Color (0,0,0,100)

function PANEL:Init ()
	self.Colour = table.Copy (PANEL.Colour)
	self.ScrollArea = vgui.Create ("gmf_scrollarea", self)
	self.ScrollBar = vgui.Create ("gmf_scrollbar", self)
end

function PANEL:GetScrollArea ()
	return self.ScrollArea
end

function PANEL:GetScrollBar ()
	return self.ScrollBar
end

function PANEL:Paint ()
	--draw.RoundedBox (8, 0, 0, self:GetWide(), self:GetTall(), self.Colour)
	self:ContentPaint()
end

function PANEL:PerformLayout ()
	self.ScrollArea:SetPos (0,0)
	self.ScrollArea:SetSize (self:GetWide() - 32, self:GetTall())
	self.ScrollBar:SetPos (self:GetWide() - 24, 0)
end

vgui.Register ("gmf_scrollframe", PANEL, "gmf_basepanel")