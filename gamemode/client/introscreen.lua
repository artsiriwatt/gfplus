introscreen = {}

introscreen.Active = false
introscreen.VGUIPanel = nil

--[[function introscreen.Begin ()
	Msg ("Introductory screen.\n")
	introscreen.Active = true
	introscreen.VGUIPanel = vgui.Create ("gmf_introscreen")
	introscreen.VGUIPanel:SetPos (100, 100)
	gui.EnableScreenClicker (true)
end

usermessage.Hook ("intro", introscreen.Begin)]]

function introscreen.DifferentTest ()
	Msg ("Running test panel . . .\n")
	introscreen.VGUIPanelTEST = vgui.Create ("gmf_baseframe") --this test, we include the panels manually - no presets, if you like
	local pnl = introscreen.VGUIPanelTEST
	pnl:SetPrintName ("welcome to")
	pnl:AddTextObject ("title1", {"gmforts"}, "Airstrip48", 50, 32)
	pnl:AddTextObject ("title2", {"build and conquer"}, "Airstrip32", 14, 80)
	pnl:SetPos (500, 100)
	pnl:SetSize (300, 400)
	pnl.ScrollFrame = vgui.Create ("gmf_scrollframe", pnl)
	pnl.ScrollFrame:SetPos (8, 116)
	pnl.ScrollFrame:SetSize (pnl:GetWide()-16, pnl:GetTall() - 124)
	pnl.ScrollFrame:GetScrollArea():Canvas():AddTextObject ("textblock", {
		"Line 1...",
		"Line 2...",
		"Line 3!",
		"line 4...",
		"LINE 5??",
		"line 6",
		"line 7",
		"line 8",
		"line NINE",
		"l. 10",
		"linen eleven??!?"
	}, "Airstrip24", 8, 8)
	gui.EnableScreenClicker (true)
end

concommand.Add ("introScreenTest", introscreen.DifferentTest)