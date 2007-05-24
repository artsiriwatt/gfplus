if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "SSG552"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "A"
	
	killicon.AddFont("tw_sg552", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_sg552.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_SG552.Single" )
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Ammo			= "ar2"

SWEP.Firemodes						= {
	{
		Name							= "Automatic",
		Kick							= 1.5,
		Damage							= 9,
		NumShots						= 1,
		Cone							= 0.012,
		Delay							= 0.09,
		Automatic						= true,
		
		ConeMulStanding					= 1.6,
		MaxConeMul						= 9,
		ConeLossPerShot 				= 1.29,
		ConeLossPerShotCrouching		= 1.23,
		ConeRecovery		 			= 0.09,
		ConeRecoveryCrouching 			= 0.11,
	},
	{
		Name							= "Zoomed",
		Cone							= 0.009,
		Delay							= 0.15,
		Automatic						= true,
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
