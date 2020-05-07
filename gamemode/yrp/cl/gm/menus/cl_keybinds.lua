--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

KEYBINDS = KEYBINDS or {}
KEYBINDS.open = false

function createDKeybinder(parent, w, h, x, y, keybind)
	local _tmp = createD("DBinder", parent, w, h, x, y)
	_tmp:SetValue(get_keybind(keybind))
	function _tmp:OnChange(num)
		if !set_keybind(keybind, num) and num != 0 then
			--_tmp:SetSelectedNumber(get_keybind(keybind))
			Derma_Message(YRP.lang_string("LID_hotkeyinuse") .. "!", YRP.lang_string("LID_error"), YRP.lang_string("LID_ok"))
		end
	end
	function _tmp:Paint(pw, ph)
		paintButton(self, pw, ph, "")
	end
	return _tmp
end

function toggleKeybindsMenu()
	if !KEYBINDS.open and YRPIsNoMenuOpen() then
		openKeybindsMenu()
	end
end

function closeKeybindsMenu()
	KEYBINDS.open = false
	if KEYBINDS.window != nil then
		closeMenu()
		KEYBINDS.window:Remove()
		KEYBINDS.window = nil
	end
end

function openKeybindsMenu()
	openMenu()

	KEYBINDS.open = true
	KEYBINDS.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	KEYBINDS.window:Center()
	KEYBINDS.window:SetTitle("LID_keybinds")
	KEYBINDS.window:SetHeaderHeight(YRP.ctr(100))
	function KEYBINDS.window:OnClose()
		closeMenu()
	end
	function KEYBINDS.window:OnRemove()
		closeMenu()
	end
	KEYBINDS.window.systime = SysTime()
	function KEYBINDS.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_givekeybinds") .. " [PROTOTYPE]")
	end
	KEYBINDS.window:MakePopup()

	CreateKeybindsContent(KEYBINDS.window.con)
end

function CreateKeybindsContent(parent)
	KEYBINDS.content = parent

	local _wide = 780

	background = createD("DPanel", parent, YRP.ctr(1200), parent:GetTall(), 0, 0)
	local keybinds = {}
	table.insert(keybinds, {YRP.lang_string("LID_characterselection"), "menu_character_selection"})
	table.insert(keybinds, {YRP.lang_string("LID_rolemenu"), "menu_role"})
	table.insert(keybinds, {YRP.lang_string("LID_buymenu"), "menu_buy"})
	table.insert(keybinds, {YRP.lang_string("LID_settings"), "menu_settings"})
	table.insert(keybinds, {YRP.lang_string("LID_togglemouse"), "toggle_mouse"})
	table.insert(keybinds, {YRP.lang_string("LID_map"), "toggle_map"})
	table.insert(keybinds, {YRP.lang_string("LID_inventory"), "menu_inventory"})
	table.insert(keybinds, {YRP.lang_string("LID_vehicles") .. " (" .. YRP.lang_string("LID_settings") .. ")", "menu_options_vehicle"})
	table.insert(keybinds, {YRP.lang_string("LID_doors") .. " (" .. YRP.lang_string("LID_settings") .. ")", "menu_options_door"})
	table.insert(keybinds, {YRP.lang_string("LID_holdtozoomoutview"), "view_zoom_out"})
	table.insert(keybinds, {YRP.lang_string("LID_holdtozoominview"), "view_zoom_in"})
	table.insert(keybinds, {YRP.lang_string("LID_interact"), "menu_interact"})
	table.insert(keybinds, {YRP.lang_string("LID_drop"), "drop_item"})
	table.insert(keybinds, {YRP.lang_string("LID_appearance"), "menu_appearance"})
	table.insert(keybinds, {YRP.lang_string("LID_emotes"), "menu_emotes"})
	table.insert(keybinds, {YRP.lang_string("LID_laws"), "menu_laws"})
	table.insert(keybinds, {YRP.lang_string("LID_switchview"), "view_switch"})
	table.insert(keybinds, {YRP.lang_string("LID_increaseviewingheight"), "view_up"})
	table.insert(keybinds, {YRP.lang_string("LID_decreaseviewingheight"), "view_down"})
	table.insert(keybinds, {YRP.lang_string("LID_viewingpositiontotheright"), "view_right"})
	table.insert(keybinds, {YRP.lang_string("LID_viewingpositiontotheleft"), "view_left"})
	table.insert(keybinds, {YRP.lang_string("LID_turnviewingangletotheright"), "view_spin_right"})
	table.insert(keybinds, {YRP.lang_string("LID_turnviewingangletotheleft"), "view_spin_left"})
	table.insert(keybinds, {YRP.lang_string("LID_presstoopensmartphone"), "sp_open"})
	table.insert(keybinds, {YRP.lang_string("LID_presstoclosesmartphone"), "sp_close"})
	table.insert(keybinds, {YRP.lang_string("LID_character"), "menu_char"})
	table.insert(keybinds, {YRP.lang_string("LID_keybinds"), "menu_keybinds"})
	table.insert(keybinds, {YRP.lang_string("LID_mutevoice"), "voice_mute"})
	table.insert(keybinds, {YRP.lang_string("LID_voicerangeup"), "voice_range_up"})
	table.insert(keybinds, {YRP.lang_string("LID_voicerangedn"), "voice_range_dn"})
	table.insert(keybinds, {YRP.lang_string("LID_voicechat"), "voice_menu"})
	table.insert(keybinds, {YRP.lang_string("LID_chat"), "chat_menu"})
	table.insert(keybinds, {YRP.lang_string("LID_talents"), "menu_talents"})
	function background:Paint(pw, ph)
		for i, v in pairs(keybinds) do
			draw.SimpleTextOutlined(YRP.lang_string(v[1]), "Y_24_500", YRP.ctr(_wide), YRP.ctr(20) + (i - 1) * YRP.ctr(50 + 4), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		end
	end

	local kbw = YRP.ctr(200)
	for i, v in pairs(keybinds) do
		createDKeybinder(parent, kbw, YRP.ctr(50), YRP.ctr(_wide + 10), YRP.ctr(20) + (i - 1) * YRP.ctr(50 + 4), v[2])
	end



	local reset = createD("DButton", parent, YRP.ctr(500), YRP.ctr(50), YRP.ctr(_wide + 400), YRP.ctr(20))
	reset:SetText("")
	function reset:Paint(pw, ph)
		local tab = {}
		tab.color = Color(255, 0, 0)
		tab.hovercolor = Color(255, 100, 100)
		tab.text = {}
		tab.text.text = YRP.lang_string("LID_settodefault")
		DrawButton(self, tab)
	end
	function reset:DoClick()
		local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
		_window:Center()
		_window:SetTitle(YRP.lang_string("LID_areyousure"))

		local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
		_yesButton:SetText(YRP.lang_string("LID_yes"))
		function _yesButton:DoClick()
			YResetKeybinds()
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
		local setsvkeybind = createD("DButton", parent, YRP.ctr(500), YRP.ctr(50), YRP.ctr(_wide + 400), YRP.ctr(90))
		setsvkeybind:SetText("")
		function setsvkeybind:Paint(pw, ph)
			local tab = {}
			tab.color = Color(255, 0, 0)
			tab.hovercolor = Color(255, 100, 100)
			tab.text = {}
			tab.text.text = YRP.lang_string("LID_setasserverdefault")
			DrawButton(self, tab)
		end
		function setsvkeybind:DoClick()
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

		local forcesetkeybinds = createD("DButton", parent, YRP.ctr(500), YRP.ctr(50), YRP.ctr(_wide + 400), YRP.ctr(160))
		forcesetkeybinds:SetText("")
		function forcesetkeybinds:Paint(pw, ph)
			local tab = {}
			tab.color = Color(255, 0, 0)
			tab.hovercolor = Color(255, 100, 100)
			tab.text = {}
			tab.text.text = YRP.lang_string("LID_forcesetkeybinds")
			DrawButton(self, tab)
		end
		function forcesetkeybinds:DoClick()
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
end

