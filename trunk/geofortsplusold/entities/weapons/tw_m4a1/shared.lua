if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "M4A1"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "w"
	
	killicon.AddFont("tw_m4a1", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Ammo			= "ar2"

SWEP.Firemodes						= {
	{
		Name							= "Automatic",
		Kick							= 1.8,
		Damage							= 10,
		NumShots						= 1,
		Cone							= 0.015,
		Delay							= 0.1,
		Automatic						= true,
		
		ConeMulStanding					= 1.6,
		MaxConeMul						= 3.9,
		ConeLossPerShot 				= 0.87,
		ConeLossPerShotCrouching		= 0.77,
		ConeRecovery		 			= 0.054,
		ConeRecoveryCrouching 			= 0.074,
	},
	{
		Name							= "Semi-automatic",
		Cone							= 0.013,
		Delay							= 0.14,
		Automatic						= false,
	},
	{
		Name							= "3-shot burst",
		Cone							= 0.014,
		Delay							= 0.4,
		Automatic						= false,
		
		ShotsToSchedule					= {0.08, 0.16}
	},
}
