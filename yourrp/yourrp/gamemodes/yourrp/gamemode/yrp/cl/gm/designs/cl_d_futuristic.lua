--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _fut = {}
_fut.author = "D4KiR"
_fut.name = "Futuristic"
_fut.textFont = "Y_18_500"
YRPRegisterDesign(_fut)
function _fut.GetAlpha()
	if InterfaceTransparent() then
		return 200
	else
		return 255
	end
end

_fut.color = {}
_fut.color["bg"] = {}
_fut.color["bg"]["dark"] = Color(30, 30, 30)
_fut.color["bg"]["light"] = Color(255, 255, 255, 255)
_fut.color["blue"] = {}
_fut.color["blue"]["dark"] = Color(0, 57, 203)
_fut.color["blue"]["light"] = Color(118, 143, 255)
_fut.color["red"] = {}
_fut.color["red"]["dark"] = Color(155, 0, 0)
_fut.color["red"]["light"] = Color(255, 81, 49)
_fut.color["green"] = {}
_fut.color["green"]["dark"] = Color(0, 150, 36)
_fut.color["green"]["light"] = Color(94, 252, 130)
_fut.color["yellow"] = {}
_fut.color["yellow"]["dark"] = Color(199, 165, 0)
_fut.color["yellow"]["light"] = Color(255, 255, 82)
_fut.color["brown"] = {}
_fut.color["brown"]["dark"] = Color(27, 0, 0)
_fut.color["brown"]["light"] = Color(106, 79, 75)
_fut.color["orange"] = {}
_fut.color["orange"]["dark"] = Color(196, 60, 0)
_fut.color["orange"]["light"] = Color(255, 158, 64)
_fut.color["purple"] = {}
_fut.color["purple"]["dark"] = Color(114, 0, 202)
_fut.color["purple"]["light"] = Color(226, 84, 255)
YRPAddColor(_fut.name, "blue", "1", Color(46, 135, 255)) -- Hovered
YRPAddColor(_fut.name, "blue", "2", Color(26, 121, 255)) -- Normal
YRPAddColor(_fut.name, "blue", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_fut.name, "blue", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "blue", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "blue", "6", Color(255, 255, 255, 255)) -- Border/Icon
YRPAddColor(_fut.name, "red", "1", Color(255, 81, 49)) -- Hovered
YRPAddColor(_fut.name, "red", "2", Color(155, 0, 0)) -- Normal
YRPAddColor(_fut.name, "red", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_fut.name, "red", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "red", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "red", "6", Color(255, 255, 255, 255)) -- Border
YRPAddColor(_fut.name, "green", "1", Color(94, 252, 130)) -- Hovered
YRPAddColor(_fut.name, "green", "2", Color(0, 150, 36)) -- Normal
YRPAddColor(_fut.name, "green", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_fut.name, "green", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "green", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "green", "6", Color(255, 255, 255, 255)) -- Border
YRPAddColor(_fut.name, "yellow", "1", Color(255, 255, 82)) -- Hovered
YRPAddColor(_fut.name, "yellow", "2", Color(199, 165, 0)) -- Normal
YRPAddColor(_fut.name, "yellow", "3", Color(179, 125, 0)) -- Selected
YRPAddColor(_fut.name, "yellow", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "yellow", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "yellow", "6", Color(0, 0, 0, 255)) -- Border
YRPAddColor(_fut.name, "brown", "1", Color(106, 79, 75)) -- Hovered
YRPAddColor(_fut.name, "brown", "2", Color(27, 0, 0)) -- Normal
YRPAddColor(_fut.name, "brown", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_fut.name, "brown", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "brown", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "brown", "6", Color(255, 255, 255, 255)) -- Border
YRPAddColor(_fut.name, "orange", "1", Color(255, 158, 64)) -- Hovered
YRPAddColor(_fut.name, "orange", "2", Color(196, 60, 0)) -- Normal
YRPAddColor(_fut.name, "orange", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_fut.name, "orange", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "orange", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "orange", "6", Color(0, 0, 0, 255)) -- Border
YRPAddColor(_fut.name, "purple", "1", Color(226, 84, 255)) -- Hovered
YRPAddColor(_fut.name, "purple", "2", Color(114, 0, 202)) -- Normal
YRPAddColor(_fut.name, "purple", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_fut.name, "purple", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_fut.name, "purple", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_fut.name, "purple", "6", Color(255, 255, 255, 255)) -- Border
function _fut.GetColor(color, style)
	return _fut.color[color][style]
end

local g_up = Material("vgui/gradient_up")
local g_dn = Material("vgui/gradient_down")
local g_ri = Material("vgui/gradient-r")
local g_le = Material("vgui/gradient-l")
function LaserBorder(pw, ph)
	local _size = YRP.ctr(12)
	surface.SetDrawColor(_fut.GetColor(InterfaceColor(), InterfaceStyle()))
	surface.SetMaterial(g_dn)
	surface.DrawTexturedRect(0, 0, pw, _size)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(0, 0, pw, _size / 2)
	surface.SetDrawColor(_fut.GetColor(InterfaceColor(), InterfaceStyle()))
	surface.SetMaterial(g_up)
	surface.DrawTexturedRect(0, ph - _size, pw, _size)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(0, ph - _size / 2, pw, _size / 2)
	surface.SetDrawColor(_fut.GetColor(InterfaceColor(), InterfaceStyle()))
	surface.SetMaterial(g_ri)
	surface.DrawTexturedRect(pw - _size, 0, _size, ph)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(pw - _size / 2, 0, _size / 2, ph)
	surface.SetDrawColor(_fut.GetColor(InterfaceColor(), InterfaceStyle()))
	surface.SetMaterial(g_le)
	surface.DrawTexturedRect(0, 0, _size, ph)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(0, 0, _size / 2, ph)
end

function _fut.DrawWindow(window, pw, ph, title)
	--[[ Vars ]]
	--
	local _title = title or ""
	--[[ Background ]]
	--
	local _color_bar = _fut.color[InterfaceColor()][InterfaceStyle()]
	local _color_bg = _fut.color["bg"][InterfaceStyle()]
	if InterfaceTransparent() then
		if InterfaceStyle() == "dark" then
			_color_bar.a = 160
			_color_bg.a = 160
		else
			_color_bar.a = 160
			_color_bg.a = 60
		end
	else
		_color_bar.a = 255
		_color_bg.a = 255
	end

	draw.RoundedBox(0, 0, 0, pw, YRP.ctr(50), _color_bar)
	draw.RoundedBox(0, 0, YRP.ctr(50), pw, ph - YRP.ctr(50), _color_bg)
	if InterfaceBorder() then
		LaserBorder(pw, ph)
	end

	--[[ Title ]]
	--
	surfaceText(_title, "Y_22_500", YRP.ctr(10), YRP.ctr(25), Color(255, 255, 255, 255), 0, 1)
end

RegisterWindowFunction(_fut.name, _fut.DrawWindow)
function _fut.YRPDrawButton(btn, pw, ph, text, color)
	--[[ Vars ]]
	--
	local _text = text or ""
	--[[ Background ]]
	--
	local _color_bar = _fut.GetColor(InterfaceColor(), InterfaceStyle())
	if InterfaceTransparent() then
		_color_bar.a = 60
	else
		_color_bar.a = 255
	end

	local _hovered = 0
	if btn:IsHovered() then
		_hovered = 60
	end

	local _color = color or _color_bar
	draw.RoundedBox(0, 0, 0, pw, ph, Color(_color.r + _hovered, _color.g + _hovered, _color.b + _hovered, _color.a))
	if InterfaceBorder() then
		LaserBorder(pw, ph)
	end

	--[[ text ]]
	--
	surfaceText(_text, _fut.textFont, pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
end

RegisterButtonFunction(_fut.name, _fut.DrawButton)
function _fut.DrawPanel(pnl, pw, ph, text, color, px, py, ax, ah)
	--[[ Vars ]]
	--
	local _text = text or ""
	--[[ Background ]]
	--
	local _color_bar = _fut.GetColor(InterfaceColor(), InterfaceStyle())
	if InterfaceTransparent() then
		_color_bar.a = 60
	else
		_color_bar.a = 255
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _color_bar)
	if InterfaceBorder() then
		LaserBorder(pw, ph)
	end

	--[[ text ]]
	--
	surfaceText(_text, _fut.textFont, px or pw / 2, py or ph / 2, color or Color(255, 255, 255, 255), ax or 1, ay or 1, 1)
end

RegisterPanelFunction(_fut.name, _fut.DrawPanel)