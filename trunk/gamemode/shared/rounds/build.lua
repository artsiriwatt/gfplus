function ROUND:GetName ()
	return "Build"
end

function ROUND:GetDescription ()
	return {"Construct stuff."}
end

function ROUND:GetLength ()
	return 480
end

function ROUND:Begin ()
	Msg ("BUILD A WALL LOL\n")
end

function ROUND:Think ()
	
end

function ROUND:End ()
	Msg ("OHNO NOT FINISHED :(\n")
end
