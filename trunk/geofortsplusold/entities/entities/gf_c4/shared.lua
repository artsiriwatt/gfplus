ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.sounds =
{
	beep = Sound("weapons/c4/c4_beep1.wav"),
	explode1 = Sound("ambient/explosions/explode_1.wav"),
	explode2 = Sound("weapons/c4/c4_explode1.wav"),
	explode3 = Sound("weapons/c4/c4_exp_deb2.wav"),
}

if CLIENT then
	return
end

function ENT:Initialize()
	local ang = self.trace.HitNormal:Angle()
	ang:RotateAroundAxis(ang:Right(), -90)
	local color = team.GetColor(self.Entity:GetOwner():Team())
	self.Entity:SetAngles(ang)

	-- create the explosions

	-- create the flashing light
	self.sprite = ents.Create("env_sprite")
	self.sprite:SetKeyValue("model", "sprites/blueflare1.spr")
	self.sprite:SetKeyValue("rendercolor", color.r .. " " .. color.g .. " " .. color.b)
	self.sprite:SetKeyValue("rendermode", "3")
	self.sprite:SetKeyValue("scale", "0.3")
	self.sprite:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 10)
	self.sprite:Spawn()
	self.sprite:Fire("showsprite", "", 0)
	self.Entity:DeleteOnRemove(self.sprite)
	timer.Simple(0.5, self.Flash, self)
	timer.Simple(0, self.Beep, self)
end

function ENT:Beep()
	if CurTime() < self.timer then
		self.Entity:EmitSound(self.sounds.beep)
		timer.Simple(1, self.Beep, self)
	end
end

function ENT:Explode()
	-- play the sound
	for _, ply in pairs(player:GetAll()) do
		ply:EmitSound(self.sounds.explode1)
		ply:EmitSound(self.sounds.explode2)
		ply:EmitSound(self.sounds.explode3)
	end
	-- shake
	local shake = ents.Create("env_shake")
	shake:SetKeyValue("amplitude", "16")
	shake:SetKeyValue("duration", "3")
	shake:SetKeyValue("frequency", "200")
	shake:SetKeyValue("spawnflags", "29")
	shake:SetPos(self.Entity:GetPos())
	shake:Fire("startshake", "", 0)
	shake:Fire("kill", "", 4)
	-- smoke
	for i = 1, 2 do
		local e = ents.Create("env_ar2explosion")
		e:SetOwner(self.Entity:GetOwner())
		e:SetPos(self.Entity:GetPos() + Vector(0, 0, 5))
		e:Spawn()
		e:Fire("explode", "", 0)
		e:Fire("kill", "", 1)
	end
	-- unfreeze and ignite
	local classes = {"gf_bb_spawner", "gf_scoreboard", "gf_timeboard", "gf_supply"}
	local entities = ents.FindInSphere(self.Entity:GetPos(), 200)
	for _, ent in pairs(entities) do
		local v = ent:GetPos() - self.Entity:GetPos() 
		local f = 1 - (v:Length() / 200)
		local v = v:GetNormal() * 1000 * f
		v = v + Vector(0, 0, 500)
		if v.z > 500 then
			v.z = 500
		end
        ent:Ignite(10 * f, 0)
		if ent:IsPlayer() then
			ent:SetGroundEntity(nil)
			ent:SetVelocity(v)
		else
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				if ent:GetName() == "gfbb" or table.HasValue(classes, ent:GetClass()) then
					phys:EnableMotion(true)
					phys:ApplyForceCenter(v)
				end
			end
		end
	end
	local e = ents.Create("env_explosion")
	e:SetKeyValue("imagnitude", "200")
	e:SetKeyValue("spawnflags", "320")
	e:SetOwner(self.Entity:GetOwner())
	e:SetPos(self.Entity:GetPos() + Vector(0, 0, 5))
	e:Spawn()
	e:Fire("explode", "", 0)
	e:Fire("kill", "", 1)
	local pe = ents.Create("env_physexplosion")
	pe:SetKeyValue("magnitude", "500")
	pe:SetKeyValue("radius", "200")
	pe:SetOwner(self.Entity:GetOwner())
	pe:SetPos(self.Entity:GetPos())
	pe:Spawn()
	pe:Fire("explode", "", 0)
	pe:Fire("kill", "", 1)
end

function ENT:Flash()
	if CurTime() < self.timer and self.sprite and self.sprite:IsValid() then
		self.sprite:Fire("togglesprite", "", 0)
		timer.Simple(0.5, self.Flash, self)
	end
end

function ENT:Think()
	if CurTime() > self.timer then
		self:Explode()
		self.Entity:Remove()
	end
end
