function RecoilThink( )
	for k,v in pairs (player.GetAll()) do
		v:AddRecoil()
	end
end
hook.Add ("Think", "RecoilThink", RecoilThink)

local pl = FindMetaTable ("Player")
function pl:Recoil (pitch, yaw)
	if ( SERVER && SinglePlayer() ) then
		// Please don't call SendLua in multiplayer games. This uses a lot of bandwidth
		str = "LocalPlayer():Recoil("..pitch..","..yaw..")"
		self:SendLua(str)
		return
	end
	
	self:GetTable().RecoilYaw = self:GetTable().RecoilYaw or 0
	self:GetTable().RecoilPitch = self:GetTable().RecoilPitch or 0
	self:GetTable().RecoilYaw = self:GetTable().RecoilYaw 		+ yaw
	self:GetTable().RecoilPitch = self:GetTable().RecoilPitch 	+ pitch
end

function pl:AddRecoil (pitch, yaw)
	--Msg ("Clientside addrecoil\n")
	if SERVER then return end
	if self != LocalPlayer() then return end
	local pitch = self:GetTable().RecoilPitch or 0
	local yaw = self:GetTable().RecoilYaw or 0
	--Msg ("Seeing recoil ("..pitch..", "..yaw..")\n")
	local pitch_d = math.Approach (pitch, 0.0, 20.0 * FrameTime() * math.abs(pitch))
	local yaw_d	= math.Approach (yaw, 0.0, 20.0 * FrameTime() * math.abs(yaw))
	self:GetTable().RecoilPitch = pitch_d
	self:GetTable().RecoilYaw = yaw_d	
	// Update eye angles
	local eyes = self:EyeAngles()
		eyes.pitch = eyes.pitch + (pitch - pitch_d)
		eyes.yaw = eyes.yaw + (yaw - yaw_d)
		eyes.roll = 0
	self:SetEyeAngles (eyes)
end

TICKMULTIPLIER = 1

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true

end

if ( CLIENT ) then

	SWEP.DrawCrosshair		= false
	SWEP.DrawAmmo			= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	
	// This is the font that's used to draw the death icons
	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )

end

SWEP.Author			= "TW Devenger"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Kick			= 2
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Delay		= 0.5
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ConeMul			= 1

SWEP.ConeMulStanding				= 1.8
SWEP.MaxConeMul			 			= 3.9
SWEP.ConeLossPerShot 				= 0.5
SWEP.ConeLossPerShotCrouching		= 0.43
SWEP.ConeRecovery		 			= 0.024
SWEP.ConeRecoveryCrouching 			= 0.045

SWEP.MoveSpeed 			= 190

SWEP.LastShot			= 0

SWEP.Firemode			= 1

SWEP.ShotSchedule		= {}

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType (self.HoldType)
	end
	self:SetFiremode(self.Firemode or 1)
end

function SWEP:Reload()
	self.ConeMul = self.MaxConeMul
	self.Weapon:DefaultReload (ACT_VM_RELOAD)
	self:AdditionalReload()
end

function SWEP:AdditionalReload()
end

function SWEP:Holster()
	self.ConeMul = self.MaxConeMul
		if SERVER then self.Owner:SetFOV (90, 0.2) end
	self:AdditionalHolster ()
	return true
end

function SWEP:AdditionalHolster ()

end

function SWEP:Deploy()
	util.PrecacheSound (self.Primary.Sound)
	self.ConeMul = self.MaxConeMul
	if SERVER then self.Owner:SetFOV (90, 0.2) end
	self:AdditionalDeploy ()
	self:SetFiremode (self.Firemode)
	return true
end

function SWEP:AdditionalDeploy ()

end

function SWEP:OwnerChanged ()
	if SERVER then self.Owner:SetFOV (90, 0.2) end
	self.ShotSchedule = {}
	if SERVER then
		self.Owner:GiveAmmo (self.Primary.ClipSize * 4, self.Primary.Ammo)
	end
	self:Deploy ()
	self.Weapon:SetClip1 (self.Primary.ClipSize)
end

function SWEP:Think()
	self.Firemode = self.Weapon:GetNetworkedInt ("firemode", 1)
	if not self.Owner:IsOnGround() then
		self.ConeMul = self.MaxConeMul
	end
	if self.Owner:Crouching() and self.ConeMul > 1 then
		self.ConeMul = math.max (self.ConeMul - self.ConeRecoveryCrouching * TICKMULTIPLIER, 1)
	elseif not self.Owner:Crouching() and self.ConeMul < (self.ConeMulStanding or 1) then
		self.ConeMul = self.ConeMul + self.ConeLossPerShot * TICKMULTIPLIER
	elseif not self.Owner:Crouching() and self.ConeMul > (self.ConeMulStanding or 1) then
		self.ConeMul = math.max (self.ConeMul - self.ConeRecovery * TICKMULTIPLIER, self.ConeMulStanding)
	end
	self.ConeMul = math.min (self.ConeMul, self.MaxConeMul)
	if SinglePlayer() then
		if SERVER then
			self.Weapon:SetNetworkedFloat ("conemul", self.ConeMul)
		else
			self.ConeMul = self.Weapon:GetNetworkedFloat ("conemul", "0")
		end
	end
	if type(self.ShotSchedule) == "table" then
		for k,v in pairs(self.ShotSchedule) do
			if CurTime() > v then
				self:DoShot ()
				self.ShotSchedule[k] = nil
			end
		end
	end
	self:AdditionalThink ()
end

function SWEP:AdditionalThink ()
	
end

function SWEP:PrimaryAttack()
	if type(self.Primary.Delay) == "function" then
		self.Weapon:SetNextPrimaryFire (CurTime() + self.Primary.Delay(self))
	else
		self.Weapon:SetNextPrimaryFire (CurTime() + self.Primary.Delay)
	end
	self:DoShot()
	
	if type(self.ShotsToSchedule) ~= "table" then
		return
	end
	for k,v in pairs (self.ShotsToSchedule) do
		table.insert (self.ShotSchedule, CurTime() + v)
	end
	self:AdditionalPrimaryAttack ()
end

function SWEP:AdditionalPrimaryAttack ()
	
end

function SWEP:DoShot()
	
	if ( !self:CanPrimaryAttack() ) then return end
	
	self.LastShot = CurTime()
	
	// Shoot the bullet
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if (SinglePlayer() && SERVER) || CLIENT then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	self.Owner:LagCompensation (true)
	
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	cone = self:ConeOverride (cone)
	bullet.Spread 	= Vector( cone * self.ConeMul, cone * self.ConeMul, 0 )			// Aim Cone
	bullet.Tracer	= 1
	bullet.Force	= dmg / 3.5								// Amount of force to give to phys objects
	bullet.Damage	= dmg
	
	self.Owner:FireBullets( bullet )
	
	self.Owner:LagCompensation (false)
	
	self:FireEffects ()
	
	self.Owner:Recoil (math.Rand (-1, -0.5) * self.Primary.Kick * 0.3 * (1 + (self.ConeMul - 1) * 0.4), math.Rand (-1, 1) * self.Primary.Kick * 0.3 * (1 + (self.ConeMul - 1) * 0.4))

	if self.Owner:Crouching() then
		self.ConeMul = self.ConeMul + self.ConeLossPerShotCrouching
	else
		self.ConeMul = self.ConeMul + self.ConeLossPerShot
	end

end

function SWEP:FireEffects ()
	self.Weapon:SendWeaponAnim (ACT_VM_PRIMARYATTACK) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation (PLAYER_ATTACK1)				// 3rd Person Animation
	self.Weapon:EmitSound (self.Primary.Sound)				// Play shoot sound
end

function SWEP:ConeOverride (val)
	return val
end

function SWEP:SecondaryAttack ()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	if self.Firemodes[2] == nil then return end
	msgb = self:ShowFiremodeMessage ()
	if self.Firemodes[self.Firemode + 1] ~= nil then
		self:SetFiremode(self.Firemode + 1, msgb)
	else
		self:SetFiremode(1, msgb)
	end
end

function SWEP:ShowFiremodeMessage ()
	return true
end

function SWEP:SetFiremode(firemode, msgbool)
	self.Firemode = firemode
	local fmt = self.Firemodes[self.Firemode]
	self.Primary.Kick				= fmt.Kick or self.Primary.Kick
	self.Primary.Damage				= fmt.Damage or self.Primary.Damage
	self.Primary.NumShots			= fmt.NumShots or self.Primary.NumShots
	self.Primary.Cone				= fmt.Cone or self.Primary.Cone
	self.Primary.Delay				= fmt.Delay or self.Primary.Delay
	self.Primary.Automatic			= fmt.Automatic
	self.ConeMulStanding			= fmt.ConeMulStanding or self.ConeMulStanding
	self.MaxConeMul			 		= fmt.MaxConeMul or self.MaxConeMul
	self.ConeLossPerShot 			= fmt.ConeLossPerShot or self.ConeLossPerShot
	self.ConeLossPerShotCrouching	= fmt.ConeLossPerShotCrouching or self.ConeLossPerShotCrouching
	self.ConeRecovery		 		= fmt.ConeRecovery or self.ConeRecovery
	self.ConeRecoveryCrouching 		= fmt.ConeRecoveryCrouching or self.ConeRecoveryCrouching
	self.ShotsToSchedule		 	= fmt.ShotsToSchedule or {}
	if SERVER then
		if msgbool then
			self.Owner:PrintMessage (4, "Changed to "..fmt.Name.." mode\n")
			self.Weapon:EmitSound( "Weapon_Pistol.Empty" )
		end
		self.Weapon:SetNetworkedInt ("firemode", self.Firemode)
	end
	self:AdditionalSetFiremode (firemode, msgbool)
end

function SWEP:AdditionalSetFiremode ()
	
end

/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	if not INIT_TW_FONTS then
		surface.CreateFont("verdana", 0.022 * ScrH(), 500, true, true, "Verdana22")
		INIT_TW_FONTS = true
	end
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), 1 )
end

/*---------------------------------------------------------
	DrawHUD
	Crosshair!
---------------------------------------------------------*/
function SWEP:DrawHUD()
	local tracedata = {}
    tracedata.start = LocalPlayer():GetShootPos()
    tracedata.endpos = LocalPlayer():GetShootPos()+(LocalPlayer():GetAimVector()*9000)
    tracedata.filter = LocalPlayer()
    local trace = util.TraceLine(tracedata)
    local pos = trace.HitPos:ToScreen()
	
	local x = pos.x
	local y = pos.y
	
	conemul = self.ConeMul

	local scale = 10 * self.Primary.Cone * conemul
	
	scale = self:SpecificConeModify (scale)
	
	surface.SetDrawColor( 200, 255, 255, 255 )
	
	local gap = 40 * scale
	local length = gap + 12
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	
	self:AdditionalDrawHUD()
end

function SWEP:AdditionalDrawHUD ()
	
end

function SWEP:SpecificConeModify (scale)
	scale = scale / (self.Owner:GetFOV () / 90)
	return scale
end

function SWEP:GetViewModelPosition (pos, ang)
	local tracedata = {}
	tracedata.start = LocalPlayer():GetShootPos()
    tracedata.endpos = LocalPlayer():GetShootPos()+(LocalPlayer():GetAimVector()*9000)
    tracedata.filter = LocalPlayer()
    local trace = util.TraceLine(tracedata)
    local pos = trace.HitPos:ToScreen()
	
	local x = pos.x
	local y = pos.y
	
	local relx = (x / ScrW()) - 0.5
	local rely = (y / ScrH()) - 0.5
	
	ang2 = LocalPlayer():EyeAngles()
	ang2.yaw = ang.yaw - (ang2.yaw - ang.yaw)

	return pos, ang2
end
