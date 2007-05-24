if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "STEYR AUG"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "e"
	
	killicon.AddFont("tw_aug", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_aug.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AUG.Single" )
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Ammo			= "ar2"

SWEP.Firemodes						= {
	{
		Name							= "Automatic",
		Kick							= 2.3,
		Damage							= 10,
		NumShots						= 1,
		Cone							= 0.009,
		Delay							= 0.14,
		Automatic						= true,
		
		ConeMulStanding					= 1.6,
		MaxConeMul						= 9,
		ConeLossPerShot 				= 1.3,
		ConeLossPerShotCrouching		= 1.2,
		ConeRecovery		 			= 0.08,
		ConeRecoveryCrouching 			= 0.1,
	},
	{
		Name							= "Semi-automatic",
		Cone							= 0.008,
		Delay							= 0.16,
		Automatic						= false,
	}
}

function SWEP:AdditionalSetFiremode (firemode, msgbool)
	if SERVER then
		if self.Owner then
			if firemode == 2 then
				self.Owner:SetFOV (60, 0.2)
			else
				self.Owner:SetFOV (90, 0.2)
			end
		end
	end
end

function SWEP:AdditionalReload ()
	self:SetFiremode (1)
end

function SWEP:ShowFiremodeMessage ()
	return false
end
