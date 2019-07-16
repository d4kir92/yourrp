--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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

net.Receive("get_feedback", function()
	local ply = LocalPlayer()
	local _fbt = net.ReadTable()

	if settingsWindow.window != nil then
		function settingsWindow.window.site:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local _fbh = createD("DPanel", settingsWindow.window.site, ScrW() - YRP.ctr(20), YRP.ctr(50), YRP.ctr(10), YRP.ctr(10))
		function _fbh:Paint(pw, ph)
			surfacePanel(self, pw, ph, YRP.lang_string("LID_settings_fb_feedbacks"))
		end

		local _fbl = createD("DPanelList", settingsWindow.window.site, ScrW() - YRP.ctr(20), ScrH() - YRP.ctr(100 + 10 + 50 + 10), YRP.ctr(10), YRP.ctr(10 + 50))
		_fbl:EnableVerticalScrollbar(true)
		function _fbl:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
		end

		for i, fb in pairs(_fbt) do
			GetAvatarUrl(fb.steamid)

			local _fb = createD("DPanel", nil, _fbl:GetWide(), YRP.ctr(400), 0, 0)
			_fb.steamid64 = util.SteamIDTo64(fb.steamid)
			_fb.avatar = createD("HTML", _fb, YRP.ctr(400), YRP.ctr(400), YRP.ctr(10), YRP.ctr(10))
			function _fb:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(0, 0, 0, 100))

				paintBr(pw, ph, Color(0, 0, 0, 255))

				--surfaceText(fb.steamname or "NO STEAMNAME", "mat1header", YRP.ctr(200 + 10), YRP.ctr(25), Color(255, 255, 255, 255), 0, 1)
				--surfaceText(fb.title, "mat1header", YRP.ctr(800), YRP.ctr(25), Color(255, 255, 255, 255), 0, 1)
				--surfaceText(fb.feedback, "mat1header", YRP.ctr(1200), YRP.ctr(25), Color(255, 255, 255, 255), 0, 1)
				--surfaceText(fb.contact, "mat1header", YRP.ctr(2000), YRP.ctr(25), Color(255, 255, 255, 255), 0, 1)

				if _avatars[self.steamid64] != nil then
					_fb.avatar:SetHTML(_avatars[self.steamid64])
				end
			end



			_fb.steamnamep = createD("DPanel", _fb, YRP.ctr(400), YRP.ctr(60), YRP.ctr(220), YRP.ctr(10))
			function _fb.steamnamep:Paint(pw, ph)
				surfacePanel(self, pw, ph, YRP.lang_string("LID_steamname"))
			end
			_fb.steamnamete = createD("DTextEntry", _fb, YRP.ctr(400), YRP.ctr(110), YRP.ctr(220), YRP.ctr(80))
			_fb.steamnamete:SetEditable(false)
			_fb.steamnamete:SetText(fb.steamname or "NO STEAMNAME AVAILABLE")



			_fb.titlep = createD("DPanel", _fb, YRP.ctr(500), YRP.ctr(60), YRP.ctr(630), YRP.ctr(10))
			function _fb.titlep:Paint(pw, ph)
				surfacePanel(self, pw, ph, "LID_settings_fb_title")
			end
			_fb.titlete = createD("DTextEntry", _fb, YRP.ctr(500), YRP.ctr(110), YRP.ctr(630), YRP.ctr(80))
			_fb.titlete:SetEditable(false)
			_fb.titlete:SetText(fb.title or "NO TITLE AVAILABLE")



			_fb.feedbackp = createD("DPanel", _fb, YRP.ctr(1200), YRP.ctr(60), YRP.ctr(1140), YRP.ctr(10))
			function _fb.feedbackp:Paint(pw, ph)
				surfacePanel(self, pw, ph, "LID_settings_fb_feedback")
			end
			_fb.feedbackte = createD("DTextEntry", _fb, YRP.ctr(1200), YRP.ctr(310), YRP.ctr(1140), YRP.ctr(80))
			_fb.feedbackte:SetEditable(false)
			_fb.feedbackte:SetMultiline(true)
			_fb.feedbackte:SetText(fb.feedback or "NO FEEDBACK AVAILABLE")



			_fb.contactp = createD("DPanel", _fb, YRP.ctr(500), YRP.ctr(60), YRP.ctr(2350), YRP.ctr(10))
			function _fb.contactp:Paint(pw, ph)
				surfacePanel(self, pw, ph, "LID_settings_fb_contact")
			end
			_fb.contactte = createD("DTextEntry", _fb, YRP.ctr(500), YRP.ctr(110), YRP.ctr(2350), YRP.ctr(80))
			_fb.contactte:SetEditable(false)
			_fb.contactte:SetText(fb.contact or "NO CONTACT AVAILABLE")



			_fb.profile = createD("DButton", _fb, YRP.ctr(600), YRP.ctr(60), YRP.ctr(2860), YRP.ctr(10))
			_fb.profile:SetText("")
			function _fb.profile:Paint(pw, ph)
				surfaceButton(self, pw, ph, YRP.lang_string("LID_openprofile"))
			end
			function _fb.profile:DoClick()
				gui.OpenURL("http://steamcommunity.com/profiles/" .. _fb.steamid64)
			end

			_fbl:AddItem(_fb)
		end
	end
end)

hook.Add("open_server_feedback", "open_server_feedback", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	function settingsWindow.window.site:Paint(w, h)
		--
	end

	net.Start("get_feedback")
	net.SendToServer()
end)
