local PANEL = {}
PANEL.Colour = Color (0,0,0,100)

function PANEL:Init ()
	self:SetSize (24, 160)
	--self.DragBar = vgui.Create ("gmf_dragbar", self)
end

function PANEL:Paint ()
	draw.RoundedBox (8, 0, 0, self:GetWide(), self:GetTall(), self.Colour)
	self:ContentPaint()
end

vgui.Register ("gmf_scrollbar", PANEL, "gmf_basepanel")