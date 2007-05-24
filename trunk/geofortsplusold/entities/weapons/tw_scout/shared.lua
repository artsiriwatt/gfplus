if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "SCHMIDT SCOUT RIFLE"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "n"
	
	killicon.AddFont("tw_scout", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_scout.Single" )
SWEP.Primary.ClipSize		= 2
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.Delay		= 0.4

SWEP.Firemodes						= {
	{
		Name							= "Unscoped",
		Kick							= 6,
		Damage							= 27,
		NumShots						= 1,
		Cone							= 0.1,
		Delay							= 1.3,
		Automatic						= true,
		
		ConeMulStanding					= 3,
		MaxConeMul						= 6,
		ConeLossPerShot 				= 3,
		ConeLossPerShotCrouching		= 3,
		ConeRecovery		 			= 0.1,
		ConeRecoveryCrouching 			= 0.12,
	},
	{
		Name							= "3X Zoom",
		Cone							= 0.0001, --bit of a lie - see below
		Automatic						= false,
	},
	{
		Name							= "10X Zoom",
		Cone							= 0.0001,
		Automatic						= false,
	}
}

function SWEP:AdditionalSetFiremode (firemode, msgbool)
	if SERVER then
		if self.Owner then
			if firemode == 2 then
				self.Owner:SetFOV (30, 0.2)
			elseif firemode == 3 then
				self.Owner:SetFOV (9, 0.2)
			else
				self.Owner:SetFOV (90, 0.2)
			end
		end
	end
end

function SWEP:AdditionalReload ()
	self:SetFiremode (1)
end

function SWEP:AdditionalPrimaryAttack ()
	self:SetFiremode (1)
end

function SWEP:SpecificConeModify (scale)
	if self.Firemode == 1 then
		return scale
	else
		scale = 0.01 / (self.Owner:GetFOV () / 90)
		return scale
	end
end

function SWEP:SwaySpeed ()
	self.mod = self.mod or 0
	swspd = (3 + self.mod + self.Owner:GetVelocity():Length() / 8) / 1.7
	if not self.Owner:Crouching() then swspd = swspd * 2.4 end
	return math.min (swspd, 100)
end

function SWEP:DrawHUD ()
	if self.Firemode == 1 then return end
	surface.SetDrawColor (0,0,0,255)
	ScID = surface.GetTextureID ("weapons/scopes/scope2")
	surface.SetTexture (ScID)
	surface.DrawTexturedRect (0,0,ScrW(),ScrH())
	linewidth = ScrW() / 300
	surface.DrawRect (ScrW() / 2 - linewidth / 2, 0, linewidth, ScrH())
	surface.DrawRect (0, ScrH() / 2 - linewidth / 2, ScrW(), linewidth)
	--wavery scope? bit lame right now but might make it better sometime
	AVX = self.AVX or 0
	AVY = self.AVY or 0
	AVX = AVX + (math.random() - 0.5) * self:SwaySpeed () - (AVX / 25)
	AVY = AVY + (math.random() - 0.5) * self:SwaySpeed () - (AVY / 25)
	local ang = self.Owner:EyeAngles()
	local vec = self.Owner:GetAimVector()
	self.oldvec = self.oldvec or vec
	local chn = vec - self.oldvec
	local dist = chn:Length()
	if self.Owner:IsOnGround() then
		self.mod = math.min (self.mod * 0.94 + dist * 15, 7)
	else
		self.mod = 7
	end
	ang.yaw = ang.yaw + AVX * FrameTime() / 7
	ang.pitch = ang.pitch + AVY * FrameTime() / 7
	self.Owner:SetEyeAngles (ang)
	self.AVX = AVX
	self.AVY = AVY
	self.oldvec = vec
	lineheight = self:SwaySpeed() * 5 * (ScrW() / 1024)
	Msg (lineheight.." ")
	surface.DrawRect (ScrW() / 4, ScrH() / 2 - lineheight / 2, linewidth, lineheight)
	surface.DrawRect (ScrW() * 3 / 4, ScrH() / 2 - lineheight / 2, linewidth, lineheight)
end

function SWEP:ShowFiremodeMessage ()
	return false
end
