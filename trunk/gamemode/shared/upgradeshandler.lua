local pl = FindMetaTable ("Player")
if (!pl) then return end

function pl:ResetUpgrades ()
	self.upgrades = {}
	--test
	self:SetUpgradeLevel ("default", 1)
end

local function ResetUpgradesHook (pl)
	pl:ResetUpgrades ()
end

hook.Add ("PlayerInitialSpawn", "RUH", ResetUpgradesHook)

function pl:UpgradeLevel (upgrade)
	return self.upgrades[upgrade] or false
end

function pl:SetUpgradeLevel (upgrade, level)
	self.upgrades[upgrade] = level
	return true
end
