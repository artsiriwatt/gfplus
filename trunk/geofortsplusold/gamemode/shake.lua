local SHAKE = {}

function SHAKE.Add(player, amplitude, duration, frequency)
	if SERVER then
		umsg.Start("shake", player)
		umsg.Float(amplitude)
		umsg.Float(duration)
		umsg.Float(frequency)
		umsg.End()
		player.shaking = (duration == -1)
	else
		player.shake = {
			amplitude = amplitude,			// how much to shake
			duration = duration,			// how long to shake
			fraction = 1,
			frequency = frequency,			// times per second to update shake
			next = CurTime(),				// next time to update shake
			offset = Vector(0, 0, 0),
			offsetAngles = Angle(0, 0, 0),
			time = CurTime() + duration		// when the shake will end
		}
	end
end

function SHAKE.AddMessage(bf)
	SHAKE.Add(LocalPlayer(), bf:ReadFloat(), bf:ReadFloat(), bf:ReadFloat())
end
if CLIENT then usermessage.Hook("shake", SHAKE.AddMessage) end

function SHAKE.Stop(player)
	if SERVER then
		umsg.Start("shakestop", player)
		umsg.End()
		player.shaking = false
	else
		player.shake = nil
	end
end

function SHAKE.StopMessage(bf)
	SHAKE.Stop(LocalPlayer())
end
if CLIENT then usermessage.Hook("shakestop", SHAKE.StopMessage) end

function SHAKE.Think(player)
	if not player.shake or (player.shake.duration != -1 and CurTime() >= player.shake.time) then
		player.shake = nil
		return
	end
	local s = player.shake
	if CurTime() >= s.next then
		s.next = CurTime() + (1 / s.frequency)
		for _, k in ipairs({"x", "y", "z"}) do
			// -amplitude >= n <= amplitude
			s.offset[k] = math.random() * s.amplitude * 2 - s.amplitude
		end
		local a = s.amplitude * 0.25
		for _, k in ipairs({"yaw", "pitch", "roll"}) do
			s.offsetAngles[k] = math.random() * a * 2 - a
		end
	end
	if player.shake.duration != -1 then
		s.fraction = (s.time - CurTime()) / s.duration
		s.fraction = s.fraction * s.fraction
	end
end

// -----------------------------------------------------------------------------

if CLIENT then

		function CalcViewShake(player, pos, ang, fov)
			SHAKE.Think(player)
			if player.shake then
				pos = pos + player.shake.offset * player.shake.fraction
				ang = ang + player.shake.offsetAngles * player.shake.fraction
				return GAMEMODE:CalcView(player, pos, ang, fov)
			end
		end
		hook.Add("CalcView", "CalcViewShake", CalcViewShake)
end

// -----------------------------------------------------------------------------

if SERVER then
	local weaponShakes =
	{
		weapon_pistol	= {0.5,  0.1, 100},
		weapon_357		= {2.0,  0.1, 100},
		weapon_ar2		= {0.5, -1.0, 100},
		weapon_smg1		= {0.2, -1.0, 100},
		weapon_shotgun	= {1.0,  0.5, 100},
		weapon_rpg		= {4.0,  0.5, 100},
		weapon_frag		= {1.0,  0.2,  20},
		--tw_m3			= {1.0,  0.5, 100},
		--tw_m4a1			= {0.5, -1.0, 100},
		--tw_p90			= {0.5, -1.0, 100},
		--tw_p228			= {0.5,  0.1, 100},
		--tw_usp			= {0.5,  0.1, 100}, --removed - why are they here? The weapon recoil suffices.
	}
	function AttackShake(player, animation)
		local weapon = player:GetActiveWeapon()
		if not weapon or not weapon:IsValid() or not weapon:IsWeapon() then return end
		if animation == PLAYER_ATTACK1 then
			local values = weaponShakes[weapon:GetClass()]
			if values then
				SHAKE.Add(player, values[1], values[2], values[3])
			end
		elseif player.shaking and (animation == PLAYER_RELOAD or not player:KeyDown(IN_ATTACK)) then
			SHAKE.Stop(player)
		end 
	end
	hook.Add("SetPlayerAnimation", "AttackShake", AttackShake)

	function StopShakeOnDeath(ply)
		SHAKE.Stop(player)
	end
	hook.Add("PlayerDeath", "StopShakeOnDeath", StopShakeOnDeath)
end
