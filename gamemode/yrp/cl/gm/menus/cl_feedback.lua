--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

FEEDBACK = FEEDBACK or {}
FEEDBACK.open = false

function toggleFeedbackMenu()
	if !FEEDBACK.open and isNoMenuOpen() then
		openFeedbackMenu()
	else
		closeFeedbackMenu()
	end
end

function closeFeedbackMenu()
	FEEDBACK.open = false
	if FEEDBACK.window != nil then
		closeMenu()
		FEEDBACK.window:Remove()
		FEEDBACK.window = nil
	end
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/formResponse"

function openFeedbackMenu()
	openMenu()

	FEEDBACK.open = true
	FEEDBACK.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	FEEDBACK.window:Center()
	FEEDBACK.window:SetTitle("LID_givefeedback")
	FEEDBACK.window:SetHeaderHeight(YRP.ctr(100))
	function FEEDBACK.window:OnClose()
		closeMenu()
	end
	function FEEDBACK.window:OnRemove()
		closeMenu()
	end
	FEEDBACK.window.systime = SysTime()
	function FEEDBACK.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_givefeedback") .. " [PROTOTYPE]")
	end
	FEEDBACK.window:MakePopup()

	FEEDBACK.content = createD("YPanel", FEEDBACK.window, BFW(), BFH() - FEEDBACK.window:GetHeaderHeight(), 0, FEEDBACK.window:GetHeaderHeight())
	FEEDBACK.content:SetHeaderHeight(YRP.ctr(100))
	function FEEDBACK.content:Paint(pw, ph)

	end

	CreateFeedbackContent(FEEDBACK.content)
end

function CreateFeedbackContent(parent)
	FEEDBACK.content = parent
	FEEDBACK.langu = YRP.DChangeLanguage(FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(100 + 20), YRP.ctr(100 + 20), YRP.ctr(100))

	FEEDBACK.discord = createD("YButton", FEEDBACK.content, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
	FEEDBACK.discord:SetText("LID_getlivesupport")
	function FEEDBACK.discord:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_getlivesupport"))
	end
	function FEEDBACK.discord:DoClick()
		gui.OpenURL("https://discord.gg/sEgNZxg")
	end

	FEEDBACK.titleP = createD("DPanel", FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(170))
	function FEEDBACK.titleP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_title"), "roleInfoHeader", YRP.ctr(20), ph / 2, Color(255, 255, 255), 0, 1)
	end
	FEEDBACK.titleT = createD("DTextEntry", FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(220))

	FEEDBACK.feedbackP = createD("DPanel", FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(300))
	function FEEDBACK.feedbackP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_feedback") .. " (" .. YRP.lang_string("LID_problems") .. ", " .. YRP.lang_string("LID_suggestions") .. ", ...)", "roleInfoHeader", YRP.ctr(20), ph/2, Color(255, 255, 255), 0, 1)
	end
	FEEDBACK.feedbackT = createD("DTextEntry", FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(40), YRP.ctr(500), YRP.ctr(20), YRP.ctr(350))
	FEEDBACK.feedbackT:SetMultiline(true)

	FEEDBACK.contactP = createD("DPanel", FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(900))
	function FEEDBACK.contactP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_contact") .. " (" .. YRP.lang_string("LID_notrequired") .. ")", "roleInfoHeader", YRP.ctr(20), ph/2, Color(255, 255, 255), 0, 1)
	end
	FEEDBACK.contactT = createD("DTextEntry", FEEDBACK.content, FEEDBACK.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(950))

	FEEDBACK.send = createD("YButton", FEEDBACK.content, YRP.ctr(600), YRP.ctr(50), YRP.ctr(20), YRP.ctr(1050))
	FEEDBACK.send:SetText("LID_sendfeedback")
	function FEEDBACK.send:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, string.upper(YRP.lang_string("LID_sendfeedback")))
	end
	function FEEDBACK.send:DoClick()
		printGM("gm", "send feedback")

		if FEEDBACK.titleT:GetText() != "" or FEEDBACK.feedbackT:GetText() != "" or FEEDBACK.contactT:GetText() != "" then
			local entry = {}
			entry["entry.1141598078"] = FEEDBACK.titleT:GetText() or "FAILED"
			entry["entry.761186932"] = FEEDBACK.feedbackT:GetText() or "FAILED"
			entry["entry.1633448754"] = FEEDBACK.contactT:GetText() or "FAILED"
			entry["entry.1109864644"] = LocalPlayer():SteamID() or "FAILED"

			http.Post(_url, entry, function(result)
				if result then

				end
			end, function(failed)
				printGM("error", "Feedback: " .. tostring(failed))
			end)

			local _net_table = {}
			_net_table.title = FEEDBACK.titleT:GetText() or "FAILED"
			_net_table.feedback = FEEDBACK.feedbackT:GetText() or "FAILED"
			_net_table.contact = FEEDBACK.contactT:GetText() or "FAILED"
			_net_table.steamid = LocalPlayer():SteamID() or "FAILED"
			_net_table.steamname = LocalPlayer():SteamName() or "FAILED"
			net.Start("add_feedback")
				net.WriteTable(_net_table)
			net.SendToServer()
		end

		closeFeedbackMenu()
	end
end
