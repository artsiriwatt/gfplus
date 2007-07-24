surface.CreateFont ("Airstrip Four", 24, 400, true, false, "Airstrip24")
surface.CreateFont ("Airstrip Four", 32, 400, true, false, "Airstrip32")
surface.CreateFont ("Airstrip Four", 36, 400, true, false, "Airstrip36")
surface.CreateFont ("Airstrip Four", 48, 400, true, false, "Airstrip48")

local PANEL = {}

PANEL.Colour = Color (0,0,0,100)

function PANEL:Init ()
	self.UnchangedSize = true
	self.Colour = table.Copy (PANEL.Colour)
	Msg ("Adding button . . .\n")
	self.ExitButton = vgui.Create ("gmf_exitbutton", self)
	self.PrintName = "Untitled"
	self.PrintNameFont = "Airstrip24"
	self.PrintNameColour = Color (255, 255, 255, 100)
end

function PANEL:SetPrintName (pn, font)
	self.PrintName = pn
	if font then self.PrintNameFont = font end
end

function PANEL:Paint ()
	draw.RoundedBox (8, 0, 0, self:GetWide(), self:GetTall(), self.Colour)
	draw.SimpleText (self.PrintName, self.PrintNameFont, 8, 8, self.PrintNameColour)
	self:ContentPaint ()
	return true
end

function PANEL:PerformLayout ()
	Msg ("Performing layout . . .\n")
	self.ExitButton:SetPos (self:GetWide() - 32, 8)
end

function PANEL:CloseActions ()
	gui.EnableScreenClicker (false)
end

vgui.Register ("gmf_baseframe", PANEL, "gmf_basepanel")