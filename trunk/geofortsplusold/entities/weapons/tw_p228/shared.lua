if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "pistol"
end

if CLIENT then
	SWEP.PrintName			= "SIG P228"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "y"
	SWEP.IconOffset			= {0, 5}
	killicon.AddFont("tw_p228", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_p228.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_p228.Single" )
SWEP.Primary.ClipSize		= 13
SWEP.Primary.Ammo			= "pistol"

SWEP.Firemodes						= {
	{
		Name							= "Semi-automatic",
		Kick							= 2.7,
		Damage							= 9,
		NumShots						= 1,
		Cone							= 0.024,
		Delay							= 0.15,
		Automatic						= false,
		
		ConeMulStanding					= 1.3,
		MaxConeMul						= 3.5,
		ConeLossPerShot 				= 1.5,
		ConeLossPerShotCrouching		= 1.32,
		ConeRecovery		 			= 0.064,
		ConeRecoveryCrouching 			= 0.078,
	}
}
