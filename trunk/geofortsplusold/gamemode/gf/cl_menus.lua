GF.Menus = {}
GF.menus = {}
local activeMenu = nil

include("cl_button.lua")
include("cl_buttonsgroup.lua")
include("cl_menuteam.lua")
include("cl_menuweapon.lua")
include("cl_menuhelp.lua")

function GF:ShowMenu(name)
	if not self.menus[name] then
		self.menus[name] = vgui.Create("gf_menu" .. name)
	end
	if activeMenu then
		GF:HideMenu(activeMenu)
	end
	activeMenu = name
	gui.EnableScreenClicker(true)
	self.menus[name]:SetVisible(true)
	self.menus[name]:Reset()
end

function GF:HideMenu(name)
	activeMenu = nil
	gui.EnableScreenClicker(false)
	self.menus[name]:SetVisible(false)
end

function GF:RemoveAllMenus()
	for _, menu in pairs(self.menus) do
		menu:SetVisible(false)
		menu:Remove()
	end
	self.menus = {}
end

function GF:ToggleMenu(name)
	if not self.menus[name] or not self.menus[name]:IsVisible() then
		return GF:ShowMenu(name)
	else
		return GF:HideMenu(name)
	end
end
