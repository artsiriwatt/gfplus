include("gf/hooks.lua")
include("shared.lua")
include("gf/cl_menus.lua")
include("gf/cl_messages.lua")
include("gf/cl_round.lua")
include("cl_targetid.lua")
include("gf/cl_scoreboard2.lua") --not yet
--include ("gf/cl_scoreboard2.lua")

GF.round = 1
GF.roundTimer = 999
GM.huddata = {}

function GM:GetTeamColor(ent)
	local team = TEAM_UNASSIGNED
	if ent.Team then
		team = ent:Team()
	end
	return GAMEMODE:GetTeamNumColor(team)
end

function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	GF:DrawRound()
end

function GM:ShutDown()
	GF:RemoveAllMenus()
end

function GM:InitPostEntity()
end

function GM:Initialize()
	surface.CreateFont("coolvetica",128,400,false,false,"ScoreL")
	surface.CreateFont("coolvetica",64,400,false,false,"ScoreM")
	surface.CreateFont("coolvetica",32,400,false,false,"ScoreS")
	LocalPlayer().gf = {}
end

function GM:KeyPress(ply, key)
	if key == IN_USE then
		local ent = LocalPlayer().cursorTrace.Entity
		if ent and ent.Use then
			ent:Use(ply)
		end
	end
end

function GM:PostProcessPermitted(str)
	return true
end

function GM:Think()
	LocalPlayer():CursorTrace()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function GM:ShowHelp()
	GF:ToggleMenu("help")
end

function GM:ShowTeam()
	GF:ToggleMenu("team")
end

function GM:ShowSpare1()
	GF:ToggleMenu("weapon")
end

function GM:ShowSpare2()
end

function GM.ShowHook(um) //How ironic, we have to send the message to the server and retrieve it again using efficient means to waste bandwidth.
	local opt = um:ReadShort()
	if opt == 1 then
		GAMEMODE:ShowHelp()
	elseif opt == 2 then
		GAMEMODE:ShowTeam()
	elseif opt == 3 then
		GAMEMODE:ShowSpare1()
	elseif opt == 4 then
		GAMEMODE:ShowSpare2()
	end
end
usermessage.Hook("gfopt",GM.ShowHook)
