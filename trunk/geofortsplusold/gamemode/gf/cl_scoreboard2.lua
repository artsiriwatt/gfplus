--redo the scoreboard. The base gamemode one just looks old now.
--doing it using lots of sandbox scoreboard code.

function GM:CreateScoreboard()
	scoreboard = vgui.Create ("scoreboard")
end
 
function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker (true)
	if not scoreboard then
		self:CreateScoreboard()
	end
	scoreboard:SetVisible (true)
end
 
function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker (false)
	scoreboard:SetVisible (false)
end
 
function GM:HUDDrawScoreBoard()

end

--now to do the actual VGUI

surface.CreateFont ("coolvetica", 32, 500, true, false, "ScoreboardHeader")
surface.CreateFont ("coolvetica", 22, 500, true, false, "ScoreboardSubtitle") --I think they look nice like the sandbox SB.
surface.CreateFont ("coolvetica", 19, 500, true, false, "ScoreboardSubsub")

local texGradient 	= surface.GetTextureID ("gui/center_gradient")
local texLogo 		= surface.GetTextureID ("gui/gmod_logo")

local flagLogo		= surface.GetTextureID("buildingblocks/logowhite")

local PANEL = {}

function PANEL:Init ()
	self.lastThink = CurTime()
	
	self.HostName = vgui.Create ("Label", self)
	self.HostName:SetText(GetGlobalString ("ServerName"))
	self.Description = vgui.Create ("Label", self)
	self.Description:SetText (GAMEMODE.Name .. " - " .. GAMEMODE.Author)
	
	--player frames (team frames)
	self.TeamFrames = {}
	for i=1, 4 do
		self.TeamFrames[i] = vgui.Create ("teamframe", self)
		self.TeamFrames[i]:SetTeam (i)
	end
end

function PANEL:Paint ()
	draw.RoundedBox (6,0,0,self:GetWide(),self:GetTall(),Color(0, 0, 0, 50))
	--surface.SetDrawColor (0, 0, 0, 100)
	--surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	
	draw.RoundedBox (6,4,self.Description.y-4,self:GetWide()-8,self:GetTall()-self.Description.y-4,Color(0, 0, 0, 50))
	--surface.SetDrawColor (0, 0, 0, 100)
	--surface.DrawRect (4,self.Description.y-4,self:GetWide()-8,self:GetTall()-self.Description.y-4)

	draw.RoundedBox (6,5,self.Description.y-3,self:GetWide()-10,self.Description:GetTall()+5,Color(0, 0, 0, 50))
	--surface.SetDrawColor (0, 0, 0, 100)
	--surface.DrawRect (4,self.Description.y-4,self:GetWide()-8,self.Description:GetTall()+8)
	
	surface.SetTexture (texLogo)
	surface.SetDrawColor (255,255,255,255)
	surface.DrawTexturedRect (0,0,128,128)
end

function PANEL:PerformLayout ()
	self.HostName:SizeToContents()
	self.HostName:SetPos (115,16)
	
	self.Description:SizeToContents()
	self.Description:SetPos (128,64)
	
	local iTall = ScrH() * 0.8
	iTall = math.Clamp (iTall,100,ScrH()*0.9)
	local iWide = math.Clamp (ScrW()*0.9,800,ScrW()*0.7)
	
	self:SetSize (iWide,iTall)
	self:SetPos ((ScrW()-self:GetWide())/2,(ScrH()-self:GetTall())/6)
	
	--self.PlayerFrame:SetPos( 5, self.Description.y + self.Description:GetTall() + 20 )
	--self.PlayerFrame:SetSize( self:GetWide() - 10, self:GetTall() - self.PlayerFrame.y - 10 )
	
	--remember: 4 boxes, 2 by 2 grid.
	for k,v in pairs (self.TeamFrames) do
		local krep = k
		if krep > 2 then
			x = krep - 2
			y = 2
		else
			x = krep
			y = 1
		end
		flswidth = self:GetWide() - 10
		flsheight = self:GetTall() - 138
		v:SetPos (10 + (flswidth / 2) * (x - 1), self.Description.y + self.Description:GetTall() + 20 + (flsheight / 2) * (y - 1))
		v:SetSize (flswidth / 2 - 10, flsheight / 2 - 5)
	end
	
	self.HostName:SetText (GetGlobalString("ServerName"))
end

function PANEL:ApplySchemeSettings ()
	self.HostName:SetFont ("ScoreboardHeader")
	self.Description:SetFont ("ScoreboardSubtitle")
	
	self.HostName:SetFGColor (Color(0,0,0,200))
	self.Description:SetFGColor (color_white)
end

function PANEL:Think ()
	if self.lastThink < CurTime() - 1 then
		self:InvalidateLayout ()
		self.lastThink = CurTime()
	end
end

vgui.Register ("scoreboard", PANEL, "Panel")

local PANEL = {}

function PANEL:Init ()
	self.lastThink = CurTime()
	self.PlayerFrame = vgui.Create ("teamplayerframe", self)
	self.FlagAlpha = 255
	self.ScoreLabel = vgui.Create ("Label", self)
	self.ScoreLabel:SetText ("Score")
end

function PANEL:GetPlayerFrame ()
	return self.PlayerFrame
end

function PANEL:SetTeam (tid)
	Msg ("TEAMFRAME\nSetting team: "..tid.."\n")
	self.team = tid
	self.clr = GF.teams[self.team].color.player
	Msg (tostring(clr).."\n")
	self.PlayerFrame:SetTeam (tid)
end

function PANEL:Paint ()
	--draw.RoundedBox (4,0,0,self:GetWide(),self:GetTall(),Color(170,170,170,255))
	--surface.SetTexture (texGradient)
	surface.SetDrawColor (self.clr.r, self.clr.g, self.clr.b, 100)
	surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	
	surface.SetTexture (flagLogo)
	surface.SetDrawColor (self.clr.r, self.clr.g, self.clr.b, self.FlagAlpha)
	surface.DrawTexturedRect (5,7,40,40)
	
	local clr = GF.teams[self.team].color.scoreboard
	--surface.SetDrawColor (clr.r, clr.g, clr.b, clr.a)
	--surface.DrawRect (self:GetWide() - 75, 18, 57, 30)
	--draw.RoundedBox (6, self:GetWide() - 75, 18, 57, 30, clr)
	--surface.SetDrawColor (clr.r, clr.g, clr.b, 55)
	--surface.DrawTexturedRect (0,0,self:GetWide(),self:GetTall())
end

function PANEL:PerformLayout ()
	self.PlayerFrame:SetPos (0, 50)
	self.PlayerFrame:SetSize (self:GetWide(), self:GetTall() - 50)
	self.ScoreLabel:SetPos (self:GetWide() - 64, 26)
end

function PANEL:ApplySchemeSettings ()
	self.ScoreLabel:SetFont ("ScoreboardSubsub")
	self.ScoreLabel:SetFGColor (Color(255,255,255,255))
	self.ScoreLabel:SizeToContents ()
end

function PANEL:Think ()
	if self.lastThink < CurTime() - 1 then
		self:InvalidateLayout ()
		self.lastThink = CurTime()
	end
end

vgui.Register ("teamframe", PANEL, "Panel")

local PANEL = {}

function PANEL:Init ()
	self.lastThink = CurTime()
	self.entries = {}
end

function PANEL:Paint ()
	--draw.RoundedBox (4,0,0,self:GetWide(),self:GetTall(),Color(170,170,170,255))
	--surface.SetTexture (texGradient)
	--surface.SetDrawColor (self.clr.r, self.clr.g, self.clr.b, 100)
	--surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	--surface.SetDrawColor (clr.r, clr.g, clr.b, 55)
	--surface.DrawTexturedRect (0,0,self:GetWide(),self:GetTall())
end

function PANEL:SetTeam (tid)
	Msg ("TEAMPLAYERFRAME\nSetting team: "..tid.."\n")
	self.team = tid
	self.clr = GF.teams[self.team].color.brighter
	Msg (tostring(clr).."\n")
end

function PANEL:PerformLayout()
	for k,v in pairs (team.GetPlayers (self.team)) do
		if self.entries[v] == nil then
			self:CreateNewEntry (v)
		end
	end
	local plys = {}
	for k,v in pairs (self.entries) do
		if not k:IsValid() or k:Team() ~= self.team then
			self:RemoveEntry (k)
		else
			table.insert (plys, k)
		end
	end
	table.sort (plys, function (a,b) return a:Frags() > b:Frags() end)
	y = 5
	for k,v in pairs (plys) do
		self.entries[v]:SetPos (5, y)
		y = y + 35
	end
end

function PANEL:CreateNewEntry (ply)
	self.entries[ply] = vgui.Create ("playerline", self)
	self.entries[ply]:SetPlayer (ply)
end

function PANEL:RemoveEntry (ply)
	self.entries[ply] = self.entries[ply]:Remove()
end

function PANEL:Think ()
	if self.lastThink < CurTime() - 1 then
		self:InvalidateLayout ()
		self.lastThink = CurTime()
	end
end

vgui.Register ("teamplayerframe", PANEL, "Panel")

local PANEL = {}

function PANEL:Init ()
	self.lastThink = CurTime()
	self.Name = vgui.Create ("Label", self)
	self.Name:SetText ("YOU SHOULD NOT SEE THIS")
	self.Score = vgui.Create ("Label", self)
	self.Score:SetText ("0")
end

function PANEL:Paint ()
	local clr = GF.teams[self:GetParent().team].color.scoreboard
	--surface.SetDrawColor (clr.r, clr.g, clr.b, 200)
	--surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	draw.RoundedBox (6, 0, 0, self:GetWide(), self:GetTall(), clr)
end

function PANEL:SetPlayer (pl)
	self.player = pl
	self:UpdateInfo ()
end

function PANEL:UpdateInfo ()
	self.Name:SetText (self.player:Name())
end

function PANEL:PerformLayout ()
	self:SetSize (self:GetParent():GetWide() - 10, 30)
	self.Name:SetPos (5,5)
	self.Name:SetText (self.player:Name())
	self.Score:SetPos (self:GetWide () - 57, 5)
	self.Score:SetText (tostring(self.player:Frags()))
	self:UpdateInfo ()
end

function PANEL:ApplySchemeSettings ()
	self.Name:SetFont ("ScoreboardSubtitle")
	self.Name:SetFGColor (Color(255,255,255,255))
	self.Name:SizeToContents()
	self.Score:SetFont ("ScoreboardSubtitle")
	self.Score:SetFGColor (Color(255,255,255,255))
	self.Score:SizeToContents()
	self.Score:SetSize (100, self.Score:GetTall()) 
end

function PANEL:Think ()
	if self.lastThink < CurTime() - 1 then
		self:InvalidateLayout ()
		self.lastThink = CurTime()
	end
end

vgui.Register ("playerline", PANEL, "Panel")