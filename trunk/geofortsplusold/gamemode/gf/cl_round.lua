local STATE_IN = 1
local STATE_NORMAL = 2
local STATE_OUT = 3
local state = nil
local statetype = "newround"
local time = 0
local times = {0.75, 4.0, 1.0}

function GF:DrawRound()
	if LocalPlayer():Team() < 1 or LocalPlayer():Team() > 4 then
		return
	end
	if LocalPlayer():Alive() and GF.round != GF.ROUND_FIGHT then
		ftime = string.FormattedTime(GF.roundTimer - CurTime(), "%02i:%02i")
		draw.RoundedBox(6, ScrW() - 127, ScrH() - 70, 105, 50, Color(0, 0, 0, 90))
		draw.DrawText(ftime, "HUDNumber", ScrW() - 32, ScrH() - 65, Color(255, 255, 255, 200), TEXT_ALIGN_RIGHT)
	end
	-- 
	if not state then return end
	if CurTime() > time then
		if state == STATE_NORMAL and statetype == "endgame" then
			--do nothing
		else
			state = state + 1
			if state > STATE_OUT then
				state = nil
				return
			end
		end
		time = CurTime() + times[state] 
	end
	local alpha = 1.0
	if state != STATE_NORMAL then
		alpha = math.min((time - CurTime()) / 1, 1.0)
		if state == STATE_IN then
			alpha = 1.0 - alpha
		end
	end
	local color = GF.teams[LocalPlayer():Team()].color.neutral
	surface.SetDrawColor(color.r, color.g, color.b, alpha * 255)
	surface.DrawRect(0, 20, ScrW(), 120)
	if statetype == "newround" then
		draw.DrawText(GF.rounds[GF.round].name, "ScoreM", ScrW() * 0.5, 28, Color(255, 255, 255, alpha * 255), TEXT_ALIGN_CENTER)
		draw.DrawText(GF.rounds[GF.round].description, "Trebuchet24", ScrW() * 0.5, 83, Color(255, 255, 255, alpha * 180), TEXT_ALIGN_CENTER)
		if GF.roundsLeft == 0 then
			draw.DrawText("This is the last "..GF.rounds[GF.round].name.." round!", "Trebuchet24", ScrW() * 0.5, 107, Color(255, 255, 255, alpha * 180), TEXT_ALIGN_CENTER)
		else
			draw.DrawText("Round cycles remaining: "..GF.roundsLeft, "Trebuchet24", ScrW() * 0.5, 107, Color(255, 255, 255, alpha * 180), TEXT_ALIGN_CENTER)
		end
	else
		draw.DrawText("GAME OVER", "ScoreM", ScrW() * 0.5, 28, Color(255, 255, 255, alpha * 255), TEXT_ALIGN_CENTER)
		--lame and inefficient
		local str = ""
		for k,v in pairs (GF.teams) do
			str = str..v.name..": "..v.score.."    "
		end
		draw.DrawText("Scores:", "Trebuchet24", ScrW() * 0.5, 83, Color(255, 255, 255, alpha * 180), TEXT_ALIGN_CENTER)
		draw.DrawText(str, "Trebuchet24", ScrW() * 0.5, 107, Color(255, 255, 255, alpha * 180), TEXT_ALIGN_CENTER)
	end
end

function GF:ShowRound()
	statetype = "newround"
	state = STATE_IN
	time = CurTime() + times[STATE_IN]
end

function GF:ShowEndGame()
	statetype = "endgame"
	state = STATE_IN
	time = CurTime() + times[STATE_IN]
end
