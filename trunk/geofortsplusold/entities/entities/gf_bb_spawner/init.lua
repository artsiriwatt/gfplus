AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	
	local ent = ents.Create("gf_bb_spawner")
	ent:SetPos(tr.HitPos + (45 * tr.HitNormal))
	ent:Spawn()
	ent:Activate()
	
	// RETURN THE ENTITY OR BE CHARGED OF THEFT
	return ent
end

function ENT:KeyValue(key,value)
	if key == "skin" then
		local val = tonumber(value)
		if val >= 0 and val <= 4 then
			self.team = val
		else
			self.team = 0
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
