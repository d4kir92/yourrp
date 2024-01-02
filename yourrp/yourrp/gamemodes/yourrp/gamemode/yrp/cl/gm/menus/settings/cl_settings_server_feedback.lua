--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #FEEDBACKSETTINGS
local _avatars = {}
function GetAvatarUrl(steamid)
	http.Fetch(
		"http://steamcommunity.com/profiles/" .. steamid,
		function(body, len, headers, code)
			_avatars[steamid] = "TEST"
			local str_start = string.find(body, "<div class=\"playerAvatarAutoSizeInner\"><img src=", 1, true)
			if str_start ~= nil then
				local str_end = string.find(body, ".jpg\">", str_start, true)
				body = string.sub(body, str_start + 49, str_end + 3)
				_avatars[steamid] = YRPGetHTMLImage(body, YRP.ctr(200), YRP.ctr(200))
			end
		end,
		function(error)
			YRP.msg("gm", "GetAvatarUrl ERROR: " .. error)
		end
	)
end

function BuildFeedbackLine(parent, tab)
	for i, v in pairs(tab) do
		tab[i] = v
	end

	tab.rows = string.Explode("\n", tab.feedback)
	tab.rows = #tab.rows
	tab.rows = math.Clamp(tab.rows, 6, 50)
	-- LINE
	local _fb = YRPCreateD("YPanel", parent, parent:GetWide(), YRP.ctr(90) + YRP.ctr(50) * tab.rows, 0, 0)
	_fb.steamid = tab.steamid
	function _fb:Paint(pw, ph)
		hook.Run("YPanelPaint", self, pw, ph)
	end

	-- STEAMNAME
	_fb.steamnamel = YRPCreateD("YLabel", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
	_fb.steamnamel:SetText("LID_steamname")
	_fb.steamnamete = YRPCreateD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(70))
	_fb.steamnamete:SetEditable(false)
	_fb.steamnamete:SetFont("Y_22_500")
	_fb.steamnamete:SetText(tab.steamname or "NO STEAMNAME AVAILABLE")
	-- RPNAME
	_fb.rpnamel = YRPCreateD("YLabel", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(120))
	_fb.rpnamel:SetText("LID_rpname")
	_fb.rpnamete = YRPCreateD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(170))
	_fb.rpnamete:SetEditable(false)
	_fb.rpnamete:SetFont("Y_22_500")
	_fb.rpnamete:SetText(tab.rpname or "NO RPNAME AVAILABLE")
	-- CONTACT
	_fb.contactl = YRPCreateD("YLabel", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(220))
	_fb.contactl:SetText("LID_contact")
	_fb.contactte = YRPCreateD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(270))
	_fb.contactte:SetEditable(false)
	_fb.contactte:SetFont("Y_22_500")
	_fb.contactte:SetText(tab.contact or "NO CONTACT AVAILABLE")
	-- TITEL
	_fb.titlel = YRPCreateD("YLabel", _fb, YRP.ctr(800), YRP.ctr(50), YRP.ctr(440), YRP.ctr(20))
	_fb.titlel:SetText("LID_title")
	_fb.titlete = YRPCreateD("DTextEntry", _fb, YRP.ctr(800), YRP.ctr(50) * tab.rows, YRP.ctr(440), YRP.ctr(70))
	_fb.titlete:SetEditable(false)
	_fb.titlete:SetMultiline(true)
	_fb.titlete:SetFont("Y_22_500")
	_fb.titlete:SetText(tab.title or "NO TITLE AVAILABLE")
	-- FEEDBACK
	_fb.feedbackp = YRPCreateD("YLabel", _fb, YRP.ctr(800), YRP.ctr(50), YRP.ctr(1260), YRP.ctr(20))
	_fb.feedbackp:SetText("LID_tickets")
	_fb.feedbackte = YRPCreateD("DTextEntry", _fb, YRP.ctr(800), YRP.ctr(50) * tab.rows, YRP.ctr(1260), YRP.ctr(70))
	_fb.feedbackte:SetEditable(false)
	_fb.feedbackte:SetMultiline(true)
	_fb.feedbackte:SetFont("Y_22_500")
	_fb.feedbackte:SetText(tab.feedback or "NO FEEDBACK AVAILABLE")
	-- PROFILE
	_fb.profile = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(20))
	_fb.profile:SetText("LID_openprofile")
	function _fb.profile:DoClick()
		gui.OpenURL("http://steamcommunity.com/profiles/" .. _fb.steamid)
	end

	-- MOVETO
	if tab.status == "open" then
		_fb.statusbtn2 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(90))
		_fb.statusbtn2:SetText("LID_movetowip")
		_fb.statusbtn3 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(160))
		_fb.statusbtn3:SetText("LID_movetoclosed")
	elseif tab.status == "wip" then
		_fb.statusbtn1 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(90))
		_fb.statusbtn1:SetText("LID_movetoopen")
		_fb.statusbtn3 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(160))
		_fb.statusbtn3:SetText("LID_movetoclosed")
	elseif tab.status == "closed" then
		_fb.statusbtn1 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(90))
		_fb.statusbtn1:SetText("LID_movetoopen")
		_fb.statusbtn2 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(160))
		_fb.statusbtn2:SetText("LID_movetowip")
	end

	_fb.statusbtn4 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(230))
	_fb.statusbtn4:SetText("LID_tpto")
	function _fb.statusbtn4:DoClick()
		net.Start("nws_yrp_tp_tpto_steamid")
		net.WriteString(_fb.steamid)
		net.SendToServer()
	end

	_fb.statusbtn5 = YRPCreateD("YButton", _fb, YRP.ctr(500), YRP.ctr(50), YRP.ctr(2080), YRP.ctr(300))
	_fb.statusbtn5:SetText("LID_bring")
	function _fb.statusbtn5:DoClick()
		net.Start("nws_yrp_tp_bring_steamid")
		net.WriteString(_fb.steamid)
		net.SendToServer()
	end

	if _fb.statusbtn1 then
		function _fb.statusbtn1:DoClick()
			net.Start("nws_yrp_fb_movetoopen")
			net.WriteString(tab.uniqueID)
			net.SendToServer()
			tab.status = "open"
			_fb:Remove()
		end
	end

	if _fb.statusbtn2 then
		function _fb.statusbtn2:DoClick()
			net.Start("nws_yrp_fb_movetowip")
			net.WriteString(tab.uniqueID)
			net.SendToServer()
			tab.status = "wip"
			_fb:Remove()
		end
	end

	if _fb.statusbtn3 then
		function _fb.statusbtn3:DoClick()
			net.Start("nws_yrp_fb_movetoclosed")
			net.WriteString(tab.uniqueID)
			net.SendToServer()
			tab.status = "closed"
			_fb:Remove()
		end
	end

	return _fb
end

function BuildFeedback(parent, tab, status)
	local lis = YRPCreateD("DScrollPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	for i, v in pairs(tab) do
		if v.status == status then
			local line = BuildFeedbackLine(lis, v)
			line:Dock(TOP)
			line:DockMargin(0, 0, 0, YRP.ctr(20))
			lis:AddItem(line)
		end
	end
end

net.Receive(
	"nws_yrp_get_ticket",
	function()
		local _fbt = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			local site = PARENT
			local tabs = YRPCreateD("YTabs", site, ScW(), ScH() - YRP.ctr(100), 0, 0)
			tabs:AddOption(
				"LID_opentickets",
				function(parent)
					BuildFeedback(parent, _fbt, "open")
				end
			)

			tabs:AddOption(
				"LID_ticketsinprocess",
				function(parent)
					BuildFeedback(parent, _fbt, "wip")
				end
			)

			tabs:AddOption(
				"LID_closedtickets",
				function(parent)
					BuildFeedback(parent, _fbt, "closed")
				end
			)

			tabs:GoToSite("LID_opentickets")
		end
	end
)

function OpenSettingsFeedback()
	net.Start("nws_yrp_get_ticket")
	net.SendToServer()
end