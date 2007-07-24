HDVs = {}
HDVs [HITGROUP_HEAD] = 2.8
HDVs [HITGROUP_CHEST] = 1.6
HDVs [HITGROUP_STOMACH] = 1.4
HDVs.Other = 0.7
 
function GM:ScalePlayerDamage (pl, hitgroup, dmg)
    basedmg = dmg:GetDamage()
    Msg ("player hit for "..dmg:GetDamage().." damage\n")
    if HDVs[hitgroup] then dmg:ScaleDamage (HDVs[hitgroup]) else dmg:ScaleDamage (HDVs.Other) end
    Msg ("translated for hitgroup: "..dmg:GetDamage().." damage\n")
	if dmg:IsBulletDamage() then
		epos = dmg:GetAttacker():GetShootPos()
		vpos = pl:GetShootPos()
		relative = epos - vpos
		dist = math.min (relative:Length (), 1000)
		dmg:SubtractDamage (math.min (dist / 100, basedmg / 2))
	end
    dmg:SubtractDamage (-basedmg) --blunt hack because otherwise we'd be doing the damage - twice??? And subtract ADDS???
    return dmg
end
