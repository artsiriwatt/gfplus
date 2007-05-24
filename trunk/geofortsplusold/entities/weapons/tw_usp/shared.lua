if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "pistol"
end

if CLIENT then
	SWEP.PrintName			= "HK USP"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "a"
	SWEP.IconOffset			= {0, 4}
	killicon.AddFont("tw_usp", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_usp.SilencedShot" )
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Ammo			= "pistol"

SWEP.Firemodes						= {
	{
		Name							= "Semi-automatic",
		Kick							= 2.7,
		Damage							= 8,
		NumShots						= 1,
		Cone							= 0.02,
		Delay							= 0.14,
		Automatic						= false,
		
		ConeMulStanding					= 1.6,
		MaxConeMul						= 3.9,
		ConeLossPerShot 				= 1.2,
		ConeLossPerShotCrouching		= 1.06,
		ConeRecovery		 			= 0.063,
		ConeRecoveryCrouching 			= 0.078,
	}
}

function SWEP:Reload()
	self.ConeMul = self.MaxConeMul
	self.Weapon:DefaultReload (ACT_VM_RELOAD_SILENCED)
	self:AdditionalReload()
end

function SWEP:Deploy ()
	self.Weapon:SendWeaponAnim (ACT_VM_DRAW_SILENCED)
end

function SWEP:FireEffects ()
	self.Weapon:SendWeaponAnim (ACT_VM_DRYFIRE_SILENCED) 		// View model animation
	--self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation (PLAYER_ATTACK1)				// 3rd Person Animation
	--self.Weapon:EmitSound (self.Primary.Sound)
end
