--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _mat1 = {}
_mat1.author = "D4KiR"
_mat1.name = "Material Design 1"
_mat1.textFont = "Y_18_500"
YRPRegisterDesign(_mat1)
function _mat1.GetAlpha()
	if InterfaceTransparent() then
		return 200
	else
		return 255
	end
end

_mat1.color = {}
_mat1.color["bg"] = {}
_mat1.color["bg"]["dark"] = Color(90, 90, 90)
_mat1.color["bg"]["light"] = Color(255, 255, 255, 255)
_mat1.color["br"] = {}
_mat1.color["br"]["dark"] = Color(255, 255, 255, 255)
_mat1.color["br"]["light"] = Color(0, 0, 0, 255)
_mat1.color["blue"] = {}
_mat1.color["blue"]["dark"] = Color(0, 57, 203)
_mat1.color["blue"]["light"] = Color(118, 143, 255)
YRPAddColor(_mat1.name, "blue", "1", Color(46, 135, 255)) -- Hovered
YRPAddColor(_mat1.name, "blue", "2", Color(26, 121, 255)) -- Normal
YRPAddColor(_mat1.name, "blue", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_mat1.name, "blue", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "blue", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "blue", "6", Color(255, 255, 255, 255)) -- Border/Icon
YRPAddColor(_mat1.name, "red", "1", Color(255, 81, 49)) -- Hovered
YRPAddColor(_mat1.name, "red", "2", Color(155, 0, 0)) -- Normal
YRPAddColor(_mat1.name, "red", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_mat1.name, "red", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "red", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "red", "6", Color(255, 255, 255, 255)) -- Border
YRPAddColor(_mat1.name, "green", "1", Color(94, 252, 130)) -- Hovered
YRPAddColor(_mat1.name, "green", "2", Color(0, 150, 36)) -- Normal
YRPAddColor(_mat1.name, "green", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_mat1.name, "green", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "green", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "green", "6", Color(255, 255, 255, 255)) -- Border
YRPAddColor(_mat1.name, "yellow", "1", Color(255, 255, 82)) -- Hovered
YRPAddColor(_mat1.name, "yellow", "2", Color(199, 165, 0)) -- Normal
YRPAddColor(_mat1.name, "yellow", "3", Color(179, 125, 0)) -- Selected
YRPAddColor(_mat1.name, "yellow", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "yellow", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "yellow", "6", Color(0, 0, 0, 255)) -- Border
YRPAddColor(_mat1.name, "brown", "1", Color(106, 79, 75)) -- Hovered
YRPAddColor(_mat1.name, "brown", "2", Color(27, 0, 0)) -- Normal
YRPAddColor(_mat1.name, "brown", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_mat1.name, "brown", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "brown", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "brown", "6", Color(255, 255, 255, 255)) -- Border
YRPAddColor(_mat1.name, "orange", "1", Color(255, 158, 64)) -- Hovered
YRPAddColor(_mat1.name, "orange", "2", Color(196, 60, 0)) -- Normal
YRPAddColor(_mat1.name, "orange", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_mat1.name, "orange", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "orange", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "orange", "6", Color(0, 0, 0, 255)) -- Border
YRPAddColor(_mat1.name, "purple", "1", Color(226, 84, 255)) -- Hovered
YRPAddColor(_mat1.name, "purple", "2", Color(114, 0, 202)) -- Normal
YRPAddColor(_mat1.name, "purple", "3", Color(13, 63, 135)) -- Selected
YRPAddColor(_mat1.name, "purple", "4", Color(90, 90, 90)) -- Background Highlight
YRPAddColor(_mat1.name, "purple", "5", Color(51, 51, 51)) -- Background
YRPAddColor(_mat1.name, "purple", "6", Color(255, 255, 255, 255)) -- Border
function _mat1.GetColor(color, style)
	return _mat1.color[color][style]
end

function _mat1.DrawWindow(window, pw, ph, title)
	--[[ Vars ]]
	--
	local _title = title or ""
	--[[ Background ]]
	--
	local _color_bar = YRPGetColor("2")
	local _color_bg = _mat1.color["bg"][InterfaceStyle()]
	local _color_br = _mat1.color["br"][InterfaceStyle()]
	if InterfaceTransparent() then
		if InterfaceStyle() == "dark" then
			_color_bar.a = 100
			_color_bg.a = 100
		else
			_color_bar.a = 100
			_color_bg.a = 20
		end
	else
		_color_bar.a = 255
		_color_bg.a = 255
	end

	draw.RoundedBox(0, 0, 0, pw, YRP:ctr(50), _color_bar)
	draw.RoundedBox(0, 0, YRP:ctr(50), pw, ph - YRP:ctr(50), _color_bg)
	--[[ Title ]]
	--
	surfaceText(YRP:trans(_title), "Y_22_500", YRP:ctr(10), YRP:ctr(25), Color(255, 255, 255, 255), 0, 1, 1)
end

RegisterWindowFunction(_mat1.name, _mat1.DrawWindow)
function _mat1.YRPDrawButton(btn, pw, ph, text, color, px, py, ax, ah, forcelang)
	--[[ Vars ]]
	--
	local _text = text or ""
	--[[ Background ]]
	--
	local _color_bar = YRPGetColor("2")
	local _color_br = YRPGetColor("6")
	if InterfaceTransparent() then
		_color_bar.a = 220
	else
		_color_bar.a = 255
	end

	if btn:IsHovered() then
		_color_bar = YRPGetColor("1")
	end

	local _color = color or _color_bar
	draw.RoundedBox(0, 0, 0, pw, ph, _color)
	--[[ text ]]
	--
	if forcelang then
		_text = YRP:trans(_text)
	end

	surfaceText(_text, _mat1.textFont, px or pw / 2, py or ph / 2, Color(255, 255, 255, 255), ax or 1, ay or 1, 1)
end

RegisterButtonFunction(_mat1.name, _mat1.DrawButton)
function _mat1.DrawPanel(pnl, pw, ph, text, color, px, py, ax, ah)
	--[[ Vars ]]
	--
	local _text = text or ""
	--[[ Background ]]
	--
	local _color_bar = YRPGetColor("2")
	local _color_br = YRPGetColor("6")
	if InterfaceTransparent() then
		_color_bar.a = 220
	else
		_color_bar.a = 255
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _color_bar)
	--[[ text ]]
	--
	surfaceText(YRP:trans(_text), _mat1.textFont, px or pw / 2, py or ph / 2, color or Color(255, 255, 255, 255), ax or 1, ay or 1, 1)
end

RegisterPanelFunction(_mat1.name, _mat1.DrawPanel)
