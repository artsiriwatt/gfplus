hook.CallHook = hook.Call

function hook.Call (name, gmtable, ...)
	--Msg ("Hook "..tostring(name).." called!\n")
	if roundcycle then
		if roundcycle.round[name] then
			--Msg ("running "..name.." on round "..roundcycle.round.Name.." . . .\n")
			roundcycle.round[name] (roundcycle.round[name], unpack (arg))
		end
	end
	return hook.CallHook (name, gmtable, unpack (arg))
end
