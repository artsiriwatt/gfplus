roundmt = {}

function roundmt:New ()
	t = table.Copy (self)
	return t
end

function roundmt:GetName ()
	return "UNTITLED"
end

function roundmt:GetLength ()
	return 0
end

rounds = {}

default = roundmt:New ()

rounds.default = default

for k,v in pairs (file.Find ("../gamemodes/geofortsplus/gamemode/shared/rounds/*.lua")) do
	ROUND = roundmt:New ()
	include ("rounds/"..v)
	rounds[string.gsub(v, ".lua", "")] = ROUND
end

for k,v in pairs (rounds) do
	Msg ("round "..k..":\n")
	Msg ("name: "..v:GetName().."\n")
	Msg ("length: "..v:GetLength().."\n\n")
end
