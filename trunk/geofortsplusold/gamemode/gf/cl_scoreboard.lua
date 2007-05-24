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

local texGradient 	= surface.GetTextureID ("gui/center_gradient")
local texLogo 		= surface.GetTextureID ("gui/gmod_logo")

local PANEL = {}

function PANEL:Init ()
	self.lastThink = CurTime()
	
	self.Hostname = vgui.Create ("Label", self)
	self.Hostname:SetText(GetGlobalString ("ServerName"))
	self.Description = vgui.Create ("Label", self)
	self.Description:SetText (GAMEMODE.Name .. " - " .. GAMEMODE.Author)
	
	--player frames (team frames)
	self.TeamFrames = {}
	for i=1, 4 do
		self.TeamFrames[i] = vgui.Create ("teamframecanvas", self)
		self.TeamFrames[i]:GetFrame():SetTeam (i)
	end
end

function PANEL:Paint ()
	draw.RoundedBox (4,0,0,self:GetWide(),self:GetTall(),Color(170,170,170,255))
	surface.SetTexture (texGradient)
	surface.SetDrawColor (255,255,255,50)
	surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	
	draw.RoundedBox (4,4,self.Description.y-4,self:GetWide()-8,self:GetTall()-self.Description.y-4,Color(230,230,230,200))
	surface.SetTexture (texGradient)
	surface.SetDrawColor (255,255,255,50)
	surface.DrawRect (4,self.Description.y-4,self:GetWide()-8,self:GetTall()-self.Description.y-4)

	draw.RoundedBox (4,5,self.Description.y-3,self:GetWide()-10,self.Description:GetTall()+5,Color(150,200,50,200))
	surface.SetTexture (texGradient)
	surface.SetDrawColor (255,255,255,50)
	surface.DrawRect (4,self.Description.y-4,self:GetWide()-8,self.Description:GetTall()+8)
	
	surface.SetTexture (texLogo)
	surface.SetDrawColor (255,255,255,255)
	surface.DrawTexturedRect (0,0,128,128)
end

function PANEL:PerformLayout ()
	self.Hostname:SizeToContents()
	self.Hostname:SetPos (115,16)
	
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
		v:InvalidateLayout ()
	end
	
	self.Hostname:SetText (GetGlobalString("ServerName"))
end

function PANEL:ApplySchemeSettings ()
	self.Hostname:SetFont ("ScoreboardHeader")
	self.Description:SetFont ("ScoreboardSubtitle")
	
	self.Hostname:SetFGColor (Color(0,0,0,200))
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
	self:SetVisible (true)
	Msg ("Creating team frame . . . \n")
	self.Frame = vgui.Create ("teamframe", self)
	self.Y = 0
end

function PANEL:Paint ()
	--Msg ("Sodding draw functions.\n")
	--self.Frame:Paint ()
end

function PANEL:GetFrame ()
	return self.Frame
end

function PANEL:PerformLayout()
	--Msg ("Updating team frame canvas . . .\n")
	self.Frame:SetPos (0, self.Y * -1)
	self.Frame:SetSize (self:GetWide(), self.Frame:GetTall())
	--self.Frame:InvalidateLayout ()
end

vgui.Register ("teamframecanvas", PANEL, "Panel")

local PANEL = {}

function PANEL:Init ()
	self:SetVisible (true)
	Msg ("Team frame created.\n")
	self.lastThink = CurTime()
	self.team = 1
	self.entries = {}
end

function PANEL:Paint ()
	Msg ("Drawing team frame . . .\n")
	--draw.RoundedBox (4,0,0,self:GetWide(),self:GetTall(),Color(170,170,170,255))
	surface.SetTexture (texGradient)
	surface.SetDrawColor (self.clr.r, self.clr.g, self.clr.b, 100)
	surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	--surface.SetDrawColor (clr.r, clr.g, clr.b, 55)
	--surface.DrawTexturedRect (0,0,self:GetWide(),self:GetTall())
end

function PANEL:SetTeam (tid)
	Msg ("Setting team: "..tid.."\n")
	self.team = tid
	self.clr = GF.teams[self.team].color
	Msg (tostring(clr).."\n")
end

function PANEL:PerformLayout()
	Msg ("Updating team frame ("..self.team..") . . .\n")
	
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
		Msg ("TEAM FRAME THINKING. \n")
		self:InvalidateLayout ()
		self.lastThink = CurTime()
	end
end

vgui.Register ("teamframe", PANEL, "Panel")

local PANEL = {}

function PANEL:Init ()
	self.lastThink = CurTime()
	self.name = vgui.Create ("Label", self)
	self.name:SetText ("YOU SHOULD NOT SEE THIS")
end

function PANEL:Paint ()
	local clr = GF.teams[self:GetParent().team].colorScoreboard
	--surface.SetDrawColor (clr.r, clr.g, clr.b, 200)
	--surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	draw.RoundedBox (8, 0, 0, self:GetWide(), self:GetTall(), clr)
end

function PANEL:SetPlayer (pl)
	self.player = pl
	self:UpdateInfo ()
end

function PANEL:UpdateInfo ()
	self.name:SetText (self.player:Name())
end

function PANEL:PerformLayout ()
	self:SetSize (self:GetParent():GetWide() - 10, 30)
	self.name:SetPos (5,5)
	self:UpdateInfo ()
end

function PANEL:ApplySchemeSettings ()
	self.name:SetFont ("ScoreboardSubtitle")
	self.name:SetFGColor (Color(255,255,255,255))
	self.name:SizeToContents()
end

function PANEL:Think ()
	if self.lastThink < CurTime() - 1 then
		self:InvalidateLayout ()
		self.lastThink = CurTime()
	end
end

vgui.Register ("playerline", PANEL, "Panel")
