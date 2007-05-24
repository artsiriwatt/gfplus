local Button = {}

function Button:Init()
	self:SetColor()
	self.hover = false
end

function Button:Paint()
	self:PaintBackground()
	return true
end

local corner8 = surface.GetTextureID("gui/corner8")
function Button:PaintBackground(color)
	local w, h = self:GetWide(), self:GetTall()
	draw.RoundedBox(6, 0, 0, w, h, color or self.color)
end

function Button:PerformLayout()
	self:SetSize(self:GetWide(), self:GetTall())
end

function Button:SetColor(color)
	self.color = color or Color(255, 255, 255, 50)
end

function Button:SetVar(key, val)
	self[key] = val
end

function Button:GetVar(key, def)
	return self[key] or def
end

vgui.Register("gf_button", Button, "Button")
GF.Menus.Button = Button
