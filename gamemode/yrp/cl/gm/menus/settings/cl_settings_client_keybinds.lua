--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
function createDKeybinder(parent, w, h, x, y, keybind)
	local _tmp = createD("DBinder", parent, w, h, x, y)
	_tmp:SetValue(get_keybind(keybind))
	function _tmp:OnChange(num)
		if !set_keybind(keybind, num) and num != 0 then
			_tmp:SetSelectedNumber(get_keybind(keybind))
			Derma_Message(YRP.lang_string("LID_hotkeyinuse") .. "!", YRP.lang_string("LID_error"), YRP.lang_string("LID_ok"))
		end
	end
	function _tmp:Paint(pw, ph)
		paintButton(self, pw, ph, "")
	end
	return _tmp
end

hook.Add("open_client_keybinds", "open_client_keybinds", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	local _wide = 800

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	--sheet:AddSheet(YRP.lang_string("LID_character"), cl_charPanel, "icon16/user_edit.png")
	function settingsWindow.window.site:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), _yrp.colors.panel)
		draw.SimpleTextOutlined(YRP.lang_string("LID_characterselection"), "sef", YRP.ctr(_wide), YRP.ctr(60), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_rolemenu"), "sef", YRP.ctr(_wide), YRP.ctr(120), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_buymenu"), "sef", YRP.ctr(_wide), YRP.ctr(180), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_settings"), "sef", YRP.ctr(_wide), YRP.ctr(240), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_togglemouse"), "sef", YRP.ctr(_wide), YRP.ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_map"), "sef", YRP.ctr(_wide), YRP.ctr(360), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_inventory"), "sef", YRP.ctr(_wide), YRP.ctr(420), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_vehicles") .. " (" .. YRP.lang_string("LID_settings") .. ")", "sef", YRP.ctr(_wide), YRP.ctr(480), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_doors") .. " (" .. YRP.lang_string("LID_settings") .. ")", "sef", YRP.ctr(_wide), YRP.ctr(540), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_nextvoicechannel"), "sef", YRP.ctr(_wide), YRP.ctr(600), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_previousvoicechannel"), "sef", YRP.ctr(_wide), YRP.ctr(660), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_holdtozoomoutview"), "sef", YRP.ctr(_wide), YRP.ctr(720), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_holdtozoominview"), "sef", YRP.ctr(_wide), YRP.ctr(780), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_drop"), "sef", YRP.ctr(_wide), YRP.ctr(840), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_appearance"), "sef", YRP.ctr(_wide), YRP.ctr(960), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_emotes"), "sef", YRP.ctr(_wide), YRP.ctr(1020), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_laws"), "sef", YRP.ctr(_wide), YRP.ctr(1080), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined(YRP.lang_string("LID_switchview"), "sef", YRP.ctr(_wide), YRP.ctr(1140), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_increaseviewingheight"), "sef", YRP.ctr(_wide), YRP.ctr(1200), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_decreaseviewingheight"), "sef", YRP.ctr(_wide), YRP.ctr(1260), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingpositiontotheright"), "sef", YRP.ctr(_wide), YRP.ctr(1320), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingpositiontotheleft"), "sef", YRP.ctr(_wide), YRP.ctr(1380), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_turnviewingangletotheright"), "sef", YRP.ctr(_wide), YRP.ctr(1440), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_turnviewingangletotheleft"), "sef", YRP.ctr(_wide), YRP.ctr(1500), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopensmartphone"), "sef", YRP.ctr(_wide), YRP.ctr(1560), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_presstoclosesmartphone"), "sef", YRP.ctr(_wide), YRP.ctr(1640), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
	end

	local _k = {}
	_k._cs = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(60), "menu_character_selection")
	_k._mr = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(120), "menu_role")
	_k._mb = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(180), "menu_buy")
	_k._ms = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(240), "menu_settings")
	_k._tm = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(300), "toggle_mouse")
	_k._tm = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(360), "toggle_map")
	_k._mi = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(420), "menu_inventory")
	_k._mv = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(480), "menu_options_vehicle")
	_k._md = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(540), "menu_options_door")
	_k._sgr = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(600), "speak_next")
	_k._sgl = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(660), "speak_prev")
	_k._vzo = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(720), "view_zoom_out")
	_k._vzi = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(780), "view_zoom_in")
	_k._di = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(840), "drop_item")
	_k._ap = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(960), "menu_appearance")
	_k._me = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1020), "menu_emotes")
	_k._me = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1080), "menu_laws")

	_k._vs = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1140), "view_switch")
	_k._vu = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1200), "view_up")
	_k._vd = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1260), "view_down")
	_k._vr = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1320), "view_right")
	_k._vl = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1380), "view_left")
	_k._vsr = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1440), "view_spin_right")
	_k._vsl = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1500), "view_spin_left")

	_k._osp = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1560), "sp_open")
	_k._csp = createDKeybinder(settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1640), "sp_close")

	_k.reset = createD("DButton", settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(1800))
	_k.reset:SetText("")
	function _k.reset:Paint(pw, ph)
		local tab = {}
		tab.color = Color(255, 0, 0)
		tab.hovercolor = Color(255, 100, 100)
		tab.text = {}
		tab.text.text = YRP.lang_string("LID_settodefault")
		DrawButton(self, tab)
	end
	function _k.reset:DoClick()
		local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
		_window:Center()
		_window:SetTitle(YRP.lang_string("LID_areyousure"))

		local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
		_yesButton:SetText(YRP.lang_string("LID_yes"))
		function _yesButton:DoClick()
			ResetKeybinds()
			CloseSettings()
			OpenSettings()
			_window:Close()
		end

		local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
		_noButton:SetText(YRP.lang_string("LID_no"))
		function _noButton:DoClick()
			_window:Close()
		end

		_window:MakePopup()
	end

	if LocalPlayer():HasAccess() then
		_k.setsvkeybind = createD("DButton", settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10 + 20 + 400), YRP.ctr(1800))
		_k.setsvkeybind:SetText("")
		function _k.setsvkeybind:Paint(pw, ph)
			local tab = {}
			tab.color = Color(255, 0, 0)
			tab.hovercolor = Color(255, 100, 100)
			tab.text = {}
			tab.text.text = YRP.lang_string("LID_setasserverdefault")
			DrawButton(self, tab)
		end
		function _k.setsvkeybind:DoClick()
			local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string("LID_areyousure"))

			local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string("LID_yes"))
			function _yesButton:DoClick()
				net.Start("setserverdefaultkeybind")
					net.WriteTable(GetKeyBinds())
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string("LID_no"))
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end

		_k.forcesetkeybinds = createD("DButton", settingsWindow.window.site, YRP.ctr(400), YRP.ctr(50), YRP.ctr(_wide + 10 + 20 + 400), YRP.ctr(1800 + 70))
		_k.forcesetkeybinds:SetText("")
		function _k.forcesetkeybinds:Paint(pw, ph)
			local tab = {}
			tab.color = Color(255, 0, 0)
			tab.hovercolor = Color(255, 100, 100)
			tab.text = {}
			tab.text.text = YRP.lang_string("LID_forcesetkeybinds")
			DrawButton(self, tab)
		end
		function _k.forcesetkeybinds:DoClick()
			local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string("LID_areyousure"))

			local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string("LID_yes"))
			function _yesButton:DoClick()
				net.Start("setserverdefaultkeybind")
					net.WriteTable(GetKeyBinds())
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string("LID_no"))
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end
	end
end)
