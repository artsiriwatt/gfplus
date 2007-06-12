UPGRADE.Base = "default"

UPGRADE.TypeName = "Default"
UPGRADE.TypeDescription = "The default UPGRADE sequence"

UPGRADE.Levels = {
	{"Level 1 Generic", "Generic upgrade at level 1", 5},
	{"Level 2 Generic", "Generic upgrade at level 2", 10},
	nil, --no lv3
	nil, --no lv4
	{"Level 5 Generic", "Generic upgrade at level 5", 20}
}

function UPGRADE:PlayerSpawn (pl)
	Msg ("default upgrade recognises someone just respawned.\n")
	if not pl:UpgradeLevel ("default") then return end
	Msg ("Player has a Level "..tostring(pl:GetUpgradeLevel ("default")).." Generic upgrade.\n")
end
