// original by jA_cOp (jakob_oevrum@hotmail.com)

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if (CLIENT) then
	SWEP.CSMuzzleFlashes = false
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.PrintName = "C4"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
end

SWEP.AdminSpawnable = false
SWEP.Spawnable = false

SWEP.ViewModel			= Model("models/weapons/v_c4.mdl")
SWEP.WorldModel			= Model("models/weapons/w_c4.mdl")
SWEP.WorldPlantedModel	= Model("models/weapons/w_c4_planted.mdl")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.sounds = {
	planted = Sound("weapons/c4/c4_plant.wav"),
/*	explosion = Sound("ambient/explosions/explode_1.wav"),
	beep = Sound("buttons/blip1.wav"),
	plant = Sound("weapons/c4/c4_plant.wav"),
	beep = Sound("weapons/c4/c4_beep1.wav"),
	click = Sound("weapons/c4/c4_click.wav"),
	explode = Sound("weapons/c4/c4_explode1.wav"),
	explodeDebris = Sound("weapons/c4/c4_exp_deb2.wav"),*/
	}
/*SWEP.reloadtimer = 1
SWEP.chargetimer = 20
SWEP.chargecountdown = SWEP.chargetimer
SWEP.SetNextReload = 1
SWEP.StartSprite = 1
SWEP.DetonationMode = 1
SWEP.RemoteDetonation = 0
SWEP.ShowHud = 0*/

/*---------------------------------------------------------
	Countdown/Explosion
---------------------------------------------------------*/
/*
function SWEP:chargecountdownfunction(charge)

         if self.chargecountdown == 0 then

         self.ShowHud = 0

         local effectdata = EffectData()
         effectdata:SetOrigin( self.charge:GetPos() )
         util.Effect( "c4explosion", effectdata )

         for _,effect in pairs(ExplosionEffectTable) do
             effect:Fire("Explode","",0)
             effect:Fire("kill","",1)
         end

         self.explosion:Fire("Explode","",0)
         self.physexplosion:Fire("explode","",0)
         
         
         self.charge:Fire("kill","",0.1)
         self.explosion:Fire("kill","",1)
         self.physexplosion:Fire("kill","",1)
         self.bombsprite:Fire("kill","",0.1)
         

         
         self.chargecountdown = self.chargetimer
         self.charge:EmitSound("ambient/explosions/explode_1.wav")
         self.charge:SetColor(255,255,255,0)
         self.chargeactive = 0
         
         for k, v in pairs(player.GetAll()) do
         v:EmitSound("ambient/explosions/explode_1.wav")
         v:EmitSound("weapons/c4/c4_explode1.wav")
         v:EmitSound("weapons/c4/c4_exp_deb2.wav")
         end

         self.entsinradius = ents.FindInSphere(self.charge:GetPos(),500)
         self.entstoignite = {}

         if self.entsinradius != nil then

            for _,ent in pairs(self.entsinradius) do

                 local trace = {}
	         trace.start = self.charge:GetPos()
                 trace.endpos = ent:GetPos()
                 trace.filter = {self.charge, self.explosion, self.shakeeffect, self.physexplosion, self.bombsprite, ent}

	         local tr = util.TraceLine(trace)

                       if tr.HitWorld == false then
                          table.insert(self.entstoignite , ent )
                       end
            end

            for _,ent in pairs(self.entstoignite) do
                if ent:GetClass() == "player" or ent:GetClass() == "prop_physics" then
                   ent:Ignite(math.random(10,20),0)
                end
            end
         end


         firetable = {}

         for i = 1,20,1 do
             self.boomfire = ents.Create("env_fire")
             self.boomfire:SetOwner( self.Owner )
             
             table.insert(firetable,self.boomfire)
         end



         for _,EntFire in pairs(firetable) do
             local trace = {}
	     trace.start = self.charge:GetPos()
	     trace.endpos = self.charge:GetPos() + Vector(0,0,200)
	     trace.filter = self.charge
             
             local tr = util.TraceLine(trace)
             
             local trace2 = {}
	     trace2.start = tr.HitPos
	     trace2.endpos = self.charge:GetPos() + Vector(math.random(-350,350),math.random(-350,350),0)
	     trace2.filter = self.charge
             
             local tr2 = util.TraceLine(trace2)
             
             EntFire:SetKeyValue("health",tostring(math.random(10,20)))
             EntFire:SetKeyValue("firesize",tostring(math.random(30,120)))
             EntFire:SetKeyValue("fireattack","1")
             EntFire:SetKeyValue("damagescale","20")
             EntFire:SetKeyValue("spawnflags","128")
             EntFire:SetPos(tr2.HitPos)
             EntFire:Spawn()
             EntFire:Activate()
             EntFire:Fire("StartFire","",0)
         end

         sparktable = {}
         for i = 1,12,1 do
         self.EntSpark = ents.Create("env_spark")
         table.insert(sparktable,self.EntSpark)
         end
         
         for _,Sparks in pairs(sparktable) do
             local trace = {}
	     trace.start = self.charge:GetPos() + Vector(0,0,200)
	     trace.endpos = self.charge:GetPos() + Vector(math.random(-350,350),math.random(-350,350),math.random(0,250))
             local tr = util.TraceLine(trace)
             
             Sparks:SetKeyValue("Magnitude",tostring(math.random(2,8)))
             Sparks:SetKeyValue("TrailLength",tostring(math.random(1,3)))
             Sparks:SetPos(tr.HitPos)
             Sparks:Spawn()
             Sparks:Fire("SparkOnce","",0)
             Sparks:Fire("kill","",2)

         end
end

function SWEP:SpriteToggle(bombsprite)
         if self.chargecountdown == 0 then return end
            self.bombsprite:Fire("ToggleSprite","",0)

            timer.Simple(0.5,self.SpriteToggle,self,self.bombsprite)
end
&/

/*---------------------------------------------------------
	Reload
---------------------------------------------------------*/
/*
function SWEP:Reload()
         if CLIENT then return end
            if self.DetonationMode == 2 then return end



         if self.reloadtimer == 1 and self.SetNextReload == 1 then
         self.chargetimer = 5
         self.Owner:PrintMessage(4,"Charge set to 5 seconds.")
         self.Owner:EmitSound("weapons/c4/c4_click.wav")
         timer.Simple(0.2,self.NextReload1,self)
         self.SetNextReload = 0
         end

         if self.reloadtimer == 2 and self.SetNextReload == 1 then
         self.chargetimer = 10
         self.Owner:PrintMessage(4,"Charge set to 10 seconds.")
         self.Owner:EmitSound("weapons/c4/c4_click.wav")
         timer.Simple(0.2,self.NextReload2,self)
         self.SetNextReload = 0
         end

         if self.reloadtimer == 3 and self.SetNextReload == 1 then
         self.chargetimer = 20
         self.Owner:PrintMessage(4,"Charge set to 20 seconds.")
         self.Owner:EmitSound("weapons/c4/c4_click.wav")
         timer.Simple(0.2,self.NextReload3,self)
         self.SetNextReload = 0
         end

         if self.reloadtimer == 4 and self.SetNextReload == 1 then
         self.chargetimer = 60
         self.Owner:PrintMessage(4,"Charge set to 60 seconds.")
         self.Owner:EmitSound("weapons/c4/c4_click.wav")
         timer.Simple(0.2,self.NextReload4,self)
         self.SetNextReload = 0

         else return end


end

function SWEP:NextReload1()
         self.SetNextReload = 1
         self.reloadtimer = 2
end

function SWEP:NextReload2()
         self.SetNextReload = 1
         self.reloadtimer = 3

end

function SWEP:NextReload3()
         self.SetNextReload = 1
         self.reloadtimer = 4
end

function SWEP:NextReload4()
         self.SetNextReload = 1
         self.reloadtimer = 1
end
*/
/*---------------------------------------------------------
   Think
---------------------------------------------------------*/
/*
function SWEP:Think()

end
*/

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if CLIENT then
		return
	end
	if self:Trace().Fraction < 1 then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.plantTimer = CurTime() + 2.5
	end
end

function SWEP:Think()
	if self.plantTimer then
		local tr = self:Trace()
		if not self.Owner:KeyDown(IN_ATTACK) or tr.Fraction >= 1 then
			self.plantTimer = nil
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		elseif CurTime() > self.plantTimer then
			self.plantTimer = nil
			self.Owner:EmitSound(self.sounds.planted)
			self.Owner:StripWeapon("weapon_c4")
			self.planted = ents.Create("gf_c4")
			self.planted:SetModel(self.WorldPlantedModel)
			self.planted:SetOwner(self.Owner)
			self.planted:SetPos(tr.HitPos)
			self.planted.timer = CurTime() + 5
			self.planted.trace = tr
			self.planted:Spawn()
		end
	end
end

function SWEP:Trace()
	local t = {}
	t.start = self.Owner:GetShootPos()
	t.endpos = t.start + (self.Owner:GetAimVector() * 100)
	t.filter = self.Owner
	return util.TraceLine(t)
end

function PlayerExtinguish(ply)
	if ply:IsOnFire() then
		ply:Extinguish()
	else
		return
	end
end
hook.Add("PlayerSpawn", "PlayerExtinguish", PlayerExtinguish)
