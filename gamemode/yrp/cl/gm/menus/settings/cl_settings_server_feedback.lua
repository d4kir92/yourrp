--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #FEEDBACKSETTINGS

local _avatars = {}
function GetAvatarUrl(steamid)
	local steamid64 = util.SteamIDTo64(steamid)
	http.Fetch("http://steamcommunity.com/profiles/" .. steamid64,
		function(body, len, headers, code)
			_avatars[steamid] = "test"
			local str_start = string.find(body, "<div class=\"playerAvatarAutoSizeInner\"><img src=")
			if str_start != nil then
				local str_end = string.find(body, ".jpg\">", str_start)
				body = string.sub(body, str_start + 49, str_end + 3)
				_avatars[steamid64] = GetHTMLImage(body, YRP.ctr(200), YRP.ctr(200))
			end
		end,
		function(error)
			printGM("gm", "GetAvatarUrl ERROR: " .. error)
		end
	)
end

function BuildFeedbackLine(parent, tab)
	for i, v in pairs(tab) do
		tab[i] = SQL_STR_OUT(v)
	end

	tab.rows = string.Explode("\n", tab.feedback)
	tab.rows = #tab.rows
	tab.rows = math.Clamp(tab.rows, 5, 50)

	-- LINE
	local _fb = createD("YPanel", parent, parent:GetWide(), YRP.ctr(90) + YRP.ctr(50) * tab.rows, 0, 0)
	_fb.steamid64 = util.SteamIDTo64(tab.steamid)
	function _fb:Paint(pw, ph)
		hook.Run("YPanelPaint", self, pw, ph)
	end

	-- STEAMNAME
	_fb.steamnamel = createD("YLabel", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
	_fb.steamnamel:SetText("LID_steamname")
	_fb.steamnamete = createD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(70))
	_fb.steamnamete:SetEditable(false)
	_fb.steamnamete:SetFont("Y_22_500")
	_fb.steamnamete:SetText(tab.steamname or "NO STEAMNAME AVAILABLE")

	-- RPNAME
	_fb.rpnamel = createD("YLabel", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(120))
	_fb.rpnamel:SetText("LID_rpname")
	_fb.rpnamete = createD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(170))
	_fb.rpnamete:SetEditable(false)
	_fb.rpnamete:SetFont("Y_22_500")
	_fb.rpnamete:SetText(tab.rpname or "NO RPNAME AVAILABLE")

	-- CONTACT
	_fb.contactl = createD("YLabel", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(220))
	_fb.contactl:SetText("LID_contact")
	_fb.contactte = createD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(270))
	_fb.contactte:SetEditable(false)
	_fb.contactte:SetFont("Y_22_500")
	_fb.contactte:SetText(tab.contact or "NO CONTACT AVAILABLE")

	-- TITEL
	_fb.titlel = createD("YLabel", _fb, YRP.ctr(800), YRP.ctr(50), YRP.ctr(440), YRP.ctr(20))
	_fb.titlel:SetText("LID_title")
	_fb.titlete = createD("DTextEntry", _fb, YRP.ctr(800), YRP.ctr(50) * tab.rows, YRP.ctr(440), YRP.ctr(70))
	_fb.titlete:SetEditable(false)
	_fb.titlete:SetMultiline(true)
	_fb.titlete:SetFont("Y_22_500")
	_fb.titlete:SetText(tab.title or "NO TITLE AVAILABLE")

	-- FEEDBACK
	_fb.feedbackp = createD("YLabel", _fb, YRP.ctr(800), YRP.ctr(50), YRP.ctr(1260), YRP.ctr(20))
	_fb.feedbackp:SetText("LID_settings_fb_feedback")
	_fb.feedbackte = createD("DTextEntry", _fb, YRP.ctr(800), YRP.ctr(50) * tab.rows, YRP.ctr(1260), YRP.ctr(70))
	_fb.feedbackte:SetEditable(false)
	_fb.feedbackte:SetMultiline(true)
	_fb.feedbackte:SetFont("Y_22_500")
	_fb.feedbackte:SetText(tab.feedback or "NO FEEDBACK AVAILABLE")

	-- PROFILE
	_fb.profile = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(20))
	_fb.profile:SetText("LID_openprofile")
	function _fb.profile:DoClick()
		gui.OpenURL("http://steamcommunity.com/profiles/" .. _fb.steamid64)
	end

	-- MOVETO
	if tab.status == "open" then
		_fb.statusbtn2 = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(90))
		_fb.statusbtn2:SetText("LID_movetowip")

		_fb.statusbtn3 = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(160))
		_fb.statusbtn3:SetText("LID_movetoclosed")
	elseif tab.status == "wip" then
		_fb.statusbtn1 = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(90))
		_fb.statusbtn1:SetText("LID_movetoopen")

		_fb.statusbtn3 = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(160))
		_fb.statusbtn3:SetText("LID_movetoclosed")
	elseif tab.status == "closed" then
		_fb.statusbtn1 = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(90))
		_fb.statusbtn1:SetText("LID_movetoopen")

		_fb.statusbtn2 = createD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(160))
		_fb.statusbtn2:SetText("LID_movetowip")
	end

	if _fb.statusbtn1 then
		function _fb.statusbtn1:DoClick()
			net.Start("fb_movetoopen")
				net.WriteString(tab.uniqueID)
			net.SendToServer()

			tab.status = "open"

			_fb:Remove()
		end
	end

	if _fb.statusbtn2 then
		function _fb.statusbtn2:DoClick()
			net.Start("fb_movetowip")
				net.WriteString(tab.uniqueID)
			net.SendToServer()

			tab.status = "wip"

			_fb:Remove()
		end
	end

	if _fb.statusbtn3 then
		function _fb.statusbtn3:DoClick()
			net.Start("fb_movetoclosed")
				net.WriteString(tab.uniqueID)
			net.SendToServer()

			tab.status = "closed"

			_fb:Remove()
		end
	end

	return _fb
end

function BuildFeedback(parent, tab, status)
	local list = createD("DScrollPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)

	for i, v in pairs(tab) do
		if v.status == status then
			local line = BuildFeedbackLine(list, v)
			line:Dock( TOP )
			line:DockMargin( 0, 0, 0, YRP.ctr(20) )
			list:AddItem(line)
		end
	end
end

net.Receive("get_ticket", function()
	local lply = LocalPlayer()
	local _fbt = net.ReadTable()

	local PARENT = GetSettingsSite()
	if pa(PARENT) then

		local site = PARENT

		local tabs = createD("YTabs", site, ScW(), ScH() - YRP.ctr(100), 0, 0)

		tabs:AddOption("LID_opentickets", function(parent)
			BuildFeedback(parent, _fbt, "open")
		end)

		tabs:AddOption("LID_ticketsinprocess", function(parent)
			BuildFeedback(parent, _fbt, "wip")
		end)

		tabs:AddOption("LID_closedtickets", function(parent)
			BuildFeedback(parent, _fbt, "closed")
		end)

		tabs:GoToSite("LID_opentickets")
	end
end)

function OpenSettingsFeedback()
	net.Start("get_ticket")
	net.SendToServer()
end
