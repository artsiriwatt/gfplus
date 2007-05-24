if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "MINIGUN"
	SWEP.ViewModelFlip		= false
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "z"
	
	killicon.AddFont("tw_minigun", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_M249.Single" )
SWEP.Primary.ClipSize		= 250
SWEP.Primary.Ammo			= "ar2"

SWEP.Heat				= 0

function SWEP:AdditionalPrimaryAttack ()
	self.Heat = self.Heat + 24
	Msg ("Heat: "..self.Heat.."\n")
end

function SWEP:AdditionalThink ()
	self.Heat = math.max (self.Heat - (1.3 + math.min ((CurTime() - self.LastShot) * 2, 4)), 0)
end

function SWEP:GetDelay ()
	self.Heat = math.min (self.Heat, 500)
	return 60 / (400 + self.Heat)
end

SWEP.Firemodes						= {
	{
		Name							= "MINIGUN",
		Kick							= 1.4,
		Damage							= 21,
		NumShots						= 1,
		Cone							= 0.022,
		Delay							= SWEP.GetDelay,
		Automatic						= true,
		
		ConeMulStanding					= 1.2,
		MaxConeMul						= 10,
		ConeLossPerShot 				= 0.98,
		ConeLossPerShotCrouching		= 0.89,
		ConeRecovery		 			= 0.12,
		ConeRecoveryCrouching 			= 0.13,
	}
}