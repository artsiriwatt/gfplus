if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "FN P90"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "m"
	
	killicon.AddFont("tw_p90", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_P90.Single" )
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Ammo			= "smg1"

SWEP.Firemodes						= {
	{
		Name							= "Automatic",
		Kick							= 0.8,//0.7,//1.4,
		Damage							= 7,
		NumShots						= 1,
		Cone							= 0.026,
		Delay							= 0.07,
		Automatic						= true,
		
		ConeMulStanding					= 1.3,//1.5,//1.7,
		MaxConeMul						= 4,
		ConeLossPerShot 				= 0.44,//0.3,//0.64,
		ConeLossPerShotCrouching		= 0.4,//0.2,//0.57,
		ConeRecovery		 			= 0.048,//0.052,
		ConeRecoveryCrouching 			= 0.06//0.068, //made second change layer to stop perfect accuracy when crouching
	}
}
