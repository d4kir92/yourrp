--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_fonts.lua

function createFont( _name, _font, _size, __weight, _outline )
	--printGM( "db", "createFont: " .. _name )
	--printGM( "db", _font .. ", " .. _size .. ", " .. __weight )
	_size = ctr( _size*2 )
	surface.CreateFont( _name, {
		font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = _size,
		weight = __weight,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = _outline
	} )
end

local tmpFont = "Roboto-Regular"
local _weight = 1

function changeFontSizeOf( _font, _size )
	printGM( "note", "changeFontSizeOf" .. _font .. _size)
	createFont( _font, tmpFont, _size, weight, false )
end

function updateDBFonts()
	createFont( "mmsf", tmpFont, cl_db["mmsf"], _weight, false )
	createFont( "hpsf", tmpFont, cl_db["hpsf"], _weight, false )
	createFont( "arsf", tmpFont, cl_db["arsf"], _weight, false )
	createFont( "wpsf", tmpFont, cl_db["wpsf"], _weight, false )
	createFont( "wssf", tmpFont, cl_db["wssf"], _weight, false )
	createFont( "wnsf", tmpFont, cl_db["wnsf"], _weight, false )
	createFont( "ttsf", tmpFont, cl_db["ttsf"], _weight, false )
	createFont( "mosf", tmpFont, cl_db["mosf"], _weight, false )
	createFont( "mhsf", tmpFont, cl_db["mhsf"], _weight, false )
	createFont( "mtsf", tmpFont, cl_db["mtsf"], _weight, false )
	createFont( "mssf", tmpFont, cl_db["mssf"], _weight, false )
	createFont( "vtsf", tmpFont, cl_db["vtsf"], _weight, false )
	createFont( "cbsf", tmpFont, cl_db["cbsf"], _weight, false )
	createFont( "masf", tmpFont, cl_db["masf"], _weight, false )
	createFont( "casf", tmpFont, cl_db["casf"], _weight, false )
	createFont( "stsf", tmpFont, cl_db["stsf"], _weight, false )
	createFont( "xpsf", tmpFont, cl_db["xpsf"], _weight, false )
end

--##############################################################################
--Change Fonts
function changeFontSize()
	printGM( "db", "changeFontSize" )

	createFont( "HudSettings", tmpFont, 24, _weight, false )

	createFont( "HudDefault", tmpFont, 72, _weight, false )

	createFont( "SettingsNormal", tmpFont, 30, _weight, false )
	createFont( "SettingsHeader", tmpFont, 30, _weight, false )

	createFont( "roleInfoHeader", tmpFont, 24, _weight, false )
	createFont( "roleInfoText", tmpFont, 20, _weight, false )

	createFont( "charTitle", tmpFont, 18, _weight, false )
	createFont( "charHeader", tmpFont, 18, _weight, false )
	createFont( "charText", tmpFont, 18, _weight, false )

	createFont( "pmT", tmpFont, 18, _weight, false )
	createFont( "weaponT", tmpFont, 14, _weight, false )

	createFont( "HudBars", tmpFont, 24, _weight, false )
	createFont( "HudHeader", tmpFont, 36, _weight, false )
	createFont( "HudVersion", tmpFont, 30, 1000, false )

	--Creating
	createFont( "mmsf", tmpFont, 24, _weight, false )
	createFont( "hpsf", tmpFont, 24, _weight, false )
	createFont( "arsf", tmpFont, 24, _weight, false )
	createFont( "wpsf", tmpFont, 24, _weight, false )
	createFont( "wssf", tmpFont, 24, _weight, false )
	createFont( "wnsf", tmpFont, 24, _weight, false )
	createFont( "ttsf", tmpFont, 24, _weight, false )
	createFont( "mosf", tmpFont, 24, _weight, false )
	createFont( "mhsf", tmpFont, 24, _weight, false )
	createFont( "mtsf", tmpFont, 24, _weight, false )
	createFont( "mssf", tmpFont, 24, _weight, false )
	createFont( "vtsf", tmpFont, 24, _weight, false )
	createFont( "cbsf", tmpFont, 24, _weight, false )
	createFont( "masf", tmpFont, 24, _weight, false )
	createFont( "casf", tmpFont, 24, _weight, false )
	createFont( "stsf", tmpFont, 24, _weight, false )
	createFont( "xpsf", tmpFont, 24, _weight, false )

	createFont( "sef", tmpFont, 24, _weight, false )

	timer.Create( "createFontDB", 0.1, 0, function()
		if cl_db["_loaded"] then
			--Changing to right values
			updateDBFonts()

			printGM( "db", "HUD Fonts loaded." )

			timer.Remove( "createFontDB" )
		end
	end)

	createFont( "ScoreBoardTitle", tmpFont, 24, _weight, false )
	createFont( "ScoreBoardNormal", tmpFont, 20, _weight, false )

	createFont( "ATM_Header", tmpFont, 80, _weight, false )
	createFont( "ATM_Normal", tmpFont, 60, _weight, false )
	createFont( "ATM_Name", tmpFont, 40, _weight, false )

	--DarkRP Fonts
	createFont( "DarkRPHUD1", tmpFont, 16, _weight, false )
	createFont( "DarkRPHUD2", tmpFont, 24, _weight, false )
	createFont( "Trebuchet18", tmpFont, 16, _weight, false )
	createFont( "Trebuchet20", tmpFont, 20, _weight, false )
	createFont( "Trebuchet24", tmpFont, 24, _weight, false )
	createFont( "Trebuchet48", tmpFont, 48, _weight, false )
	createFont( "TabLarge", tmpFont, 16, 700, false )
	createFont( "UiBold", tmpFont, 16, 800, false )
	createFont( "HUDNumber5", tmpFont, 30, 800, false )
	createFont( "ScoreboardHeader", tmpFont, 32, _weight, false )
	createFont( "ScoreboardSubtitle", tmpFont, 24, _weight, false )
	createFont( "ScoreboardPlayerName", tmpFont, 19, _weight, false )
	createFont( "ScoreboardPlayerName2", tmpFont, 15, _weight, false )
	createFont( "ScoreboardPlayerNameBig", tmpFont, 24, _weight, false )
	createFont( "AckBarWriting", tmpFont, 20, _weight, false )
	createFont( "DarkRP_tipjar", tmpFont, 100, _weight, false )
end
changeFontSize()
--##############################################################################
