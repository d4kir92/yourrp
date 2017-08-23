//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_fonts.lua

function createFont( _name, _font, _size, _weight, _outline )
	//printGM( "db", "createFont: " .. _name .. ", " .. _font .. ", " .. _size )
	local _antialaising = false
	if _size > 72 then
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
//##############################################################################
//Change Fonts
function changeFontSize()
	printGM( "db", "changeFontSize" )

	local tmpFont = "Roboto-Thin"
	createFont( "HudDefault", tmpFont, 80, 500, false )

	createFont( "SettingsNormal", tmpFont, 14, 500, true )
	createFont( "SettingsHeader", tmpFont, 18, 500, false )

	createFont( "HudBars", tmpFont, 16, 500, true )

	createFont( "roleInfoHeader", tmpFont, 14, 500, true )
	createFont( "roleInfoText", tmpFont, 12, 500, true )

	createFont( "charTitle", tmpFont, 14, 500, false )
	createFont( "charHeader", tmpFont, 14, 500, false )
	createFont( "charText", tmpFont, 14, 500, false )

	createFont( "pmT", tmpFont, 14, 500, true )
	createFont( "weaponT", tmpFont, 12, 500, true )

	createFont( "HudVersion", tmpFont, 30, 700, true )
	createFont( "HudMinimap", tmpFont, 14, 500, true )

	createFont( "ScoreBoardTitle", tmpFont, 24, 500, true )
	createFont( "ScoreBoardNormal", tmpFont, 15, 500, true )

	createFont( "ATM_Header", tmpFont, 80, 500, true )
	createFont( "ATM_Normal", tmpFont, 60, 500, true )
	createFont( "ATM_Name", tmpFont, 40, 500, true )
end
changeFontSize()
//##############################################################################
