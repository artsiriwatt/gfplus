local PANEL = {}
PANEL.Colour = Color (0,0,0,100)
PANEL.DrawBack = true

function PANEL:Init ()
	self.DrawCanvas = vgui.Create ("gmf_basepanel", self) --empty panel to throw stuff into
	self.YOffset = 0
end

function PANEL:Canvas ()
	return self.DrawCanvas
end

function PANEL:SetYOffset (y)
	self.YOffset = y
end

function PANEL:Paint ()
	if PANEL.DrawBack then
		draw.RoundedBox (8, 0, 0, self:GetWide(), self:GetTall(), self.Colour)
	end
	self:ContentPaint()
end

function PANEL:PerformLayout() 
 	self.DrawCanvas:SetPos (0, self.YOffset * -1) 
 	self.DrawCanvas:SetSize (self:GetWide(), self.DrawCanvas:GetTall()) 
end

vgui.Register ("gmf_scrollarea", PANEL, "gmf_basepanel")