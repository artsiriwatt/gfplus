GF.Commands = {}

local function StringToTeam(str)
	local tmi, tm = nil, nil
	for i, t in pairs(GF.teams) do
		if t.name:lower() == str then
			tmi = i
			tm = t
			break
		end
	end
	return tmi, tm
end

-- help, team, spares just get forwarded to the client
function GM:ShowHelp(ply)
	umsg.Start("gfopt", ply)
	umsg.Short(1)
	umsg.End()
end
function GM:ShowTeam(ply)
	umsg.Start("gfopt", ply)
	umsg.Short(2)
	umsg.End()
end
function GM:ShowSpare1(ply)
	umsg.Start("gfopt", ply)
	umsg.Short(3)
	umsg.End()
end
function GM:ShowSpare2(ply)
	umsg.Start("gfopt", ply)
	umsg.Short(4)
	umsg.End()
end

-- start the next round
function GF.Commands.NextRound(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	GF.roundTimer = 0
end
concommand.Add("gf_nextround", GF.Commands.NextRound)

-- end the game regardless of what's happening
function GF.Commands.EndGame(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	GF:EndGame()
	local str = ply:Name() .. " forced the game to end.\n"
	for _, p in pairs(player.GetAll()) do
		p:PrintMessage(HUD_PRINTTALK, str)
	end
end
concommand.Add("gf_endgame", GF.Commands.EndGame)

-- go to the next map immediately
function GF.Commands.NextMap(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	for i, map in pairs(GF.maps) do
		if map == game.GetMap() then
			i = i + 1
			if i > #GF.maps then
				i = 1
			end
			game.ConsoleCommand("changelevel " .. GF.maps[i] .. "\n")
			return
		end
	end
end
concommand.Add("gf_nextmap", GF.Commands.NextMap)

-- toggle noclip movement
function GF.Commands.NoClip(ply, cmd, args)
	if ply:IsAdmin() then --changed to admin - now admins can kick, they need to know what they are kicking
		if ply:GetMoveType() == MOVETYPE_NOCLIP then
			ply:PrintMessage(HUD_PRINTCONSOLE, "Noclip disabled.")
			ply:SetMoveType(MOVETYPE_WALK)
		else
			ply:PrintMessage(HUD_PRINTCONSOLE, "Noclip enabled.")
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	end
end
concommand.Add("gf_noclip", GF.Commands.NoClip)

-- reset the flag for a team
function GF.Commands.ResetFlag(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	local tmi, tm = StringToTeam(args[1])
	if not tm then
		if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid team.") end
		return
	end
	local pos = GF.flags[tmi][1].defaultPos
	if args[2] and args[3] and args[4] then
		pos = Vector(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
	elseif cmd == "gf_restoreflag" then
		pos = GF.flags[tmi][1].roundPos
	end
	local flag = GF.flags[tmi][1] 
	flag:SetPos(pos)
	flag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = flag:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Reset the flag for the " .. tm.name .. " team.") end
end
concommand.Add("gf_resetflag", GF.Commands.ResetFlag)
concommand.Add("gf_restoreflag", GF.Commands.ResetFlag)

-- reset the blocks for a team
function GF.Commands.ResetTeam(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	local tmi, tm = StringToTeam(args[1])
	if not tm then
		if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid team.") end
		return
	end
	for _, block in pairs(ents.FindByName("gfbb")) do
		if block:GetSkin() == tmi then
			if cmd == "gf_restoreteam" and block.roundPos then
				block:SetPos(block.roundPos)
				block:SetAngles(block.roundAng)
				block:SetCollisionGroup(COLLISION_GROUP_NONE)
				block:Extinguish()
				local phys = block:GetPhysicsObject()
				if (phys:IsValid()) then
					phys:EnableMotion(false)
				end
			else
				block:Remove()
			end
		end
	end
	for _, class in pairs({"gf_timeboard", "gf_scoreboard", "gf_supply"}) do
		for _, ent in pairs(ents.FindByClass(class)) do
			if ent:GetSkin() == tmi then
				if cmd == "gf_restoreteam" and ent.roundPos then
					ent:SetPos(ent.roundPos)
					ent:SetAngles(ent.roundAng)
					ent:SetCollisionGroup(COLLISION_GROUP_NONE)
					ent:Extinguish()
					local phys = ent:GetPhysicsObject()
					if (phys:IsValid()) then
						phys:EnableMotion(false)
					end
				else
					ent:Remove()
				end
			end
		end
	end
	for _, class in pairs({"gf_playerspawn", "gf_bb_spawner"}) do
		for _, ent in pairs(ents.FindByClass(class)) do
			if ent:GetSkin() == tmi then
				ent:Extinguish()
				if cmd == "gf_restoreteam" and ent.roundPos then
					ent:SetPos(ent.roundPos)
					ent:SetAngles(ent.roundAng)
				else
					ent:SetPos(ent.defaultPos)
					ent:SetAngles(ent.defaultAng)
				end
				ent:SetCollisionGroup(COLLISION_GROUP_NONE)
				local phys = ent:GetPhysicsObject()
				if (phys:IsValid()) then
					phys:EnableMotion(false)
				end
			end
		end
	end
	GF.Commands.ResetFlag(ply, "gf_resetflag", {args[1]})
	if ply then ply:PrintMessage(HUD_PRINTCONSOLE, tm.name .. " team reset.") end
end
concommand.Add("gf_resetteam", GF.Commands.ResetTeam)
concommand.Add("gf_restoreteam", GF.Commands.ResetTeam)

-- set the amount of time left in the round
function GF.Commands.RoundTime(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	args = tonumber(args[1])
	if type(args) == "number" then
		GF.roundTimer = CurTime() + args
	end
	if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Remaining round time set ("..args.." seconds)\n") end
	GF:SendRoundMessage()
end
concommand.Add("gf_roundtime", GF.Commands.RoundTime)

-- set the number of round cycles still left to go
function GF.Commands.RoundCycles (ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	args = tonumber(args[1])
	if type(args) == "number" then
		GF.roundsLeft = args
	end
	if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Remaining round cycles set ("..args..")\n") end
	GF:SendRoundMessage()
end
concommand.Add("gf_roundcycles", GF.Commands.RoundCycles)

-- manually qualify a team
function GF.Commands.QualifyTeam(ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	local tmi, tm = StringToTeam(args[1])
	if not tm then
		if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid team.") end
		return
	end
	GF.teams[tmi].qualify = 1.0
	GF:SendTeamsMessage()
	if ply then ply:PrintMessage(HUD_PRINTCONSOLE, tm.name .. " team qualified.") end
end
concommand.Add("gf_qualifyteam", GF.Commands.QualifyTeam)

-- kick a player via UniqueID
function GF.Commands.KickID (ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	pid = tonumber(args[1])
	args[1] = ""
	str = string.sub(table.concat (args, " "), 2)
	if pid then
		for k,v in pairs (player.GetAll()) do
			if v:UserID() == pid then
				if string.len (str) > 1 then
					GF:Kick (v, ply:Name().." ("..str..")")
				else
					GF:Kick (v, ply:Name().." (unspecified)")
				end
				if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "Successfully kicked player "..pid.."\n") end
				return
			end
		end
	else
		if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "ERROR: first argument must be an ID (number) - use status to find IDs\n") end
	end
end
concommand.Add("gf_kickid", GF.Commands.KickID)

-- kick a player via partial name
function GF.Commands.Kick (ply, cmd, args)
	if ply and not ply:IsAdmin() then return end
	pname = args[1]
	args[1] = ""
	str = string.sub(table.concat (args, " "), 2)
	if not pname then return end
	local matches = {}
	for k,v in pairs (player.GetAll()) do
		if string.find (string.lower(v:Name()), string.lower(pname)) then
			table.insert (matches, v)
		end
	end
	if table.getn (matches) > 1 then
		if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "ERROR: partial name provided matches multiple clients\n") end
		return
	elseif matches[1] == nil then
		if ply then ply:PrintMessage(HUD_PRINTCONSOLE, "ERROR: no matches found\n") end
		return
	end
	if string.len (str) > 1 then
		GF:Kick (matches[1], ply:Name().." ("..str..")")
	else
		GF:Kick (matches[1], ply:Name().." (unspecified)")
	end
end
concommand.Add("gf_kick", GF.Commands.Kick)

function GF:Kick (ply, reason)
	game.ConsoleCommand ("kickid "..ply:UserID().." "..reason.."\n")
end

-- select a team
function GF.Commands.SelectTeam(ply, cmd, args)
	local t = tonumber(args[1])
	if t == ply:Team() then return end
	if t and t > 0 and t <= 4 then
		if not GF.teams[t].open then
			return
		end
		ply:SetTeam(t)
		ply:Spawn()
	end
end
concommand.Add("gf_team", GF.Commands.SelectTeam)

-- select primary weapon
function GF.Commands.SelectPrimaryWeapon(ply, cmd, args)
	ply:SetPrimaryWeapon(tonumber(args[1]))
end
concommand.Add("gf_primary", GF.Commands.SelectPrimaryWeapon)

-- select secondary weapon
function GF.Commands.SelectSecondaryWeapon(ply, cmd, args)
	ply:SetSecondaryWeapon(tonumber(args[1]))
end
concommand.Add("gf_secondary", GF.Commands.SelectSecondaryWeapon)
