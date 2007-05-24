AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("gf/hooks.lua")
AddCSLuaFile("gf/cl_button.lua")
AddCSLuaFile("gf/cl_buttonsgroup.lua")
AddCSLuaFile("gf/cl_menus.lua")
AddCSLuaFile("gf/cl_menuteam.lua")
AddCSLuaFile("gf/cl_menuweapon.lua")
AddCSLuaFile("gf/cl_messages.lua")
AddCSLuaFile("gf/cl_round.lua")
AddCSLuaFile("gf/cl_scoreboard2.lua")

include("shared.lua")
include("gf/hooks.lua")
include("gf/blocks.lua")
include("gf/commands.lua")
include("gf/entities.lua")
include("gf/players.lua")
include("gf/resources.lua")
include("gf/rounds.lua")

--
function GM:Initialize()
	GF:AutoBalance()
end

--
function GM:InitPostEntity()
	if game.GetMap() == "gm_construct" then
		game.ConsoleCommand("changelevel " .. GF.maps[1] .. "\n")
	end	
	GF:FindEntities()
	GF:SendRoundMessage()
	GF:SendTeamsMessage()
end

--
function GM:PlayerDeath(ply, weapon, killer)
	GF:CleanupPlayer(ply)
	self.BaseClass:PlayerDeath(ply, weapon, killer)
	if killer ~= ply then
		killer:AddFrags (1)
	end
	ply:AddDeaths (1)
end

--
function GM:PlayerDisconnected(ply)
	GF:CleanupPlayer(ply, true)
end

--
function GM:PlayerInitialSpawn(ply)
	ply.gf = {}
	local smallestTeam, smallestTeamSize = 1, 999
	for ti, t in pairs(GF.teams) do
		if t.open then
			local ts = team.NumPlayers(ti)
			if ts < smallestTeamSize then
				smallestTeam = ti
				smallestTeamSize = ts
			end
		end
	end 
	ply:SetTeam(smallestTeam)
	GF:SendRoundMessage(ply)
	GF:SendTeamsMessage(ply)
end

--
function GM:PlayerSelectSpawn(ply)
	if ply:GetVar ("spawn", 0) == 0 then
		ply:SetVar ("spawns", GF:FindSpawns(ply:Team()) or ents.FindByClass("info_player_start"))
		local spn = ply:GetVar ("spawns")[math.random(table.getn(ply:GetVar ("spawns")))]
		ply:SetVar ("spawn", spn)
		return spn
	else
		return ply:GetVar ("spawns")[ply:GetVar("spawn")]
	end
end

--
function GM:PlayerShouldTakeDamage(victim, attacker)
	if attacker:IsValid() and attacker:IsPlayer() and (victim:Team() == attacker:Team() and server_settings.Bool("mp_friendlyfire") == false) then
		return false
	elseif victim:GetVar("invulnerability", 0) > CurTime() then
		return false
	else
		return true
	end
end

--
function GM:PlayerSpawn(ply)
	if GF.round != GF.ROUND_PRE and GF.round != GF.ROUND_BUILD and ply.gf.spawnTimer == nil then
		-- for normal rounds, the first time they spawn, do a spectator spawn
		-- and delay the real spawn for a number of seconds
		GF:SpawnQueue(ply)
	else
		-- if they've already waited, spawn them normally
		GF:Spawn(ply)
		if ply:IsSuperAdmin() then
			ply:SetModel(Model("models/player/breen.mdl"))
		elseif ply:IsAdmin() then
			ply:SetModel(Model("models/player/police.mdl"))
		else
			ply:SetModel(Model("models/player/kleiner.mdl"))
		end
	end
end

--
function GM:PlayerTraceAttack(ply, dmginfo, dir, trace)
	if ply:Crouching() then
		local height
		if ply:GetVelocity():Length() > 1 then
			height = 52.4
		else
			height = 41.4
		end
		local t = {}
		t.start = ply:GetPos()
		t.endpos = t.start + Vector(0, 0, height)
		t.filter = ply
		local tr = util.TraceLine(t)
		if tr.Entity and tr.Entity:IsValid() then
			//if tr.Entity:GetName() == "gfbb" or table.HasValue({"gf_bb_spawner", "gf_playerspawn", "gf_qualifyspawn", "gf_scoreboard", "gf_supply", "gf_timeboard"}, tr.Entity:GetClass()) then
			if trace.HitPos.z > tr.HitPos.z then
				dmginfo:ScaleDamage(-1)
			end
			//end
		end
	end
end

--
function GM:PlayerUse(ply, ent)
	if ent:GetClass() == "gf_bb_spawner" or ent:GetClass() == "gf_supply" then
		ent:Use(ply)
	end
end

--
function GM:Think()
	GF:SpawnThink()
	GF:RoundThink()
	for _, ply in pairs(player.GetAll()) do
		ply:CursorTrace()
		if ply:GetNetworkedInt("armor") != ply:Armor() then
			ply:SetNetworkedInt("armor", ply:Armor())
		end
	end
end

--
function GM:UpdateAnimation(ply)
	-- fix the crouch speed
	local crouching = ply:Crouching()
	if crouching then
		if not ply.crouching then
			ply.crouching = true
			GAMEMODE:SetPlayerSpeed(ply, 250, 250)
		end
	else
		if ply.crouching then
			ply.crouching = false
			GAMEMODE:SetPlayerSpeed(ply, 200, 320)
		end
	end	
end

// Team chat.
function GM:PlayerSay( pPlayer, sText, bPublic )
	if ( !bPublic ) then
		for _, pPlayer in pairs( team.GetPlayers( pSaid:Team() ) ) do
			pPlayer:ChatPrint( "(TEAM) " .. pSaid:Nick() .. ": " .. sText )
			pPlayer:SendLua( "surface.PlaySound( Sound( \"common/talk.wav\" ) )" )
		end
		return ""
	end
end

--------------------------------------------------------------------------------
-- stub override functions that don't do anything

function GM:EntityKeyValue(ent, key, value) end
function GM:EntityTakeDamage(ent, inflictor, attacker, amount) end
function GM:PlayerLoadout(pl) end
