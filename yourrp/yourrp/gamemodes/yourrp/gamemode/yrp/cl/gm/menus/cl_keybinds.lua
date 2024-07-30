--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
KEYBINDS = KEYBINDS or {}
KEYBINDS.open = false
function YRPCreateDKeybinder(parent, w, h, x, y, keybind)
	local _tmp = YRPCreateD("DBinder", parent, w, h, x, y)
	_tmp:SetValue(YRPGetKeybind(keybind))
	function _tmp:OnChange(num)
		if not YRPSetKeybind(keybind, num) and num ~= 0 then
			--_tmp:SetSelectedNumber(YRPGetKeybind(keybind) )
			Derma_Message(YRP:trans("LID_hotkeyinuse") .. "!", YRP:trans("LID_error"), YRP:trans("LID_ok"))
		end
	end

	function _tmp:Paint(pw, ph)
		paintButton(self, pw, ph, "")
	end

	return _tmp
end

function YRPToggleKeybindsMenu()
	if not KEYBINDS.open and YRPIsNoMenuOpen() then
		openKeybindsMenu()
	end
end

function closeKeybindsMenu()
	KEYBINDS.open = false
	if KEYBINDS.window ~= nil then
		YRPCloseMenu()
		KEYBINDS.window:Remove()
		KEYBINDS.window = nil
	end
end

function openKeybindsMenu()
	YRPOpenMenu()
	KEYBINDS.open = true
	KEYBINDS.window = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	KEYBINDS.window:Center()
	KEYBINDS.window:SetTitle("LID_keybinds")
	KEYBINDS.window:SetHeaderHeight(YRP:ctr(100))
	function KEYBINDS.window:OnClose()
		YRPCloseMenu()
	end

	function KEYBINDS.window:OnRemove()
		YRPCloseMenu()
	end

	KEYBINDS.window.systime = SysTime()
	function KEYBINDS.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end

	KEYBINDS.window:MakePopup()
	CreateKeybindsContent(KEYBINDS.window.con)
end

function CreateKeybindsContent(parent)
	KEYBINDS.content = parent
	local _wide = 780
	background = YRPCreateD("DPanel", parent, YRP:ctr(1200), parent:GetTall(), 0, 0)
	local keybinds = {}
	table.insert(keybinds, {YRP:trans("LID_characterselection"), "menu_character_selection"})
	table.insert(keybinds, {YRP:trans("LID_rolemenu"), "menu_role"})
	table.insert(keybinds, {YRP:trans("LID_buymenu"), "menu_buy"})
	table.insert(keybinds, {YRP:trans("LID_settings"), "menu_settings"})
	table.insert(keybinds, {YRP:trans("LID_togglemouse"), "toggle_mouse"})
	table.insert(keybinds, {YRP:trans("LID_map"), "toggle_map"})
	table.insert(keybinds, {YRP:trans("LID_inventory"), "menu_inventory"})
	table.insert(keybinds, {YRP:trans("LID_vehicles") .. " ( " .. YRP:trans("LID_settings") .. " )", "menu_options_vehicle"})
	table.insert(keybinds, {YRP:trans("LID_doors") .. " ( " .. YRP:trans("LID_settings") .. " )", "menu_options_door"})
	table.insert(keybinds, {YRP:trans("LID_holdtozoomoutview"), "view_zoom_out"})
	table.insert(keybinds, {YRP:trans("LID_holdtozoominview"), "view_zoom_in"})
	table.insert(keybinds, {YRP:trans("LID_interact"), "menu_interact"})
	table.insert(keybinds, {YRP:trans("LID_groupmenu"), "menu_group"})
	table.insert(keybinds, {YRP:trans("LID_drop"), "drop_item"})
	table.insert(keybinds, {YRP:trans("LID_appearance"), "menu_appearance"})
	table.insert(keybinds, {YRP:trans("LID_emotes"), "menu_emotes"})
	table.insert(keybinds, {YRP:trans("LID_laws"), "menu_laws"})
	table.insert(keybinds, {YRP:trans("LID_switchview"), "view_switch"})
	table.insert(keybinds, {YRP:trans("LID_increaseviewingheight"), "view_up"})
	table.insert(keybinds, {YRP:trans("LID_decreaseviewingheight"), "view_down"})
	table.insert(keybinds, {YRP:trans("LID_viewingpositiontotheright"), "view_right"})
	table.insert(keybinds, {YRP:trans("LID_viewingpositiontotheleft"), "view_left"})
	table.insert(keybinds, {YRP:trans("LID_turnviewingangletotheright"), "view_spin_right"})
	table.insert(keybinds, {YRP:trans("LID_turnviewingangletotheleft"), "view_spin_left"})
	table.insert(keybinds, {YRP:trans("LID_presstoopensmartphone"), "sp_open"})
	table.insert(keybinds, {YRP:trans("LID_presstoclosesmartphone"), "sp_close"})
	table.insert(keybinds, {YRP:trans("LID_character"), "menu_char"})
	table.insert(keybinds, {YRP:trans("LID_keybinds"), "menu_keybinds"})
	table.insert(keybinds, {YRP:trans("LID_mutevoice"), "voice_mute"})
	table.insert(keybinds, {YRP:trans("LID_voicerangeup"), "voice_range_up"})
	table.insert(keybinds, {YRP:trans("LID_voicerangedn"), "voice_range_dn"})
	table.insert(keybinds, {YRP:trans("LID_voicechat"), "voice_menu"})
	table.insert(keybinds, {YRP:trans("LID_chat"), "chat_menu"})
	function background:Paint(pw, ph)
		for i, v in pairs(keybinds) do
			draw.SimpleTextOutlined(YRP:trans(v[1]), "Y_24_500", YRP:ctr(_wide), YRP:ctr(20) + (i - 1) * YRP:ctr(50 + 4), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		end
	end

	local kbw = YRP:ctr(200)
	for i, v in pairs(keybinds) do
		YRPCreateDKeybinder(parent, kbw, YRP:ctr(50), YRP:ctr(_wide + 10), YRP:ctr(20) + (i - 1) * YRP:ctr(50 + 4), v[2])
	end

	local reset = YRPCreateD("DButton", parent, YRP:ctr(500), YRP:ctr(50), YRP:ctr(_wide + 400), YRP:ctr(20))
	reset:SetText("")
	function reset:Paint(pw, ph)
		local tab = {}
		tab.color = Color(0, 255, 0)
		tab.hovercolor = Color(255, 100, 100)
		tab.text = {}
		tab.text.text = YRP:trans("LID_settodefault")
		YRPDrawButton(self, tab)
	end

	function reset:DoClick()
		local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
		_window:Center()
		_window:SetTitle(YRP:trans("LID_areyousure"))
		local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
		_yesButton:SetText(YRP:trans("LID_yes"))
		function _yesButton:DoClick()
			YRPResetKeybinds()
			F8CloseSettings()
			F8OpenSettings()
			_window:Close()
		end

		local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
		_noButton:SetText(YRP:trans("LID_no"))
		function _noButton:DoClick()
			_window:Close()
		end

		_window:MakePopup()
	end

	if LocalPlayer():HasAccess("CreateKeybindsContent") then
		local setsvkeybind = YRPCreateD("DButton", parent, YRP:ctr(500), YRP:ctr(50), YRP:ctr(_wide + 400), YRP:ctr(90))
		setsvkeybind:SetText("")
		function setsvkeybind:Paint(pw, ph)
			local tab = {}
			tab.color = Color(0, 255, 0)
			tab.hovercolor = Color(255, 100, 100)
			tab.text = {}
			tab.text.text = YRP:trans("LID_setasserverdefault")
			YRPDrawButton(self, tab)
		end

		function setsvkeybind:DoClick()
			local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP:trans("LID_areyousure"))
			local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP:trans("LID_yes"))
			function _yesButton:DoClick()
				net.Start("nws_yrp_setserverdefaultkeybind")
				net.WriteTable(YRPGetKeybinds())
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP:trans("LID_no"))
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end

		local forcesetkeybinds = YRPCreateD("DButton", parent, YRP:ctr(500), YRP:ctr(50), YRP:ctr(_wide + 400), YRP:ctr(160))
		forcesetkeybinds:SetText("")
		function forcesetkeybinds:Paint(pw, ph)
			local tab = {}
			tab.color = Color(0, 255, 0)
			tab.hovercolor = Color(255, 100, 100)
			tab.text = {}
			tab.text.text = YRP:trans("LID_forcesetkeybinds")
			YRPDrawButton(self, tab)
		end

		function forcesetkeybinds:DoClick()
			local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP:trans("LID_areyousure"))
			local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP:trans("LID_yes"))
			function _yesButton:DoClick()
				net.Start("nws_yrp_setserverdefaultkeybind")
				net.WriteTable(YRPGetKeybinds())
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP:trans("LID_no"))
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end
	end
end
