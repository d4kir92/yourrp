--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local HUD = {}
function RegisterHUDElement(design, element, func)
	HUD[design] = HUD[design] or {}
	HUD[design][element] = func
end

function DrawHUDElement(design, element)
	HUD[design][element]()
end

function ScrV(dec)
	return ScrH() * dec
end

function HudBox(tab)
	tab = tab or {}
	tab.r = tab.r or 0
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.color = tab.color or Color(255, 0, 0)
	draw.RoundedBox(tab.r, tab.x, tab.y, tab.w, tab.h, tab.color)
end

function HudBoxBr(tab)
	tab.br = tab.br or 1

	local up = table.Copy(tab)
	up.h = tab.br
	HudBox(up)

	local dn = table.Copy(tab)
	dn.h = tab.br
	dn.y = tab.y + tab.h - tab.br
	HudBox(dn)

	local le = table.Copy(tab)
	le.w = tab.br
	HudBox(le)

	local ri = table.Copy(tab)
	ri.w = tab.br
	ri.x = tab.x + tab.w - tab.br
	HudBox(ri)
end

function HudBoxBrRounded(tab)
	tab.br = tab.br or 1
	-- LU
	local center = Vector(tab.x + tab.r, tab.y + tab.r, 0)
	local scale = Vector(tab.r, tab.r, 0)
	local segmentdist = 360 / ( 2 * math.pi * math.max( scale.x, scale.y ) / 2 )
	surface.SetDrawColor(tab.color)
	for a = 90, 90 + 90, segmentdist do
		surface.DrawLine( center.x + math.cos( math.rad( a ) ) * scale.x, center.y - math.sin( math.rad( a ) ) * scale.y, center.x + math.cos( math.rad( a + segmentdist ) ) * scale.x, center.y - math.sin( math.rad( a + segmentdist ) ) * scale.y )
	end

	draw.RoundedBox(0, tab.x, tab.y + tab.r, tab.br, tab.h - 2 * tab.r, tab.color)

	-- LD
	local center = Vector(tab.x + tab.r, tab.y + tab.h - tab.r, 0)
	local scale = Vector(tab.r, tab.r, 0)
	local segmentdist = 360 / ( 2 * math.pi * math.max( scale.x, scale.y ) / 2 )
	surface.SetDrawColor(tab.color)
	for a = 180, 180 + 90, segmentdist do
		surface.DrawLine( center.x + math.cos( math.rad( a ) ) * scale.x, center.y - math.sin( math.rad( a ) ) * scale.y, center.x + math.cos( math.rad( a + segmentdist ) ) * scale.x, center.y - math.sin( math.rad( a + segmentdist ) ) * scale.y )
	end

	-- MID
	draw.RoundedBox(0, tab.x + tab.r, tab.y, tab.w - 2 * tab.r, tab.br, tab.color)
	draw.RoundedBox(0, tab.x + tab.r, tab.y + tab.h - tab.br, tab.w - 2 * tab.r, tab.br, tab.color)

	-- RU
	center = Vector(tab.x + tab.w - tab.r, tab.y + tab.r, 0)
	scale = Vector(tab.r, tab.r, 0)
	segmentdist = 360 / ( 2 * math.pi * math.max( scale.x, scale.y ) / 2 )
	surface.SetDrawColor(tab.color)
	for a = 360, 360 + 90, segmentdist do
		surface.DrawLine( center.x + math.cos( math.rad( a ) ) * scale.x, center.y - math.sin( math.rad( a ) ) * scale.y, center.x + math.cos( math.rad( a + segmentdist ) ) * scale.x, center.y - math.sin( math.rad( a + segmentdist ) ) * scale.y )
	end

	draw.RoundedBox(0, tab.x + tab.w - tab.br, tab.y + tab.r, tab.br, tab.h - 2 * tab.r, tab.color)

	-- RD
	center = Vector(tab.x + tab.w - tab.r, tab.y + tab.h - tab.r, 0)
	scale = Vector(tab.r, tab.r, 0)
	segmentdist = 360 / ( 2 * math.pi * math.max( scale.x, scale.y ) / 2 )
	surface.SetDrawColor(tab.color)
	for a = 270, 270 + 90, segmentdist do
		surface.DrawLine( center.x + math.cos( math.rad( a ) ) * scale.x, center.y - math.sin( math.rad( a ) ) * scale.y, center.x + math.cos( math.rad( a + segmentdist ) ) * scale.x, center.y - math.sin( math.rad( a + segmentdist ) ) * scale.y )
	end
end

function OldHudBoxBr(tab)
	HudBox(tab[1])
	HudBox(tab[2])
	HudBox(tab[3])
	HudBox(tab[4])
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

function HudText(tab)
	draw.SimpleText(tab.text, tab.font, tab.x, tab.y, tab.color, tab.ax, tab.ay)
end

function HudTextBr(tab)
	draw.SimpleTextOutlined(tab.text, tab.font, tab.x, tab.y, tab.color, tab.ax, tab.ay, 1, tab.brcolor)
end

function stc(str)
	if str != nil then
		str = string.Explode(",", str)
		if table.Count(str) >= 3 then
			return Color(str[1] or 0, str[2] or 0, str[3] or 0, str[4] or 255)
		end
	end
	return Color(255, 255, 255)
end

function DrawBox(tab)
	tab.r = tab.r or 0
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.color = tab.color or Color(200, 200, 200)
	draw.RoundedBox(tab.r, tab.x, tab.y, tab.w, tab.h, tab.color)
end

function DrawButton(button, tab)
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
		tab.color = tab.hovercolor or Color(255, 255, 255)
	end
	DrawBox(tab)
	tab.text = tab.text or {}
	tab.text.text = tab.text.text or "NOTEXT"
	tab.text.x = tab.text.x or tab.w / 2
	tab.text.y = tab.text.y or tab.h / 2
	tab.text.color = tab.text.color or Color(255, 255, 255, 255)
	DrawText(tab.text)
end

function GetTextLength(text, font)
	surface.SetFont(font)
	local l = select(1, surface.GetTextSize(text))

	return l
end

local yrp_if = {}

function GetHTMLImage(url, w, h)
	return "<style type=\"text/css\"> body { padding: 0; margin: 0; border:0; } img { padding: 0; margin: 0; border:0; } </style> <body> <img src=\"" .. url .. "\"width=\"" .. w .. "\" height=\"" .. h .. "\" /> </body>"
end

function TableToColorStr(tbl)
	return tbl.r .. "," .. tbl.g .. "," .. tbl.b .. "," .. tbl.a
end

function StringToColor(str)
	local _col = string.Explode(",", str)

	return Color(_col[1], _col[2], _col[3], _col[4] or 255)
end

function RegisterDesign(tab)
	if tab.name ~= nil then
		yrp_if[tab.name] = {}
		yrp_if[tab.name].author = tab.author or "NO AUTHOR"
		yrp_if[tab.name].name = tab.name or "NO Name"
		yrp_if[tab.name].textFont = tab.textFont or "mat1text"
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

function GetDesigns()
	return yrp_if
end

function GetFont()
	return yrp_if[interfaceDesign()].textFont
end

function interfaceDesign()
	local ply = LocalPlayer()
	local design = ply:GetNWString("interface_design", "Material Design 1")

	if yrp_if[design] ~= nil then
		return design
	else
		return "Material Design 1"
	end
end

function InterfaceBorder()
	local ply = LocalPlayer()

	return ply:GetNWBool("interface_border", true)
end

function InterfaceRounded()
	local ply = LocalPlayer()

	return ply:GetNWBool("interface_rounded", true)
end

function InterfaceTransparent()
	local ply = LocalPlayer()

	return ply:GetNWBool("interface_transparent", true)
end

function InterfaceColor()
	local ply = LocalPlayer()

	return ply:GetNWString("interface_color", "blue")
end

function InterfaceStyle()
	local ply = LocalPlayer()

	return ply:GetNWString("interface_style", "dark")
end

local yrp_colors = {}

function YRPGetColor(nr)
	if wk(yrp_colors[interfaceDesign()]) and wk(yrp_colors[interfaceDesign()][InterfaceColor()]) and wk(yrp_colors[interfaceDesign()][InterfaceColor()][nr]) then
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

function YRP.AddDesignIcon(name, path)
	_icons[name] = Material(path)
end

function YRP.GetDesignIcon(name)
	if _icons[name] ~= nil then
		return _icons[name]
	else
		return _icons["clear"]
	end
end

function YRP.DrawIcon(material, w, h, x, y, color)
	local col = color or YRPGetColor("6")
	surface.SetDrawColor(col)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x or 0, y or 0, w or 64, h or 64)
end

YRP.AddDesignIcon("auto", "vgui/flags/lang_" .. "auto" .. ".png")
YRP.AddDesignIcon("group", "vgui/material/icon_group.png")
YRP.AddDesignIcon("role", "vgui/material/icon_person.png")
YRP.AddDesignIcon("help", "vgui/material/icon_help.png")
YRP.AddDesignIcon("keyboard", "vgui/material/icon_keyboard.png")
YRP.AddDesignIcon("mouse", "vgui/material/icon_mouse.png")
YRP.AddDesignIcon("security", "vgui/material/icon_security.png")
YRP.AddDesignIcon("usergroup", "vgui/material/icon_usergroup.png")
YRP.AddDesignIcon("character", "vgui/material/icon_character.png")
YRP.AddDesignIcon("shop", "vgui/material/icon_shop.png")
YRP.AddDesignIcon("settings", "vgui/material/icon_settings.png")
YRP.AddDesignIcon("feedback", "vgui/material/icon_feedback.png")
YRP.AddDesignIcon("map", "vgui/material/icon_map.png")
YRP.AddDesignIcon("color_lens", "vgui/material/icon_color_lens.png")
YRP.AddDesignIcon("pin_drop", "vgui/material/icon_pin_drop.png")
YRP.AddDesignIcon("face", "vgui/material/icon_face.png")
YRP.AddDesignIcon("smile", "vgui/material/icon_insert_emoticon.png")
YRP.AddDesignIcon("keyboard_arrow_down", "vgui/material/icon_keyboard_arrow_down.png")
YRP.AddDesignIcon("keyboard_arrow_up", "vgui/material/icon_keyboard_arrow_up.png")
YRP.AddDesignIcon("keyboard_arrow_right", "vgui/material/icon_keyboard_arrow_right.png")
YRP.AddDesignIcon("keyboard_arrow_left", "vgui/material/icon_keyboard_arrow_left.png")
YRP.AddDesignIcon("unfold_less", "vgui/material/icon_unfold_less.png")
YRP.AddDesignIcon("unfold_more", "vgui/material/icon_unfold_more.png")
YRP.AddDesignIcon("record_voice_over", "vgui/material/icon_record_voice_over.png")
YRP.AddDesignIcon("3d_rotation", "vgui/material/icon_3d_rotation.png")
YRP.AddDesignIcon("rotate_left", "vgui/material/icon_rotate_left.png")
YRP.AddDesignIcon("rotate_right", "vgui/material/icon_rotate_right.png")
YRP.AddDesignIcon("smartphone", "vgui/material/icon_smartphone.png")
YRP.AddDesignIcon("system_update", "vgui/material/icon_system_update.png")
YRP.AddDesignIcon("os_windows", "vgui/material/icon_os_windows.png")
YRP.AddDesignIcon("os_linux", "vgui/material/icon_os_linux.png")
YRP.AddDesignIcon("os_osx", "vgui/material/icon_os_osx.png")
YRP.AddDesignIcon("work", "vgui/material/icon_work.png")
YRP.AddDesignIcon("done", "vgui/material/icon_done_outline.png")
YRP.AddDesignIcon("navigation", "vgui/material/icon_navigation.png")
YRP.AddDesignIcon("chat", "vgui/material/icon_chat.png")
YRP.AddDesignIcon("voice", "vgui/material/icon_voice.png")
YRP.AddDesignIcon("close", "vgui/material/icon_highlight_off.png")
YRP.AddDesignIcon("clear", "vgui/material/icon_clear.png")
YRP.AddDesignIcon("launch", "vgui/material/icon_launch.png")
YRP.AddDesignIcon("lock", "vgui/material/icon_lock.png")
YRP.AddDesignIcon("steam", "vgui/material/icon_steam.png")
YRP.AddDesignIcon("play", "vgui/material/icon_play.png")
YRP.AddDesignIcon("play_circle", "vgui/material/icon_play_circle.png")
YRP.AddDesignIcon("pause", "vgui/material/icon_pause.png")
YRP.AddDesignIcon("pause_circle", "vgui/material/icon_pause_circle.png")
YRP.AddDesignIcon("language", "vgui/material/icon_language.png")

YRP.AddDesignIcon("discord", "vgui/material/icon_discord.png")
YRP.AddDesignIcon("discord_black", "vgui/material/icon_discord_black.png")
YRP.AddDesignIcon("discord_white", "vgui/material/icon_discord_white.png")

YRP.AddDesignIcon("ts", "vgui/material/icon_ts_bluelight.png")
YRP.AddDesignIcon("ts_light", "vgui/material/icon_ts_light.png")

local _delay = 1
local _get_design = true

function GetDesign()
	if _get_design then
		_get_design = not _get_design
		net.Start("get_design")
		net.SendToServer()
	end
end

function surfaceWindow(derma, pw, ph, title)
	local _title = title or ""

	if yrp_if[interfaceDesign()] ~= nil then
		yrp_if[interfaceDesign()]["DFrame"](derma, pw, ph, _title)
	else
		GetDesign()
	end
end

function surfaceButton(derma, pw, ph, text, color, px, py, ax, ay, forcelang)
	local _text = text or ""

	if yrp_if[interfaceDesign()] ~= nil then
		yrp_if[interfaceDesign()]["DButton"](derma, pw, ph, text, color, px, py, ax, ay, forcelang)
	else
		GetDesign()
	end
end

function surfacePanel(derma, pw, ph, text, color, px, py, ax, ay)
	local _text = text or ""

	if yrp_if[interfaceDesign()] ~= nil then
		yrp_if[interfaceDesign()]["DPanel"](derma, pw, ph, _text, color, px, py, ax, ay)
	else
		GetDesign()
	end
end

function surfaceCheckBox(derma, pw, ph, icon)
	if yrp_if[interfaceDesign()] ~= nil then
		if yrp_if[interfaceDesign()]["Selected"] ~= nil then
			yrp_if[interfaceDesign()]["DCheckBox"](derma, pw, ph, icon)
		else
			local th = 4
			local br = 8
			local color = Color(0, 0, 0, 255)
			surfaceBox(ctr(br), ctr(br), pw - ctr(br * 2), ctr(th), color)
			surfaceBox(ctr(br), ctr(br), ctr(th), ph - ctr(br * 2), color)
			surfaceBox(ctr(br), ph - ctr(br + th), pw - ctr(br * 2), ctr(th), color)
			surfaceBox(pw - ctr(br + th), ctr(br), ctr(th), ph - ctr(br * 2), color)

			if derma:GetChecked() then
				br = 4
				surface.SetDrawColor(0, 255, 0, 255)
				surface.SetMaterial(YRP.GetDesignIcon(icon))
				surface.DrawTexturedRect(ctr(br), ctr(br), pw - ctr(br * 2), ph - ctr(8))
			end
		end
	else
		GetDesign()
	end
end

function surfaceSelected(derma, pw, ph, px, py)
	px = px or 0
	py = py or 0
	local _text = text or ""

	if yrp_if[interfaceDesign()] ~= nil then
		if yrp_if[interfaceDesign()]["Selected"] ~= nil then
			yrp_if[interfaceDesign()]["Selected"](derma, pw, ph, px, py)
		else
			local _br = 4
			local _w = 32
			local _h = 12
			--Outter
			surfaceBox(px + ctr(_br), ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
			surfaceBox(px + ctr(_br), ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))
			surfaceBox(px + ctr(_br), ph - ctr(_h) - ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
			surfaceBox(px + ctr(_br), ph - ctr(_w) - ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))
			surfaceBox(px + pw - ctr(_w) - ctr(_br), ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
			surfaceBox(px + pw - ctr(_h) - ctr(_br), ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))
			surfaceBox(px + pw - ctr(_w) - ctr(_br), ph - ctr(_h) - ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
			surfaceBox(px + pw - ctr(_h) - ctr(_br), ph - ctr(_w) - ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))
			_br = 8
			_w = 32 - 2 * 4
			_h = 12 - 2 * 4
			--Inner
			surfaceBox(px + ctr(_br), ctr(_br), ctr(_w), ctr(_h), Color(255, 255, 255, 255))
			surfaceBox(px + ctr(_br), ctr(_br), ctr(_h), ctr(_w), Color(255, 255, 255, 255))
			surfaceBox(px + ctr(_br), ph - ctr(_h) - ctr(_br), ctr(_w), ctr(_h), Color(255, 255, 255, 255))
			surfaceBox(px + ctr(_br), ph - ctr(_w) - ctr(_br), ctr(_h), ctr(_w), Color(255, 255, 255, 255))
			surfaceBox(px + pw - ctr(_w) - ctr(_br), ctr(_br), ctr(_w), ctr(_h), Color(255, 255, 255, 255))
			surfaceBox(px + pw - ctr(_h) - ctr(_br), ctr(_br), ctr(_h), ctr(_w), Color(255, 255, 255, 255))
			surfaceBox(px + pw - ctr(_w) - ctr(_br), ph - ctr(_h) - ctr(_br), ctr(_w), ctr(_h), Color(255, 255, 255, 255))
			surfaceBox(px + pw - ctr(_h) - ctr(_br), ph - ctr(_w) - ctr(_br), ctr(_h), ctr(_w), Color(255, 255, 255, 255))
		end
	else
		GetDesign()
	end
end

function mouseVisible()
	return vgui.CursorVisible()
end

--[[ OLD ]]
--
local _menuOpen = false

function isNoMenuOpen()
	if not vgui.CursorVisible() then
		return true
	else
		return false
	end
end

function closeMenu()
	_menuOpen = false
	gui.EnableScreenClicker(false)
end

function openMenu()
	_menuOpen = true
end

function paintBr(pw, ph, color)
	local _br = ctr(2)
	--links
	draw.RoundedBox(0, _br, _br, _br, ph - 2 * _br, color)
	--oben
	draw.RoundedBox(0, _br, _br, pw - 2 * _br, _br, color)
	--rechts
	draw.RoundedBox(0, pw - 2 * _br, _br, _br, ph - 2 * _br, color)
	--unten
	draw.RoundedBox(0, _br, ph - 2 * _br, pw - 2 * _br, _br, color)
end

function paintWindow(derma, pw, ph, title)
	yrp_if["Material Design 1"]["DFrame"](derma, pw, ph, title)
end

function paintButton(derma, pw, ph, mytext)
	local _color = Color(255, 255, 255, 150)

	if derma:IsHovered() then
		_color = Color(255, 255, 100, 150)
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _color)
	local _brC = Color(0, 0, 0, 255)
	paintBr(pw, ph, _brC)
	draw.SimpleTextOutlined(YRP.lang_string(mytext), "windowTitle", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
end

function paintPanel(derma, pw, ph, color)
	local _c = color

	if _c == nil then
		_c = Color(0, 0, 0, 250)
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _c)
	local _brC = Color(255, 255, 255, 255)
	paintBr(pw, ph, _brC)
end

function paintInv(derma, pw, ph, text1, text2)
	draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 190))
	local _brC = Color(255, 255, 255, 255)
	paintBr(pw, ph, _brC)
	draw.SimpleTextOutlined(YRP.lang_string(text1), "DermaDefault", ctr(15), ph - ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, ctr(1), Color(0, 0, 0, 255))

	if text2 ~= nil then
		draw.SimpleTextOutlined(YRP.lang_string(text2), "DermaDefault", ctr(15), ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, ctr(1), Color(0, 0, 0, 255))
	end
end

function createD(derma, parent, w, h, x, y)
	local _parent = parent or nil
	local _w = w or 100
	local _h = h or 100
	local _x = x or 0
	local _y = y or 0
	local tmpD = vgui.Create(derma, parent)
	tmpD:SetSize(_w, _h)
	tmpD:SetPos(_x, _y)

	return tmpD
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

function getMDPCol()
	return Color(80, 80, 80, 255)
end

function getMDSCol()
	return Color(40, 40, 40, 255)
end

function getMDPColor()
	local tmp = getMDPCol()

	return colorToMode(tmp)
end

function getMDSColor()
	local tmp = getMDSCol()

	return colorToMode(tmp)
end

function get_color(mystring)
	return _yrp_derma.colors[mystring]
end

function addColor(mystring, r, g, b, a)
	_yrp_derma.colors[mystring] = {}
	_yrp_derma.colors[mystring].r = r
	_yrp_derma.colors[mystring].g = g
	_yrp_derma.colors[mystring].b = b
	_yrp_derma.colors[mystring].a = a
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
	draw.RoundedBox(ctr(r), ctr(x), ctr(y), ctr(w), ctr(h), col)
end

function drawRBoxBr2(r, x, y, w, h, col, br)
	draw.RoundedBox(r, x - br, y - br, w + 2 * br - 1, 2 * br, col)
	draw.RoundedBox(r, x - br, y + h - br, w + 2 * br - 1, 2 * br, col)
	draw.RoundedBox(r, x - br, y, 2 * br, h, col)
	draw.RoundedBox(r, x + w - br, y, 2 * br, h, col)
end

function drawRBoxBr(r, x, y, w, h, col, br)
	draw.RoundedBox(ctr(r), ctr(x - br), ctr(y - br), ctr(w + 2 * br - 1), ctr(2 * br), col)
	draw.RoundedBox(ctr(r), ctr(x - br), ctr(y + h - br), ctr(w + 2 * br - 1), ctr(2 * br), col)
	draw.RoundedBox(ctr(r), ctr(x - br), ctr(y), ctr(2 * br), ctr(h), col)
	draw.RoundedBox(ctr(r), ctr(x + w - br), ctr(y), ctr(2 * br), ctr(h), col)
end

function drawRBoxCr(x, y, size, col)
	draw.RoundedBox(ctr(size / 2), ctr(x), ctr(y), ctr(size), ctr(size), col)
end

function surfaceText(mytext, font, x, y, color, ax, ay, br)
	br = br or true
	local col_br = Color(0, 0, 0, color.a)

	if color == Color(0, 0, 0, 255) then
		col_br = Color(255, 255, 255, color.a)
	end

	if not br then
		draw.SimpleTextOutlined(mytext, font, x, y, color, ax, ay, 0, Color(0, 0, 0, 0))
	else
		draw.SimpleTextOutlined(mytext, font, x, y, color, ax, ay, 1, col_br)
	end
end

function createVGUI(art, parent, w, h, x, y)
	local tmp = vgui.Create(art, parent, nil)

	if w ~= nil and h ~= nil then
		tmp:SetSize(ctr(w), ctr(h))
	end

	if x ~= nil and y ~= nil then
		tmp:SetPos(ctr(x), ctr(y))
	end

	return tmp
end

function paintMDBackground(derma, pw, ph)
	if derma:IsHovered() then
		draw.RoundedBox(0, 0, 0, pw, ph, get_dsbg_col())
	else
		draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col())
	end
end

function createMDMenu(parent, w, h, x, y)
	local tmp = createD("DFrame", parent, w, h, x, y)
	tmp:ShowCloseButton(true)
	tmp:SetDraggable(true)
	tmp:SetTitle("")
	tmp.sites = {}
	tmp.cat = {}

	function tmp:AddCategory(cat)
		local tmpNr = #tmp.cat + 1
		self.cat[tmpNr] = cat
		self.sites[cat] = {}
	end

	function tmp:AddSite(hook, site, cat, icon)
		local material = Material(icon)
		local tmpNrMax = #tmp.sites[cat]
		local tmpNr = tmpNrMax + 1
		self.sites[cat][tmpNr] = {}
		self.sites[cat][tmpNr].hook = hook
		self.sites[cat][tmpNr].site = site
		self.sites[cat][tmpNr].material = material
	end

	tmp.sitepanel = createD("DPanel", tmp, w, h - ctr(100), 0, ctr(100))

	function tmp.sitepanel:Paint(pw, ph)
		--
	end

	function tmp:SwitchToSite(_hook)
		self.lastsite = _hook

		if self.site ~= nil then
			self.site:Remove()
		end

		hook.Call(_hook)
	end

	function tmp:openMenu()
		self.menu = createD("DPanelList", self, ctr(600), h - ctr(100), 0, ctr(100))
		self.menu:EnableVerticalScrollbar(true)

		function self.menu:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, ctr(600), ph, YRPGetColor("5"))
			local mx = select(1,gui.MousePos())

			if mx > ctr(600) then
				self:Remove()
			end
		end

		local posY = 100

		for k, v in pairs(self.cat) do
			local tmpCat = createD("DPanel", self.menu, ctr(600 - 20), ctr(50), ctr(10), ctr(posY))

			function tmpCat:Paint(pw, ph)
				draw.SimpleTextOutlined(string.upper(YRP.lang_string(v)), "windowTitle", ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end

			self.menu:AddItem(tmpCat)

			--posY = posY + 50 + 10
			if self.sites[v] ~= nil then
				for _l, _w in pairs(self.sites[v]) do
					local tmp2 = createD("DButton", self.menu, ctr(600 - 20), ctr(80), ctr(10), ctr(posY))
					tmp2:SetText("")
					tmp2.hook = string.lower(_w.hook)
					tmp2.site = string.upper(_w.site)

					function tmp2:Paint(pw, ph)
						local color = YRPGetColor("2")

						if tmp.cursite == self.site then
							color = YRPGetColor("3")
						elseif self:IsHovered() then
							color = YRPGetColor("1")
						end

						draw.RoundedBox(0, 0, 0, pw, ph, color)

						if _w.material ~= nil then
							surface.SetDrawColor(255, 255, 255, 255)
							surface.SetMaterial(_w.material)
							surface.DrawTexturedRect(ctr(24), ctr(24), ctr(32), ctr(32))
						end

						draw.SimpleTextOutlined(string.upper(YRP.lang_string(_w.site)), "mat1text", ctr(80 + 10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
					end

					function tmp2:DoClick()
						tmp.cursite = self.site
						tmp:SwitchToSite(self.hook)
						tmp.menu:Remove()
					end

					self.menu:AddItem(tmp2)
					local tmpHr2 = createD("DPanel", self.menu, ctr(600 - 20), ctr(6), ctr(10), ctr(posY))

					function tmpHr2:Paint(pw, ph)
					end

					self.menu:AddItem(tmpHr2)
					--posY = posY + 80 + 10
				end

				local tmpHr = createD("DPanel", self.menu, ctr(600 - 20), ctr(20), ctr(10), ctr(posY))

				function tmpHr:Paint(pw, ph)
					--draw.SimpleTextOutlined("test", "windowTitle", ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				end

				self.menu:AddItem(tmpHr)
			end
		end
	end

	return tmp
end

function createMDSwitch(parent, w, h, x, y, opt1, opt2, _hook)
	local tmp = createD("DButton", parent, w, h, x, y)
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

		draw.SimpleTextOutlined(YRP.lang_string("LID_dark"), "HudBars", 1 * (pw / 4), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_light"), "HudBars", 3 * (pw / 4), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
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
	local tmp = createD("DButton", parent, ctr(50), ctr(50), x, y)
	tmp.color = col
	tmp:SetText("")

	function tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)

		if self:IsHovered() then
			draw.SimpleTextOutlined("X", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
	end

	function tmp:DoClick()
		addMDColor("dprimary", getMDPColor())
		addMDColor("dprimaryBG", colorBG(getMDPColor()))
	end

	return tmp
end

function addSColorField(parent, col, x, y)
	local tmp = createD("DButton", parent, ctr(50), ctr(50), x, y)
	tmp.color = col
	tmp:SetText("")

	function tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)

		if self:IsHovered() then
			draw.SimpleTextOutlined("X", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
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

function createCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	return cir
end

function drawCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end

function drawCircleL(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -180)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end

function drawCircleR(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad(((i / seg) * -180) + 180)

		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts

	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end

function drawRoundedBox(r, x, y, w, h, color)
	draw.RoundedBox(0, x + h / 2, y, w - h, h, color)
	surface.SetDrawColor(color)
	draw.NoTexture()
	drawCircleL(x + h / 2, y + h / 2, h / 2, 64)

	if w >= h then
		drawCircleR(x + w - h / 2, y + h / 2, h / 2, 64)
	end
end

function drawRoundedBoxStencil(r, x, y, w, h, color, max)
	--drawRoundedBox(0, x, y, max, h, Color(255, 0, 255, 100))
	if true then
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
end

function drawRBBR(r, x, y, w, h, color, br)
	local _br = br or 0
	draw.RoundedBox(0, x, y, w, br, color)
	draw.RoundedBox(0, x, y + h - br, w, br, color)
	draw.RoundedBox(0, x, y, br, h, color)
	draw.RoundedBox(0, x + w - br, y, br, h, color)
end

function drawRoundedBoxBR(r, x, y, w, h, color, br)
	local _br = br or 0

	--drawRoundedBox(0, x+_br, y+_br, w-_br*2, h-_br*2, Color(255, 0, 255, 255))
	--drawRoundedBox(r, x+_br, y+_br, w-_br*2, h-_br*2, Color(255, 0, 0, 100))
	--drawRoundedBox(r, x-_br, y-_br, w+_br*2, h+_br*2, Color(0, 255, 0, 100))
	if true then
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilFailOperation(STENCILOPERATION_INCR)
		render.SetStencilPassOperation(STENCILOPERATION_INCR)
		render.SetStencilZFailOperation(STENCILOPERATION_INCR)
		render.SetStencilTestMask(1)
		drawRoundedBox(r, x + _br, y + _br, w - _br * 2, h - _br * 2, Color(255, 0, 255, 200))
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
		render.SetStencilWriteMask(1)
		drawRoundedBox(r, x - _br, y - _br, w + _br * 2, h + _br * 2, color)
		render.SetStencilEnable(false)
	end
end
