AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Think()
	for ply, panel in pairs(self.players) do
		print(ply, panel)
		if ply and ply:IsValid() and ply:Alive() and (ply:GetShootPos() - self.Entity:GetPos()):Length() < 100 then
			if panel == 1 then
				if ply:Health() < 100 then
					print("healing")
					ply:SetHealth(ply:Health() + 1)
				else
					print("ending, health >= 100")
					panel = nil
				end
			else
				if GF.rounds[GF.round].weapons == GF.WEAPONS_FIGHTING then
					print("resupplying")
					ammo1 = ply.gf.primary.Primary.Ammo
					ammo2 = ply.gf.secondary.Primary.Ammo
					ammo1 = (ply:GetAmmoCount(ammo1) < 50) and ammo1 or nil
					ammo2 = (ply:GetAmmoCount(ammo2) < 50) and ammo2 or nil
					if ammo1 or ammo2 then
						if ammo1 then ply:GiveAmmo(1, ammo1) end
						if ammo2 then ply:GiveAmmo(1, ammo2) end
					else
						print("ending, ammo")
						panel = nil
					end
				else
					print("ending, weapons != GF.WEAPONS_FIGHTING")
					panel = nil
				end
			end
		else
			print("ending, too far away")
			panel = nil
		end
		self.players[ply] = panel
	end
end

function ENT:Use(ply)
	print("use", ply)
	if ply:Team() == self.Entity:GetSkin() then
		print("team matches")
		local cursor = self:Cursor(ply)
		if cursor.onPanel then
			print("on panel", cursor.onPanel)
			self.players[ply] = cursor.onPanel
		end
	end
end

--[[
function ENT:Think()
	for ply, type in pairs(self.leeches) do
		if ply:Alive() and (ply:GetShootPos() - self.Entity:GetPos()):Length() < 64 then
			if type == 1 then
				if ply:Health() < 100 then
					ply:SetHealth(ply:Health() + 1)
				elseif ply:Armor() < 100 then
					ply:SetArmor(ply:Armor() + 1)
				else
					self.leeches[ply] = nil
				end
			elseif type == 2 then
				if GF.rounds[GF.round].weapons == GF.WEAPONS_FIGHTING then
					primaryAmmo = ply.gf.primary.Primary.Ammo
					secondaryAmmo = ply.gf.secondary.Primary.Ammo
					if ply:GetAmmoCount(primaryAmmo) < 50 then
						ply:GiveAmmo(1, primaryAmmo)
					elseif ply:GetAmmoCount(secondaryAmmo) < 50 then
						ply:GiveAmmo(1, secondaryAmmo)
					else
						self.leeches[ply] = nil
					end
				end
			end
		else
			self.leeches[ply] = nil
		end
	end
end
]]
