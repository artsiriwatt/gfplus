if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
end

if CLIENT then
	SWEP.PrintName			= "12 GAUGE"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "k"
	SWEP.IconOffset			= {0, 8}
	killicon.AddFont("tw_m3", "CSKillIcons", SWEP.IconLetter, Color (255, 80, 0, 255))
end

SWEP.Base				= "tw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_m3.Single" )
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Ammo			= "buckshot"

SWEP.Firemodes						= {
	{
		Name							= "Pump-action",
		Kick							= 20,
		Damage							= 3.4,
		NumShots						= 8,
		Cone							= 0.095,
		Delay							= 0.94,
		Automatic						= false,

		ConeMul							= 1,		
		ConeMulStanding					= 1,
		MaxConeMul						= 3,
		ConeLossPerShot 				= 5,
		ConeLossPerShotCrouching		= 5,
		ConeRecovery		 			= 0.05,
		ConeRecoveryCrouching 			= 0.05,
	}
}

function SWEP:Reload()
	//if ( CLIENT ) then return end
	// Already reloading
	if self.Weapon:GetNetworkedBool( "reloading", false ) then return end
	// Start reloading if we can
	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 and self.LastShot < CurTime() - self.Primary.Delay then
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
	end
end

function SWEP:AdditionalThink()
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			// Next cycle -- maybe
			--they might want to fire now, y'know.
			// Add ammo
			--if SERVER then
			--	self.Owner:GiveAmmo (1, self.Primary.Ammo, true)
			--end
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			if self.Owner:KeyDown(IN_ATTACK) or self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 then
				self.Weapon:SetNetworkedBool( "reloading", false )
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.6 )
			else
				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.35 )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.35 )
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			end

/*			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.35 )
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.35 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.7 )
			end*/
		end
	end
end
