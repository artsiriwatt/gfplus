if SERVER then
AddCSLuaFile("shake.lua")
end
include("shake.lua")

GM.Name 	= "GeoForts+"
GM.Author 	= "cringerpants, Devenger, Esik1er (GF by Night-Eagle)"
GM.Email 	= ""
GM.Website 	= "http://gmod.phuce.com"
function GM:GetGameDescription() return self.Name end

GF =
{
	-- constants
	DELAY_FLAGRETURN = 30,
	DELAY_RESPAWN = 7,
	FLAG_DROPPED = 0,
	FLAG_GRABBED = 1,
	FLAG_HOME = 2,
	PENALTY_NOCAPTURE = 0.5,
	ROUND_PRE = 1,
	ROUND_BUILD = 2,
	ROUND_QUALIFY = 3,
	ROUND_FIGHT = 4,
	WEAPONS_NONE = 0,
	WEAPONS_BUILDING = 1,
	WEAPONS_FIGHTING = 2,

	-- variables
	flags = {},
	maps = {"gf_stiyo"},
	round = 0,
	roundTimer = 0,
	roundsLeft = 4,
	rounds = {
		[0] = {
			name = "",
			description = "",
			time = 0,
			wall = 0,
			respawn = 1,
			weapons = 0,
			},
		[1] = {
			name = "Preround",
			description = "",
			time = 30,
			wall = 0,
			respawn = 1,
			weapons = 2,
			},
		[2] = {
			name = "Build",
			description = "Use the block spawners to build a base.",
			time = 480,
			initialTime = 840, -- addition: time for first round only
			wall = 1,
			respawn = 1,
			weapons = 1,
			},
		[3] = {
			name = "Qualify",
			description = "Touch your flag, then touch the pad in the middle of the map.",
			time = 120,
			wall = 1,
			respawn = 0,
			weapons = 0,
			},
		[4] = {
			name = "Fight",
			description = "Capture the enemy flags!",
			time = 450,
			wall = 0,
			respawn = 1,
			weapons = 2,
			},
		},
	spawnBlockers = {},
	spawnQueueTimer = CurTime() + 1,
	spawns = {},
	spawnsQualify = {},
	teams =
	{
		{
			name = "Blue",
			color =
			{
				brighter   = Color( 80, 150, 255, 255),
				darker     = Color( 80, 150, 255, 255),
				neutral    = Color( 70, 120, 220, 255),
				player     = Color(100, 140, 255, 255),
				scoreboard = Color( 35,  60, 255, 100),
			},
			open = false,
			score = 0,
			qualify = 1,
		},
		{
			name = "Yellow",
			color =
			{
				brighter   = Color(245, 245,   0, 255),
				darker     = Color(245, 245,   0, 255),
				neutral    = Color(200, 200,   0, 255),
				player     = Color(255, 255, 150, 255),
				scoreboard = Color(120, 120,   0, 100),
			},
			open = false,
			score = 0,
			qualify = 1,
		},
		{
			name = "Green",
			color =
			{
				brighter   = Color(  0, 235,   0, 255),
				darker     = Color(  0, 235,   0, 255),
				neutral    = Color(  0, 200,   0, 255),
				player     = Color(150, 255, 150, 255),
				scoreboard = Color(  0, 120,   0, 100),
			},
			open = false,
			score = 0,
			qualify = 1,
		},
		{
			name = "Red",
			color =
			{
				brighter   = Color(255,  40,  40, 255),
				darker     = Color(255,  40,  40, 255),
				neutral    = Color(200,  50,  40, 255),
				player     = Color(255, 150, 150, 255),
				scoreboard = Color(100,  25,  20, 100),
			},
			open = false,
			score = 0,
			qualify = 1,
		},
	},
	weapons =
	{
		primary = {"tw_p90", "tw_m4a1", "tw_sg552", "tw_m3"},
		secondary = {"tw_p228", "tw_usp", "tw_mac10", "tw_deagle"},
	},
	items =
	{
		superspeed = {
			"Leg Augmentation",
			"Increase your movement speed by 20%."
		},
		energyshield = {
			"Energy Shield",
			"Have an auto-recharging energy shield reduce damage taken."
		},
		vitality = {
			"Increased Vitality",
			"Have a maximum of 150HP."
		},
		scopedrifle = {
			"Light Sniper Rifle",
			"Sacrifice your primary weapon for the Scout sniper rifle."
		}
	},
}

for i = 1, 4 do
	team.SetUp(i, GF.teams[i].name, GF.teams[i].color.brighter)
end

function GM:PlayerConnect(name, address, steamid) end
function GM:Restored() end
function GM:Saved() end

local Player = FindMetaTable("Player")

if SERVER then
	Player.OldAddFrags = Player.AddFrags
	function Player:AddFrags(f)
		if phuce then
			pply = phuce.players[self:SteamID()]
			if pply then
				pply.frags = pply.frags + f
			end
		end
		self:OldAddFrags(f)
	end

	Player.OldSetTeam = Player.SetTeam
	function Player:SetTeam(t)
		self.joinedTeamAt = CurTime()
		GF:CleanupPlayer(self)
		self:OldSetTeam(t)
		GF:InitializePlayer(self)
	end
else
	function Player:Armor()
		return self:GetNetworkedInt("armor")
	end
end

function Player:CursorTrace()
	local t = {}
	t.start = self:GetShootPos()
	t.endpos = t.start + self:GetAimVector() * 86
	t.filter = self
	self.cursorTrace = util.TraceLine(t)
end

function Player:SetPrimaryWeapon(index)
	if not GF.weapons.primary[index] then
		print("Invalid primary weapon index " .. index .. (SERVER and (" for " .. self:Nick()) or ""))
	end
	self.gf.primary = weapons.GetStored(GF.weapons.primary[index])
	if SERVER then
		umsg.Start("gfm_primary", self)
		umsg.Short(index)
		umsg.End()
	end
end

function Player:SetSecondaryWeapon(index)
	if not GF.weapons.secondary[index] then
		print("Invalid secondary weapon index " .. index .. (SERVER and (" for " .. self:Nick()) or ""))
	end
	self.gf.secondary = weapons.GetStored(GF.weapons.secondary[index])
	if SERVER then
		self.gf.secondary = weapons.GetStored(GF.weapons.secondary[index])
		umsg.Start("gfm_secondary", self)
		umsg.Short(index)
		umsg.End()
	end
end
