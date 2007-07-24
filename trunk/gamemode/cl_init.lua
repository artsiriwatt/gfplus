GMName = "gmforts"

--function GM:Initialize ()
	Msg ("cl_init loaded . . .\n")

	include ("shared.lua")
	
	for k,v in pairs (file.Find ("../lua/_downloaded/lua/"..GMName.."/gamemode/shared/*.lua")) do
		Msg ("Loading shared/"..v.." . . .\n")
		include ("shared/"..v)
	end
	
	for k,v in pairs (file.Find ("../lua/_downloaded/lua/"..GMName.."/gamemode/client/*.lua")) do
		Msg ("Loading client/"..v.." . . .\n")
		include ("client/"..v)
	end
--end
