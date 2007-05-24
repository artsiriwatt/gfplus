--WIP (nothing loads this file yet anyway)

--this will at base level only do votes with no arguments.

GF.Chatvotes = {}

local startsymbol = "/"

GF.Chatvotes.votes = {}

function GF.Chatvotes:AddNewVote (Aname, Avmessage, Areq, Aallowfunc, Anotallowedmessage, Adofunc, Aargs)
	self.votes[Aname] = {
		req = Areq,
		allowfunc = Aallowfunc,
		notallowedmessage = Anotallowedmessage,
		dofunc = Adofunc,
		vmessage = Avmessage,
		args = Aargs or {},
		votedfor = {}
	}
end

function GF.Chatvotes.PlayerSay (pl, text, team)
	if string.sub (text, 1, 1) == startsymbol then
		--eat the chat
		GF.Chatvotes:PlayerChatcommand (pl, string.sub (text, 2))
	end
end

hook.Add ("PlayerSay", "ChatvotesPlayerSay", GF.Chatvotes.PlayerSay)

function GF.Chatvotes:PlayerChatcommand (pl, text)
	Msg ("text: "..text.."\n")
	args = string.Explode (" ", text)
	vname = args[1]
	Msg ("vname: "..vname.."\n")
	if self.votes[vname] ~= nil then
		--we have something to vote about!
		UID = pl:UserID ()
		Msg ("player id: "..UID.."\n")
		--check the allowfunc
		local allowed = self.votes[vname].allowfunc()
		if not allowed then
			Msg ("not allowed. str: "..self.votes[vname].notallowedmessage.."\n")
			pl:ChatPrint (self.votes[vname].notallowedmessage)
			pl:PrintMessage (2, self.votes[vname].notallowedmessage)
			return false
		end
		if self.votes[vname].votedfor[UID] then
			Msg ("Already voted\n")
			avtxt = "You have already voted for this action.\n"
			pl:ChatPrint (avtxt)
			pl:PrintMessage (2, avtxt)
		else
			self.votes[vname].votedfor[UID] = true
			Msg ("Vote successful\n")
			--print message to all clients
			local name = pl:Nick ()
			local votes = 0
			for k,v in pairs (self.votes[vname].votedfor) do
				votes = votes + 1
			end
			local required = table.getn (player.GetAll()) / 100 * self.votes[vname].req
			local str = self.votes[vname].vmessage
			--always relevant stuff
				str = string.gsub (str, "&name&", name)
				str = string.gsub (str, "&votes&", votes)
				str = string.gsub (str, "&required&", required)
			--args
			for k,v in pairs (self.votes[vname].args) do
				str = string.gsub (str, "&"..k.."&", v)
			end
			for k,v in pairs (player.GetAll()) do
				v:ChatPrint (str)
				v:PrintMessage (2, str)
			end
		end
	end
end

function GF.Chatvotes.IsBuild ()
	Msg ("round: "..GF.round.."\n")
	if GF.round == GF.ROUND_BUILD then
		return true
	else
		return false
	end
end

function GF.Chatvotes.Skipbuild (args)
	Msg ("Skipping build . . .\n")
end

GF.Chatvotes:AddNewVote ("skipbuild", "&name& voted to skip the build round (&votes&/&required&).", 66, GF.Chatvotes.IsBuild, "This vote can only be used during build time.", GF.Chatvotes.Skipbuild)