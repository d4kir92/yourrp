--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function GetFontSizeTable()
	local tab = {}
	table.insert(tab, 8)
	table.insert(tab, 9)
	table.insert(tab, 10)
	table.insert(tab, 11)
	table.insert(tab, 12)
	table.insert(tab, 14)
	table.insert(tab, 18)
	table.insert(tab, 24)
	table.insert(tab, 30)
	table.insert(tab, 36)
	table.insert(tab, 48)
	table.insert(tab, 60)
	table.insert(tab, 72)
	table.insert(tab, 96)
	return tab
end

function createFont(_name, _font, _size, __weight, _outline, _shadow)
	--printGM("db", "createFont: " .. _name)
	--printGM("db", _font .. ", " .. _size .. ", " .. __weight)
	_size = ctr(_size * 2)
	surface.CreateFont(_name, {
		font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = _size,
		weight = __weight,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = _shadow or false,
		additive = false,
		outline = _outline or false
	})
end

local tmpFont = "Roboto"
local _weight = 500

function GetYRPFont()
	return tmpFont
end

function changeFontSizeOf(_font, _size)
	printGM("note", "changeFontSizeOf" .. _font .. _size)
	createFont(_font, GetYRPFont(), _size, weight, false)
end

function changeFontSize()
	printGM("db", "changeFontSize")

	for i, s in pairs(GetFontSizeTable()) do
		createFont("Roboto" .. s, "Roboto", s, _weight, false)
		createFont("Roboto" .. s .. "B", "Roboto", s, 700, false)
	end

	--[[ DESIGNS ]]--
	createFont("mat1header", GetYRPFont(), 22, _weight, false)
	createFont("mat1text", GetYRPFont(), 18, 0, false)

	--[[ EMOTES ]]--
	createFont("emotes", GetYRPFont(), 22, _weight, false)

	--[[ 3D2D ]]--
	createFont("3d2d_string", GetYRPFont(), 22, _weight, false)

	--[[ Settings ]]--
	createFont("Settings_Normal", GetYRPFont(), 22, _weight, false)
	createFont("Settings_Header", GetYRPFont(), 26, _weight, false)

	createFont("apph1", GetYRPFont(), fontr(36), _weight, false)
	createFont("appt", GetYRPFont(), fontr(30), _weight, false)

	createFont("appname", GetYRPFont(), ctrb(28), _weight, false)

	createFont("plates", GetYRPFont(), 30, _weight, false)
	createFont("plyinfo", GetYRPFont(), 18, _weight, false)

	createFont("mdMenu", GetYRPFont(), 17, 1000, false)

	createFont("windowTitle", GetYRPFont(), 18, 1000, false)

	createFont("HudSettings", GetYRPFont(), 24, _weight, false)

	createFont("HudDefault", GetYRPFont(), 72, _weight, false)

	createFont("SettingsNormal", GetYRPFont(), 24, _weight, false)
	createFont("SettingsHeader", GetYRPFont(), 30, _weight, false)

	createFont("roleInfoHeader", GetYRPFont(), 24, _weight, false)
	createFont("roleInfoText", GetYRPFont(), 20, _weight, false)

	createFont("charTitle", GetYRPFont(), 20, 800, false)
	createFont("charHeader", GetYRPFont(), 20, 800, false)
	createFont("charText", GetYRPFont(), 20, 800, false)

	createFont("pmT", GetYRPFont(), 18, _weight, false)
	createFont("weaponT", GetYRPFont(), 14, _weight, false)

	createFont("HudBars", GetYRPFont(), 24, _weight, false)
	createFont("HudHeader", GetYRPFont(), 36, _weight, false)
	createFont("HudVersion", GetYRPFont(), 30, 1000, false)

	createFont("72", GetYRPFont(), 72, _weight, false)
	--Creating
	createFont("mmsf", GetYRPFont(), 24, _weight, false)
	createFont("hpsf", GetYRPFont(), 24, _weight, false)
	createFont("arsf", GetYRPFont(), 24, _weight, false)
	createFont("wpsf", GetYRPFont(), 24, _weight, false)
	createFont("wssf", GetYRPFont(), 24, _weight, false)
	createFont("wnsf", GetYRPFont(), 24, _weight, false)
	createFont("ttsf", GetYRPFont(), 24, _weight, false)
	createFont("mosf", GetYRPFont(), 24, _weight, false)
	createFont("mhsf", GetYRPFont(), 24, _weight, false)
	createFont("mtsf", GetYRPFont(), 24, _weight, false)
	createFont("mssf", GetYRPFont(), 24, _weight, false)
	createFont("vtsf", GetYRPFont(), 24, _weight, false)
	createFont("cbsf", GetYRPFont(), 24, _weight, false)
	createFont("masf", GetYRPFont(), 24, _weight, false)
	createFont("casf", GetYRPFont(), 24, _weight, false)
	createFont("stsf", GetYRPFont(), 24, _weight, false)
	createFont("xpsf", GetYRPFont(), 24, _weight, false)
	createFont("utsf", GetYRPFont(), 24, _weight, false)
	createFont("blsf", GetYRPFont(), 24, _weight, false)
	createFont("rtsf", GetYRPFont(), 24, _weight, false)

	createFont("sef", GetYRPFont(), 24, 1, false)

	createFont("ScoreBoardTitle", GetYRPFont(), 24, _weight, false)
	createFont("ScoreBoardNormal", GetYRPFont(), 20, _weight, false)

	createFont("ATM_Header", GetYRPFont(), 80, _weight, false)
	createFont("ATM_Normal", GetYRPFont(), 60, _weight, false)
	createFont("ATM_Name", GetYRPFont(), 40, _weight, false)

	--DarkRP Fonts
	createFont("DarkRPHUD1", GetYRPFont(), 16, _weight, false)
	createFont("DarkRPHUD2", GetYRPFont(), 24, _weight, false)
	createFont("Trebuchet18", GetYRPFont(), 16, _weight, false)
	createFont("Trebuchet20", GetYRPFont(), 20, _weight, false)
	createFont("Trebuchet24", GetYRPFont(), 24, _weight, false)
	createFont("Trebuchet48", GetYRPFont(), 48, _weight, false)
	createFont("TabLarge", GetYRPFont(), 16, 700, false)
	createFont("UiBold", GetYRPFont(), 16, 800, false)
	createFont("HUDNumber5", GetYRPFont(), 30, 800, false)
	createFont("ScoreboardHeader", GetYRPFont(), 32, _weight, false)
	createFont("ScoreboardSubtitle", GetYRPFont(), 24, _weight, false)
	createFont("ScoreboardPlayerName", GetYRPFont(), 19, _weight, false)
	createFont("ScoreboardPlayerName2", GetYRPFont(), 15, _weight, false)
	createFont("ScoreboardPlayerNameBig", GetYRPFont(), 24, _weight, false)
	createFont("AckBarWriting", GetYRPFont(), 20, _weight, false)
	createFont("DarkRP_tipjar", GetYRPFont(), 100, _weight, false)
end
changeFontSize()

function SetYRPFont(font)
	tmpFont = font
	changeFontSize()
end
