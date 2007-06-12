local pl = FindMetaTable ("Player")
if (!pl) then return end

function pl:IssueEquipment ()
	--stub function
	Msg ("Issue weapons.\n")
	self:Give ("tw_m4a1")
	self:GiveAmmo (150, "ar2")
	self:Give ("tw_usp")
	self:GiveAmmo (96, "pistol")
end
