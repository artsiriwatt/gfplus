return

hook.CallHook2 = hook.Call --this is the second time I've done this - but it doesn't matter!

function hook.Call (name, gmtable, ...)
	--Msg ("Hook "..tostring(name).." called!\n")
	if upgrades then --N.B. upgrades are run clientside
		for k,v in pairs (upgrades) do
			local retrn = nil
			if v[name] then
				retrn = v[name] (v[name], unpack (arg))
			end
			if retrn != nil then
				return retrn
			end
		end
	end
	return hook.CallHook2 (name, gmtable, unpack (arg))
end
