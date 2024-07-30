--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function YRPTextColor(bgcol)
	if bgcol.r and bgcol.g and bgcol.b then
		local sum = bgcol.r + bgcol.g + bgcol.b
		if sum > 255 then return Color(0, 0, 0, 255) end
	end

	return Color(255, 255, 255, 255)
end

function YRPAreYouSure(yes, no)
	local win = createVGUI("YFrame", nil, 630, 100 + 10 + 50 + 10, 0, 0)
	win:Center()
	win:SetTitle(YRP:trans("LID_areyousure"))
	function win:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	local _yes = createVGUI("DButton", win, 300, 50, 10, 110)
	_yes:SetText(YRP:trans("LID_yes"))
	function _yes:DoClick()
		if yes ~= nil then
			yes()
		end

		win:Close()
	end

	local _no = createVGUI("DButton", win, 300, 50, 10 + 300 + 10, 110)
	_no:SetText(YRP:trans("LID_no"))
	function _no:DoClick()
		if no ~= nil then
			no()
		end

		win:Close()
	end

	win:MakePopup()
end

local HUD = {}
function RegisterHUDElement(design, element, func)
	HUD[design] = HUD[design] or {}
	HUD[design][element] = func
end

function ScrV(dec)
	return ScrH() * dec
end

function YRPHudBox(tab)
	local vTab = tab or {}
	vTab.r = vTab.r or 0
	vTab.x = vTab.x or 0
	vTab.y = vTab.y or 0
	vTab.w = vTab.w or 100
	vTab.h = vTab.h or 100
	vTab.color = vTab.color or Color(0, 255, 0)
	draw.RoundedBox(vTab.r, vTab.x, vTab.y, vTab.w, vTab.h, vTab.color)
end

function HudBoxBr(tab)
	tab.br = tab.br or 1
	local up = table.Copy(tab)
	up.h = tab.br
	YRPHudBox(up)
	local dn = table.Copy(tab)
	dn.h = tab.br
	dn.y = tab.y + tab.h - tab.br
	YRPHudBox(dn)
	local le = table.Copy(tab)
	le.w = tab.br
	YRPHudBox(le)
	local ri = table.Copy(tab)
	ri.w = tab.br
	ri.x = tab.x + tab.w - tab.br
	YRPHudBox(ri)
end

function HudBoxBrRounded(tab)
	tab.br = tab.br or 1
	-- LU
	local center = Vector(tab.x + tab.r, tab.y + tab.r, 0)
	local scale = Vector(tab.r, tab.r, 0)
	local segmentdist = 360 / (2 * math.pi * math.max(scale.x, scale.y) / 2)
	surface.SetDrawColor(tab.color)
	for a = 90, 90 + 90, segmentdist do
		surface.DrawLine(center.x + math.cos(math.rad(a)) * scale.x, center.y - math.sin(math.rad(a)) * scale.y, center.x + math.cos(math.rad(a + segmentdist)) * scale.x, center.y - math.sin(math.rad(a + segmentdist)) * scale.y)
	end

	draw.RoundedBox(0, tab.x, tab.y + tab.r, tab.br, tab.h - 2 * tab.r, tab.color)
	-- LD
	local center2 = Vector(tab.x + tab.r, tab.y + tab.h - tab.r, 0)
	local scale2 = Vector(tab.r, tab.r, 0)
	local segmentdist2 = 360 / (2 * math.pi * math.max(scale2.x, scale2.y) / 2)
	surface.SetDrawColor(tab.color)
	for a = 180, 180 + 90, segmentdist2 do
		surface.DrawLine(center2.x + math.cos(math.rad(a)) * scale2.x, center2.y - math.sin(math.rad(a)) * scale2.y, center2.x + math.cos(math.rad(a + segmentdist2)) * scale2.x, center2.y - math.sin(math.rad(a + segmentdist2)) * scale2.y)
	end

	-- MID
	draw.RoundedBox(0, tab.x + tab.r, tab.y, tab.w - 2 * tab.r, tab.br, tab.color)
	draw.RoundedBox(0, tab.x + tab.r, tab.y + tab.h - tab.br, tab.w - 2 * tab.r, tab.br, tab.color)
	-- RU
	center = Vector(tab.x + tab.w - tab.r, tab.y + tab.r, 0)
	scale = Vector(tab.r, tab.r, 0)
	segmentdist = 360 / (2 * math.pi * math.max(scale.x, scale.y) / 2)
	surface.SetDrawColor(tab.color)
	for a = 360, 360 + 90, segmentdist do
		surface.DrawLine(center.x + math.cos(math.rad(a)) * scale.x, center.y - math.sin(math.rad(a)) * scale.y, center.x + math.cos(math.rad(a + segmentdist)) * scale.x, center.y - math.sin(math.rad(a + segmentdist)) * scale.y)
	end

	draw.RoundedBox(0, tab.x + tab.w - tab.br, tab.y + tab.r, tab.br, tab.h - 2 * tab.r, tab.color)
	-- RD
	center = Vector(tab.x + tab.w - tab.r, tab.y + tab.h - tab.r, 0)
	scale = Vector(tab.r, tab.r, 0)
	segmentdist = 360 / (2 * math.pi * math.max(scale.x, scale.y) / 2)
	surface.SetDrawColor(tab.color)
	for a = 270, 270 + 90, segmentdist do
		surface.DrawLine(center.x + math.cos(math.rad(a)) * scale.x, center.y - math.sin(math.rad(a)) * scale.y, center.x + math.cos(math.rad(a + segmentdist)) * scale.x, center.y - math.sin(math.rad(a + segmentdist)) * scale.y)
	end
end

function OldHudBoxBr(tab)
	YRPHudBox(tab[1])
	YRPHudBox(tab[2])
	YRPHudBox(tab[3])
	YRPHudBox(tab[4])
end

function GetBorderTab(tab)
	tab[1] = {}
	tab[1].r = 0
	tab[2] = {}
	tab[2].r = 0
	tab[3] = {}
	tab[3].r = 0
	tab[4] = {}
	tab[4].r = 0
	tab[1].w = tab.w
	tab[1].h = tab.br
	tab[1].x = tab.x
	tab[1].y = tab.y
	tab[1].color = tab.color
	tab[2].w = tab.br
	tab[2].h = tab.h
	tab[2].x = tab.x + tab.w - tab.br
	tab[2].y = tab.y
	tab[2].color = tab.color
	tab[3].w = tab.w
	tab[3].h = tab.br
	tab[3].x = tab.x
	tab[3].y = tab.y + tab.h - tab.br
	tab[3].color = tab.color
	tab[4].w = tab.br
	tab[4].h = tab.h
	tab[4].x = tab.x
	tab[4].y = tab.y
	tab[4].color = tab.color

	return tab
end

function YRPHudText(tab)
	draw.SimpleText(tab.text, tab.font, tab.x, tab.y, tab.color, tab.ax, tab.ay)
end

function stc(str)
	if str ~= nil then
		str = string.Explode(",", str)
		if table.Count(str) >= 3 then return Color(str[1] or 0, str[2] or 0, str[3] or 0, str[4] or 255) end
	end

	return Color(255, 255, 255, 255)
end

local color_db = Color(200, 200, 200)
function YRPDrawBox(tab)
	tab.r = tab.r or 0
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.color = tab.color or color_db
	draw.RoundedBox(tab.r, tab.x, tab.y, tab.w, tab.h, tab.color)
end

function YRPDrawButton(button, tab)
	tab.r = tab.r or 0
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or button:GetWide()
	tab.h = tab.h or button:GetTall()
	tab.color = tab.color or YRPGetColor("2")
	tab.hovercolor = tab.hovercolor or YRPGetColor("1")
	if InterfaceTransparent() then
		tab.color.a = 200
		tab.hovercolor.a = 200
	end

	if button:IsHovered() then
		tab.color = tab.hovercolor or Color(255, 255, 255, 255)
	end

	YRPDrawBox(tab)
	tab.text = tab.text or {}
	tab.text.text = tab.text.text or "NOTEXT"
	tab.text.x = tab.text.x or tab.w / 2
	tab.text.y = tab.text.y or tab.h / 2
	tab.text.color = tab.color or Color(255, 255, 255, 255)
	YRPDrawText(tab.text)
end

function YRPGetTextLength(text, font)
	surface.SetFont(font)
	local l = select(1, surface.GetTextSize(text))

	return l
end

local yrp_if = {}
function YRPGetHTMLImage(url, w, h)
	return "<style type=\"text/css\"> body { padding: 0; margin: 0; border:0; } img { padding: 0; margin: 0; border:0; } </style> <body> <img src=\"" .. url .. "\" width=\"" .. w .. "\" height=\"" .. h .. "\"/> </body>"
end

function YRPRegisterDesign(tab)
	if tab.name ~= nil then
		yrp_if[tab.name] = {}
		yrp_if[tab.name].author = tab.author or "NO AUTHOR"
		yrp_if[tab.name].name = tab.name or "NO Name"
		yrp_if[tab.name].textFont = tab.textFont or "Y_18_500"
	end
end

function RegisterPanelFunction(name, func)
	yrp_if[name]["DPanel"] = func
end

function RegisterButtonFunction(name, func)
	yrp_if[name]["DButton"] = func
end

function RegisterWindowFunction(name, func)
	yrp_if[name]["DFrame"] = func
end

function YRPGetDesigns()
	return yrp_if
end

function YRPGetFont()
	return yrp_if[interfaceDesign()].textFont
end

function interfaceDesign()
	local lply = LocalPlayer()
	local design = lply:GetYRPString("interface_design", "Material Design 1")
	if yrp_if[design] ~= nil then
		return design
	else
		return "Material Design 1"
	end
end

function InterfaceBorder()
	local lply = LocalPlayer()

	return lply:GetYRPBool("interface_border", true)
end

function InterfaceRounded()
	local lply = LocalPlayer()

	return lply:GetYRPBool("interface_rounded", true)
end

function InterfaceTransparent()
	local lply = LocalPlayer()

	return lply:GetYRPBool("interface_transparent", true)
end

function InterfaceColor()
	local lply = LocalPlayer()

	return lply:GetYRPString("interface_color", "blue")
end

function InterfaceStyle()
	local lply = LocalPlayer()

	return lply:GetYRPString("interface_style", "dark")
end

local yrp_colors = {}
function YRPGetColor(nr)
	if IsNotNilAndNotFalse(yrp_colors[interfaceDesign()]) and IsNotNilAndNotFalse(yrp_colors[interfaceDesign()][InterfaceColor()]) and IsNotNilAndNotFalse(yrp_colors[interfaceDesign()][InterfaceColor()][nr]) then
		local color = yrp_colors[interfaceDesign()][InterfaceColor()][nr]
		if InterfaceTransparent() then
			color.a = 200
		end

		return color
	end

	return Color(255, 0, 0, 255)
end

function YRPAddColor(design, color, nr, col)
	yrp_colors[design] = yrp_colors[design] or {}
	yrp_colors[design][color] = yrp_colors[design][color] or {}
	yrp_colors[design][color][nr] = col
end

local _icons = {}
local _w_icons = {}
local m_adding = false
local m_counter = 0
local m_w_counter = 0
function YRP:AddDesignIcon(name, path)
	m_w_counter = m_w_counter + 1
	_w_icons[m_w_counter] = {name, path}
end

YRP:AddDesignIcon("lang_auto", "vgui/iso_639/" .. "auto" .. ".png")
YRP:AddDesignIcon("group", "vgui/material/icon_group.png")
YRP:AddDesignIcon("role", "vgui/material/icon_person.png")
YRP:AddDesignIcon("help", "vgui/material/icon_help.png")
YRP:AddDesignIcon("keyboard", "vgui/material/icon_keyboard.png")
YRP:AddDesignIcon("mouse", "vgui/material/icon_mouse.png")
YRP:AddDesignIcon("security", "vgui/material/icon_security.png")
YRP:AddDesignIcon("usergroup", "vgui/material/icon_usergroup.png")
YRP:AddDesignIcon("character", "vgui/material/icon_character.png")
YRP:AddDesignIcon("shop", "vgui/material/icon_shop.png")
YRP:AddDesignIcon("settings", "vgui/material/icon_settings.png")
YRP:AddDesignIcon("feedback", "vgui/material/icon_feedback.png")
YRP:AddDesignIcon("map", "vgui/material/icon_map.png")
YRP:AddDesignIcon("color_lens", "vgui/material/icon_color_lens.png")
YRP:AddDesignIcon("pin_drop", "vgui/material/icon_pin_drop.png")
YRP:AddDesignIcon("face", "vgui/material/icon_face.png")
YRP:AddDesignIcon("smile", "vgui/material/icon_insert_emoticon.png")
YRP:AddDesignIcon("keyboard_arrow_down", "vgui/material/icon_keyboard_arrow_down.png")
YRP:AddDesignIcon("keyboard_arrow_up", "vgui/material/icon_keyboard_arrow_up.png")
YRP:AddDesignIcon("keyboard_arrow_right", "vgui/material/icon_keyboard_arrow_right.png")
YRP:AddDesignIcon("keyboard_arrow_left", "vgui/material/icon_keyboard_arrow_left.png")
YRP:AddDesignIcon("unfold_less", "vgui/material/icon_unfold_less.png")
YRP:AddDesignIcon("unfold_more", "vgui/material/icon_unfold_more.png")
YRP:AddDesignIcon("record_voice_over", "vgui/material/icon_record_voice_over.png")
YRP:AddDesignIcon("3d_rotation", "vgui/material/icon_3d_rotation.png")
YRP:AddDesignIcon("rotate_left", "vgui/material/icon_rotate_left.png")
YRP:AddDesignIcon("rotate_right", "vgui/material/icon_rotate_right.png")
YRP:AddDesignIcon("smartphone", "vgui/material/icon_smartphone.png")
YRP:AddDesignIcon("system_update", "vgui/material/icon_system_update.png")
YRP:AddDesignIcon("work", "vgui/material/icon_work.png")
YRP:AddDesignIcon("done", "vgui/material/icon_done.png")
YRP:AddDesignIcon("navigation", "vgui/material/icon_navigation.png")
YRP:AddDesignIcon("chat", "vgui/material/icon_chat.png")
YRP:AddDesignIcon("mic", "vgui/material/icon_mic.png")
YRP:AddDesignIcon("close", "vgui/material/icon_highlight_off.png")
YRP:AddDesignIcon("mat_square", "vgui/material/icon_square.png")
YRP:AddDesignIcon("launch", "vgui/material/icon_launch.png")
YRP:AddDesignIcon("lock", "vgui/material/icon_lock.png")
YRP:AddDesignIcon("steam", "vgui/material/icon_steam.png")
YRP:AddDesignIcon("play", "vgui/material/icon_play.png")
YRP:AddDesignIcon("play_circle", "vgui/material/icon_play_circle.png")
YRP:AddDesignIcon("pause", "vgui/material/icon_pause.png")
YRP:AddDesignIcon("pause_circle", "vgui/material/icon_pause_circle.png")
YRP:AddDesignIcon("language", "vgui/material/icon_language.png")
YRP:AddDesignIcon("list", "vgui/material/icon_list.png")
YRP:AddDesignIcon("edit", "vgui/material/icon_create.png")
YRP:AddDesignIcon("circle", "vgui/material/icon_circle.png")
YRP:AddDesignIcon("add", "vgui/material/icon_add.png")
YRP:AddDesignIcon("remove", "vgui/material/icon_remove.png")
YRP:AddDesignIcon("shopping_cart", "vgui/material/icon_shop_cart.png")
YRP:AddDesignIcon("radiation", "vgui/material/icon_radiation.png")
YRP:AddDesignIcon("dashboard", "vgui/material/icon_dashboard.png")
YRP:AddDesignIcon("person_pin", "vgui/material/icon_person_pin.png")
YRP:AddDesignIcon("accessibility", "vgui/material/icon_accessibility.png")
YRP:AddDesignIcon("gavel", "vgui/material/icon_gavel.png")
YRP:AddDesignIcon("web", "vgui/material/icon_web.png")
YRP:AddDesignIcon("forum", "vgui/material/icon_forum.png")
YRP:AddDesignIcon("policy", "vgui/material/icon_policy.png")
YRP:AddDesignIcon("ts_white", "vgui/material/icon_teamspeak.png")
YRP:AddDesignIcon("code", "vgui/material/icon_code.png")
YRP:AddDesignIcon("eye", "vgui/material/icon_visibility.png")
YRP:AddDesignIcon("account", "vgui/material/icon_account.png")
YRP:AddDesignIcon("incognito", "vgui/material/icon_incognito.png")
YRP:AddDesignIcon("return", "vgui/material/icon_sync.png")
YRP:AddDesignIcon("wifi", "vgui/material/icon_wifi.png")
YRP:AddDesignIcon("bullet", "vgui/material/icon_bullet.png")
YRP:AddDesignIcon("bullet_secondary", "vgui/material/icon_bullet_secondary.png")
YRP:AddDesignIcon("discord", "vgui/material/icon_discord.png")
YRP:AddDesignIcon("discord_black", "vgui/material/icon_discord_black.png")
YRP:AddDesignIcon("discord_white", "vgui/material/icon_discord_white.png")
YRP:AddDesignIcon("os_windows", "vgui/material/icon_os_windows.png")
YRP:AddDesignIcon("os_linux", "vgui/material/icon_os_linux.png")
YRP:AddDesignIcon("os_osx", "vgui/material/icon_os_osx.png")
YRP:AddDesignIcon("importexport", "vgui/material/icon_import_export.png")
YRP:AddDesignIcon("volume_up", "vgui/material/icon_volume_up.png")
YRP:AddDesignIcon("volume_down", "vgui/material/icon_volume_down.png")
YRP:AddDesignIcon("volume_mute", "vgui/material/icon_volume_mute.png")
YRP:AddDesignIcon("volume_off", "vgui/material/icon_volume_off.png")
YRP:AddDesignIcon("signal1", "vgui/material/icon_signal01.png")
YRP:AddDesignIcon("signal2", "vgui/material/icon_signal02.png")
YRP:AddDesignIcon("signal3", "vgui/material/icon_signal03.png")
local _, folders = file.Find("materials/icons/*", "GAME")
for _, folder in pairs(folders) do
	local _, f_folders = file.Find("materials/icons/" .. folder .. "/*", "GAME")
	for _, f_folder in pairs(f_folders) do
		local f_files, _ = file.Find("materials/icons/" .. folder .. "/" .. f_folder .. "/*.png", "GAME")
		for i, f_file in pairs(f_files) do
			local f = "materials/icons/" .. folder .. "/" .. f_folder .. "/" .. f_file
			local name = string.Explode("/", f_file)
			name = folder .. "_" .. name[#name]
			name = string.Replace(name, ".png", "")
			YRP:AddDesignIcon(name, f)
		end
	end
end

-- Flags
local flags, _ = file.Find("materials/vgui/iso_3166/*.png", "GAME", "nameasc")
for i, flag in pairs(flags) do
	flag = string.Replace(flag, ".png", "")
	YRP:AddDesignIcon("flag_" .. flag, "vgui/iso_3166/" .. flag .. ".png")
end

function YRP:YLoadDesignIcon()
	if not m_adding and _w_icons[m_counter + 1] ~= nil then
		m_adding = true
		m_counter = m_counter + 1
		local name = _w_icons[m_counter][1]
		local path = _w_icons[m_counter][2]
		local mat, _ = Material(path, "noclamp")
		_icons[name] = mat
		m_adding = false
		if _w_icons[m_counter + 1] ~= nil then
			YRP:YLoadDesignIcon()
		end
	elseif m_counter ~= m_w_counter then
		timer.Simple(
			1,
			function()
				YRP:YLoadDesignIcon()
			end
		)
	end
end

timer.Simple(
	1,
	function()
		YRP:YLoadDesignIcon()
	end
)

YRP:AddDesignIcon("clear", "vgui/material/icon_clear.png")
function YRP:GetDesignIcon(name)
	if _icons[name] ~= nil and tostring(_icons[name]) ~= "Material [___error]" then return _icons[name] end

	return _icons["clear"]
end

function YRP:DrawIcon(material, w, h, x, y, colo)
	local col = colo or YRPGetColor("6")
	if IsNotNilAndNotFalse(material) then
		surface.SetDrawColor(col)
		surface.SetMaterial(material)
		surface.DrawTexturedRect(x or 0, y or 0, w or 64, h or 64)
	end
end

local _delay = 1
local _get_design = true
function surfaceWindow(self, pw, ph, title)
	local _title = title or ""
	if yrp_if[interfaceDesign()] ~= nil and yrp_if[interfaceDesign()]["DFrame"] then
		yrp_if[interfaceDesign()]["DFrame"](self, pw, ph, _title)
	end
end

function surfacePanel(derm, pw, ph, text, color, px, py, ax, ay)
	local _text = text or ""
	if yrp_if and yrp_if[interfaceDesign()] ~= nil and yrp_if[interfaceDesign()] and yrp_if[interfaceDesign()]["DPanel"] then
		yrp_if[interfaceDesign()]["DPanel"](derm, pw, ph, _text, color, px, py, ax, ay)
	end
end

function surfaceCheckBox(self, pw, ph, icon)
	if yrp_if[interfaceDesign()] ~= nil then
		if yrp_if[interfaceDesign()]["DCheckBox"] ~= nil then
			yrp_if[interfaceDesign()]["DCheckBox"](self, pw, ph, icon)
		else
			local th = 4
			local br = 4
			local color = Color(0, 0, 0, 255)
			draw.RoundedBox(0, YRP:ctr(br), YRP:ctr(br), pw - YRP:ctr(br * 2), YRP:ctr(th), color)
			draw.RoundedBox(0, YRP:ctr(br), YRP:ctr(br), YRP:ctr(th), ph - YRP:ctr(br * 2), color)
			draw.RoundedBox(0, YRP:ctr(br), ph - YRP:ctr(br + th), pw - YRP:ctr(br * 2), YRP:ctr(th), color)
			draw.RoundedBox(0, pw - YRP:ctr(br + th), YRP:ctr(br), YRP:ctr(th), ph - YRP:ctr(br * 2), color)
			if self:GetChecked() then
				br = 4
				if YRP:GetDesignIcon(icon) ~= nil then
					surface.SetDrawColor(Color(0, 255, 0))
					surface.SetMaterial(YRP:GetDesignIcon(icon))
					surface.DrawTexturedRect(YRP:ctr(br), YRP:ctr(br), pw - YRP:ctr(br * 2), ph - YRP:ctr(8))
				end
			end
		end
	end
end

function YRPMouseVisible()
	return vgui.CursorVisible()
end

-- OLD
--
local _menuOpen = false
function YRPIsNoMenuOpen()
	if not vgui.CursorVisible() then
		return true
	else
		return false
	end
end

function YRPCloseMenu()
	_menuOpen = false
	gui.EnableScreenClicker(false)
end

function YRPOpenMenu()
	_menuOpen = true
end

function paintBr(pw, ph, color)
	local _br = YRP:ctr(2)
	--links
	draw.RoundedBox(0, _br, _br, _br, ph - 2 * _br, color)
	--oben
	draw.RoundedBox(0, _br, _br, pw - 2 * _br, _br, color)
	--rechts
	draw.RoundedBox(0, pw - 2 * _br, _br, _br, ph - 2 * _br, color)
	--unten
	draw.RoundedBox(0, _br, ph - 2 * _br, pw - 2 * _br, _br, color)
end

function paintWindow(self, pw, ph, title)
	yrp_if["Material Design 1"]["DFrame"](self, pw, ph, title)
end

local color_pb1 = Color(255, 255, 255, 150)
local color_pb2 = Color(255, 255, 100, 150)
function paintButton(self, pw, ph, mytext)
	local _color = color_pb1
	if self:IsHovered() then
		_color = color_pb2
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _color)
	local _brC = Color(0, 0, 0, 255)
	paintBr(pw, ph, _brC)
	draw.SimpleTextOutlined(YRP:trans(mytext), "Y_18_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP:ctr(1), Color(0, 0, 0, 255))
end

function paintPanel(self, pw, ph, color)
	local _c = color
	if _c == nil then
		_c = Color(0, 0, 0, 255)
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _c)
	local _brC = Color(255, 255, 255, 255)
	paintBr(pw, ph, _brC)
end

local color_pi = Color(0, 0, 0, 190)
function paintInv(self, pw, ph, text1, text2)
	draw.RoundedBox(0, 0, 0, pw, ph, color_pi)
	local _brC = Color(255, 255, 255, 255)
	paintBr(pw, ph, _brC)
	draw.SimpleTextOutlined(YRP:trans(text1), "DermaDefault", YRP:ctr(15), ph - YRP:ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, YRP:ctr(1), Color(0, 0, 0, 255))
	if text2 ~= nil then
		draw.SimpleTextOutlined(YRP:trans(text2), "DermaDefault", YRP:ctr(15), YRP:ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, YRP:ctr(1), Color(0, 0, 0, 255))
	end
end

function YRPCreateD(cla, parent, w, h, x, y)
	local _parent = parent or nil
	local _w = w or 100
	local _h = h or 100
	local _x = x or 0
	local _y = y or 0
	local tmpD = vgui.Create(cla, parent)
	if IsValid(tmpD) then
		tmpD:SetSize(_w, _h)
		tmpD:SetPos(_x, _y)

		return tmpD
	else
		return NULL
	end
end

local _yrp_derma = {}
_yrp_derma.colors = {}
_yrp_derma.colors.dbackground = Color(0, 0, 0, 254)
_yrp_derma.colors.dprimary = Color(40, 40, 40, 255)
_yrp_derma.colors.dprimaryBG = Color(20, 20, 20, 255)
_yrp_derma.colors.dsecondary = Color(0, 33, 113, 255)
_yrp_derma.colors.dsecondaryH = Color(0, 33 + 50, 113 + 50, 255)
_yrp_derma.colors.header = Color(0, 255, 0, 200)
_yrp_derma.colors.font = Color(255, 255, 255, 255)
function get_dbg_col()
	return _yrp_derma.colors.dbackground
end

function get_dp_col()
	return _yrp_derma.colors.dprimary
end

function get_dpbg_col()
	return _yrp_derma.colors.dprimaryBG
end

function get_ds_col()
	return _yrp_derma.colors.dsecondary or Color(0, 0, 0, 255)
end

function get_dsbg_col()
	return _yrp_derma.colors.dsecondaryH
end

function get_header_col()
	return _yrp_derma.colors.header
end

function get_font_col()
	return _yrp_derma.colors.font
end

function getMDMode()
	return "dark"
end

function colorH(colTab)
	local tmp = colTab
	local col = {}
	local def = 40
	for k, v in pairs(tmp) do
		if tostring(k) == "a" then
			col[k] = v
		else
			col[k] = v + def
			if col[k] > 255 then
				col[k] = 255
			end
		end
	end

	return Color(col.r, col.g, col.b, col.a)
end

function colorBG(colTab)
	local tmp = colTab
	local col = {}
	local def = 40
	for k, v in pairs(tmp) do
		if tostring(k) == "a" then
			col[k] = v
		else
			col[k] = v - def
			if col[k] < 0 then
				col[k] = 0
			end
		end
	end

	return Color(col.r, col.g, col.b, col.a)
end

function colorToMode(colTab)
	local tmp = colTab
	local col = {}
	local def = 40
	for k, v in pairs(tmp) do
		if tostring(k) == "a" then
			col[k] = v
		elseif getMDMode() == "light" then
			col[k] = v + def
			if col[k] > 255 then
				col[k] = 255
			end
		elseif getMDMode() == "dark" then
			col[k] = v - def
			if col[k] < 0 then
				col[k] = 0
			end
		end
	end

	return Color(col.r, col.g, col.b, col.a)
end

function addMDColor(name, _color)
	_yrp_derma.colors[name] = _color
end

local color_mdp = Color(80, 80, 80, 255)
function getMDPCol()
	return color_mdp
end

local color_mds = Color(40, 40, 40, 255)
function getMDSCol()
	return color_mds
end

function getMDPColor()
	local tmp = getMDPCol()

	return colorToMode(tmp)
end

function getMDSColor()
	local tmp = getMDSCol()

	return colorToMode(tmp)
end

function get_color(str)
	return _yrp_derma.colors[str]
end

function addColor(str, r, g, b, a)
	_yrp_derma.colors[str] = {}
	_yrp_derma.colors[str].r = r
	_yrp_derma.colors[str].g = g
	_yrp_derma.colors[str].b = b
	_yrp_derma.colors[str].a = a
end

addColor("epicBlue", 23, 113, 240, 100)
addColor("darkBG", 0, 0, 0, 200)
addColor("epicOrange", 255, 140, 0, 200)
function GetFontSizes()
	local _fs = {}
	_fs[1] = 6
	_fs[2] = 8
	_fs[3] = 9
	_fs[4] = 10
	_fs[5] = 11
	_fs[6] = 12
	_fs[7] = 14
	_fs[8] = 18
	_fs[9] = 24
	_fs[10] = 30
	_fs[11] = 36
	_fs[12] = 48
	_fs[13] = 60
	_fs[14] = 72
	_fs[15] = 96

	return _fs
end

function drawRBox(r, x, y, w, h, col)
	draw.RoundedBox(YRP:ctr(r), YRP:ctr(x), YRP:ctr(y), YRP:ctr(w), YRP:ctr(h), col)
end

function drawRBoxBr2(r, x, y, w, h, col, br)
	draw.RoundedBox(r, x - br, y - br, w + 2 * br - 1, 2 * br, col)
	draw.RoundedBox(r, x - br, y + h - br, w + 2 * br - 1, 2 * br, col)
	draw.RoundedBox(r, x - br, y, 2 * br, h, col)
	draw.RoundedBox(r, x + w - br, y, 2 * br, h, col)
end

function drawRBoxBr(r, x, y, w, h, col, br)
	draw.RoundedBox(YRP:ctr(r), YRP:ctr(x - br), YRP:ctr(y - br), YRP:ctr(w + 2 * br - 1), YRP:ctr(2 * br), col)
	draw.RoundedBox(YRP:ctr(r), YRP:ctr(x - br), YRP:ctr(y + h - br), YRP:ctr(w + 2 * br - 1), YRP:ctr(2 * br), col)
	draw.RoundedBox(YRP:ctr(r), YRP:ctr(x - br), YRP:ctr(y), YRP:ctr(2 * br), YRP:ctr(h), col)
	draw.RoundedBox(YRP:ctr(r), YRP:ctr(x + w - br), YRP:ctr(y), YRP:ctr(2 * br), YRP:ctr(h), col)
end

function drawRBoxCr(x, y, size, col)
	draw.RoundedBox(YRP:ctr(size / 2), YRP:ctr(x), YRP:ctr(y), YRP:ctr(size), YRP:ctr(size), col)
end

function surfaceText(mytext, font, x, y, color, ax, ay, br)
	br = br or true
	local col_br = Color(0, 0, 0, color.a)
	if color == Color(0, 0, 0, 255) then
		col_br = Color(255, 255, 255, color.a)
	end

	if not br then
		draw.SimpleText(mytext, font, x, y, color, ax, ay, 0, Color(255, 255, 255, 0))
	else
		draw.SimpleText(mytext, font, x, y, color, ax, ay, 1, col_br)
	end
end

function createVGUI(art, parent, w, h, x, y)
	local tmp = vgui.Create(art, parent, nil)
	if w ~= nil and h ~= nil then
		tmp:SetSize(YRP:ctr(w), YRP:ctr(h))
	end

	if x ~= nil and y ~= nil then
		tmp:SetPos(YRP:ctr(x), YRP:ctr(y))
	end

	return tmp
end

function paintMDBackground(self, pw, ph)
	if self:IsHovered() then
		draw.RoundedBox(0, 0, 0, pw, ph, get_dsbg_col())
	else
		draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col())
	end
end

function createMDMenu(parent, w, h, x, y)
	local tmp = YRPCreateD("YFrame", parent, w, h, x, y)
	tmp:SetBorder(0)
	tmp:SetDraggable(true)
	tmp:SetMinWidth(100)
	tmp:SetMinHeight(100)
	tmp:Sizable(true)
	tmp:SetTitle("")
	tmp.sites = {}
	tmp.cats = {}
	tmp.cat = {}
	local BarW = YRP:ctr(140)
	local IconSize = YRP:ctr(94)
	local BR = (BarW - IconSize) / 2
	-- LOGO
	local logoS = tmp:GetHeaderHeight() - YRP:ctr(20)
	tmp.logo = YRPCreateD("YPanel", tmp, YRP:ctr(200), logoS, tmp:GetWide() / 2 - YRP:ctr(200), YRP:ctr(10))
	tmp.logo.yrp = Material("vgui/yrp/logo100_beta.png")
	function tmp.logo:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(self.yrp)
		surface.DrawTexturedRect(0, 0, 400 * logoS / 130, 130 * logoS / 130)
		self.w = self.w or 0
		if self.w ~= 400 * logoS / 130 or self.h ~= logoS or self.x ~= tmp:GetWide() / 2 - self.w or self.y ~= YRP:ctr(10) then
			self.w = 400 * logoS / 130
			self.h = logoS
			self.x = tmp:GetWide() / 2 - self.w
			self.y = YRP:ctr(10)
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	-- DISCORD
	local icon_size = tmp:GetHeaderHeight() - YRP:ctr(20)
	local icon_x, icon_y = tmp.logo:GetPos()
	icon_x = icon_x + tmp.logo:GetWide() + YRP:ctr(20)
	tmp.discord = YRPCreateD("YPanel", tmp, icon_size, icon_size, icon_x, icon_y)
	tmp.discord.logo = YRPCreateD("DHTML", tmp.discord, icon_size, icon_size, 0, 0)
	tmp.discord.btn = YRPCreateD("DButton", tmp.discord, icon_size, icon_size, 0, 0)
	tmp.discord.btn:SetText("")
	local img = YRPGetHTMLImage("https://discordapp.com/assets/f8389ca1a741a115313bede9ac02e2c0.svg", icon_size, icon_size)
	tmp.discord.logo:SetHTML(img)
	function tmp.discord:Paint(pw, ph)
		icon_size = tmp:GetHeaderHeight() - YRP:ctr(20)
		icon_x, icon_y = tmp.logo:GetPos()
		icon_x = icon_x + tmp.logo:GetWide() + YRP:ctr(20)
		if self.w ~= icon_size or self.h ~= icon_size or self.x ~= icon_x or self.y ~= icon_y then
			self.w = icon_size
			self.h = icon_size
			self.x = icon_x
			self.y = icon_y
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
			self.logo:SetSize(self.w, self.h)
			self.btn:SetSize(self.w, self.h)
		end
	end

	function tmp.discord.btn:Paint(pw, ph)
	end

	function tmp.discord.btn:DoClick()
		gui.OpenURL("https://discord.gg/CXXDCMJ")
	end

	function tmp:AddCategory(cat)
		local tmpNr = #tmp.cat + 1
		self.cat[tmpNr] = cat
		self.cats[cat] = {}
	end

	function tmp:AddSite(hoo, site, cat, icon)
		local material = Material(icon)
		local tmpNrMax = #tmp.cats[cat]
		local tmpNr = tmpNrMax + 1
		self.cats[cat][tmpNr] = {}
		self.cats[cat][tmpNr].hook = hoo
		self.cats[cat][tmpNr].site = site
		self.cats[cat][tmpNr].material = material
	end

	tmp.sitepanel = YRPCreateD("DPanel", tmp, w, h - YRP:ctr(100), 0, YRP:ctr(100))
	function tmp.sitepanel:Paint(pw, ph)
	end

	--
	function tmp:SwitchToSite(_hook)
		self.site:Clear()
		self.lastsite = _hook
		tmp.cursite = tmp.sites[_hook].site
		tmp:SetTitle(string.upper(YRP:trans(tmp.sites[_hook].site)))
		hook.Call(_hook)
	end

	tmp.menu = YRPCreateD("DPanel", tmp, BarW, tmp:GetTall() - tmp:GetHeaderHeight() - YRP:ctr(50), 0, tmp:GetHeaderHeight())
	tmp.menulist = YRPCreateD("DPanelList", tmp.menu, IconSize, tmp:GetTall() - tmp:GetHeaderHeight() - YRP:ctr(50) - 2 * BR, BR, BR)
	tmp.menulist:EnableVerticalScrollbar(true)
	function tmp.menu:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPGetColor("5"))
		if self.w ~= BarW or self.h ~= tmp:GetTall() - tmp:GetHeaderHeight() - YRP:ctr(50) or self.x ~= 0 or self.y ~= tmp:GetHeaderHeight() then
			self.w = BarW
			self.h = tmp:GetTall() - tmp:GetHeaderHeight() - YRP:ctr(50)
			self.x = 0
			self.y = tmp:GetHeaderHeight()
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
			tmp.menulist:SetSize(IconSize, self.h)
			tmp.menulist:SetPos(BR, BR)
		end
	end

	local posY = 0
	function tmp:CreateMenu()
		for k, v in pairs(tmp.cat) do
			local tmpCat = YRPCreateD("DPanel", tmp.menulist, IconSize, YRP:ctr(0), BR, YRP:ctr(posY))
			function tmpCat:Paint(pw, ph)
				draw.SimpleTextOutlined(string.upper(YRP:trans(v)), "Y_18_500", YRP:ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end

			tmp.menulist:AddItem(tmpCat)
			--posY = posY + 50 + 10
			if tmp.cats[v] ~= nil then
				for _l, _w in pairs(tmp.cats[v]) do
					tmp.sites[_w.hook] = YRPCreateD("DButton", nil, IconSize, IconSize, BR, YRP:ctr(posY))
					local tmp2 = tmp.sites[_w.hook]
					tmp2:SetText("")
					tmp2.hook = string.lower(_w.hook)
					tmp2.site = string.upper(_w.site)
					function tmp2:Paint(pw, ph)
						local color = YRPGetColor("2")
						if tmp.cursite == self.site then
							color = YRPGetColor("3")
						elseif tmp:IsHovered() then
							color = YRPGetColor("1")
						end

						draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
						if _w.material ~= nil then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(_w.material)
							surface.DrawTexturedRect(BR, BR, IconSize - 2 * BR, IconSize - 2 * BR)
						end
						--draw.SimpleTextOutlined(string.upper(YRP:trans(_w.site) ), "Y_18_500", YRP:ctr(80 + 10), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
					end

					function tmp2:DoClick()
						tmp:SwitchToSite(self.hook)
					end

					tmp.menulist:AddItem(tmp2)
					local tmpHr2 = YRPCreateD("DPanel", nil, IconSize, YRP:ctr(20), 0, YRP:ctr(posY))
					function tmpHr2:Paint(pw, ph)
					end

					tmp.menulist:AddItem(tmpHr2)
					--posY = posY + 80 + 10
				end

				local tmpHr = YRPCreateD("DPanel", nil, IconSize, YRP:ctr(0), 0, YRP:ctr(posY))
				function tmpHr:Paint(pw, ph)
				end

				--
				tmp.menulist:AddItem(tmpHr)
			end
		end
	end

	local CONTENT = tmp:GetContent()
	tmp.site = YRPCreateD("YPanel", tmp, CONTENT:GetWide() - BarW, CONTENT:GetTall() - YRP:ctr(50), BarW, tmp:GetHeaderHeight())
	function tmp.site:Paint(pw, ph)
		local color = YRPInterfaceValue("YFrame", "HB")
		draw.RoundedBox(0, 0, 0, pw, ph, color)
		if self.w ~= CONTENT:GetWide() - BarW or self.h ~= CONTENT:GetTall() - YRP:ctr(50) or self.x ~= BarW or self.y ~= tmp:GetHeaderHeight() then
			self.w = CONTENT:GetWide() - BarW
			self.h = CONTENT:GetTall() - YRP:ctr(50)
			self.x = BarW
			self.y = tmp:GetHeaderHeight()
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	-- BOTTOMBAR
	tmp.bot = YRPCreateD("YPanel", tmp, 10, 10, 0, 0)
	local color_bot1 = Color(0, 0, 0, 20)
	function tmp.bot:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, color_bot1)
		draw.SimpleText(GetGlobalYRPString("text_server_name", "-"), "Y_18_500", ph / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("YourRP Version.: " .. YRPGetVersionFull() .. " ( " .. string.upper(GAMEMODE.dedicated) .. " Server)", "Y_18_500", pw / 2, ph / 2, YRPGetVersionColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP:trans("LID_map") .. ": " .. game.GetMap() .. "        " .. YRP:trans("LID_players") .. ": " .. player.GetCount() .. "/" .. game.MaxPlayers(), "Y_18_500", pw - ph / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	function tmp.bot:Think()
		if self.w ~= tmp:GetWide() or self.h ~= YRP:ctr(50) or self.px ~= 0 or self.py ~= tmp:GetTall() - YRP:ctr(50) then
			self.w = tmp:GetWide()
			self.h = YRP:ctr(50)
			self.px = 0
			self.py = tmp:GetTall() - YRP:ctr(50)
			self:SetSize(self.w, self.h)
			self:SetPos(self.px, self.py)
		end
	end

	return tmp
end

function createMDSwitch(parent, w, h, x, y, opt1, opt2, _hook)
	local tmp = YRPCreateD("DButton", parent, w, h, x, y)
	tmp.opt1 = opt1
	tmp.opt2 = opt2
	tmp.value = "dark"
	tmp:SetText("")
	function tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col())
		if tmp.value == opt1 then
			draw.RoundedBox(0, 0, 0, pw / 2, ph, get_dsbg_col())
		elseif tmp.value == opt2 then
			draw.RoundedBox(0, pw / 2, 0, pw / 2, ph, get_dsbg_col())
		end

		draw.SimpleTextOutlined(YRP:trans("LID_dark"), "Y_24_500", 1 * (pw / 4), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_light"), "Y_24_500", 3 * (pw / 4), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	function tmp:DoClick()
		if self.value == self.opt1 then
			self.value = self.opt2
		elseif self.value == self.opt2 then
			self.value = self.opt1
		end

		addMDColor("dprimary", getMDPColor())
		addMDColor("dprimaryBG", colorBG(getMDPColor()))
		addMDColor("dsecondary", getMDSColor())
		addMDColor("dsecondaryH", colorH(getMDSColor()))
	end

	return tmp
end

function addPColorField(parent, col, x, y)
	local tmp = YRPCreateD("DButton", parent, YRP:ctr(50), YRP:ctr(50), x, y)
	tmp.color = col
	tmp:SetText("")
	function tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		if self:IsHovered() then
			draw.SimpleTextOutlined("X", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
	end

	function tmp:DoClick()
		addMDColor("dprimary", getMDPColor())
		addMDColor("dprimaryBG", colorBG(getMDPColor()))
	end

	return tmp
end

function addSColorField(parent, col, x, y)
	local tmp = YRPCreateD("DButton", parent, YRP:ctr(50), YRP:ctr(50), x, y)
	tmp.color = col
	tmp:SetText("")
	function tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		if self:IsHovered() then
			draw.SimpleTextOutlined("X", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
	end

	function tmp:DoClick()
		addMDColor("dsecondary", getMDSColor())
		addMDColor("dsecondaryH", colorH(getMDSColor()))
	end

	return tmp
end

function anchorW(num)
	if num == 0 then
		return 0
	elseif num == 1 then
		return ScrW2()
	elseif num == 2 then
		return ScrW()
	end
end

function anchorH(num)
	if num == 0 then
		return 0
	elseif num == 1 then
		return ScrH2()
	elseif num == 2 then
		return ScrH()
	end
end

function YRPDrawCircle(x, y, radius, seg)
	if x == nil then
		YRP:msg("error", "x: " .. tostring(x))

		return
	end

	if y == nil then
		YRP:msg("error", "y: " .. tostring(y))

		return
	end

	if radius == nil then
		YRP:msg("error", "Radius: " .. tostring(radius))

		return
	end

	if seg == nil then
		YRP:msg("error", "Seg: " .. tostring(seg))

		return
	end

	local cir = {}
	table.insert(
		cir,
		{
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		}
	)

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(
			cir,
			{
				x = x + math.sin(a) * radius,
				y = y + math.cos(a) * radius,
				u = math.sin(a) / 2 + 0.5,
				v = math.cos(a) / 2 + 0.5
			}
		)
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(
		cir,
		{
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		}
	)

	surface.DrawPoly(cir)
end

function YRPDrawCircleL(x, y, radius, seg)
	local cir = {}
	table.insert(
		cir,
		{
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		}
	)

	for i = 0, seg do
		local a = math.rad((i / seg) * -180)
		table.insert(
			cir,
			{
				x = x + math.sin(a) * radius,
				y = y + math.cos(a) * radius,
				u = math.sin(a) / 2 + 0.5,
				v = math.cos(a) / 2 + 0.5
			}
		)
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(
		cir,
		{
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		}
	)

	surface.DrawPoly(cir)
end

function YRPDrawCircleR(x, y, radius, seg)
	local cir = {}
	table.insert(
		cir,
		{
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		}
	)

	for i = 0, seg do
		local a = math.rad(((i / seg) * -180) + 180)
		table.insert(
			cir,
			{
				x = x + math.sin(a) * radius,
				y = y + math.cos(a) * radius,
				u = math.sin(a) / 2 + 0.5,
				v = math.cos(a) / 2 + 0.5
			}
		)
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(
		cir,
		{
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		}
	)

	surface.DrawPoly(cir)
end

function drawRoundedBox(r, x, y, w, h, color)
	draw.RoundedBox(0, x + h / 2, y, w - h, h, color)
	surface.SetDrawColor(color)
	draw.NoTexture()
	YRPDrawCircleL(x + h / 2, y + h / 2, h / 2, 64)
	if w >= h then
		YRPDrawCircleR(x + w - h / 2, y + h / 2, h / 2, 64)
	end
end

function drawRoundedBoxStencil(r, x, y, w, h, color, max)
	--drawRoundedBox(0, x, y, max, h, Color( 255, 0, 255, 100) )
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(99)
	render.SetStencilTestMask(99)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation(STENCILOPERATION_INCR)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	drawRoundedBox(0, x, y, max, h, Color(255, 0, 0, 255))
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	draw.RoundedBox(0, x, y, w, h, color)
	render.SetStencilEnable(false)
end

function drawRBBR(r, x, y, w, h, color, br)
	local _br = br or 0
	draw.RoundedBox(0, x, y, w, br, color)
	draw.RoundedBox(0, x, y + h - br, w, br, color)
	draw.RoundedBox(0, x, y, br, h, color)
	draw.RoundedBox(0, x + w - br, y, br, h, color)
end

local color_drbbr = Color(255, 0, 255, 200)
function drawRoundedBoxBR(r, x, y, w, h, color, br)
	local _br = br or 0
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation(STENCILOPERATION_INCR)
	render.SetStencilPassOperation(STENCILOPERATION_INCR)
	render.SetStencilZFailOperation(STENCILOPERATION_INCR)
	render.SetStencilTestMask(1)
	drawRoundedBox(r, x + _br, y + _br, w - _br * 2, h - _br * 2, color_drbbr)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
	render.SetStencilWriteMask(1)
	drawRoundedBox(r, x - _br, y - _br, w + _br * 2, h + _br * 2, color)
	render.SetStencilEnable(false)
end

function YRPTestHTML(pnl, url, rem)
	if SERVER then return end
	if rem == nil then
		rem = true
	end

	if strEmpty(url) then
		if rem then
			pnl:Remove()
		else
			pnl:SetVisible(false)
		end
	else
		http.Fetch(
			url,
			function(body, len, headers, code)
				if code ~= 200 then
					if rem and YRPPanelAlive(pnl, "pnl:Remove") and pnl.Remove then
						pnl:Remove()
					elseif YRPPanelAlive(pnl, "pnl:SetV 1") and pnl.SetVisible then
						pnl:SetVisible(false)
					end
				elseif YRPPanelAlive(pnl, "pnl:SetV 2") and pnl.SetVisible then
					pnl:SetVisible(true)
				end
			end,
			function(error)
				if pnl and YRPPanelAlive(pnl, "error derma") then
					if rem and pnl.Remove then
						pnl:Remove()
					elseif pnl.SetVisible then
						pnl:SetVisible(false)
					end
				end
			end
		)
	end
end

hook.Add(
	"Think",
	"yrp_motion",
	function()
		local lply = LocalPlayer()
		lply.oldang = lply.oldang or Angle(0, 0, 0)
		lply.newang = lply:EyeAngles()
		lply.swayx = lply.swayx or 0
		lply.swayy = lply.swayy or 0
		local valx1 = Lerp(FrameTime() * 8, lply.swayx, lply.newang.y - lply.oldang.y)
		local valy1 = Lerp(FrameTime() * 8, lply.swayy, lply.newang.p - lply.oldang.p)
		if valx1 < 4 and valx1 > -4 then
			lply.swayx = valx1
		end

		if valy1 < 4 and valy1 > -4 then
			lply.swayy = valy1
		end

		lply.oldang = lply.newang
	end
)

function HUDMOTIONX(px)
	if GetGlobalYRPBool("bool_yrp_hud_swaying", false) then
		local lply = LocalPlayer()

		return px + lply.swayx * 20
	else
		return px
	end
end

function HUDMOTIONY(py)
	if GetGlobalYRPBool("bool_yrp_hud_swaying", false) then
		local lply = LocalPlayer()

		return py + -lply.swayy * 20
	else
		return py
	end
end

-- Panel SHADOWS
PANEL_SHADOW_intensity = 1
PANEL_SHADOW_Spread = 2
PANEL_SHADOW_Blur = 2
PANEL_SHADOW_Opacity = 255
PANEL_SHADOW_Direction = 0
PANEL_SHADOW_Distance = 0
-- FROM: https://gist.github.com/MysteryPancake/a31637af9fd531079236a2577145a754
--Global table
if BSHADOWS == nil then
	BSHADOWS = {}
	--The original drawing layer
	BSHADOWS.RenderTarget = GetRenderTarget("bshadows_original", ScrW(), ScrH())
	--The shadow layer
	BSHADOWS.RenderTarget2 = GetRenderTarget("bshadows_shadow", ScrW(), ScrH())
	--The matarial to draw the render targets on
	BSHADOWS.ShadowMaterial = CreateMaterial(
		"bshadows",
		"UnlitGeneric",
		{
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["alpha"] = 1
		}
	)

	--When we copy the rendertarget it retains color, using this allows up to force any drawing to be black
	--Then we can blur it to create the shadow effect
	BSHADOWS.ShadowMaterialGrayscale = CreateMaterial(
		"bshadows_grayscale",
		"UnlitGeneric",
		{
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$alpha"] = 1,
			["$color"] = "0 0 0",
			["$color2"] = "0 0 0"
		}
	)

	--Call this to begin drawing a shadow
	BSHADOWS.BeginShadow = function()
		--Set the render target so all draw calls draw onto the render target instead of the screen
		render.PushRenderTarget(BSHADOWS.RenderTarget)
		--Clear is so that theres no color or alpha
		render.OverrideAlphaWriteEnable(true, true)
		render.Clear(0, 0, 0, 0)
		render.OverrideAlphaWriteEnable(false, false)
		--Start Cam2D as where drawing on a flat surface 
		cam.Start2D()
	end

	--Now leave the rest to the user to draw onto the surface
	--This will draw the shadow, and mirror any other draw calls the happened during drawing the shadow
	BSHADOWS.EndShadow = function(intensity, spread, blur, opacity, direction, distance, _shadowOnly)
		--Set default opcaity
		opacity = opacity or 255
		direction = direction or 0
		distance = distance or 0
		_shadowOnly = _shadowOnly or false
		--Copy this render target to the other
		render.CopyRenderTargetToTexture(BSHADOWS.RenderTarget2)
		--Blur the second render target
		if blur > 0 then
			render.OverrideAlphaWriteEnable(true, true)
			render.BlurRenderTarget(BSHADOWS.RenderTarget2, spread, spread, blur)
			render.OverrideAlphaWriteEnable(false, false)
		end

		--First remove the render target that the user drew
		render.PopRenderTarget()
		--Now update the material to what was drawn
		BSHADOWS.ShadowMaterial:SetTexture("$basetexture", BSHADOWS.RenderTarget)
		--Now update the material to the shadow render target
		BSHADOWS.ShadowMaterialGrayscale:SetTexture("$basetexture", BSHADOWS.RenderTarget2)
		--Work out shadow offsets
		local xOffset = math.sin(math.rad(direction)) * distance
		local yOffset = math.cos(math.rad(direction)) * distance
		--Now draw the shadow
		BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255) --set the alpha of the shadow
		render.SetMaterial(BSHADOWS.ShadowMaterialGrayscale)
		if intensity then
			for i = 1, math.ceil(intensity) do
				render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
			end
		end

		if not _shadowOnly then
			--Now draw the original
			BSHADOWS.ShadowMaterial:SetTexture("$basetexture", BSHADOWS.RenderTarget)
			render.SetMaterial(BSHADOWS.ShadowMaterial)
			render.DrawScreenQuad()
		end

		cam.End2D()
	end

	--This will draw a shadow based on the texture you passed it.
	BSHADOWS.DrawShadowTexture = function(texture, intensity, spread, blur, opacity, direction, distance, shadowOnly)
		--Set default opcaity
		opacity = opacity or 255
		direction = direction or 0
		distance = distance or 0
		shadowOnly = shadowOnly or false
		--Copy the texture we wish to create a shadow for to the shadow render target
		render.CopyTexture(texture, BSHADOWS.RenderTarget2)
		--Blur the second render target
		if blur > 0 then
			render.PushRenderTarget(BSHADOWS.RenderTarget2)
			render.OverrideAlphaWriteEnable(true, true)
			render.BlurRenderTarget(BSHADOWS.RenderTarget2, spread, spread, blur)
			render.OverrideAlphaWriteEnable(false, false)
			render.PopRenderTarget()
		end

		--Now update the material to the shadow render target
		BSHADOWS.ShadowMaterialGrayscale:SetTexture("$basetexture", BSHADOWS.RenderTarget2)
		--Work out shadow offsets
		local xOffset = math.sin(math.rad(direction)) * distance
		local yOffset = math.cos(math.rad(direction)) * distance
		--Now draw the shadow 
		BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255) --Set the alpha
		render.SetMaterial(BSHADOWS.ShadowMaterialGrayscale)
		for i = 1, math.ceil(intensity) do
			render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
		end

		if not shadowOnly then
			--Now draw the original
			BSHADOWS.ShadowMaterial:SetTexture("$basetexture", texture)
			render.SetMaterial(BSHADOWS.ShadowMaterial)
			render.DrawScreenQuad()
		end
	end
end
