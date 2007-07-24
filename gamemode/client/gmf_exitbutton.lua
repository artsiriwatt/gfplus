local PANEL = {}

PANEL.Colour = Color (255, 0, 0, 100)

function PANEL:Init ()
	self.Colour = table.Copy (PANEL.Colour)
end

function PANEL:OnCursorEntered ()
	self.Colour.a = 255
end

function PANEL:OnCursorExited ()
	self.Colour.a = 155
end

function PANEL:Paint ()
	draw.RoundedBox (4, 0, 0, self:GetWide(), self:GetTall(), self.Colour)
	return true
end

function PANEL:PerformLayout ()
	self:SetSize (22, 22)
end

function PANEL:DoClick ()
	self:GetParent():CloseActions ()
	self:GetParent():SetVisible (false)
end

vgui.Register ("gmf_exitbutton", PANEL, "Button")