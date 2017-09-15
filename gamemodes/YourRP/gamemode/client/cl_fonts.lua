--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_fonts.lua

function createFont( _name, _font, _size, _weight, _outline )
	--printGM( "db", "createFont: " .. _name .. ", " .. _font .. ", " .. _size )
	local _antialaising = false
	local _size = ctrW( _size*2 )
	if _size >= 72 then
		_antialaising = true
	end
	surface.CreateFont( _name, {
		font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = _size,
		weight = _weight,
		blursize = 0,
		scanlines = 0,
		antialias = _antialaising,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = _outline,
	} )
end
--##############################################################################
--Change Fonts
function changeFontSize()
	printGM( "db", "changeFontSize" )

	local tmpFont = "Roboto-Thin"
	createFont( "HudDefault", tmpFont, 80, 500, false )

	createFont( "SettingsNormal", tmpFont, 26, 500, true )
	createFont( "SettingsHeader", tmpFont, 30, 500, false )

	createFont( "roleInfoHeader", tmpFont, 24, 500, true )
	createFont( "roleInfoText", tmpFont, 20, 500, true )

	createFont( "charTitle", tmpFont, 14, 500, true )
	createFont( "charHeader", tmpFont, 14, 500, true )
	createFont( "charText", tmpFont, 14, 500, true )

	createFont( "pmT", tmpFont, 18, 500, true )
	createFont( "weaponT", tmpFont, 16, 500, true )

	createFont( "HudBars", tmpFont, 22, 500, true )
	createFont( "HudVersion", tmpFont, 30, 700, true )

	--Creating
	createFont( "mmf", tmpFont, 22, 500, true )
	createFont( "hpf", tmpFont, 22, 500, true )
	createFont( "arf", tmpFont, 22, 500, true )
	createFont( "wpf", tmpFont, 22, 500, true )
	createFont( "wsf", tmpFont, 22, 500, true )
	createFont( "wnf", tmpFont, 22, 500, true )
	createFont( "rif", tmpFont, 22, 500, true )
	createFont( "ttf", tmpFont, 22, 500, true )
	createFont( "mof", tmpFont, 22, 500, true )
	createFont( "mhf", tmpFont, 22, 500, true )
	createFont( "mtf", tmpFont, 22, 500, true )
	createFont( "msf", tmpFont, 22, 500, true )
	createFont( "vtf", tmpFont, 22, 500, true )
	createFont( "cbf", tmpFont, 22, 500, true )
	createFont( "vof", tmpFont, 22, 500, true )
	createFont( "maf", tmpFont, 22, 500, true )
	createFont( "caf", tmpFont, 22, 500, true )
	createFont( "stf", tmpFont, 22, 500, true )

	createFont( "sef", tmpFont, 22, 500, true )

	timer.Create( "createFontDB", 0.1, 0, function()
		if cl_db["_load"] == 1 then
			--Changing to right values
			createFont( "mmf", tmpFont, cl_db["mmf"], 500, true )
			createFont( "hpf", tmpFont, cl_db["hpf"], 500, true )
			createFont( "arf", tmpFont, cl_db["arf"], 500, true )
			createFont( "wpf", tmpFont, cl_db["wpf"], 500, true )
			createFont( "wsf", tmpFont, cl_db["wsf"], 500, true )
			createFont( "wnf", tmpFont, cl_db["wnf"], 500, true )
			createFont( "rif", tmpFont, cl_db["rif"], 500, true )
			createFont( "ttf", tmpFont, cl_db["ttf"], 500, true )
			createFont( "mof", tmpFont, cl_db["mof"], 500, true )
			createFont( "mhf", tmpFont, cl_db["mhf"], 500, true )
			createFont( "mtf", tmpFont, cl_db["mtf"], 500, true )
			createFont( "msf", tmpFont, cl_db["msf"], 500, true )
			createFont( "vtf", tmpFont, cl_db["vtf"], 500, true )
			createFont( "cbf", tmpFont, cl_db["cbf"], 500, true )
			createFont( "vof", tmpFont, cl_db["vof"], 500, true )
			createFont( "maf", tmpFont, cl_db["maf"], 500, true )
			createFont( "caf", tmpFont, cl_db["caf"], 500, true )
			createFont( "stf", tmpFont, cl_db["stf"], 500, true )

			createFont( "sef", tmpFont, cl_db["sef"], 500, true )

			printGM( "db", "HUD Fonts loaded." )

			timer.Remove( "createFontDB" )
		end
	end)

	createFont( "ScoreBoardTitle", tmpFont, 24, 500, true )
	createFont( "ScoreBoardNormal", tmpFont, 20, 500, true )

	createFont( "ATM_Header", tmpFont, 80, 500, true )
	createFont( "ATM_Normal", tmpFont, 60, 500, true )
	createFont( "ATM_Name", tmpFont, 40, 500, true )

	--DarkRP Fonts
	createFont( "DarkRPHUD1", tmpFont, 16, 600, true )
	createFont( "DarkRPHUD2", tmpFont, 23, 400, true )
	createFont( "Trebuchet18", tmpFont, 18, 500, true )
	createFont( "Trebuchet20", tmpFont, 20, 500, true )
	createFont( "Trebuchet24", tmpFont, 24, 500, true )
	createFont( "Trebuchet48", tmpFont, 48, 500, true )
	createFont( "TabLarge", tmpFont, 15, 700, true )
	createFont( "UiBold", tmpFont, 16, 800, true )
	createFont( "HUDNumber5", tmpFont, 30, 800, true )
	createFont( "ScoreboardHeader", tmpFont, 32, 500, true )
	createFont( "ScoreboardSubtitle", tmpFont, 22, 500, true )
	createFont( "ScoreboardPlayerName", tmpFont, 19, 500, true )
	createFont( "ScoreboardPlayerName2", tmpFont, 15, 500, true )
	createFont( "ScoreboardPlayerNameBig", tmpFont, 22, 500, true )
	createFont( "AckBarWriting", tmpFont, 20, 500, true )
	createFont( "DarkRP_tipjar", tmpFont, 100, 500, true )
end
changeFontSize()
--##############################################################################
