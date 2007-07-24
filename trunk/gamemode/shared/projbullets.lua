local ent = FindMetaTable ("Entity")
if (!ent) then return end

function ent:FireProjBullets (bullet)
	for i=1, bullet.Num do
		aAim = bullet.Dir:Angle()
		aAim:RotateAroundAxis (aAim:Up(), ((math.random() * 2) - 1) * bullet.Spread)
		aAim:RotateAroundAxis (aAim:Right(), ((math.random() * 2) - 1) * bullet.Spread)
		aVec = aAim:Forward ()
		projbullets.projectiles[#projbullets.projectiles+1] = {
			Pos = bullet.Src,
			Vel = aVec * (bullet.Speed or 500),
			Weight = bullet.Weight or 100,
			Attacker = self
		}
		if SERVER then
			--tell all the clients, eventually
		end
	end
end

projbullets = {projectiles = {}}

function projbullets.Think ()
	for k,v in pairs (projbullets.projectiles) do
		local killWhenDone = false
		Msg ("Bullet from "..tostring(v.Attacker).." being calculated!\n")
		local trcdata = {
			start = v.Pos,
			endpos = v.Pos + v.Vel,
			filter = v.Attacker,
			mask = MASK_SHOT
	    }
		local trBullet = util.TraceLine (trcdata)
		if trBullet.Hit then
			Msg ("bullet hits ("..tostring(trBullet.HitPos)..")!\n")
			v.Attacker:FireBullets ({
	            Num = 1,
	            Src = v.Pos,
	            Dir = v.Vel:Normalize(),
	            Spread = Vector (0,0,0),
	            Tracer = 0,
	            Force = v.Vel * v.Weight / 25000,
	            Damage = v.Vel * v.Weight / 5000
	        })
			killWhenDone = true
		else
			v.Pos = v.Pos + v.Vel
			v.Vel = Vector (0,0,-0.01) + v.Vel * 0.99
		end
		if killWhenDone then
			projbullets.projectiles[k] = nil
		end
	end
end

hook.Add ("Think", "pb.T", projbullets.Think)