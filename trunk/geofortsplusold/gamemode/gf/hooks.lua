GFHS = {}

function GFHS:HookCall (name, ...)
	if not GFHS[name] then
		GFHS[name] = function () end
	end
	if arg then
		Msg ("arg exists\n")
		hook.Call (name, GFHS, unpack(arg))
	else
		Msg ("arg does not exist\n")
		hook.Call (name, GFHS)
	end
end

function GFHS:HookTest (num)
	Msg ("Hook system operating (Code: "..num..")\n")
end

hook.Call ("HookTest", GFHS, 13)

--[[function RandomFightStartedFunction ()
	Msg ("Fight has started, supposedly.\n")
end

hook.Add ("FightStarted", "RBSF", RandomFightStartedFunction)]]

function RFGF (team, ply)
	Msg ("Flag captured (team "..tostring(team)..", ply "..tostring(ply)..")\n")
end

hook.Add ("FlagGrabbed", "RFGF", RFGF)