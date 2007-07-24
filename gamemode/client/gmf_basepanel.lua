--this is where I have put helper functions I want to access from any of the GMF panels.

local PANEL = {}

function PANEL:Init () --even derivatives call the original init function
	self.Texts = {}
	self.PrintNameColour = Color (255, 255, 255, 100)
end

function PANEL:AddTextObject (name, iTexts, iFont, iX, iY, iColour) --this is a throwbasck to GM9 techniques. Because I don't like labels.
	self.Texts[name] = {texts = iTexts, font = iFont, x = iX, y = iY, colour = iColour or self.PrintNameColour}
end

function PANEL:RemoveTextObject (name)
	self.Texts[name] = nil
end

function PANEL:Paint ()
	self:ContentPaint()
end

function PANEL:ContentPaint ()
	for k,v in pairs (self.Texts) do
		--height
		local height = draw.GetFontHeight (v.font)
		local ypt = 0
		for k2,v2 in pairs (v.texts) do
			draw.SimpleText (v2, v.font, v.x, v.y + ypt, v.colour)
			ypt = ypt + height
		end
	end
end

vgui.Register ("gmf_basepanel", PANEL, "Panel")