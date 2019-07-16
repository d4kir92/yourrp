--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _fb = {}

function toggleFeedbackMenu()
	if isNoMenuOpen() then
		openFeedbackMenu()
	else
		closeFeedbackMenu()
	end
end

function closeFeedbackMenu()
	if _fb.window != nil then
		closeMenu()
		_fb.window:Remove()
		_fb.window = nil
	end
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/formResponse"

function openFeedbackMenu()
	openMenu()
	_fb.window = createD("YFrame", nil, FW(), FH(), PX(), PY())
	_fb.window:Center()
	_fb.window:SetTitle("LID_givefeedback")
	_fb.window:SetHeaderHeight(50)
	function _fb.window:OnClose()
		closeMenu()
	end
	function _fb.window:OnRemove()
		closeMenu()
	end

	_fb.langu = YRP.DChangeLanguage(_fb.window, FW() - YRP.ctr(100 + 20), YRP.ctr(100 + 20), YRP.ctr(100))

	_fb.window.systime = SysTime()
	function _fb.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_givefeedback") .. " [PROTOTYPE]")
	end

	_fb.discord = createD("YButton", _fb.window, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(100 + 20))
	_fb.discord:SetText("LID_getlivesupport")
	function _fb.discord:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_getlivesupport"))
	end
	function _fb.discord:DoClick()
		gui.OpenURL("https://discord.gg/sEgNZxg")
	end

	_fb.titleP = createD("DPanel", _fb.window, FW() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(170))
	function _fb.titleP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_title"), "roleInfoHeader", YRP.ctr(20), ph / 2, Color(255, 255, 255), 0, 1)
	end
	_fb.titleT = createD("DTextEntry", _fb.window, FW() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(220))

	_fb.feedbackP = createD("DPanel", _fb.window, FW() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(300))
	function _fb.feedbackP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_feedback") .. " (" .. YRP.lang_string("LID_problems") .. ", " .. YRP.lang_string("LID_suggestions") .. ", ...)", "roleInfoHeader", YRP.ctr(20), ph/2, Color(255, 255, 255), 0, 1)
	end
	_fb.feedbackT = createD("DTextEntry", _fb.window, FW() - YRP.ctr(40), YRP.ctr(500), YRP.ctr(20), YRP.ctr(350))
	_fb.feedbackT:SetMultiline(true)

	_fb.contactP = createD("DPanel", _fb.window, FW() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(900))
	function _fb.contactP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_contact") .. " (" .. YRP.lang_string("LID_notrequired") .. ")", "roleInfoHeader", YRP.ctr(20), ph/2, Color(255, 255, 255), 0, 1)
	end
	_fb.contactT = createD("DTextEntry", _fb.window, FW() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(950))

	_fb.send = createD("YButton", _fb.window, YRP.ctr(600), YRP.ctr(50), YRP.ctr(20), YRP.ctr(1050))
	_fb.send:SetText("LID_sendfeedback")
	function _fb.send:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, string.upper(YRP.lang_string("LID_sendfeedback")))
	end
	function _fb.send:DoClick()
		printGM("gm", "send feedback")

		if _fb.titleT:GetText() != "" or _fb.feedbackT:GetText() != "" or _fb.contactT:GetText() != "" then
			local entry = {}
			entry["entry.1141598078"] = _fb.titleT:GetText() or "FAILED"
			entry["entry.761186932"] = _fb.feedbackT:GetText() or "FAILED"
			entry["entry.1633448754"] = _fb.contactT:GetText() or "FAILED"
			entry["entry.1109864644"] = LocalPlayer():SteamID() or "FAILED"

			http.Post(_url, entry, function(result)
				if result then end
			end, function(failed)
				printGM("error", "Feedback: " .. tostring(failed))
			end)

			local _net_table = {}
			_net_table.title = _fb.titleT:GetText() or "FAILED"
			_net_table.feedback = _fb.feedbackT:GetText() or "FAILED"
			_net_table.contact = _fb.contactT:GetText() or "FAILED"
			_net_table.steamid = LocalPlayer():SteamID() or "FAILED"
			_net_table.steamname = LocalPlayer():SteamName() or "FAILED"
			net.Start("add_feedback")
				net.WriteTable(_net_table)
			net.SendToServer()
		end

		closeFeedbackMenu()
	end

	_fb.window:MakePopup()
end
