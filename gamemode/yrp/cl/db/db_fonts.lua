--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function createFont(_name, _font, _size, __weight, _outline, _shadow)
	--printGM("db", "createFont: " .. _name)
	--printGM("db", _font .. ", " .. _size .. ", " .. __weight)
	_size = ctr(_size*2)
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

function update_db_fonts()
	createFont("mmsf", GetYRPFont(), HudV("mmsf"), _weight, false)
	createFont("hpsf", GetYRPFont(), HudV("hpsf"), _weight, false)
	createFont("arsf", GetYRPFont(), HudV("arsf"), _weight, false)
	createFont("wpsf", GetYRPFont(), HudV("wpsf"), _weight, false)
	createFont("wssf", GetYRPFont(), HudV("wssf"), _weight, false)
	createFont("wnsf", GetYRPFont(), HudV("wnsf"), _weight, false)
	createFont("ttsf", GetYRPFont(), HudV("ttsf"), _weight, false)
	createFont("mosf", GetYRPFont(), HudV("mosf"), _weight, false)
	createFont("mhsf", GetYRPFont(), HudV("mhsf"), _weight, false)
	createFont("mtsf", GetYRPFont(), HudV("mtsf"), _weight, false)
	createFont("mssf", GetYRPFont(), HudV("mssf"), _weight, false)
	createFont("vtsf", GetYRPFont(), HudV("vtsf"), _weight, false)
	createFont("cbsf", GetYRPFont(), HudV("cbsf"), _weight, false)
	createFont("masf", GetYRPFont(), HudV("masf"), _weight, false)
	createFont("casf", GetYRPFont(), HudV("casf"), _weight, false)
	createFont("stsf", GetYRPFont(), HudV("stsf"), _weight, false)
	createFont("xpsf", GetYRPFont(), HudV("xpsf"), _weight, false)
	createFont("utsf", GetYRPFont(), HudV("utsf"), _weight, false)
	createFont("blsf", GetYRPFont(), HudV("utsf"), _weight, false)
	createFont("rtsf", GetYRPFont(), HudV("utsf"), _weight, false)
end

function changeFontSize()
	printGM("db", "changeFontSize")

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

	timer.Create("createFontDB", 0.1, 0, function()
		if is_hud_db_loaded() then
			--Changing to right values
			update_db_fonts()

			printGM("db", "HUD Fonts loaded.")

			timer.Remove("createFontDB")
		end
	end)

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
