if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "pistol"
end

if CLIENT then
	SWEP.PrintName			= "DEAGLE"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "f"
	SWEP.IconOffset			= {0, 3}
	killicon.AddFont("tw_deagle", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_deagle.Single" )
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Ammo			= "pistol"

SWEP.Firemodes						= {
	{
		Name							= "Semi-automatic",
		Kick							= 5.3,
		Damage							= 13,
		NumShots						= 1,
		Cone							= 0.017,
		Delay							= 0.24,
		Automatic						= false,
		
		ConeMulStanding					= 1.7,
		MaxConeMul						= 3.5,
		ConeLossPerShot 				= 1.7,
		ConeLossPerShotCrouching		= 1.5,
		ConeRecovery		 			= 0.065,
		ConeRecoveryCrouching 			= 0.078,
	}
}
