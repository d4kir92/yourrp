--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_fonts.lua

function createFont( _name, _font, _size, _weight, _outline )
	--printGM( "db", "createFont: " .. _name .. ", " .. _font .. ", " .. _size )
	local _antialaising = false
	local _shadow = false
	local _size = ctrW( _size*2 )
	if _size >= 72 then
		_antialaising = true
	end
	if _size < 18 then
		_outline = false
		_shadow = true
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
		shadow = _shadow,
		additive = false,
		outline = _outline,
	} )
end
--##############################################################################
--Change Fonts
function changeFontSize()
	printGM( "db", "changeFontSize" )

	local weight = 600

	local tmpFont = "Roboto-Thin"
	createFont( "HudDefault", tmpFont, 80, weight, false )

	createFont( "SettingsNormal", tmpFont, 26, weight, true )
	createFont( "SettingsHeader", tmpFont, 30, weight, false )

	createFont( "roleInfoHeader", tmpFont, 24, weight, true )
	createFont( "roleInfoText", tmpFont, 20, weight, true )

	createFont( "charTitle", tmpFont, 18, weight, true )
	createFont( "charHeader", tmpFont, 18, weight, true )
	createFont( "charText", tmpFont, 18, weight, true )

	createFont( "pmT", tmpFont, 18, weight, true )
	createFont( "weaponT", tmpFont, 16, weight, true )

	createFont( "HudBars", tmpFont, 22, weight, true )
	createFont( "HudHeader", tmpFont, 40, weight, true )
	createFont( "HudVersion", tmpFont, 30, 700, true )

	--Creating
	createFont( "mmf", tmpFont, 22, weight, true )
	createFont( "hpf", tmpFont, 22, weight, true )
	createFont( "arf", tmpFont, 22, weight, true )
	createFont( "wpf", tmpFont, 22, weight, true )
	createFont( "wsf", tmpFont, 22, weight, true )
	createFont( "wnf", tmpFont, 22, weight, true )
	createFont( "rif", tmpFont, 22, weight, true )
	createFont( "ttf", tmpFont, 22, weight, true )
	createFont( "mof", tmpFont, 22, weight, true )
	createFont( "mhf", tmpFont, 22, weight, true )
	createFont( "mtf", tmpFont, 22, weight, true )
	createFont( "msf", tmpFont, 22, weight, true )
	createFont( "vtf", tmpFont, 22, weight, true )
	createFont( "cbf", tmpFont, 22, weight, true )
	createFont( "vof", tmpFont, 22, weight, true )
	createFont( "maf", tmpFont, 22, weight, true )
	createFont( "caf", tmpFont, 22, weight, true )
	createFont( "stf", tmpFont, 22, weight, true )

	createFont( "sef", tmpFont, 22, weight, true )

	timer.Create( "createFontDB", 0.1, 0, function()
		if cl_db["_load"] == 1 then
			--Changing to right values
			createFont( "mmf", tmpFont, cl_db["mmf"], weight, true )
			createFont( "hpf", tmpFont, cl_db["hpf"], weight, true )
			createFont( "arf", tmpFont, cl_db["arf"], weight, true )
			createFont( "wpf", tmpFont, cl_db["wpf"], weight, true )
			createFont( "wsf", tmpFont, cl_db["wsf"], weight, true )
			createFont( "wnf", tmpFont, cl_db["wnf"], weight, true )
			createFont( "rif", tmpFont, cl_db["rif"], weight, true )
			createFont( "ttf", tmpFont, cl_db["ttf"], weight, true )
			createFont( "mof", tmpFont, cl_db["mof"], weight, true )
			createFont( "mhf", tmpFont, cl_db["mhf"], weight, true )
			createFont( "mtf", tmpFont, cl_db["mtf"], weight, true )
			createFont( "msf", tmpFont, cl_db["msf"], weight, true )
			createFont( "vtf", tmpFont, cl_db["vtf"], weight, true )
			createFont( "cbf", tmpFont, cl_db["cbf"], weight, true )
			createFont( "vof", tmpFont, cl_db["vof"], weight, true )
			createFont( "maf", tmpFont, cl_db["maf"], weight, true )
			createFont( "caf", tmpFont, cl_db["caf"], weight, true )
			createFont( "stf", tmpFont, cl_db["stf"], weight, true )

			createFont( "sef", tmpFont, cl_db["sef"], weight, true )

			printGM( "db", "HUD Fonts loaded." )

			timer.Remove( "createFontDB" )
		end
	end)

	createFont( "ScoreBoardTitle", tmpFont, 24, weight, true )
	createFont( "ScoreBoardNormal", tmpFont, 20, weight, true )

	createFont( "ATM_Header", tmpFont, 80, weight, true )
	createFont( "ATM_Normal", tmpFont, 60, weight, true )
	createFont( "ATM_Name", tmpFont, 40, weight, true )

	--DarkRP Fonts
	createFont( "DarkRPHUD1", tmpFont, 16, 600, true )
	createFont( "DarkRPHUD2", tmpFont, 23, 400, true )
	createFont( "Trebuchet18", tmpFont, 18, weight, true )
	createFont( "Trebuchet20", tmpFont, 20, weight, true )
	createFont( "Trebuchet24", tmpFont, 24, weight, true )
	createFont( "Trebuchet48", tmpFont, 48, weight, true )
	createFont( "TabLarge", tmpFont, 15, 700, true )
	createFont( "UiBold", tmpFont, 16, 800, true )
	createFont( "HUDNumber5", tmpFont, 30, 800, true )
	createFont( "ScoreboardHeader", tmpFont, 32, weight, true )
	createFont( "ScoreboardSubtitle", tmpFont, 22, weight, true )
	createFont( "ScoreboardPlayerName", tmpFont, 19, weight, true )
	createFont( "ScoreboardPlayerName2", tmpFont, 15, weight, true )
	createFont( "ScoreboardPlayerNameBig", tmpFont, 22, weight, true )
	createFont( "AckBarWriting", tmpFont, 20, weight, true )
	createFont( "DarkRP_tipjar", tmpFont, 100, weight, true )
end
changeFontSize()
--##############################################################################
