if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "MAC-10"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "l"
	SWEP.IconOffset			= {0, 1}
	killicon.AddFont("tw_mac10", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Ammo			= "smg1"

SWEP.Firemodes						= {
	{
		Name							= "Automatic",
		Kick							= 2,
		Damage							= 5,
		NumShots						= 1,
		Cone							= 0.035,
		Delay							= 0.07,
		Automatic						= true,
		
		ConeMulStanding					= 1.2,
		MaxConeMul						= 3,
		ConeLossPerShot 				= 0.37,
		ConeLossPerShotCrouching		= 0.33,
		ConeRecovery		 			= 0.051,
		ConeRecoveryCrouching 			= 0.055,
	}
}
